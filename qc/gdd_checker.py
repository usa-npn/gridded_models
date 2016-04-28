import csv
import json
from urllib.request import urlopen
from datetime import *
import yaml
import psycopg2
import mysql.connector
from psycopg2.extensions import AsIs
import os.path
import logging


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), os.path.pardir, 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
db = cfg["postgis"]
conn = psycopg2.connect(dbname=db["db"], port=db["port"], user=db["user"],
                        password=db["password"], host=db["host"])
mysql_db = cfg["mysql"]
mysql_conn = mysql.connector.connect(database=mysql_db["db"], port=mysql_db["port"], user=mysql_db["user"],
                        password=mysql_db["password"], host=mysql_db["host"])


# list of stations in station csv list that ACIS doesn't respond to
# these stations have been removed from our database
stations_not_found = ['RSW00037201'
,'USW00003076'
,'USW00003077'
,'USW00003078'
,'USW00003079'
,'USW00003081'
,'USW00003083'
,'USW00003084'
,'USW00003085'
,'USW00003086'
,'USW00003088'
,'USW00003089'
,'USW00003091'
,'USW00003093'
,'USW00003094'
,'USW00003095'
,'USW00003096'
,'USW00003098'
,'USW00003099'
,'USW00004143'
,'USW00025380'
,'USW00025381'
,'USW00025522'
,'USW00026564'
,'USW00026565'
,'USW00053004'
,'USW00053005'
,'USW00053006'
,'USW00053007'
,'USW00053010'
,'USW00053011'
,'USW00053012'
,'USW00053013'
,'USW00053014'
,'USW00053015'
,'USW00053016'
,'USW00053019'
,'USW00053022'
,'USW00053023'
,'USW00053156'
,'USW00053159'
,'USW00053160'
,'USW00053162'
,'USW00053163'
,'USW00053164'
,'USW00053165'
,'USW00053166'
,'USW00053167'
,'USW00053168'
,'USW00053169'
,'USW00053170'
,'USW00053171'
,'USW00053172'
,'USW00053174'
,'USW00053176'
,'USW00053180'
,'USW00053181'
,'USW00053183'
,'USW00053184'
,'USW00053185'
,'USW00056401'
,'USW00063866'
,'USW00094092'
,'USW00094094'
,'USW00094096'
,'USW00094097'
,'USW00094098'
,'USW00096406']


# todo collect prism gdds
# returns array of climate elements at lat/long for the specified year from PRISM
# def get_prism_climate_data(long, lat, climate_element, year):
#     table_name = "prism_{climate_element}_{year}".format(climate_element=climate_element,year=year)
#     curs = conn.cursor()
#     elems = []
#
#     start_date = date(year, 1, 1)
#     end_date = date(year, 12, 31)
#     delta = end_date - start_date
#     for i in range(delta.days + 1):
#         day = start_date + timedelta(days=i)
#         query = "SELECT st_value(ST_Union(rast),ST_SetSRID(ST_Point(%(long)s, %(lat)s),4269)) FROM %(table)s WHERE rast_date = %(rast_date)s;"
#         data = {"table": AsIs(table_name), "long": long, "lat": lat, "rast_date": day.strftime("%Y-%m-%d")}
#         curs.execute(query, data)
#         result = curs.fetchone()[0]
#         elems.append(result*1.8+32)
#     return elems


def load_stations_csv_to_db():
    cursor = mysql_conn.cursor()
    csvReader = csv.DictReader(open('crn-stations.csv'))
    for station in csvReader:
        if station['WMO ID'].isdigit():
            station_id = int(station['WMO ID'])
        else:
            station_id = None
        # some stations were not returning data from acis - we skip populating those stations
        if station['ID'] not in stations_not_found:
            query = "INSERT INTO climate.stations (latitude, longitude, elevation, name, int_network_id, char_network_id, type) VALUES (%s, %s, %s, %s, %s, %s, %s);"
            cursor.execute(query, (float(station['Lat']), float(station['Lon']), float(station['Elevation']), station['Name'], station_id, station['ID'], station['HCN/CRN']))
    mysql_conn.commit()
    cursor.close()


def load_station_states(stations):

    cursor = mysql_conn.cursor(dictionary=True)

    query = "SELECT * FROM climate.attribute_types;"
    cursor.execute(query)
    state_attribute_id = 0
    for attribute in cursor:
        if attribute['name'] == 'state':
            state_attribute_id = attribute['id']

    csvReader = csv.DictReader(open('crn-stations.csv'))
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


def load_sources():
    cursor = mysql_conn.cursor()
    csvReader = csv.DictReader(open('sources.csv'))
    for source in csvReader:
        query = "INSERT INTO climate.sources (name, description) VALUES (%s, %s);"
        cursor.execute(query, (source['Name'], source['Description']))
    mysql_conn.commit()
    cursor.close()


