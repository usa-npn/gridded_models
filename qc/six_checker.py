import logging
import numpy as np
from six.spring_index import spring_index_for_point
from qc.utils import *


def add_six_row(station_id, source_id, leaf_lilac, leaf_arnoldred, leaf_zabelli, leaf_average, bloom_lilac, bloom_arnoldred, bloom_zabelli, bloom_average, year, missing):
    if np.isnan(leaf_average):
        missing = True
        leaf_lilac, leaf_arnoldred, leaf_zabelli, leaf_average, bloom_lilac, bloom_arnoldred, bloom_zabelli, bloom_average = 0, 0, 0, 0, 0, 0, 0, 0
    if np.isnan(bloom_average):
        missing = True
        bloom_lilac, bloom_arnoldred, bloom_zabelli, bloom_average = 0, 0, 0, 0
    cursor = mysql_conn.cursor(buffered=True)
    query = "SELECT * FROM climate.six WHERE station_id = %s AND source_id = %s AND year = %s ;"
    cursor.execute(query, (station_id, source_id, year))
    if cursor.rowcount < 1:
        query = "INSERT INTO climate.six (station_id, source_id, leaf_lilac, leaf_arnoldred, leaf_zabelli, leaf_average, bloom_lilac, bloom_arnoldred, bloom_zabelli, bloom_average, year, missing) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);"
        cursor.execute(query, (station_id, source_id, leaf_lilac, leaf_arnoldred, leaf_zabelli, leaf_average, bloom_lilac, bloom_arnoldred, bloom_zabelli, bloom_average, year, missing))
    else:
        query = "UPDATE climate.six SET leaf_lilac = %s, leaf_arnoldred = %s, leaf_zabelli = %s, leaf_average = %s, bloom_lilac = %s, bloom_arnoldred = %s, bloom_zabelli = %s, bloom_average = %s, missing = %s WHERE station_id = %s AND source_id = %s AND year = %s;"
        cursor.execute(query, (leaf_lilac, leaf_arnoldred, leaf_zabelli, leaf_average, bloom_lilac, bloom_arnoldred, bloom_zabelli, bloom_average, missing, station_id, source_id, year))
    mysql_conn.commit()
    cursor.close()


def populate_six_in_qc_table(tmax, tmin, latitude, station_id, source_id, year):
    plants = ['lilac', 'arnoldred', 'zabelli']
    leaf_day = {'lilac': 0, 'arnoldred': 0, 'zabelli': 0, 'average': 0}
    bloom_day = {'lilac': 0, 'arnoldred': 0, 'zabelli': 0, 'average': 0}
    leaf_day_sum = 0
    bloom_day_sum = 0
    for plant in plants:
        leaf_day[plant] = spring_index_for_point(tmax, tmin, 31, 0, 'leaf', plant, latitude)
        leaf_day_sum += leaf_day[plant]
        bloom_day[plant] = spring_index_for_point(tmax, tmin, 31, leaf_day[plant], 'bloom', plant, latitude)
        bloom_day_sum += bloom_day[plant]
    leaf_day['average'] = leaf_day_sum / len(plants)
    bloom_day['average'] = bloom_day_sum / len(plants)
    add_six_row(station_id, source_id,
                leaf_day['lilac'], leaf_day['arnoldred'], leaf_day['zabelli'], leaf_day['average'],
                bloom_day['lilac'], bloom_day['arnoldred'], bloom_day['zabelli'], bloom_day['average'], year, False)


def populate_six_using_temps_from_qc_table(start_date, end_date, source_id, stations):
    year = start_date.year
    num_days = (end_date - start_date).days
    if num_days > 240:
        num_days = 240

    for station in stations:
        station_id = station['id']
        latitude = station['latitude']

        tmin = get_temps_for_year_from_qc_table(station_id, 'tmin', source_id, year)
        tmax = get_temps_for_year_from_qc_table(station_id, 'tmax', source_id, year)

        tmin = np.array(tmin[:num_days])
        tmax = np.array(tmax[:num_days])

        populate_six_in_qc_table(tmax, tmin, latitude, station_id, source_id, year)


