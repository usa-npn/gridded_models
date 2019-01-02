from datetime import datetime, timedelta
from util.raster import *
from util.database import *
import numpy as np
from datetime import date
import logging
from osgeo import gdal


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), os.path.pardir, 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)

def dynamic_agdd_in_db(agdd_table_name, start_date, num_days):

    (rast_cols, rast_rows, transform, projection, no_data_value) = get_raster_info(agdd_table_name, start_date)

#     query = """
#           CREATE OR REPLACE FUNCTION agdd (start_date DATE, n INTEGER) 
#  RETURNS RASTER AS $$ 
# DECLARE
#    counter INTEGER := 1 ; 
#    agdd RASTER;
# BEGIN
 
#  IF (n < 1) THEN
#  RETURN 0 ;
#  END IF; 
 
#  SELECT ST_Union(ST_MapAlgebra(rast, NULL, '[rast]-25')) FROM prism_tmin_1989 WHERE rast_date = start_date INTO agdd;

#  LOOP 
#  EXIT WHEN counter = n ; 
#  counter := counter + 1 ;
#  SELECT ST_MapAlgebra(ST_UNION(rast), agdd, '[rast1]+[rast2]-25') FROM prism_tmin_1989 WHERE rast_date = start_date + counter INTO agdd;
#  END LOOP ; 
 
#  RETURN agdd;
# END ; 
# $$ LANGUAGE plpgsql;
# SELECT ST_AsGDALRaster(agdd('1989-09-01', 22), 'Gtiff');"""

    query = """
CREATE OR REPLACE FUNCTION agdd (start_date DATE, n INTEGER) 
 RETURNS RASTER AS $$ 
DECLARE
   counter INTEGER := 1 ; 
   agdd RASTER;
BEGIN
 
 SELECT ST_Union(rast, 'SUM') FROM prism_tmin_1989 WHERE rast_date = start_date INTO agdd;

 LOOP 
 EXIT WHEN counter = n ; 
 counter := counter + 1 ;
 SELECT ST_Union(rast, 'SUM') FROM prism_tmin_1989 WHERE rast_date = start_date + counter OR rast_date = start_date INTO agdd;
 END LOOP ; 
 
 RETURN agdd;
END ; 
$$ LANGUAGE plpgsql;
SELECT ST_AsGDALRaster(agdd('1989-09-01', 20), 'Gtiff');"""

#     query = """
# CREATE OR REPLACE FUNCTION agdd (start_date DATE, n INTEGER) 
#  RETURNS RASTER AS $$ 
# DECLARE
#    counter INTEGER := 1 ; 
#    agdd RASTER;
# BEGIN
 
#  SELECT ST_Union(rast, 'SUM') FROM prism_tmin_1989 WHERE rast_date < start_date + n AND rast_date > start_date INTO agdd;
 
#  RETURN agdd;
# END ; 
# $$ LANGUAGE plpgsql;
# SELECT ST_AsGDALRaster(agdd('1989-09-01', 20), 'Gtiff');"""
    data = (AsIs(agdd_table_name), start_date.strftime("%Y-%m-%d"))
    agdd = get_raster_from_query(query, data)

    save_path = '/Users/npn/Desktop/'
    file_name = 'dynamic_agdd_' + start_date.strftime("%Y-%m-%d") + '_' + str(num_days) + '.tif'
    file_path = save_path + file_name
    write_raster(file_path, agdd, no_data_value, rast_cols, rast_rows, projection, transform)


