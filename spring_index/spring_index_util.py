from datetime import datetime, timedelta
from util.raster import *
from util.database import *
import numpy as np
from datetime import date
import logging
import shutil
from climate.importer import gdalwarp_tif_file
# from urllib.request import urlretrieve
# import urllib


def import_six_postgis(file_path, file_name, six_anomaly_table_name, time_series_table_name, plant, phenophase, day):

    new_table = not table_exists(six_anomaly_table_name)
    new_time_series = not table_exists(time_series_table_name)

    save_raster_to_postgis(file_path, six_anomaly_table_name, 4269)
    set_date_column(six_anomaly_table_name, day, new_table)
    set_plant_column(six_anomaly_table_name, plant, new_table)
    set_phenophase_column(six_anomaly_table_name, phenophase, new_table)
    if not new_time_series:
        update_time_series(time_series_table_name, file_name, day)


def populate_six_30yr_average(plant, phenophase, climateToWarpTo):
    logging.info(' ')
    logging.info('------------populating spring index 30yr average for %s-----------------', phenophase)
    save_path = cfg["avg_six_path"] + 'six_30yr_average_' + phenophase + os.sep
    native_save_path = cfg["avg_six_path"] + 'six_30yr_average_4k_' + phenophase + os.sep
    os.makedirs(os.path.dirname(save_path), exist_ok=True)
    os.makedirs(os.path.dirname(native_save_path), exist_ok=True)

    historic_six_table = 'prism_spring_index'
    # this holds 30yr avg warped to ncep 2.5k rez
    six_avg_table_name = 'prism_30yr_avg_spring_index'
    # this holds 30yr avg in native prism 4k rez
    six_avg_native_table_name = 'prism_30yr_avg_4k_spring_index'
    six_avg_array = None

    # calculate average over 30 years by grabbing the year-01-01 map from each year (01-01 represents entire year)
    count = 0
    for year in range(1981, 2011):
        query = """
          SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff')
          FROM %s
          WHERE plant = %s AND rast_date = %s AND phenophase = %s;"""
        data = (AsIs(historic_six_table), plant, str(year)+'-01-01', phenophase)
        result_array = get_raster_from_query(query, data)
        if result_array is None:
            logging.error("Couldn't retrieve spring index for year %s", str(year))
            return
        result_array = result_array.astype(np.float32, copy=False)
        result_array[result_array == -9999] = np.nan

        if count is 0:
            (rast_cols, rast_rows, transform, projection, no_data_value) = get_raster_info_from_query(query, data)

        if six_avg_array is None:
            six_avg_array = result_array
        else:
            six_avg_array = six_avg_array + result_array
        count += 1
    six_avg_array /= count
    six_avg_array[np.isnan(six_avg_array)] = -9999
    # six_avg_array[six_avg_array == 0] = -9999
    six_avg_array = six_avg_array.astype(np.int16, copy=False)

    # for each doy mask out six values greater than doy and then save the raster and import it to the database
    # because of the nature of the masking we work backwards over the day of year
    new_table = False
    if climateToWarpTo is 'NCEP':
        new_table = not table_exists(six_avg_table_name)
    if climateToWarpTo is 'PRISM':
        new_table = not table_exists(six_avg_native_table_name)

    for day_of_year in range(365, 0, -1):
        six_avg_array[six_avg_array > day_of_year] = -9999

        # write the raster to disk and import it to the database
        if climateToWarpTo is 'NCEP':
            prewarped_file_path = save_path + "six_average_unwarped_{phenophase}_{doy}.tif".format(phenophase=phenophase, doy=day_of_year)
            postwarped_file_path = save_path + "six_average_{phenophase}_{doy}.tif".format(phenophase=phenophase, doy=day_of_year)
        if climateToWarpTo is 'PRISM':
            prewarped_file_path = native_save_path + "six_average_unwarped_{phenophase}_{doy}.tif".format(phenophase=phenophase, doy=day_of_year)
            postwarped_file_path = native_save_path + "six_average_{phenophase}_{doy}.tif".format(phenophase=phenophase, doy=day_of_year)
        
        write_raster(prewarped_file_path, six_avg_array, -9999, rast_cols, rast_rows, projection, transform)

        if climateToWarpTo is 'NCEP':
            warp_to_rtma_resolution(prewarped_file_path, postwarped_file_path)
            os.remove(prewarped_file_path)

        if climateToWarpTo is 'PRISM':
            save_raster_to_postgis(prewarped_file_path, six_avg_native_table_name, 4269)
            set_plant_column(six_avg_native_table_name, plant, new_table)
            set_phenophase_column(six_avg_native_table_name, phenophase, new_table)
            set_doy_column(six_avg_native_table_name, day_of_year, new_table)
        if climateToWarpTo is 'NCEP':
            save_raster_to_postgis(postwarped_file_path, six_avg_table_name, 4269)
            set_plant_column(six_avg_table_name, plant, new_table)
            set_phenophase_column(six_avg_table_name, phenophase, new_table)
            set_doy_column(six_avg_table_name, day_of_year, new_table)
        new_table = False
        logging.info('populated average six %s for day of year: %s', phenophase, str(day_of_year))