def populate_six_qc(urma_start, urma_end, acis_start, acis_end, prism_start, prism_end):
    """Populates the six table using urma, acis, and prism data for qc purposes."""
    logging.info(' ')
    logging.info('-----------------beginning si-x quality check population-----------------')

    stations = get_stations()

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
    logging.info('-----------------populating urma qc si-x-----------------')
    populate_six_using_temps_from_qc_table(urma_start, urma_end, urma_source_id, stations)

    logging.info(' ')
    logging.info('-----------------populating acis qc si-x-----------------')
    populate_six_using_temps_from_qc_table(acis_start, acis_end, acis_source_id, stations)

    logging.info(' ')
    logging.info('-----------------populating prism qc si-x-----------------')
    populate_six_using_temps_from_qc_table(prism_start, prism_end, prism_source_id, stations)


def populate_historic_six_points(year):
    """Populates the six table using acis, and prism data for qc purposes."""
    num_days = 240
    line = '-------------------------------------------------------------------------------------------------------------------------------------------------------------------'
    logging.info(line)
    logging.info('CRN Temps For Year: {year}'.format(year=year))
    print('CRN Temps For Year: {year}'.format(year=year))
    logging.info(line)

    start_date = date(year, 1, 1)
    end_date = date(year, 12, 31)
    climate_elements = 'mint,maxt'

    station_ids = []
    stations = get_stations()
    for station in stations:
        station_ids.append(station['char_network_id'])

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

    data = get_acis_climate_data(",".join(station_ids), climate_elements, start_date, end_date)

    complete_stations = 0

    for station in data['data']:
        missing = False

        acis_tmin = []
        acis_tmax = []

        for sid in station['meta']['sids']:
            for s in stations:
                if s['char_network_id'] in sid:
                    station_id = s['id']
                    break

        logging.info('***Station has some data: {station}'.format(station=station['meta']))
        longitude = station['meta']['ll'][0]
        latitude = station['meta']['ll'][1]
        for doy in range(num_days):
            station_data = station['data']
            acis_tmin.append(station_data[doy][0])
            acis_tmax.append(station_data[doy][1])
            if acis_tmin[doy] == 'M' or acis_tmax[doy] == 'M':
                missing = True
                logging.info('Missing data on day of year {doy}... here is the data up to the missing day'.format(doy=doy+1))
                break

        prism_tmin = []
        prism_tmax = []
        prev_tmin = 0
        prev_tmax = 0
        if not missing:
            acis_tmin = list(map(float, acis_tmin))
            acis_tmax = list(map(float, acis_tmax))
            complete_stations += 1
            for i in range(num_days):
                day = start_date + timedelta(days=i)
                t_min = get_prism_climate_data(longitude, latitude, day, 'tmin')
                t_max = get_prism_climate_data(longitude, latitude, day, 'tmax')
                if t_min is not None:
                    t_min = t_min * 1.8 + 32
                else:
                    t_min = prev_tmin
                if t_max is not None:
                    t_max = t_max * 1.8 + 32
                else:
                    t_max = prev_tmax
                prev_tmin = t_min
                prev_tmax = t_max
                prism_tmin.append(float(t_min))
                prism_tmax.append(float(t_max))
            #min_diffs = np.array(acis_tmin[:num_days]) - np.array(prism_tmin[:num_days])
            #max_diffs = np.array(acis_tmax[:num_days]) - np.array(prism_tmax[:num_days])
            populate_six_in_qc_table(np.array(acis_tmax[:num_days]), np.array(acis_tmin[:num_days]), latitude, station_id, acis_source_id, year)
            populate_six_in_qc_table(np.array(prism_tmax[:num_days]), np.array(prism_tmin[:num_days]), latitude, station_id, prism_source_id, year)

        logging.info('acis_tmin: {tmin}'.format(tmin=acis_tmin))
        logging.info('prism_tmin: {tmin}'.format(tmin=prism_tmin))
        logging.info('acis_tmax: {tmax}'.format(tmax=acis_tmax))
        logging.info('prism_tmax: {tmax}'.format(tmax=prism_tmax))
    logging.info('####Year: {year} had {complete_stations} stations with no missing data'.format(year=year,complete_stations=complete_stations))
    print('####Year: {year} had {complete_stations} stations with no missing data'.format(year=year,complete_stations=complete_stations))


if __name__ == "__main__":
    print('nothing yet')
    #load_acis_csv_to_db()
    # populate_agdd_qc()