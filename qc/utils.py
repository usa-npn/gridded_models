import csv
from util.log_manager import get_error_log
from util.database import conn, mysql_conn
import json
from urllib.request import urlopen, URLError, HTTPError
from psycopg2.extensions import AsIs
from datetime import date, timedelta


error_log = get_error_log()


def get_acis_climate_data(station_ids, climate_elements, start_date, end_date):
    try:
        url = 'http://data.rcc-acis.org/MultiStnData?sids={stations}&sdate={start_date}&edate={end_date}&elems={climate_elements}&output=json'\
            .format(start_date=start_date.strftime("%Y-%m-%d"),end_date=end_date.strftime("%Y-%m-%d"),stations=station_ids,climate_elements=climate_elements)
        response = urlopen(url)
    except HTTPError as err:
        error_log.log("ACIS request failed. http error code: {code}".format(code=err.code))
    except URLError as err:
        error_log.log("ACIS request failed: {reason}".format(reason=err.reason))
    str_response = response.readall().decode('utf-8')
    data = json.loads(str_response)
    return data


def get_urma_climate_data(long, lat, date, climate_element):
    if climate_element is 'tmin':
        table_name = "tmin_" + date.strftime("%Y")
    else:
        table_name = "tmax_" + date.strftime("%Y")
    curs = conn.cursor()

    query = "SELECT st_value(rast,ST_SetSRID(ST_Point(%(long)s, %(lat)s),4269)) FROM %(table)s WHERE rast_date = %(rast_date)s AND dataset = 'urma' AND ST_Intersects(rast, ST_SetSRID(ST_MakePoint(%(long)s, %(lat)s),4269));"
    data = {"table": AsIs(table_name), "long": long, "lat": lat, "rast_date": date.strftime("%Y-%m-%d")}
    curs.execute(query, data)
    result = curs.fetchone()
    if result is None:
        return None
    else:
        return result[0]


def get_prism_climate_data(long, lat, date, climate_element):
    if climate_element is 'tmin':
        table_name = "prism_tmin_" + date.strftime("%Y")
    else:
        table_name = "prism_tmax_" + date.strftime("%Y")
    curs = conn.cursor()

    query = "SELECT st_value(rast,ST_SetSRID(ST_Point(%(long)s, %(lat)s),4269)) FROM %(table)s WHERE rast_date = %(rast_date)s AND ST_Intersects(rast, ST_SetSRID(ST_MakePoint(%(long)s, %(lat)s),4269));"
    data = {"table": AsIs(table_name), "long": long, "lat": lat, "rast_date": date.strftime("%Y-%m-%d")}
    curs.execute(query, data)
    result = curs.fetchone()
    if result is None:
        return None
    else:
        return result[0]


def get_temps_for_year_from_qc_table(station_id, element, source_id, year):
    cursor = mysql_conn.cursor(dictionary=True)
    query = "SELECT * FROM climate.agdds WHERE station_id = %s AND source_id = %s AND base_temp_f = 32 AND YEAR = %s ORDER BY date;"
    cursor.execute(query, [station_id, source_id, year])
    rows = []
    return_array = []
    for row in cursor:
        rows.append(row)
    if len(rows) is 0:
        return None
    else:
        for row in rows:
            return_array.append(row[element])
        return return_array


def get_element_from_qc_table(station_id, source_id, date, base, element):
    cursor = mysql_conn.cursor(dictionary=True)
    query = "SELECT * FROM climate.agdds WHERE station_id = %s AND source_id = %s AND base_temp_f = %s AND date = %s;"
    cursor.execute(query, [station_id, source_id, base, date.strftime("%Y-%m-%d")])
    agdds = []
    for agdd in cursor:
        agdds.append(agdd)
    if len(agdds) is 0:
        return None
    else:
        if (element == 'tmin' or element == 'tmax') and agdds[0]['missing']:
            return None
        return agdds[0][element]


def get_sources():
    cursor = mysql_conn.cursor(dictionary=True)
    query = "SELECT * FROM climate.sources;"
    cursor.execute(query)
    sources = []
    for source in cursor:
        sources.append(source)
    return sources


def load_sources():
    cursor = mysql_conn.cursor()
    csvReader = csv.DictReader(open('sources.csv'))
    for source in csvReader:
        query = "INSERT INTO climate.sources (name, description) VALUES (%s, %s);"
        cursor.execute(query, (source['Name'], source['Description']))
    mysql_conn.commit()
    cursor.close()