def copy_spring_index_anomaly_raster(phenophase, from_date, to_date):
    six_anomaly_table_name = 'six_anomaly'
    plant = 'average'
    new_table = False
    day_of_year = to_date.timetuple().tm_yday

    if phenophase is 'bloom':
        time_series_table_name = 'six_bloom_anomaly'
        source_file_name = 'six_bloom_anomaly_' + from_date.strftime("%Y%m%d") + '.tif'
        dest_file_name = 'six_bloom_anomaly_' + to_date.strftime("%Y%m%d") + '.tif'
        folder_name = 'six_bloom_anomaly' + os.sep
    else:
        time_series_table_name = 'six_leaf_anomaly'
        source_file_name = 'six_leaf_anomaly_' + from_date.strftime("%Y%m%d") + '.tif'
        dest_file_name = 'six_leaf_anomaly_' + to_date.strftime("%Y%m%d") + '.tif'
        folder_name = 'six_leaf_anomaly' + os.sep

    source_file_path = cfg["six_anomaly_path"] + folder_name + source_file_name
    dest_file_path = cfg["six_anomaly_path"] + folder_name + dest_file_name

    if os.path.isfile(source_file_path) and not os.path.isfile(dest_file_path):
        shutil.copyfile(source_file_path, dest_file_path)
        import_six_postgis(dest_file_path, dest_file_name, six_anomaly_table_name, time_series_table_name, plant, phenophase, to_date)
        logging.info('copied six %s anomaly for %s - doy %s from doy 240', phenophase,
                     to_date.strftime("%Y-%m-%d"), str(day_of_year))