def get_sources():
    cursor = mysql_conn.cursor(dictionary=True)
    query = "SELECT * FROM climate.sources;"
    cursor.execute(query)
    sources = []
    for source in cursor:
        sources.append(source)
    return sources


def get_agdd(station_id, source_id, date, base, element):
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


def get_acis_climate_data(station_ids, climate_elements, start_date, end_date):
    url = 'http://data.rcc-acis.org/MultiStnData?sids={stations}&sdate={start_date}&edate={end_date}&elems={climate_elements}&output=json'.format(start_date=start_date.strftime("%Y-%m-%d"),end_date=end_date.strftime("%Y-%m-%d"),stations=station_ids,climate_elements=climate_elements)
    response = urlopen(url)
    str_response = response.readall().decode('utf-8')
    data = json.loads(str_response)
    return data


def get_urma_climate_data(long, lat, date, climate_element):
    if climate_element is 'tmin':
        table_name = "tmin_" + date.strftime("%Y")
    else:
        table_name = "tmax_" + date.strftime("%Y")
    curs = conn.cursor()

    query = "SELECT st_value(ST_Union(rast),ST_SetSRID(ST_Point(%(long)s, %(lat)s),4269)) FROM %(table)s WHERE rast_date = %(rast_date)s AND dataset = 'urma';"
    data = {"table": AsIs(table_name), "long": long, "lat": lat, "rast_date": date.strftime("%Y-%m-%d")}
    curs.execute(query, data)
    result = curs.fetchone()[0]
    return result


def get_prism_climate_data(long, lat, date, climate_element):
    if climate_element is 'tmin':
        table_name = "prism_tmin_" + date.strftime("%Y")
    else:
        table_name = "prism_tmax_" + date.strftime("%Y")
    curs = conn.cursor()

    query = "SELECT st_value(ST_Union(rast),ST_SetSRID(ST_Point(%(long)s, %(lat)s),4269)) FROM %(table)s WHERE rast_date = %(rast_date)s;"
    data = {"table": AsIs(table_name), "long": long, "lat": lat, "rast_date": date.strftime("%Y-%m-%d")}
    curs.execute(query, data)
    result = curs.fetchone()[0]
    return result


def compute_gdd(tmin, tmax, base):
    gdd = (tmin + tmax) / 2 - base
    if gdd < 0:
        return 0
    else:
        return gdd


def add_agdd_row(station_id, source_id, gdd, agdd, year, doy, date, base, missing, tmin, tmax):
    cursor = mysql_conn.cursor(buffered=True)
    query = "SELECT * FROM climate.agdds WHERE station_id = %s AND source_id = %s AND date = %s AND base_temp_f = %s ;"
    cursor.execute(query, (station_id, source_id, date, base))
    if cursor.rowcount < 1:
        query = "INSERT INTO climate.agdds (station_id, source_id, gdd, agdd, year, doy, date, base_temp_f, missing, tmin, tmax) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);"
        cursor.execute(query, (station_id, source_id, gdd, agdd, year, doy, date, base, missing, tmin, tmax))
    else:
        query = "UPDATE climate.agdds SET tmin = %s, tmax = %s, gdd = %s, agdd = %s, missing = %s WHERE station_id = %s AND source_id = %s AND base_temp_f = %s AND date = %s;"
        cursor.execute(query, (tmin, tmax, gdd, agdd, missing, station_id, source_id, base, date))
    mysql_conn.commit()
    cursor.close()


