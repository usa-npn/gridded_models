import logging
from qc.utils import *


def compute_gdd(tmin, tmax, base):
    """Computes growing degree days for one day.
    :param tmin: day's minimum temperature
    :param tmax: day's maximum temperature
    :param base: base temperature
    :return: growing degree days
    """
    gdd = (tmin + tmax) / 2 - base
    if gdd < 0:
        return 0
    else:
        return gdd


def add_agdd_row(station_id, source_id, gdd, agdd, year, doy, date, base, missing, tmin, tmax):
    """Inserts or updates a row in the agdds table."""
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
    """Retrieves tmin and tmax data from climate source and computes agdds to be inserted into the agdd table."""
    # possibly grab ACIS station data (for entire date range)
    if source == 'ACIS':
        station_ids = []
        for station in stations:
            station_ids.append(station['char_network_id'])
        acis_data = get_acis_climate_data(",".join(station_ids), 'mint,maxt,gdd32,gdd50', start_date, end_date)

    for station in stations:
        print(station['char_network_id'])
        # grab previous days tmin, tmax, and agdd for both bases from mysql agdds table and start over at year breaks
        day_before_start_date = start_date - timedelta(days=1)
        if day_before_start_date.year == start_date.year:
            prev_tmin = get_element_from_qc_table(station['id'], source_id, day_before_start_date, 32, 'tmin')
            prev_tmax = get_element_from_qc_table(station['id'], source_id, day_before_start_date, 32, 'tmax')
            agdd32 = get_element_from_qc_table(station['id'], source_id, day_before_start_date, 32, 'agdd')
            agdd50 = get_element_from_qc_table(station['id'], source_id, day_before_start_date, 50, 'agdd')

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

        previous_year = start_date.year
        delta = end_date - start_date
        for i in range(delta.days + 1):
            day = start_date + timedelta(days=i)
            doy = day.timetuple().tm_yday

            # reset the agdd to 0 if we go into a new year
            if previous_year != day.year:
                agdd32 = 0
                agdd50 = 0
            previous_year = day.year

            missing_data = False
            print(day.strftime("%Y-%m-%d"))

            # see if we already have tmin and tmax from local db
            # tmin = None
            # tmax = None
            tmin = get_element_from_qc_table(station['id'], source_id, day, 32, 'tmin')
            tmax = get_element_from_qc_table(station['id'], source_id, day, 32, 'tmax')

            already_retrieved = False
            if tmin is not None and tmin != 'M' and tmax is not None and tmax != 'M' and source != 'PRISM':
                already_retrieved = True

            # don't already have tmin and tmax locally so grab from URMA postgis db or ACIS data
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


def populate_agdd_qc(urma_start, urma_end, acis_start, acis_end, prism_start, prism_end):
    """Populates the agdds table with urma, acis, and prism temps and agdds for qc purposes."""
    logging.info(' ')
    logging.info('-----------------beginning climate quality check population-----------------')

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
    logging.info('-----------------populating urma qc agdds-----------------')
    populate_agdds(urma_start, urma_end, 'URMA', urma_source_id, stations)

    logging.info(' ')
    logging.info('-----------------populating acis qc agdds-----------------')
    populate_agdds(acis_start, acis_end, 'ACIS', acis_source_id, stations)

    logging.info(' ')
    logging.info('-----------------populating prism qc agdds-----------------')
    populate_agdds(prism_start, prism_end, 'PRISM', prism_source_id, stations)


if __name__ == "__main__":
    print("nothing to do")