def import_six_return_interval(ri_year, phenophase):
    logging.info(' ')
    logging.info('-----------------populating spring index %s return intervals-----------------', phenophase)

    time_series_table_name = 'six_' + phenophase + '_return_interval'
    six_return_interval_table_name = 'six_return_interval'
    save_path = cfg["six_return_interval_path"] + 'six_' + phenophase + '_return_interval' + os.sep
    os.makedirs(os.path.dirname(save_path), exist_ok=True)

    #load 1981 through previous year 2.5k SI-x Anomalies
    prism_anomaly_path = cfg["six_return_interval_path"] + 'six_' + phenophase + '_anomaly_prism_2.5k'
    prism_anomaly_path_4k = cfg["six_anomaly_path"] + 'six_' + phenophase + '_anomaly_prism'
    historic_anom_array = {}
    for year in range(1981, ri_year - 1):
        prism_anom_file = prism_anomaly_path + os.sep + 'six_' + phenophase + '_anomaly_' + str(year) + '.tif'
        prism_anom_file_4k = prism_anomaly_path_4k + os.sep + 'six_' + phenophase + '_anomaly_' + str(year) + '.tif'
        ncep_historic_anom_file = cfg["six_anomaly_path"] + 'six_' + phenophase + '_anomaly_historic' + os.sep + 'six_' + phenophase + '_anomaly_' + str(year) + '.tif'
        ncep_anom_file = cfg["six_anomaly_path"] + 'six_' + phenophase + '_anomaly' + os.sep + 'six_' + phenophase + '_anomaly_' + str(year) + '1231' + '.tif'
        # gdalwarp_file was originally used on 4k anomalies to preprocess resampled 2.5k prism rasters
        # gdalwarp_file(prism_anom_file)
        # todo if file doesn't exist, copy and warp file
        if (os.path.isfile(prism_anom_file_4k)):
            shutil.copy(prism_anom_file_4k, prism_anom_file)
            gdalwarp_tif_file(prism_anom_file)
            ds = gdal.Open(prism_anom_file)
            historic_anom_array[year] = np.array(ds.GetRasterBand(1).ReadAsArray())
        elif(os.path.isfile(ncep_historic_anom_file)): #use ncep historic when prism doesn't exist
            ds = gdal.Open(ncep_historic_anom_file)
            historic_anom_array[year] = np.array(ds.GetRasterBand(1).ReadAsArray())
        else: #use ncep daily if ncep historic hasn't been created yet
            ds = gdal.Open(ncep_anom_file)
            historic_anom_array[year] = np.array(ds.GetRasterBand(1).ReadAsArray())
    
    #load ncep current day anomaly raster, set null values
    current_month_and_day = date.today().strftime("%m%d")
    ncep_anomaly_path = cfg["six_anomaly_path"] + 'six_' + phenophase + '_anomaly'
    ds = gdal.Open(ncep_anomaly_path + os.sep + 'six_' + phenophase + '_anomaly_' + str(ri_year) + current_month_and_day + '.tif')
    ncep_anom_array = np.array(ds.GetRasterBand(1).ReadAsArray())
    conus_mask = np.where(ncep_anom_array == -9999, np.nan, 0)

    num_cols = ds.RasterXSize
    num_rows = ds.RasterYSize
    transform = ds.GetGeoTransform()
    projection = ds.GetProjection()

    #create an "Early" current year raster where all late or on-time pixels are null.
    SIXA20_4k_Early = np.where(ncep_anom_array <= -0.0000001, ncep_anom_array, np.nan)
    SIXA20_4k_Early_Mask = np.where(ncep_anom_array <= -0.0000001, 0, np.nan)

    #create a "Late" current year raster where all early or on-time pixels are null.
    SIXA20_4k_Late = np.where(ncep_anom_array >= 0.0000001, ncep_anom_array, np.nan)
    SIXA20_4k_Late_Mask = np.where(ncep_anom_array >= 0.0000001, 0, np.nan)

    #sum them up
    RI_Early = np.copy(conus_mask)
    RI_Late = np.copy(conus_mask)
    first = True
    for year in range(1981, 2019):
        if first:
            RI_Early = conus_mask + np.where(historic_anom_array[year] <= SIXA20_4k_Early, 1, 0)
            RI_Late = conus_mask + np.where(historic_anom_array[year] >= SIXA20_4k_Late, 1, 0)
        else:
            RI_Early = RI_Early + np.where(historic_anom_array[year] <= SIXA20_4k_Early, 1, 0)
            RI_Late = RI_Late + np.where(historic_anom_array[year] >= SIXA20_4k_Late, 1, 0)
        first = False
    #divide count raster by 38 to create Return Interval raster.
    RI_Early = np.where(RI_Early == 0, 0, -38 / RI_Early) 
    RI_Early = np.where(np.logical_and(RI_Early == 0, SIXA20_4k_Early_Mask == 0), -39, RI_Early)
    RI_Late = np.where(RI_Late == 0, 0, 38 / RI_Late)
    RI_Late = np.where(np.logical_and(RI_Late == 0, SIXA20_4k_Late_Mask == 0), 39, RI_Late)
    #combine early, late and ontime rasters
    RI = RI_Early + RI_Late
    #Output the raster of the Return interval 
    file_name = 'six_return_interval_' + str(ri_year) + '.tiff'
    output_file_path = save_path + file_name
    write_raster(output_file_path, RI, -9999, num_cols, num_rows, projection, transform)
                
    import_six_postgis(output_file_path, file_name, six_return_interval_table_name, time_series_table_name, 'average', phenophase, date(ri_year, 1, 1))