def import_agdd_anomalies(anomaly_date, base):
    logging.info(' ')
    logging.info('-----------------populating agdd anomalies (base %s)-----------------', base)

    first_day_of_year = date(anomaly_date.year, 1, 1)
    day = first_day_of_year
    delta = timedelta(days=1)

    agdd_table_name = 'agdd_' + anomaly_date.strftime("%Y")
    agdd_avg_table = 'prism_30yr_avg_agdd'
    agdd_anomaly_table_name = 'agdd_anomaly_' + anomaly_date.strftime("%Y")

    scale = 'fahrenheit'
    if base == 32:
        time_series_table_name = 'agdd_anomaly'
        save_path = cfg["agdd_anomaly_path"]
    elif base == 50:
        time_series_table_name = 'agdd_anomaly_50f'
        save_path = cfg["agdd_anomaly_50f_path"]
    else:
        logging.error('unsupported base: %s', base)
        return

    os.makedirs(os.path.dirname(save_path), exist_ok=True)

    new_table = not table_exists(agdd_anomaly_table_name)
    new_time_series = not table_exists(time_series_table_name)

    (rast_cols, rast_rows, transform, projection, no_data_value) = get_raster_info(agdd_table_name, first_day_of_year)

    while day <= anomaly_date:
        day_of_year = day.timetuple().tm_yday
        today = datetime.today().date()

        #can't see more than a week into the future
        if day > (today + timedelta(days=8)):
            day += delta
            continue

        # skip if agdd anomaly has already been computed and is older than 8 days
        # (otherwise recompute it, because newer tmin/tmax files get updated nightly)
        if not new_table and day < (today - timedelta(days=8)) and agdd_row_exists(agdd_anomaly_table_name, scale, base, day):
            # logging.info('skipping day %s because it already exists', day.strftime("%Y-%m-%d"))
            day += delta
            continue

        query = """
          SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff')
          FROM %s
          WHERE base = %s AND scale = %s AND rast_date = %s;"""
        data = (AsIs(agdd_table_name), base, 'fahrenheit', day.strftime("%Y-%m-%d"))
        agdd = get_raster_from_query(query, data)

        query = """
          SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff')
          FROM %s
          WHERE base = %s AND scale = %s AND doy = %s;"""
        data = (AsIs(agdd_avg_table), base, 'fahrenheit', day_of_year)
        av_agdd = get_raster_from_query(query, data)

        if agdd is None:
            logging.warning('skipping - could not get agdd for date: %s', day.strftime("%Y-%m-%d"))
            day += delta
            continue

        if av_agdd is None:
            logging.warning('skipping - could not get av_agdd for day of year: %s', str(day_of_year))
            day += delta
            continue

        # convert -9999 values to not a number so we don't have to worry about manipulating them
        agdd[agdd == -9999.0] = np.nan
        av_agdd[av_agdd == -9999.0] = np.nan

        diff_agdd = agdd - av_agdd
        diff_agdd[diff_agdd == np.nan] = -9999

        # write the raster to disk and import it to the database
        if base == 50:
            file_name = 'agdd_anomaly_' + day.strftime("%Y%m%d") + '_base_fifty_f.tif'
        else:
            file_name = 'agdd_anomaly_' + day.strftime("%Y%m%d") + '_base_thirtytwo_f.tif'
        file_path = save_path + file_name
        write_raster(file_path, diff_agdd, no_data_value, rast_cols, rast_rows, projection, transform)
        save_raster_to_postgis(file_path, agdd_anomaly_table_name, 4269)
        set_date_column(agdd_anomaly_table_name, day, new_table)
        set_scale_column(agdd_anomaly_table_name, 'fahrenheit', new_table)
        set_base_column(agdd_anomaly_table_name, base, new_table)
        if not new_time_series:
            update_time_series(time_series_table_name, file_name, day)
        new_table = False
        logging.info('populated agdd anomaly (base %s) for %s based on historical agdd average for doy %s', base, day.strftime("%Y-%m-%d"), str(day_of_year))

        day += delta