def load_stations_csv_to_db():
    cursor = mysql_conn.cursor()
    csvReader = csv.DictReader(open('crn-stations-v2.csv'))
    for station in csvReader:
        if station['WMO ID'].isdigit():
            station_id = int(station['WMO ID'])
        else:
            station_id = None
        # some stations were not returning data from acis - we skip populating those stations
        # if station['ID'] not in stations_not_found:
        query = "INSERT INTO climate.stations (latitude, longitude, elevation, name, int_network_id, char_network_id, type) VALUES (%s, %s, %s, %s, %s, %s, %s);"
        cursor.execute(query, (float(station['Lat']), float(station['Lon']), float(station['Elevation']), station['Name'], station_id, station['ID'], station['HCN/CRN']))
    mysql_conn.commit()
    cursor.close()


def get_stations():
    cursor = mysql_conn.cursor(dictionary=True)
    query = "SELECT * FROM climate.stations;"
    cursor.execute(query)
    stations = []
    for station in cursor:
        stations.append(station)
    return stations


def load_station_states():
    stations = get_stations()

    cursor = mysql_conn.cursor(dictionary=True)

    query = "SELECT * FROM climate.attribute_types;"
    cursor.execute(query)
    state_attribute_id = 0
    for attribute in cursor:
        if attribute['name'] == 'state':
            state_attribute_id = attribute['id']

    csvReader = csv.DictReader(open('crn-stations-v2.csv'))
    for station in stations:
        for csv_station in csvReader:
            if csv_station['ID'] == station['char_network_id']:
                station_id = station['id']
                station_state = csv_station['State']
                query = "INSERT INTO climate.station_attributes (station_id, attribute_id, int_value, char_value, float_value) VALUES (%s, %s, %s, %s, %s);"
                cursor.execute(query, (station['id'], state_attribute_id, None, csv_station['State'], None))
                mysql_conn.commit()
                break;
    cursor.close()

    def get_acis_missing_climate_data():
        start_date = '1940-01-01'
        end_date = '1940-12-31'
        climate_elements = 'mint,maxt'
        # grab station ids
        # cursor = mysql_conn.cursor(dictionary=True)
        # query = "SELECT * FROM climate.stations;"
        # cursor.execute(query)
        stations = ["US1AKAB0001",
                    "US1AKAB0003",
                    "US1AKAB0004",
                    "US1AKAB0006",
                    "US1AKAB0007",
                    "US1AKAB0008",
                    "US1AKAB0009",
                    "US1AKAB0012",
                    "US1AKAB0014",
                    "US1AKAB0021",
                    "US1AKAB0022",
                    "US1AKAB0023",
                    "US1AKAB0027",
                    "US1AKAB0028",
                    "US1AKAB0030",
                    "US1AKAB0034",
                    "US1AKAB0036",
                    "US1AKAB0038",
                    "US1AKAB0048",
                    "US1AKAB0052",
                    "US1AKBC0003",
                    "US1AKBC0004",
                    "US1AKFN0004",
                    "US1AKFN0011",
                    "US1AKFN0013",
                    "US1AKFN0015",
                    "US1AKJB0002",
                    "US1AKJB0003",
                    "US1AKJB0005",
                    "US1AKJB0007",
                    "US1AKJB0009",
                    "US1AKJB0010",
                    "US1AKKP0001",
                    "US1AKKP0002",
                    "US1AKMS0005",
                    "US1AKMS0010",
                    "US1AKMS0011",
                    "US1AKMS0012",
                    "US1AKPW0001",
                    "US1AKPW0005",
                    "US1AKSH0002",
                    "US1AKVC0005",
                    "US1AKWH0003",
                    "US1AKWH0005",
                    "US1AKWP0001",
                    "USC00500040",
                    "USC00500100",
                    "USC00500125",
                    "USC00500144",
                    "USC00500172",
                    "USC00500201",
                    "USC00500230",
                    "USC00500235",
                    "USC00500237",
                    "USC00500238",
                    "USC00500243",
                    "USC00500247",
                    "USC00500249",
                    "USC00500252",
                    "USC00500258",
                    "USC00500260",
                    "USC00500270",
                    "USC00500272",
                    "USC00500275",
                    "USC00500279",
                    "USC00500281",
                    "USC00500284",
                    "USC00500286",
                    "USC00500287",
                    "USC00500288",
                    "USC00500299",
                    "USC00500302",
                    "USC00500310",
                    "USC00500363",
                    "USC00500396",
                    "USC00500433",
                    "USC00500452",
                    "USC00500464",
                    "USC00500490",
                    "USC00500522",
                    "USC00500594",
                    "USC00500602",
                    "USC00500653",
                    "USC00500655",
                    "USC00500657",
                    "USC00500676",
                    "USC00500685",
                    "USC00500702",
                    "USC00500707",
                    "USC00500766",
                    "USC00500775",
                    "USC00500777",
                    "USC00500781",
                    "USC00500788",
                    "USC00500804",
                    "USC00500824",
                    "USC00500832",
                    "USC00500910",
                    "USC00500986",
                    "USC00501017",
                    "USC00501175",
                    "USC00501180",
                    "USC00501201",
                    "USC00501220",
                    "USC00501225",
                    "USC00501226",
                    "USC00501228",
                    "USC00501230",
                    "USC00501240",
                    "USC00501243",
                    "USC00501244",
                    "USC00501251",
                    "USC00501254",
                    "USC00501269",
                    "USC00501308",
                    "USC00501312",
                    "USC00501314",
                    "USC00501316",
                    "USC00501318",
                    "USC00501321",
                    "USC00501325",
                    "USC00501334",
                    "USC00501341",
                    "USC00501447",
                    "USC00501451",
                    "USC00501452",
                    "USC00501458",
                    "USC00501466",
                    "USC00501475",
                    "USC00501492",
                    "USC00501497",
                    "USC00501557",
                    "USC00501574",
                    "USC00501601",
                    "USC00501629",
                    "USC00501641",
                    "USC00501662",
                    "USC00501684",
                    "USC00501716",
                    "USC00501763",
                    "USC00501810",
                    "USC00501814",
                    "USC00501818",
                    "USC00501821",
                    "USC00501824",
                    "USC00501900",
                    "USC00501926",
                    "USC00501977",
                    "USC00501987",
                    "USC00502005",
                    "USC00502015",
                    "USC00502019",
                    "USC00502041",
                    "USC00502084",
                    "USC00502101",
                    "USC00502103",
                    "USC00502104",
                    "USC00502105",
                    "USC00502107",
                    "USC00502110",
                    "USC00502112",
                    "USC00502114",
                    "USC00502126",
                    "USC00502144",
                    "USC00502147",
                    "USC00502149",
                    "USC00502156",
                    "USC00502161",
                    "USC00502173",
                    "USC00502179",
                    "USC00502217",
                    "USC00502222",
                    "USC00502227",
                    "USC00502235",
                    "USC00502241",
                    "USC00502247",
                    "USC00502252",
                    "USC00502266",
                    "USC00502280",
                    "USC00502307",
                    "USC00502327",
                    "USC00502339",
                    "USC00502341",
                    "USC00502347",
                    "USC00502350",
                    "USC00502352",
                    "USC00502393",
                    "USC00502425",
                    "USC00502457",
                    "USC00502465",
                    "USC00502493",
                    "USC00502522",
                    "USC00502568",
                    "USC00502586",
                    "USC00502587",
                    "USC00502607",
                    "USC00502638",
                    "USC00502642",
                    "USC00502645",
                    "USC00502648",
                    "USC00502656",
                    "USC00502665",
                    "USC00502681",
                    "USC00502692",
                    "USC00502707",
                    "USC00502711",
                    "USC00502717",
                    "USC00502725",
                    "USC00502730",
                    "USC00502737",
                    "USC00502770",
                    "USC00502785",
                    "USC00502825",
                    "USC00502835",
                    "USC00502868",
                    "USC00502870",
                    "USC00502871",
                    "USC00502872",
                    "USC00502873",
                    "USC00502876",
                    "USC00502952",
                    "USC00502960",
                    "USC00502964",
                    "USC00502965",
                    "USC00502970",
                    "USC00503009",
                    "USC00503072",
                    "USC00503082",
                    "USC00503083",
                    "USC00503085",
                    "USC00503125",
                    "USC00503160",
                    "USC00503162",
                    "USC00503163",
                    "USC00503165",
                    "USC00503181",
                    "USC00503183",
                    "USC00503184",
                    "USC00503196",
                    "USC00503198",
                    "USC00503205",
                    "USC00503208",
                    "USC00503210",
                    "USC00503212",
                    "USC00503252",
                    "USC00503275",
                    "USC00503283",
                    "USC00503294",
                    "USC00503299",
                    "USC00503304",
                    "USC00503347",
                    "USC00503367",
                    "USC00503368",
                    "USC00503378",
                    "USC00503390",
                    "USC00503438",
                    "USC00503454",
                    "USC00503470",
                    "USC00503473",
                    "USC00503500",
                    "USC00503502",
                    "USC00503504",
                    "USC00503530",
                    "USC00503558",
                    "USC00503573",
                    "USC00503581",
                    "USC00503585",
                    "USC00503591",
                    "USC00503605",
                    "USC00503628",
                    "USC00503650",
                    "USC00503655",
                    "USC00503667",
                    "USC00503668",
                    "USC00503670",
                    "USC00503672",
                    "USC00503680",
                    "USC00503682",
                    "USC00503685",
                    "USC00503687",
                    "USC00503695",
                    "USC00503705",
                    "USC00503720",
                    "USC00503731",
                    "USC00503765",
                    "USC00503812",
                    "USC00503821",
                    "USC00503868",
                    "USC00503871",
                    "USC00503908",
                    "USC00503910",
                    "USC00503914",
                    "USC00503925",
                    "USC00503933",
                    "USC00504062",
                    "USC00504089",
                    "USC00504092",
                    "USC00504094",
                    "USC00504103",
                    "USC00504104",
                    "USC00504107",
                    "USC00504109",
                    "USC00504110",
                    "USC00504117",
                    "USC00504155",
                    "USC00504158",
                    "USC00504161",
                    "USC00504163",
                    "USC00504165",
                    "USC00504206",
                    "USC00504210",
                    "USC00504329",
                    "USC00504331",
                    "USC00504333",
                    "USC00504342",
                    "USC00504425",
                    "USC00504429",
                    "USC00504444",
                    "USC00504453",
                    "USC00504524",
                    "USC00504550",
                    "USC00504555",
                    "USC00504560",
                    "USC00504567",
                    "USC00504570",
                    "USC00504575",
                    "USC00504592",
                    "USC00504600",
                    "USC00504621",
                    "USC00504683",
                    "USC00504689",
                    "USC00504701",
                    "USC00504762",
                    "USC00504812",
                    "USC00504823",
                    "USC00504830",
                    "USC00504887",
                    "USC00504898",
                    "USC00504929",
                    "USC00504943",
                    "USC00504964",
                    "USC00504971",
                    "USC00504984",
                    "USC00504991",
                    "USC00505010",
                    "USC00505021",
                    "USC00505051",
                    "USC00505091",
                    "USC00505136",
                    "USC00505318",
                    "USC00505346",
                    "USC00505354",
                    "USC00505359",
                    "USC00505364",
                    "USC00505374",
                    "USC00505397",
                    "USC00505425",
                    "USC00505454",
                    "USC00505458",
                    "USC00505464",
                    "USC00505483",
                    "USC00505499",
                    "USC00505506",
                    "USC00505511",
                    "USC00505512",
                    "USC00505516",
                    "USC00505517",
                    "USC00505519",
                    "USC00505525",
                    "USC00505527",
                    "USC00505534",
                    "USC00505544",
                    "USC00505562",
                    "USC00505600",
                    "USC00505602",
                    "USC00505604",
                    "USC00505607",
                    "USC00505644",
                    "USC00505721",
                    "USC00505725",
                    "USC00505726",
                    "USC00505728",
                    "USC00505731",
                    "USC00505733",
                    "USC00505734",
                    "USC00505735",
                    "USC00505752",
                    "USC00505754",
                    "USC00505757",
                    "USC00505770",
                    "USC00505778",
                    "USC00505780",
                    "USC00505789",
                    "USC00505810",
                    "USC00505843",
                    "USC00505845",
                    "USC00505851",
                    "USC00505853",
                    "USC00505857",
                    "USC00505860",
                    "USC00505873",
                    "USC00505875",
                    "USC00505878",
                    "USC00505879",
                    "USC00505880",
                    "USC00505881",
                    "USC00505882",
                    "USC00505883",
                    "USC00505884",
                    "USC00505885",
                    "USC00505888",
                    "USC00505889",
                    "USC00505891",
                    "USC00505893",
                    "USC00505894",
                    "USC00505895",
                    "USC00505896",
                    "USC00505898",
                    "USC00506062",
                    "USC00506078",
                    "USC00506086",
                    "USC00506089",
                    "USC00506093",
                    "USC00506144",
                    "USC00506147",
                    "USC00506157",
                    "USC00506166",
                    "USC00506227",
                    "USC00506270",
                    "USC00506403",
                    "USC00506419",
                    "USC00506441",
                    "USC00506450",
                    "USC00506463",
                    "USC00506503",
                    "USC00506564",
                    "USC00506581",
                    "USC00506656",
                    "USC00506672",
                    "USC00506727",
                    "USC00506760",
                    "USC00506762",
                    "USC00506769",
                    "USC00506777",
                    "USC00506783",
                    "USC00506800",
                    "USC00506812",
                    "USC00506824",
                    "USC00506831",
                    "USC00506844",
                    "USC00506853",
                    "USC00506870",
                    "USC00506871",
                    "USC00506872",
                    "USC00506873",
                    "USC00506874",
                    "USC00506875",
                    "USC00506876",
                    "USC00506880",
                    "USC00507095",
                    "USC00507097",
                    "USC00507105",
                    "USC00507108",
                    "USC00507141",
                    "USC00507221",
                    "USC00507281",
                    "USC00507304",
                    "USC00507314",
                    "USC00507352",
                    "USC00507365",
                    "USC00507421",
                    "USC00507431",
                    "USC00507442",
                    "USC00507444",
                    "USC00507447",
                    "USC00507451",
                    "USC00507465",
                    "USC00507486",
                    "USC00507494",
                    "USC00507502",
                    "USC00507513",
                    "USC00507557",
                    "USC00507570",
                    "USC00507640",
                    "USC00507669",
                    "USC00507692",
                    "USC00507708",
                    "USC00507716",
                    "USC00507721",
                    "USC00507738",
                    "USC00507778",
                    "USC00507780",
                    "USC00507783",
                    "USC00507850",
                    "USC00507854",
                    "USC00507891",
                    "USC00507900",
                    "USC00507902",
                    "USC00507916",
                    "USC00507977",
                    "USC00507989",
                    "USC00508025",
                    "USC00508039",
                    "USC00508044",
                    "USC00508047",
                    "USC00508054",
                    "USC00508100",
                    "USC00508102",
                    "USC00508105",
                    "USC00508107",
                    "USC00508114",
                    "USC00508130",
                    "USC00508140",
                    "USC00508156",
                    "USC00508168",
                    "USC00508171",
                    "USC00508183",
                    "USC00508211",
                    "USC00508239",
                    "USC00508273",
                    "USC00508307",
                    "USC00508341",
                    "USC00508350",
                    "USC00508355",
                    "USC00508375",
                    "USC00508377",
                    "USC00508379",
                    "USC00508389",
                    "USC00508397",
                    "USC00508400",
                    "USC00508409",
                    "USC00508416",
                    "USC00508437",
                    "USC00508450",
                    "USC00508463",
                    "USC00508466",
                    "USC00508470",
                    "USC00508477",
                    "USC00508488",
                    "USC00508503",
                    "USC00508505",
                    "USC00508512",
                    "USC00508525",
                    "USC00508530",
                    "USC00508532",
                    "USC00508547",
                    "USC00508550",
                    "USC00508554",
                    "USC00508556",
                    "USC00508558",
                    "USC00508584",
                    "USC00508594",
                    "USC00508612",
                    "USC00508613",
                    "USC00508615",
                    "USC00508618",
                    "USC00508625",
                    "USC00508648",
                    "USC00508666",
                    "USC00508672",
                    "USC00508715",
                    "USC00508727",
                    "USC00508731",
                    "USC00508745",
                    "USC00508755",
                    "USC00508785",
                    "USC00508807",
                    "USC00508813",
                    "USC00508815",
                    "USC00508855",
                    "USC00508882",
                    "USC00508884",
                    "USC00508886",
                    "USC00508915",
                    "USC00508930",
                    "USC00508945",
                    "USC00508970",
                    "USC00508995",
                    "USC00509005",
                    "USC00509015",
                    "USC00509038",
                    "USC00509085",
                    "USC00509098",
                    "USC00509102",
                    "USC00509113",
                    "USC00509121",
                    "USC00509134",
                    "USC00509139",
                    "USC00509142",
                    "USC00509144",
                    "USC00509146",
                    "USC00509148",
                    "USC00509313",
                    "USC00509314",
                    "USC00509315",
                    "USC00509316",
                    "USC00509349",
                    "USC00509385",
                    "USC00509396",
                    "USC00509397",
                    "USC00509398",
                    "USC00509399",
                    "USC00509402",
                    "USC00509410",
                    "USC00509421",
                    "USC00509428",
                    "USC00509452",
                    "USC00509460",
                    "USC00509489",
                    "USC00509494",
                    "USC00509502",
                    "USC00509511",
                    "USC00509575",
                    "USC00509641",
                    "USC00509648",
                    "USC00509685",
                    "USC00509687",
                    "USC00509690",
                    "USC00509693",
                    "USC00509694",
                    "USC00509699",
                    "USC00509702",
                    "USC00509747",
                    "USC00509759",
                    "USC00509763",
                    "USC00509765",
                    "USC00509767",
                    "USC00509769",
                    "USC00509782",
                    "USC00509790",
                    "USC00509793",
                    "USC00509798",
                    "USC00509829",
                    "USC00509845",
                    "USC00509858",
                    "USC00509859",
                    "USC00509860",
                    "USC00509861",
                    "USC00509864",
                    "USC00509865",
                    "USC00509869",
                    "USC00509873",
                    "USC00509883",
                    "USC00509891",
                    "USC00509902",
                    "USC00509911",
                    "USC00509915",
                    "USC00509919",
                    "USR0000AALC",
                    "USR0000AANG",
                    "USR0000ABCA",
                    "USR0000ABCK",
                    "USR0000ABEA",
                    "USR0000ABEN",
                    "USR0000ABER",
                    "USR0000ABEV",
                    "USR0000ABIL",
                    "USR0000ABNT",
                    "USR0000ABOO",
                    "USR0000ABRO",
                    "USR0000ACAK",
                    "USR0000ACCR",
                    "USR0000ACHA",
                    "USR0000ACHF",
                    "USR0000ACHI",
                    "USR0000ACHL",
                    "USR0000ACHS",
                    "USR0000ACHT",
                    "USR0000ACKN",
                    "USR0000ACOT",
                    "USR0000AEAG",
                    "USR0000AFAI",
                    "USR0000AFAR",
                    "USR0000AFLT",
                    "USR0000AGEO",
                    "USR0000AGOP",
                    "USR0000AGRA",
                    "USR0000AGRN",
                    "USR0000AHAI",
                    "USR0000AHAY",
                    "USR0000AHEL",
                    "USR0000AHLM",
                    "USR0000AHOD",
                    "USR0000AHOG",
                    "USR0000AHOM",
                    "USR0000AHON",
                    "USR0000AHOO",
                    "USR0000AINN",
                    "USR0000AJAT",
                    "USR0000AJUN",
                    "USR0000AKAI",
                    "USR0000AKAK",
                    "USR0000AKAN",
                    "USR0000AKAV",
                    "USR0000AKEL",
                    "USR0000AKEN",
                    "USR0000AKIA",
                    "USR0000AKIL",
                    "USR0000AKLA",
                    "USR0000AKLK",
                    "USR0000AKOY",
                    "USR0000ALIB",
                    "USR0000ALIV",
                    "USR0000ALMI",
                    "USR0000ALOS",
                    "USR0000AMAY",
                    "USR0000AMCK",
                    "USR0000ANEW",
                    "USR0000ANIN",
                    "USR0000ANOA",
                    "USR0000ANOR",
                    "USR0000APAL",
                    "USR0000APAX",
                    "USR0000APOO",
                    "USR0000APRE",
                    "USR0000AQTZ",
                    "USR0000ARAB",
                    "USR0000AREI",
                    "USR0000AREN",
                    "USR0000AROU",
                    "USR0000ARUT",
                    "USR0000ASAL",
                    "USR0000ASEL",
                    "USR0000ASEV",
                    "USR0000ASHC",
                    "USR0000ASIT",
                    "USR0000ASKI",
                    "USR0000ASLC",
                    "USR0000ASTO",
                    "USR0000ASTR",
                    "USR0000ASWA",
                    "USR0000ATEL",
                    "USR0000ATHO",
                    "USR0000ATLA",
                    "USR0000ATOK",
                    "USR0000ATTA",
                    "USR0000AVUN",
                    "USR0000AWEI",
                    "USR0000AWON",
                    "USR0000AZAR",
                    "USS0033J01S",
                    "USS0035K02S",
                    "USS0041P07S",
                    "USS0042M01S",
                    "USS0042N01S",
                    "USS0044Q07S",
                    "USS0045L01S",
                    "USS0045M07S",
                    "USS0045O01S",
                    "USS0045O04S",
                    "USS0045O10S",
                    "USS0045P03S",
                    "USS0045Q02S",
                    "USS0045Q05S",
                    "USS0045R01S",
                    "USS0046M04S",
                    "USS0046P01S",
                    "USS0046Q01S",
                    "USS0046Q02S",
                    "USS0046Q07S",
                    "USS0047O01S",
                    "USS0047P03S",
                    "USS0048L06S",
                    "USS0048M04S",
                    "USS0048U01S",
                    "USS0048V01S",
                    "USS0049L01S",
                    "USS0049L09S",
                    "USS0049L10S",
                    "USS0049L13S",
                    "USS0049L14S",
                    "USS0049L18S",
                    "USS0049L19S",
                    "USS0049M08S",
                    "USS0049M22S",
                    "USS0049M26S",
                    "USS0049T01S",
                    "USS0049T03S",
                    "USS0050K05S",
                    "USS0050K06S",
                    "USS0050K07S",
                    "USS0050L02S",
                    "USS0050M01S",
                    "USS0050M03S",
                    "USS0050M05S",
                    "USS0050N05S",
                    "USS0050N07S",
                    "USS0050O01S",
                    "USS0050R04S",
                    "USS0050S01S",
                    "USS0051K05S",
                    "USS0051K14S",
                    "USS0051K15S",
                    "USS0051R01S",
                    "USS0053L01S",
                    "USS0054K01S",
                    "USS0062S01S",
                    "USS0063P01S",
                    "USS0063P02S",
                    "USS0064P01S",
                    "USW00025308",
                    "USW00025309",
                    "USW00025322",
                    "USW00025323",
                    "USW00025325",
                    "USW00025329",
                    "USW00025331",
                    "USW00025333",
                    "USW00025335",
                    "USW00025339",
                    "USW00025367",
                    "USW00025379",
                    "USW00025380",
                    "USW00025381",
                    "USW00025402",
                    "USW00025403",
                    "USW00025501",
                    "USW00025503",
                    "USW00025506",
                    "USW00025507",
                    "USW00025508",
                    "USW00025515",
                    "USW00025516",
                    "USW00025522",
                    "USW00025602",
                    "USW00025603",
                    "USW00025623",
                    "USW00025624",
                    "USW00025625",
                    "USW00025626",
                    "USW00025628",
                    "USW00025630",
                    "USW00025704",
                    "USW00025708",
                    "USW00025709",
                    "USW00025711",
                    "USW00025713",
                    "USW00026401",
                    "USW00026403",
                    "USW00026407",
                    "USW00026409",
                    "USW00026410",
                    "USW00026411",
                    "USW00026412",
                    "USW00026413",
                    "USW00026414",
                    "USW00026415",
                    "USW00026422",
                    "USW00026425",
                    "USW00026435",
                    "USW00026436",
                    "USW00026438",
                    "USW00026439",
                    "USW00026440",
                    "USW00026442",
                    "USW00026445",
                    "USW00026451",
                    "USW00026452",
                    "USW00026453",
                    "USW00026458",
                    "USW00026491",
                    "USW00026492",
                    "USW00026494",
                    "USW00026501",
                    "USW00026502",
                    "USW00026508",
                    "USW00026509",
                    "USW00026510",
                    "USW00026513",
                    "USW00026514",
                    "USW00026516",
                    "USW00026517",
                    "USW00026519",
                    "USW00026523",
                    "USW00026528",
                    "USW00026529",
                    "USW00026533",
                    "USW00026534",
                    "USW00026535",
                    "USW00026536",
                    "USW00026537",
                    "USW00026562",
                    "USW00026563",
                    "USW00026564",
                    "USW00026565",
                    "USW00026615",
                    "USW00026616",
                    "USW00026617",
                    "USW00026618",
                    "USW00026620",
                    "USW00026627",
                    "USW00026631",
                    "USW00026632",
                    "USW00026633",
                    "USW00026634",
                    "USW00026642",
                    "USW00026643",
                    "USW00026655",
                    "USW00026703",
                    "USW00027401",
                    "USW00027406",
                    "USW00027502",
                    "USW00027503",
                    "USW00027515",
                    "USW00027516",
                    "USW00045702",
                    "USW00045708",
                    "USW00045709",
                    "USW00045714",
                    "USW00045715",
                    "USW00056401",
                    "USW00096404",
                    "USW00096406"]

        crn_stations = ["USW00025379",
                        "USW00025380",
                        "USW00025381",
                        "USW00025522",
                        "USW00025630",
                        "USW00025711",
                        "USW00026494",
                        "USW00026562",
                        "USW00026563",
                        "USW00026564",
                        "USW00026565",
                        "USW00026655",
                        "USW00027516",
                        "USW00056401",
                        "USW00096404",
                        "USW00096406",
                        "USW00096407",
                        "USW00096408"]

        gsn_stations = ["USW00025308",
                        "USW00025339",
                        "USW00025503",
                        "USW00025507",
                        "USW00025624",
                        "USW00025713",
                        "USW00026411",
                        "USW00026510",
                        "USW00026528",
                        "USW00026615",
                        "USW00026616",
                        "USW00026617",
                        "USW00027401",
                        "USW00027502"]

        for station in gsn_stations:
            try:
                url = 'http://data.rcc-acis.org/MultiStnData?sids={station_id}&sdate={start_date}&edate={end_date}&elems={climate_elements}&output=json' \
                    .format(start_date=start_date, end_date=end_date, station_id=station,
                            climate_elements=climate_elements)
                response = urlopen(url)
            except HTTPError as err:
                if err.code == 404:
                    print("Page not found!")
                elif err.code == 403:
                    print("Access denied!")
                else:
                    print("Something happened! Error code: {code}".format(code=err.code))
            except URLError as err:
                print("Some other error happened: {reason}".format(reason=err.reason))

            str_response = response.readall().decode('utf-8')
            data = json.loads(str_response)
            # print(data['data'])

            if data and data['data'] and data['data'][0]:
                # print(station)
                print(data['data'][0])