def import_six_anomalies(anomaly_date, phenophase):
    logging.info(' ')
    logging.info('-----------------populating spring index %s anomalies-----------------', phenophase)

    time_series_table_name = 'six_' + phenophase + '_anomaly'
    save_path = cfg["six_anomaly_path"] + 'six_' + phenophase + '_anomaly' + os.sep

    os.makedirs(os.path.dirname(save_path), exist_ok=True)

    first_day_of_year = date(anomaly_date.year, 1, 1)
    day = first_day_of_year
    delta = timedelta(days=1)

    plant = 'average'
    six_table_name = 'ncep_spring_index'
    six_avg_table_name = 'prism_30yr_avg_spring_index'
    six_anomaly_table_name = 'six_anomaly'

    new_table = not table_exists(six_anomaly_table_name)

    (rast_cols, rast_rows, transform, projection, no_data_value) = get_raster_info(six_table_name, first_day_of_year)

    # get historic 30 year average from day of year 365
    query = """
          SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff')
          FROM %s
          WHERE plant = %s AND doy = %s AND phenophase = %s;"""
    data = (AsIs(six_avg_table_name), plant, 365, phenophase)
    av_six = get_raster_from_query(query, data)
    if av_six is None:
        logging.warning('skipping - could not get avg spring index for day of year: %s', str(365))
        day += delta
        return
    av_six = av_six.astype(np.float32, copy=False)
    av_six[av_six == -9999] = np.nan

    while day <= anomaly_date:
        day_of_year = day.timetuple().tm_yday
        today = datetime.today().date()

        #can't see more than a week into the future
        if day > (today + timedelta(days=8)):
            day += delta
            continue

        # skip if six anomaly has already been computed and is older than 30 days
        # (otherwise recompute it, because newer tmin/tmax files get updated nightly)
        # if not new_table and day < (today - timedelta(days=60)) and six_row_exists(six_anomaly_table_name, plant, phenophase, day):
        #     # logging.info('skipping day %s because it already exists', day.strftime("%Y-%m-%d"))
        #     day += delta
        #     continue

        query = """
          SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff')
          FROM %s
          WHERE plant = %s AND rast_date = %s AND phenophase = %s;"""
        data = (AsIs(six_table_name), plant, day.strftime("%Y-%m-%d"), phenophase)
        six = get_raster_from_query(query, data)
        if six is None:
            logging.warning('error - could not get spring index for date: %s', day.strftime("%Y-%m-%d"))
            return

        av_six = av_six.astype(np.float32, copy=False)
        av_six[av_six == -9999] = np.nan
        six = six.astype(np.float32, copy=False)
        six[six == -9999] = np.nan

        diff_six = six - av_six
        diff_six[np.isnan(diff_six)] = -9999

        diff_six = diff_six.astype(np.int16, copy=False)

        # write the raster to disk and import it to the database
        if phenophase is 'bloom':
            file_name = 'six_bloom_anomaly_' + day.strftime("%Y%m%d") + '.tif'
        else:
            file_name = 'six_leaf_anomaly_' + day.strftime("%Y%m%d") + '.tif'
        file_path = save_path + file_name
        write_raster(file_path, diff_six, -9999, rast_cols, rast_rows, projection, transform)

        import_six_postgis(file_path, file_name, six_anomaly_table_name, time_series_table_name, plant, phenophase,
                           day)

        new_table = False
        logging.info('populated six %s anomaly for %s based on historical six average for doy %s', phenophase, day.strftime("%Y-%m-%d"), str(day_of_year))

        day += delta


# populates yearly prism on prism six anomaly
def import_prism_on_prism_six_anomaly(year, phenophase):
    logging.info(' ')
    logging.info('-----------------populating prism on prism spring index %s anomaly for year %s-----------------', phenophase, year)

    time_series_table_name = 'six_' + phenophase + '_anomaly_prism'
    save_path = cfg["six_anomaly_path"] + 'six_' + phenophase + '_anomaly_prism' + os.sep

    os.makedirs(os.path.dirname(save_path), exist_ok=True)

    first_day_of_year = date(year, 1, 1)

    plant = 'average'
    six_table_name = 'prism_spring_index'
    six_avg_table_name = 'prism_30yr_avg_4k_spring_index'
    six_anomaly_table_name = 'six_anomaly_historic_prism'

    new_table = not table_exists(six_anomaly_table_name)

    (rast_cols, rast_rows, transform, projection, no_data_value) = get_raster_info(six_table_name, first_day_of_year)

    # get historic 30 year average from day of year 365
    query = """
          SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff')
          FROM %s
          WHERE plant = %s AND doy = %s AND phenophase = %s;"""
    data = (AsIs(six_avg_table_name), plant, 365, phenophase)
    av_six = get_raster_from_query(query, data)
    if av_six is None:
        logging.warning('skipping - could not get avg spring index for day of year: %s', str(365))
        return
    av_six = av_six.astype(np.float32, copy=False)
    av_six[av_six == -9999] = np.nan
    
    # get prism spring index layer for year
    query = """
        SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff')
        FROM %s
        WHERE plant = %s AND rast_date = %s AND phenophase = %s;"""
    data = (AsIs(six_table_name), plant, first_day_of_year.strftime("%Y-%m-%d"), phenophase)
    six = get_raster_from_query(query, data)
    if six is None:
        logging.warning('error - could not get spring index for date: %s', first_day_of_year.strftime("%Y-%m-%d"))
        return

    av_six = av_six.astype(np.float32, copy=False)
    av_six[av_six == -9999] = np.nan
    six = six.astype(np.float32, copy=False)
    six[six == -9999] = np.nan

    diff_six = six - av_six
    diff_six[np.isnan(diff_six)] = -9999

    diff_six = diff_six.astype(np.int16, copy=False)

    # write the raster to disk and import it to the database
    if phenophase is 'bloom':
        file_name = 'six_bloom_anomaly_' + str(year) + '.tif'
    else:
        file_name = 'six_leaf_anomaly_' + str(year) + '.tif'
    file_path = save_path + file_name
    write_raster(file_path, diff_six, -9999, rast_cols, rast_rows, projection, transform)

    import_six_postgis(file_path, file_name, six_anomaly_table_name, time_series_table_name, plant, phenophase,
                       first_day_of_year)

    logging.info('populated prism on prism six %s anomaly for year %s', phenophase, str(year))