def dynamic_double_sine_agdd(start_date, num_days, lct, uct, climate_data_provider, region, temp_unit):
    end_date = start_date + timedelta(days=num_days)
    logging.info(' ')
    logging.info("computing double sine agdd {region} {climate_data_provider} {start_date} through {end_date} (lower threshold {lower_thresh}, upper threshold {upper_thresh})"
        .format(region=region, climate_data_provider=climate_data_provider, start_date=start_date.strftime("%Y-%m-%d"), end_date=end_date.strftime("%Y-%m-%d"), lower_thresh = lct, upper_thresh = uct))

    # save_path = '/Users/npn/Development/temp/ncep_daily/agdd/'
    save_path = cfg["dynamic_agdd_path"]
    
    os.makedirs(os.path.dirname(save_path), exist_ok=True)

    day = start_date
    delta = timedelta(days=1)

    agdd = None
    first = True
    projection = None
    transform = None
    tmin_prev_day = None

    while day <= start_date + timedelta(days=num_days):
        logging.info("day = {day}".format(day=day.strftime("%Y-%m-%d")))
        try:

            tmin_tif_path = None
            tmax_tif_path = None
            tmin = None
            tmax = None

            # todo later if possible (prism temps not outdb)
            # if climate_data_provider == 'prism':
            #     tavg_tif_path = "/geo-vault/climate_data/prism/prism_data/tavg/tavg_{day}.tif".format(day=day.strftime("%Y%m%d"))

            if climate_data_provider == 'ncep':
                tmin_tif_path = "/geo-data/climate_data/daily_data/tmin/tmin_{day}.tif".format(day=day.strftime("%Y%m%d"))
                tmax_tif_path = "/geo-data/climate_data/daily_data/tmax/tmax_{day}.tif".format(day=day.strftime("%Y%m%d"))
                # tmin_tif_path = "/Users/npn/Development/temp/ncep_daily/tmin/tmin_{day}.tif".format(day=day.strftime("%Y%m%d"))
                # tmax_tif_path = "/Users/npn/Development/temp/ncep_daily/tmax/tmax_{day}.tif".format(day=day.strftime("%Y%m%d"))
                tmin = get_climate_data_from_file(tmin_tif_path, temp_unit)
                tmax = get_climate_data_from_file(tmax_tif_path, temp_unit)
                if first:
                    ds = gdal.Open(tmin_tif_path)
                    projection = ds.GetProjection()
                    transform = ds.GetGeoTransform()
                    ds = None
            elif climate_data_provider == 'prism':
                tmin_table_name = 'prism_tmin_' + day.strftime("%Y")
                tmax_table_name = 'prism_tmax_' + day.strftime("%Y")
                tmin = get_climate_data(tmin_table_name, day, temp_unit)
                tmax = get_climate_data(tmax_table_name, day, temp_unit)
                if first:
                    (rast_cols, rast_rows, transform, projection, no_data_value) = get_raster_info(tmin_table_name, day)

            if first:
                tmin_prev_day = np.copy(tmin)                

            # double sine algorithm
            taveam = (tmax + tmin_prev_day) / 2
            tavepm = (tmax + tmin) / 2
            alphaam = (tmax - tmin_prev_day) / 2
            thetaam = np.arcsin((lct - taveam) / alphaam)
            alphapm = (tmax - tmin) / 2
            thetapm = np.arcsin((lct - tavepm) / alphapm)
            theta2am = np.arcsin((uct - taveam) / alphaam)
            theta2pm = np.arcsin((uct - tavepm) / alphapm)

            # case 1 If the lower temperature exceeds the upper critical temperature then there is development
            case1_outer_condition = tmin_prev_day >= uct
            case1am = np.where(case1_outer_condition, 0.5*(uct-lct), 0)
            case1pm1 = np.where(np.logical_and(case1_outer_condition, tmin >=uct), 
            0.5*(uct-lct), 0)
            case1pm2 = np.where(np.logical_and(case1_outer_condition, np.logical_and(tmin < uct, tmin >= lct)),
            (1 / (2 * np.pi)) * ((tavepm - lct) * (theta2pm + (np.pi / 2)) + (uct-lct) * ((np.pi / 2) - theta2pm) - (alphapm * np.cos(theta2pm))), 0)
            case1pm3 = np.where(np.logical_and(case1_outer_condition, np.logical_and(tmin < uct, tmin < lct)),
            (1 / (2 * np.pi)) * ((tavepm - lct) * (theta2pm - thetapm) + alphapm * (np.cos(thetapm) - np.cos(theta2pm)) + (uct - lct) * ((np.pi / 2) - theta2pm)), 0)
            case1pm = case1pm1 + case1pm2 + case1pm3
            case1gdd = case1am + case1pm
            

            # case 2 If the upper temperature exceeds the lower critical temperature then there is no development
            # case2_outer_condition = tmax < lct
            # this becomes a no opp
            # case2gdd = np.where(case2_outer_condition, 0, 0)


            # Case 3, tmin1 and maximum temperature both between upper and lower critical threshold temperatures.
            case3_outer_condition = np.logical_and(
                # np.logical_not(case1_outer_condition),
                # np.logical_not(case2_outer_condition),
                np.logical_and(tmin_prev_day >= lct, tmin_prev_day < uct), 
                np.logical_and(tmax >= lct, tmax <= uct))
            case3am = np.where(case3_outer_condition, 0.5*(taveam-lct), 0)
            case3pm1 = np.where(np.logical_and(case3_outer_condition, np.logical_and(tmin >= lct, tmin <= uct)), # case 3, tmin and tmax between thresholds
            0.5 * (tavepm - lct), 0)
            case3pm2 = np.where(np.logical_and(case3_outer_condition, tmin < lct), # case 4, tmin below lct, tmax between thresholds
            (1 / (2 * np.pi)) * ((tavepm - lct) * ((np.pi / 2) - thetapm) + (alphapm * np.cos(thetapm))), 0)
            case3pm = case3pm1 + case3pm2
            case3gdd = case3am + case3pm


            # Case 4, minimum temperature is below minimum critical threshold temperature, but maximum temperature is above minimum critical threshold temperature, and below maximum critical threshold temperature.
            case4_outer_condition = np.logical_and(tmin_prev_day < lct, np.logical_and(tmax >= lct, tmax <= uct))
            case4am = np.where(case4_outer_condition,
            (1 / (2 * np.pi)) * ((taveam - lct) * ((np.pi / 2) - thetaam) + (alphaam * np.cos(thetaam))), 0)
            case4pm1 = np.where(np.logical_and(case4_outer_condition, tmin < lct), # case 4, tmin below lct, tmax between thresholds
            (1 / (2 * np.pi)) * ((tavepm - lct) * ((np.pi / 2) - thetapm) + (alphapm * np.cos(thetapm))), 0)
            case4pm2 = np.where(np.logical_and(case4_outer_condition, tmin >= lct), # case 3, tmin between thresholds, tmax between threshold
            0.5 * (tavepm - lct), 0)
            case4pm = case4pm1 + case4pm2
            case4gdd = case4am + case4pm


            # Case 5, minimum temperature is between the minimum and maximum critical temperature thresholds, but the maximum temperature is above the maximum critical temperature threshold.
            case5_outer_condition = np.logical_and(np.logical_and(tmin_prev_day >= lct, tmin_prev_day < uct), tmax > uct)
            case5am = np.where(case5_outer_condition,
            (1 / (2 * np.pi)) * (((taveam - lct) * (theta2am + (np.pi / 2)) + (uct - lct) * ((np.pi / 2) - theta2am) - (alphaam * np.cos(theta2am)))), 0)
            case5pm1 = np.where(np.logical_and(case5_outer_condition, np.logical_and(tmin >= lct, tmin <= uct)), # case 5, tmin between thresholds, tmax above uct
            (1 / (2 * np.pi)) * ((tavepm - lct) * (theta2pm + (np.pi / 2)) + (uct-lct) * ((np.pi / 2) - theta2pm) - (alphapm * np.cos(theta2pm))), 0)
            case5pm2 = np.where(np.logical_and(case5_outer_condition, tmin < lct), # case 6, tmin below lct, tmax above uct
            (1 / (2 * np.pi)) * ((tavepm - lct) * (theta2pm - thetapm) + alphapm * (np.cos(thetapm) - np.cos(theta2pm)) + (uct - lct) * ((np.pi / 2) - theta2pm)), 0)
            case5pm3 = np.where(np.logical_and(case5_outer_condition, tmin > uct), #case 1, tmin2 and tmax above uct
            0.5 * (uct-lct), 0)
            case5pm = case5pm1 + case5pm2 + case5pm3
            case5gdd = case5am + case5pm


            # Case 6, minimum temperature is below the minimum critical threshold temperature, and maximum temperature is above the maximum critical threshold temperature.
            case6_outer_condition = np.logical_and(tmin_prev_day < lct, tmax > uct)
            case6am = np.where(case6_outer_condition,
            (1 / (2 * np.pi)) * ((taveam - lct) * (theta2am - thetaam) + alphaam * (np.cos(thetaam) - np.cos(theta2am)) + (uct - lct) * ((np.pi / 2) - theta2am)), 0)
            case6pm1 = np.where(np.logical_and(case6_outer_condition, np.logical_and(tmin >= lct, tmin < lct)), # case 6, tmin below lct, tmax above uct
            (1 / (2 * np.pi)) * ((tavepm - lct) * (theta2pm - thetapm) + alphapm * (np.cos(thetapm) - np.cos(theta2pm)) + (uct - lct) * ((np.pi / 2) - theta2pm)), 0)
            case6pm2 = np.where(np.logical_and(case6_outer_condition, np.logical_and(tmin < uct, tmin >= lct)), # case 5, tmin2 between thresholds, tmax abov uct
            (1 / (2 * np.pi)) * ((tavepm - lct) * (theta2pm + (np.pi / 2)) + (uct - lct) * ((np.pi / 2) - theta2pm) - (alphapm * np.cos(theta2pm))), 0)
            case6pm3 = np.where(np.logical_and(case6_outer_condition, tmin >= uct), # case 1, tmin and tmax above uct
            0.5 * (uct-lct), 0)
            case6pm = case6pm1 + case6pm2 + case6pm3
            case6gdd = case6am + case6pm

            gdd = case1gdd + case3gdd + case4gdd + case5gdd + case6gdd
            gdd[gdd < 0] = 0
            
            if not first:
                agdd += gdd
            else:
                oceanMask = np.where(np.isnan(tmax), np.nan, 0)
                agdd = gdd + oceanMask

            first = False
            tmin_prev_day = np.copy(tmin)

        except():
            logging.error('skipping - could not compute double-sine agdd (lower_thresh %s, upper_thresh %s) for date: %s due to an exception', lct, uct, day.strftime("%Y-%m-%d"))

        day += delta
    
    # replace no data values
    no_data_value = -9999
    agdd[np.isnan(agdd)] = no_data_value

    # write the raster to disk
    file_name = "{climate}_{temp_unit}_double_sine_{start_date}_through_{end_date}_lthr{lower_thresh}_uthr{upper_thresh}.tif".format(climate=climate_data_provider, temp_unit=temp_unit, start_date=start_date.strftime("%Y-%m-%d"), end_date=end_date.strftime("%Y-%m-%d"), lower_thresh=lct, upper_thresh=uct)
    file_path = save_path + file_name
    rast_cols = 1405
    rast_rows = 621
    # transform = [-125.02083333333336, 0.0416666666667, 0.0, 49.937499999999766, 0.0, -0.0416666666667]
    # projection = 'GEOGCS["NAD83",DATUM["North_American_Datum_1983",SPHEROID["GRS 1980",6378137,298.2572221010042,AUTHORITY["EPSG","7019"]],TOWGS84[0,0,0,0,0,0,0],AUTHORITY["EPSG","6269"]],PRIMEM["Greenwich",0],UNIT["degree",0.0174532925199433],AUTHORITY["EPSG","4269"]]'
    
    if climate_data_provider == 'ncep':
        rast_cols = 2606
        rast_rows = 1228
    write_raster(file_path, agdd, no_data_value, rast_cols, rast_rows, projection, transform)
    ds = None
    print('file saved to: ' + file_path)