# # list of stations in station csv list that ACIS doesn't respond to
# # these stations have been removed from our database
# stations_not_found = ['RSW00037201'
# ,'USW00003076'
# ,'USW00003077'
# ,'USW00003078'
# ,'USW00003079'
# ,'USW00003081'
# ,'USW00003083'
# ,'USW00003084'
# ,'USW00003085'
# ,'USW00003086'
# ,'USW00003088'
# ,'USW00003089'
# ,'USW00003091'
# ,'USW00003093'
# ,'USW00003094'
# ,'USW00003095'
# ,'USW00003096'
# ,'USW00003098'
# ,'USW00003099'
# ,'USW00004143'
# ,'USW00025380'
# ,'USW00025381'
# ,'USW00025522'
# ,'USW00026564'
# ,'USW00026565'
# ,'USW00053004'
# ,'USW00053005'
# ,'USW00053006'
# ,'USW00053007'
# ,'USW00053010'
# ,'USW00053011'
# ,'USW00053012'
# ,'USW00053013'
# ,'USW00053014'
# ,'USW00053015'
# ,'USW00053016'
# ,'USW00053019'
# ,'USW00053022'
# ,'USW00053023'
# ,'USW00053156'
# ,'USW00053159'
# ,'USW00053160'
# ,'USW00053162'
# ,'USW00053163'
# ,'USW00053164'
# ,'USW00053165'
# ,'USW00053166'
# ,'USW00053167'
# ,'USW00053168'
# ,'USW00053169'
# ,'USW00053170'
# ,'USW00053171'
# ,'USW00053172'
# ,'USW00053174'
# ,'USW00053176'
# ,'USW00053180'
# ,'USW00053181'
# ,'USW00053183'
# ,'USW00053184'
# ,'USW00053185'
# ,'USW00056401'
# ,'USW00063866'
# ,'USW00094092'
# ,'USW00094094'
# ,'USW00094096'
# ,'USW00094097'
# ,'USW00094098'
# ,'USW00096406']