def populate_yearly_six_prism_species_averages(phenophase):
    logging.info(' ')
    logging.info('------------computing historic prism six species averages for phenophase %s-----------------', phenophase)
    save_path = cfg["six_path"] + 'six_average_' + phenophase + '_prism' + os.sep
    os.makedirs(os.path.dirname(save_path), exist_ok=True)

    historic_six_table = 'prism_spring_index'
    new_table = not table_exists(historic_six_table)

    for year in range(1981, 2016):
        six_avg_array = None
        year_as_date = date(year, 1, 1)
        count = 0
        for plant in ['lilac', 'arnoldred', 'zabelli']:
            query = """
              SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff')
              FROM %s
              WHERE plant = %s AND rast_date = %s AND phenophase = %s;"""
            data = (AsIs(historic_six_table), plant, str(year)+'-01-01', phenophase)
            result_array = get_raster_from_query(query, data)
            if result_array is None:
                logging.error("Couldn't retrieve spring index for plant %s phenophase %s on year %s", plant, phenophase, str(year))
                return

            if count is 0:
                (rast_cols, rast_rows, transform, projection, no_data_value) = get_raster_info_from_query(query, data)

            result_array = result_array.astype(np.float32, copy=False)
            result_array[result_array == -9999] = np.nan

            if six_avg_array is None:
                six_avg_array = result_array
            else:
                six_avg_array = six_avg_array + result_array
            count += 1
        six_avg_array /= count
        six_avg_array[np.isnan(six_avg_array)] = -9999
        six_avg_array = six_avg_array.astype(np.int16, copy=False)

        # write the raster to disk and import it to the database
        file_path = save_path + "average_{phenophase}_prism_{year}.tif".format(phenophase=phenophase, year=year)
        write_int16_raster(file_path, six_avg_array, -9999, rast_cols, rast_rows, projection, transform)
        save_raster_to_postgis(file_path, historic_six_table, 4269)
        set_plant_column(historic_six_table, 'average', new_table)
        set_phenophase_column(historic_six_table, phenophase, new_table)
        set_date_column(historic_six_table, year_as_date, new_table)
        new_table = False
        logging.info('populated historic six spring index (averaged species) %s for year: %s', phenophase, str(year))


# def save_nightly_six_image():
#     today = datetime.today().date()
#     today_string = today.strftime("%Y-%m-%d")
#
#     working_path = cfg["temp_path"]
#
#     file_name = "six_leafout.png"
#     url = 'http://geoserver.usanpn.org/geoserver/si-x/wms?service=WMS&request=GetMap&layers=si-x:average_leaf_ncep&time={today}&bbox=-125.020833333333,24.0625,-66.479166666662,49.937500000002&width=1200&height=600&format=image/png'\
#         .format(today=today_string)
#     urlretrieve(url, working_path + file_name)
#
#     legend_file_name = "six_leafout_ramp.png"
#     legend_url = 'http://geoserver.usanpn.org/geoserver/wms?REQUEST=GetLegendGraphic&VERSION=1.3.0&FORMAT=image/png&WIDTH=20&HEIGHT=10&LAYER=si-x:average_leaf_ncep'
#     urlretrieve(legend_url, working_path + legend_file_name)