def dynamic_agdd(start_date, num_days, base, climate_data_provider, region, temp_unit):
    end_date = start_date + timedelta(days=num_days)
    logging.info(' ')
    logging.info("computing agdd {region} {climate_data_provider} {start_date} through {end_date} (base {base})"
        .format(region=region, climate_data_provider=climate_data_provider, start_date=start_date.strftime("%Y-%m-%d"), end_date=end_date.strftime("%Y-%m-%d"), base=base))
    # set up path to save geotiffs to along with geoserver layer table
    save_path = cfg["dynamic_agdd_path"]
    
    os.makedirs(os.path.dirname(save_path), exist_ok=True)

    day = start_date
    delta = timedelta(days=1)

    # (rast_cols, rast_rows, transform, projection, no_data_value) = get_raster_info(tmin_table_name, start_date)

    agdd = None
    first = True
    projection = None
    transform = None
    while day <= start_date + timedelta(days=num_days):
        logging.info("day = {day}".format(day=day.strftime("%Y-%m-%d")))
        try:

            tavg_tif_path = None

            if climate_data_provider == 'prism':
                tavg_tif_path = "/geo-vault/climate_data/prism/prism_data/tavg/tavg_{day}.tif".format(day=day.strftime("%Y%m%d"))

            if climate_data_provider == 'ncep':
                tavg_tif_path = "/geo-data/climate_data/daily_data/tavg/tavg_{day}.tif".format(day=day.strftime("%Y%m%d"))
            
            tavg = get_climate_data_from_file(tavg_tif_path, 'already_stored_as_fahrenheit')

            if temp_unit == 'celsius':
                tavg = (tavg - 32) * (5/9)

            if first:
                ds = gdal.Open(tavg_tif_path)
                projection = ds.GetProjection()
                transform = ds.GetGeoTransform()
                ds = None

            gdd = tavg - base
            gdd[gdd < 0] = 0
            
            if not first:
                agdd += gdd
            else:
                agdd = gdd

            first = False

        except():
            logging.error('skipping - could not compute agdd (base %s) for date: %s due to an exception', base, day.strftime("%Y-%m-%d"))

        day += delta
    
    # replace no data values
    no_data_value = -9999
    agdd[np.isnan(agdd)] = no_data_value

    # write the raster to disk
    file_name = "{climate}_{temp_unit}_simple_{start_date}_through_{end_date}_base{base}.tif".format(climate=climate_data_provider, temp_unit=temp_unit, start_date=start_date.strftime("%Y-%m-%d"), end_date=end_date.strftime("%Y-%m-%d"), base=base)
    file_path = save_path + file_name
    rast_cols = 1405
    rast_rows = 621
    # transform = [-125.02083333333336, 0.0416666666667, 0.0, 49.937499999999766, 0.0, -0.0416666666667]
    # projection = 'GEOGCS["NAD83",DATUM["North_American_Datum_1983",SPHEROID["GRS 1980",6378137,298.2572221010042,AUTHORITY["EPSG","7019"]],TOWGS84[0,0,0,0,0,0,0],AUTHORITY["EPSG","6269"]],PRIMEM["Greenwich",0],UNIT["degree",0.0174532925199433],AUTHORITY["EPSG","4269"]]'
    
    if climate_data_provider == 'ncep':
        rast_cols = 2606
        rast_rows = 1228
    write_raster(file_path, agdd, no_data_value, rast_cols, rast_rows, projection, transform)
    ds = None
    print('file saved to: ' + file_path)


