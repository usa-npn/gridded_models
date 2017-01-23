import csv
from util.log_manager import get_error_log
from util.database import conn, mysql_conn
import json
from urllib.request import urlopen, URLError, HTTPError
from psycopg2.extensions import AsIs
from datetime import date, timedelta
from qc.mysql_queries import *
from qc.postgis_queries import *


error_log = get_error_log()


def get_acis_climate_data(station_ids, climate_elements, start_date, end_date):
    try:
        url = 'http://data.rcc-acis.org/MultiStnData?sids={stations}&sdate={start_date}&edate={end_date}&elems={climate_elements}&output=json'\
            .format(start_date=start_date.strftime("%Y-%m-%d"),
                    end_date=end_date.strftime("%Y-%m-%d"),
                    stations=station_ids,
                    climate_elements=climate_elements)
        response = urlopen(url)
        str_response = response.readall().decode('utf-8')
        data = json.loads(str_response)
        return data
    except HTTPError as err:
        error_log.log("ACIS request failed. http error code: {code}".format(code=err.code))
    except URLError as err:
        error_log.log("ACIS request failed: {reason}".format(reason=err.reason))


def get_urma_climate_data(long, lat, date, climate_element):
    if climate_element is 'tmin':
        table_name = "tmin_" + date.strftime("%Y")
    else:
        table_name = "tmax_" + date.strftime("%Y")
    curs = conn.cursor()
    data = {"table": AsIs(table_name), "long": long, "lat": lat, "rast_date": date.strftime("%Y-%m-%d")}
    curs.execute(select_urma_by_date, data)
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
    data = {"table": AsIs(table_name), "long": long, "lat": lat, "rast_date": date.strftime("%Y-%m-%d")}
    curs.execute(select_prism_by_date, data)
    result = curs.fetchone()
    if result is None:
        return None
    else:
        return result[0]


def get_six_data(long, lat, date, phenophase, climate_provider):
    if climate_provider == 'best':
        table_name = "best_spring_index"
    else:
        table_name = "prism_spring_index"
    curs = conn.cursor()
    data = {"table": AsIs(table_name), "long": long, "lat": lat, "rast_date": date.strftime("%Y-%m-%d"),
            "phenophase": phenophase}
    curs.execute(select_best_six_by_date, data)
    result = curs.fetchone()
    if result is None:
        return None
    else:
        return result[0]


def get_temps_for_year_from_qc_table(station_id, element, source_id, year):
    cursor = mysql_conn.cursor(dictionary=True)
    cursor.execute(select_agdd_temps_for_year, [station_id, source_id, year])
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
    cursor.execute(select_agdd_by_date, [station_id, source_id, base, date.strftime("%Y-%m-%d")])
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
    cursor.execute(select_sources)
    sources = []
    for source in cursor:
        sources.append(source)
    return sources


def load_sources():
    cursor = mysql_conn.cursor()
    csv_reader = csv.DictReader(open('sources.csv'))
    for source in csv_reader:
        cursor.execute(insert_source, (source['Name'], source['Description']))
    mysql_conn.commit()
    cursor.close()


def load_stations_csv_to_db():
    cursor = mysql_conn.cursor()
    csv_reader = csv.DictReader(open('crn-stations-v2.csv'))
    for station in csv_reader:
        if station['WMO ID'].isdigit():
            station_id = int(station['WMO ID'])
        else:
            station_id = None
        # some stations were not returning data from acis - we skip populating those stations
        # if station['ID'] not in stations_not_found:
        cursor.execute(insert_station, (float(station['Lat']), float(station['Lon']), float(station['Elevation']),
                                        station['Name'], station_id, station['ID'], station['HCN/CRN']))
    mysql_conn.commit()
    cursor.close()


def get_stations():
    cursor = mysql_conn.cursor(dictionary=True)
    cursor.execute(select_stations)
    stations = []
    for station in cursor:
        stations.append(station)
    return stations


def load_station_states():
    stations = get_stations()

    cursor = mysql_conn.cursor(dictionary=True)

    cursor.execute(select_attribute_types)
    state_attribute_id = 0
    for attribute in cursor:
        if attribute['name'] == 'state':
            state_attribute_id = attribute['id']

    csv_reader = csv.DictReader(open('crn-stations-v2.csv'))
    for station in stations:
        for csv_station in csv_reader:
            if csv_station['ID'] == station['char_network_id']:
                cursor.execute(insert_station_attribute, (station['id'], state_attribute_id, None, csv_station['State'], None))
                mysql_conn.commit()
                break
    cursor.close()


def get_acis_missing_climate_data():
    # start_date = '1940-01-01'
    # end_date = '1940-12-31'
    start_date = '2017-01-01'
    end_date = '2017-01-09'
    climate_elements = 'mint,maxt'
    # grab station ids
    # cursor = mysql_conn.cursor(dictionary=True)
    # query = "SELECT * FROM climate.stations;"
    # cursor.execute(query)

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

    alaska_crn_stations = [ "USW00027516",
                            "USW00026565",
                            "USW00026494",
                            "USW00056401",
                            "USW00025380",
                            "USW00026564",
                            "USW00026563",
                            "USW00025522",
                            "USW00025381",
                            "USW00026562",
                            "USW00026655",
                            "USW00096406",
                            "USW00025630",
                            "USW00025379",
                            "USW00025711",
                            "USW00096404"]

    alaska_gsn_stations = [ "USW00025308",
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

    for station in alaska_crn_stations:
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
        # else:
        #     print('no data')


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