def populate_agdds(start_date, end_date, source, source_id, stations):
    # possibly grab ACIS station data (for entire date range)
    if source == 'ACIS':
        station_ids = []
        for station in stations:
            station_ids.append(station['char_network_id'])
        acis_data = get_acis_climate_data(",".join(station_ids), 'mint,maxt,gdd32,gdd50', start_date, end_date)

    for station in stations:
        print(station['char_network_id'])
        # grab previous days tmin, tmax, and agdd for both bases from mysql agdds table
        day_before_start_date = start_date - timedelta(days=1)

        prev_tmin = get_agdd(station['id'], source_id, day_before_start_date, 32, 'tmin')
        prev_tmax = get_agdd(station['id'], source_id, day_before_start_date, 32, 'tmax')
        agdd32 = get_agdd(station['id'], source_id, day_before_start_date, 32, 'agdd')
        agdd50 = get_agdd(station['id'], source_id, day_before_start_date, 50, 'agdd')

        if prev_tmin is None or prev_tmin == 'M':
            prev_tmin = 0
        if prev_tmax is None or prev_tmax == 'M':
            prev_tmax = 0
        if agdd32 is None or agdd32 == 'M':
            agdd32 = 0
        if agdd50 is None or agdd50 == 'M':
            agdd50 = 0

        # possibly find station of interest from ACIS retrieved data
        acis_station = None
        if source == 'ACIS':
            station_found = False
            for a_station in acis_data['data']:
                if station_found:
                    break
                for sid in a_station['meta']['sids']:
                    # print(sid)
                    # print(station['char_network_id'])
                    if station['char_network_id'] in sid:
                        station_found = True
                        acis_station = a_station
                        break
            if not station_found:
                print("Could not find station " + station['char_network_id'])

        delta = end_date - start_date
        for i in range(delta.days + 1):
            day = start_date + timedelta(days=i)
            doy = day.timetuple().tm_yday
            missing_data = False

            print(day.strftime("%Y-%m-%d"))

            # see if we already have tmin and tmax from local db
            # tmin = None
            # tmax = None
            tmin = get_agdd(station['id'], source_id, day, 32, 'tmin')
            tmax = get_agdd(station['id'], source_id, day, 32, 'tmax')

            already_retrieved = False
            if tmin is not None and tmin != 'M' and tmax is not None and tmax != 'M' and source != 'PRISM':
                already_retrieved = True

            # don't have already have tmin and tmax locally so grab from URMA postgis db or ACIS data
            if not already_retrieved:
                if source == 'URMA':
                    tmin = get_urma_climate_data(station['longitude'], station['latitude'], day, 'tmin')
                    tmax = get_urma_climate_data(station['longitude'], station['latitude'], day, 'tmax')
                    # URMA and PRISM are in celsius in our postgis db everything else is Fer so convert here
                    if tmin is not None:
                        tmin = tmin * 1.8 + 32
                    if tmax is not None:
                        tmax = tmax * 1.8 + 32
                elif source == 'PRISM':
                    tmin = get_prism_climate_data(station['longitude'], station['latitude'], day, 'tmin')
                    tmax = get_prism_climate_data(station['longitude'], station['latitude'], day, 'tmax')
                    if tmin is not None:
                        tmin = tmin * 1.8 + 32
                    if tmax is not None:
                        tmax = tmax * 1.8 + 32
                elif acis_station is not None:
                    tmin = acis_station['data'][i][0]
                    tmax = acis_station['data'][i][1]

            # if tmin or tmax is missing, set to previous day's and mark as missing
            if tmin is not None and tmin != 'M':
                tmin = float(tmin)
                prev_tmin = tmin
            else:
                missing_data = True
                tmin = prev_tmin
            if tmax is not None and tmax != 'M':
                tmax = float(tmax)
                prev_tmax = tmax
            else:
                missing_data = True
                tmax = prev_tmax

            # compute gdd and agdd for both bases
            gdd32 = compute_gdd(tmin, tmax, 32)
            gdd50 = compute_gdd(tmin, tmax, 50)

            agdd32 += gdd32
            agdd50 += gdd50

            if not already_retrieved:
                # do an insert or update
                add_agdd_row(station['id'], source_id, gdd32, agdd32, day.year, doy, day, 32, missing_data, tmin, tmax)
                add_agdd_row(station['id'], source_id, gdd50, agdd50, day.year, doy, day, 50, missing_data, tmin, tmax)


def populate_climate_qc():
    logging.info(' ')
    logging.info('-----------------beginning climate quality check population-----------------')

    # grab station ids
    cursor = mysql_conn.cursor(dictionary=True)
    query = "SELECT * FROM climate.stations;"
    cursor.execute(query)
    stations = []
    for station in cursor:
        stations.append(station)

    # grab sources
    sources = get_sources()
    acis_source_id = None
    urma_source_id = None
    prism_source_id = None
    for source in sources:
        if source['name'] == 'ACIS':
            acis_source_id = source['id']
        elif source['name'] == 'URMA':
            urma_source_id = source['id']
        elif source['name'] == 'PRISM':
            prism_source_id = source['id']

    logging.info(' ')
    logging.info('-----------------populating urma qc agdds-----------------')
    start_date = datetime.now().date() - timedelta(days=3)
    end_date = datetime.now().date()
    populate_agdds(start_date, end_date, 'URMA', urma_source_id, stations)

    logging.info(' ')
    logging.info('-----------------populating acis qc agdds-----------------')
    start_date = datetime.now().date() - timedelta(days=7)
    end_date = datetime.now().date()
    populate_agdds(start_date, end_date, 'ACIS', acis_source_id, stations)

    logging.info(' ')
    logging.info('-----------------populating prism qc agdds-----------------')
    start_date = datetime.now().date() - timedelta(days=7)
    # date(2016, 1, 1) #datetime.now().date() - timedelta(days=7)
    end_date = datetime.now().date() - timedelta(days=3)
    populate_agdds(start_date, end_date, 'PRISM', prism_source_id, stations)


if __name__ == "__main__":
    # todo prism is not yet working populate later
    # prism_tmins = get_prism_climate_data(-91.8731, 30.0917, "tmin", 2014)
    # prism_tmaxs = get_prism_climate_data(-91.8731, 30.0917, "tmax", 2014)

    populate_climate_qc()