def import_agdd(agdd_date, base, climate_data_provider, region):
    logging.info(' ')
    logging.info("-----------------populating {region} {climate_data_provider} agdds (base {base})-----------------"
                 .format(region=region, climate_data_provider=climate_data_provider, base=base))
    # set up path to save geotiffs to along with geoserver layer table
    scale = 'fahrenheit'
    if base == 32:
        if climate_data_provider == 'prism':
            save_path = cfg["prism_agdd_path"]
            time_series_table_name = 'prism_agdd'
        else:
            if region == 'alaska':
                save_path = cfg["agdd_alaska_path"]
                time_series_table_name = 'agdd_alaska'
            else:
                save_path = cfg["agdd_path"]
                time_series_table_name = 'agdd'
    elif base == 50:
        if climate_data_provider == 'prism':
            save_path = cfg["prism_agdd_50f_path"]
            time_series_table_name = 'prism_agdd_50f'
        else:
            if region == 'alaska':
                save_path = cfg["agdd_alaska_50f_path"]
                time_series_table_name = 'agdd_alaska_50f'
            else:
                save_path = cfg["agdd_50f_path"]
                time_series_table_name = 'agdd_50f'
    else:
        logging.error('unsupported base: %s', base)
        return
    os.makedirs(os.path.dirname(save_path), exist_ok=True)

    # tables used to get climate data
    if climate_data_provider == 'ncep':
        if region == 'alaska':
            tmin_table_name = 'tmin_alaska_' + agdd_date.strftime("%Y")
            tmax_table_name = 'tmax_alaska_' + agdd_date.strftime("%Y")
        else:
            tmin_table_name = 'tmin_' + agdd_date.strftime("%Y")
            tmax_table_name = 'tmax_' + agdd_date.strftime("%Y")
    elif climate_data_provider == 'prism':
        tmin_table_name = 'prism_tmin_' + agdd_date.strftime("%Y")
        tmax_table_name = 'prism_tmax_' + agdd_date.strftime("%Y")
    else:
        logging.error('invalid climate data provider: %s', climate_data_provider)

    if not table_exists(tmin_table_name):
        logging.info('cannot compute agdd tmin table doesnt yet exist: %s ', tmin_table_name)
        return

    if not table_exists(tmax_table_name):
        logging.info('cannot compute agdd tmax table doesnt yet exist: %s ', tmax_table_name)
        return

    # table to save agdd data to
    if climate_data_provider == 'ncep':
        if region == 'alaska':
            agdd_table_name = 'agdd_alaska_' + agdd_date.strftime("%Y")
        else:
            agdd_table_name = 'agdd_' + agdd_date.strftime("%Y")
    elif climate_data_provider == 'prism':
        agdd_table_name = 'prism_agdd_' + agdd_date.strftime("%Y")
    else:
        logging.error('invalid climate data provider: %s', climate_data_provider)

    first_day_of_year = date(agdd_date.year, 1, 1)
    day = first_day_of_year
    delta = timedelta(days=1)

    new_table = not table_exists(agdd_table_name)
    new_time_series = not table_exists(time_series_table_name)

    (rast_cols, rast_rows, transform, projection, no_data_value) = get_raster_info(tmin_table_name, first_day_of_year)

    while day <= agdd_date:

        today = datetime.today().date()

        # can't see past yesterday with prism data
        if climate_data_provider == 'prism':
            if day > (today - timedelta(days=1)):
                day += delta
                continue

        # can't see more than a week into the future using ncep data
        if day > (today + timedelta(days=8)):
            day += delta
            continue

        # skip if agdd has already been computed and is older than 3 days and it's not from PRISM
        # (otherwise recompute it, because newer tmin/tmax files get updated nightly)
        if climate_data_provider != 'prism' and not new_table and day < (today - timedelta(days=3)) and agdd_row_exists(agdd_table_name, scale, base, day):
            day += delta
            continue

        # only need to get previous days gdd if it's not Jan 1st
        if day != first_day_of_year:
            previous_day = day - delta
            query = """
              SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff')
              FROM %s
              WHERE base = %s AND scale = %s AND rast_date = %s;"""
            data = (AsIs(agdd_table_name), base, 'fahrenheit', previous_day.strftime("%Y-%m-%d"))
            previous_day_agdd = get_raster_from_query(query, data)

            if previous_day_agdd is None:
                logging.warning('skipping - could not get agdd for date: %s', previous_day.strftime("%Y-%m-%d"))
                day += delta
                continue
            else:
                # convert -9999 values to not a number so we don't have to worry about manipulating them
                previous_day_agdd[previous_day_agdd == -9999.0] = np.nan

        # compute gdd
        try:
            tmin = get_climate_data(tmin_table_name, day, 'fahrenheit')
            tmax = get_climate_data(tmax_table_name, day, 'fahrenheit')
            if tmin is None:
                logging.warning('skipping - could not get tmin for date: %s', day.strftime("%Y-%m-%d"))
                day += delta
                continue

            if tmax is None:
                logging.warning('skipping - could not get tmax for date: %s', day.strftime("%Y-%m-%d"))
                day += delta
                continue

            gdd = (tmin + tmax) / 2 - base
            gdd[gdd < 0] = 0

            # compute agdd
            if day != first_day_of_year:
                agdd = previous_day_agdd + gdd
            else:
                agdd = gdd

            # replace no data values
            agdd[agdd == np.nan] = -9999

            # write the raster to disk and import it to the database
            if base == 50:
                file_name = 'agdd_' + day.strftime("%Y%m%d") + '_base_fifty_f.tif'
            else:
                file_name = 'agdd_' + day.strftime("%Y%m%d") + '_base_thirtytwo_f.tif'
            file_path = save_path + file_name
            write_raster(file_path, agdd, no_data_value, rast_cols, rast_rows, projection, transform)
            save_raster_to_postgis(file_path, agdd_table_name, 4269)
            set_date_column(agdd_table_name, day, new_table)
            set_scale_column(agdd_table_name, 'fahrenheit', new_table)
            set_base_column(agdd_table_name, base, new_table)
            if not new_time_series:
                update_time_series(time_series_table_name, file_name, day)
            new_table = False
            logging.info('populated agdd (base %s) for %s', base, day.strftime("%Y-%m-%d"))
        except():
            logging.error('skipping - could not compute agdd (base %s) for date: %s due to an exception', base, day.strftime("%Y-%m-%d"))

        day += delta


def import_average_agdd(first_year, last_year, base):
    logging.info('importing average agdds')
    agdd_avg_table = 'prism_30yr_avg_agdd'
    if base == 32:
        save_path = cfg["avg_agdd_path"]
    elif base == 50:
        save_path = cfg["avg_agdd_50f_path"]
    else:
        logging.error('unsupported base: %s', base)
        return
    (rast_cols, rast_rows, transform, projection, no_data_value) = get_raster_info('prism_tmin_2000', datetime(2000, 1, 1))
    new_table = not table_exists(agdd_avg_table)
    agdd = np.zeros((last_year - first_year, rast_rows, rast_cols))
    for day_of_year in range(1,366):
        logging.info('doy: %s', str(day_of_year))
        years_accumulated = 0
        total_over_years = np.zeros((rast_rows, rast_cols))
        for year in range(first_year, last_year):
            year_idx = year - first_year
            logging.info('year: %s', str(year))
            try:
                date_from_doy = date(year, 1, 1) + timedelta(day_of_year - 1)
                logging.info('date_from_doy: %s', date_from_doy.strftime("%Y-%m-%d"))
                tmin_table_name = 'prism' + "_" + 'tmin' + "_" + date_from_doy.strftime("%Y")
                tmax_table_name = 'prism' + "_" + 'tmax' + "_" + date_from_doy.strftime("%Y")
                tmin = get_climate_data(tmin_table_name, date_from_doy, 'fahrenheit')
                tmax = get_climate_data(tmax_table_name, date_from_doy, 'fahrenheit')

                gdd = (tmin + tmax) / 2 - base
                gdd[gdd < 0] = 0

                if agdd[year_idx] == None:
                    agdd[year_idx] = gdd
                else:
                    agdd[year_idx] += gdd
                total_over_years += agdd[year_idx]
                years_accumulated += 1
            except():
                logging.error('skipping - could not compute agdd average for year: %s (doy: %s)' ,str(year), str(day_of_year))
        average_agdd = total_over_years / years_accumulated
        average_agdd[average_agdd == np.nan] = -9999.0

        prewarped_file_path = save_path + 'agdd_unwarped_' + str(day_of_year) + '.tif'
        if base == 50:
            postwarped_file_path = save_path + 'agdd_' + str(day_of_year) + '_base_fifty_f.tif'
        else:
            postwarped_file_path = save_path + 'agdd_' + str(day_of_year) + '_base_thirtytwo_f.tif'
        os.makedirs(os.path.dirname(postwarped_file_path), exist_ok=True)
        write_raster(prewarped_file_path, average_agdd, -9999.0, rast_cols, rast_rows, projection, transform)

        warp_to_rtma_resolution(prewarped_file_path, postwarped_file_path)
        os.remove(prewarped_file_path)

        save_raster_to_postgis(postwarped_file_path, agdd_avg_table, 4269)
        set_doy_column(agdd_avg_table, day_of_year, new_table)
        set_scale_column(agdd_avg_table, 'fahrenheit', new_table)
        set_base_column(agdd_avg_table, base, new_table)
        new_table = False
        logging.info('populated average agdd for day of year: %s', str(day_of_year))


def get_climate_data(table_name, date, temp_unit):
    outarray = get_raster_array(table_name, 'rast_date', date.strftime("%Y-%m-%d"))

    if outarray is None:
        return outarray

    # convert -9999 values to not a number so we don't have to worry about manipulating them
    outarray[outarray == -9999.0] = np.nan

    if temp_unit == 'fahrenheit':
        outarray *= 1.8
        outarray += 32

    return outarray


def get_climate_data_from_file(raster_path, temp_unit):

    raster_dataset = gdal.Open(raster_path)
    #geo_transform = raster_dataset.GetGeoTransform()
    #proj = raster_dataset.GetProjectionRef()

    band = raster_dataset.GetRasterBand(1)
    outarray = band.ReadAsArray()

    if outarray is None:
        return outarray

    # convert -9999 values to not a number so we don't have to worry about manipulating them
    outarray[outarray == -9999.0] = np.nan

    if temp_unit == 'fahrenheit':
        outarray *= 1.8
        outarray += 32
    
    return outarray