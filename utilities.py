#!/usr/bin/python3
from datetime import date
from datetime import datetime
import logging
import time
# from datetime import timedelta
# from geoserver.catalog import Catalog
# from six.spring_index import spring_index_for_point
# import numpy as np
from osgeo import gdal
import yaml
import os.path
from util.log_manager import get_error_log
import glob
import os
from climate.importer import rtma_import
from netCDF4 import Dataset
from time import sleep
from qc.six_checker import *
from qc.gdd_checker import *
from spring_index.spring_index import spring_index
from osgeo import osr
from util.database import *


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]


def pixel2coord(col, row):
    ds = gdal.Open('D:/gridded/climate-tmax.tif')

    # unravel GDAL affine transform parameters
    c, a, b, f, d, e = ds.GetGeoTransform()
    ydim = ds.GetGeoTransform()[1]
    """Returns global coordinates to pixel center using base-0 raster index"""
    xp = a * col + b * row + a * 0.5 + b * 0.5 + c
    yp = d * col + e * row + d * 0.5 + e * 0.5 + f
    return (xp, yp)


def load_geotiff_directory_into_postgis(directory, climate_variable, source_data_string):
    os.chdir(directory)
    for file_name in glob.glob("*.tif"):
        print(file_name)
        date_list = list(filter(str.isdigit, file_name))
        year = int(''.join(date_list[0:4]))
        month = int(''.join(date_list[4:6]))
        day = int(''.join(date_list[6:8]))
        import_date = date(year, month, day)
        if climate_variable == 'tmin':
            table_name = "tmin_" + str(year)
        else:
            table_name = "tmax_" + str(year)
        print('Importing: ' + directory + file_name + ' into ' + table_name)
        rtma_import(directory + file_name, table_name, False, import_date, None, source_data_string)


def convert_to_f(temps):
    temps *= 1.8
    temps += 32
    return temps


def write_raster(file_path, array, min_lon, max_lon, num_lons, min_lat, max_lat, num_lats):
    driver = gdal.GetDriverByName('Gtiff')
    no_data_value = -9999

    srs = osr.SpatialReference()
    srs.ImportFromEPSG(4269)

    xmin, ymin, xmax, ymax = [min_lon, min_lat, max_lon, max_lat]
    nrows = num_lats
    ncols = num_lons
    xres = (xmax - xmin) / float(ncols)
    yres = (ymax - ymin) / float(nrows)
    geotransform = (xmin, xres, 0, ymax, 0, -yres)

    raster = driver.Create(file_path, num_lons, num_lats, 1, gdal.GDT_Float32)
    band = raster.GetRasterBand(1)
    band.SetNoDataValue(no_data_value)
    band.WriteArray(array)

    raster.SetGeoTransform(geotransform)
    raster.SetProjection(srs.ExportToWkt())
    band.FlushCache()


def compute_best_six_layers():
    save_path = cfg["six_path"]
    best_six_table = 'best_spring_index'
    best_six_leaf_mosaic_table = 'six_average_leaf_best'
    best_six_bloom_mosaic_table = 'six_average_bloom_best'
    new_table = not table_exists(best_six_table)
    # decades = [1880, 1890, 1900, 1910, 1920, 1930, 1940, 1950, 1960, 1970, 1980, 1990, 2000, 2010]
    decades = [2000, 2010]
    for decade in decades:
        tmin_root_group = Dataset("D:\\gridded\\best\\Complete_TMIN_Daily_LatLong1_{decade}.nc"
                                  .format(decade=decade), "r", format="NETCDF4")
        tmax_root_group = Dataset("D:\\gridded\\best\\Complete_TMAX_Daily_LatLong1_{decade}.nc"
                                  .format(decade=decade), "r", format="NETCDF4")

        lats = tmin_root_group.variables['latitude'][90:]
        lons = tmin_root_group.variables['longitude'][:180]
        years = tmin_root_group.variables['year'][:]
        # months = tmin_root_group.variables['month'][:]
        # days = tmin_root_group.variables['day'][:]
        # doys = tmin_root_group.variables['day_of_year'][:]

        tmin_climatology = tmin_root_group.variables['climatology']
        tmin_anomaly = tmin_root_group.variables['temperature']
        tmax_climatology = tmax_root_group.variables['climatology']
        tmax_anomaly = tmax_root_group.variables['temperature']

        prev_seen_year = None
        year_start_index, index = 0, 0
        for year in years:
            year_as_date = date(year, 1, 1)
            if prev_seen_year is None or int(prev_seen_year) != int(year):
                year_start_index = index
                prev_seen_year = int(year)
                index += 1
            else:
                index += 1
                continue

            min_temps = np.empty((364, len(lats), len(lons)))
            max_temps = np.empty((364, len(lats), len(lons)))

            for doy in range(364):
                daily_tmin_climatology = tmin_climatology[doy, 90:, :180]
                daily_tmax_climatology = tmax_climatology[doy, 90:, :180]
                daily_tmin_anomaly = tmin_anomaly[year_start_index + doy, 90:, :180]
                daily_tmax_anomaly = tmax_anomaly[year_start_index + doy, 90:, :180]

                daily_min_temps = np.add(daily_tmin_climatology, daily_tmin_anomaly)
                daily_min_temps = convert_to_f(daily_min_temps)
                daily_min_temps = np.flipud(daily_min_temps)
                min_temps[doy] = daily_min_temps

                daily_max_temps = np.add(daily_tmax_climatology, daily_tmax_anomaly)
                daily_max_temps = convert_to_f(daily_max_temps)
                daily_max_temps = np.flipud(daily_max_temps)
                max_temps[doy] = daily_max_temps

            # reshape the array to be station lat, station long, day of year, temperature
            min_temps = np.swapaxes(min_temps, 1, 0)
            min_temps = np.swapaxes(min_temps, 2, 1)
            max_temps = np.swapaxes(max_temps, 1, 0)
            max_temps = np.swapaxes(max_temps, 2, 1)

            base_temp = 31
            leaf_out_days = None
            bloom_days = None

            plants = ['lilac', 'arnoldred', 'zabelli']
            phenophases = ['leaf', 'bloom']
            for plant in plants:
                temp_leaf = None
                for phenophase in phenophases:
                    if phenophase == 'leaf':
                        temp_leaf = spring_index(max_temps, min_temps, base_temp, None, phenophase, plant, lats)
                        temp_leaf[temp_leaf == -9999] = np.nan
                        if leaf_out_days is None:
                            leaf_out_days = temp_leaf
                        else:
                            leaf_out_days += temp_leaf
                    else:
                        temp_bloom = spring_index(max_temps, min_temps, base_temp, temp_leaf, phenophase, plant, lats)
                        temp_bloom[temp_bloom == -9999] = np.nan
                        if bloom_days is None:
                            bloom_days = temp_bloom
                        else:
                            bloom_days += temp_bloom

            leaf_file_name = "best_leaf_{year}.tif".format(year=int(year))
            bloom_file_name = "best_bloom_{year}.tif".format(year=int(year))
            leaf_folder_name = "six_" + 'average' + "_" + 'leaf' + "_" + 'best'
            bloom_folder_name = "six_" + 'average' + "_" + 'bloom' + "_" + 'best'
            leaf_save_path = save_path + leaf_folder_name + os.sep + leaf_file_name
            bloom_save_path = save_path + bloom_folder_name + os.sep + bloom_file_name

            leaf_avg = leaf_out_days / 3
            bloom_avg = bloom_days / 3
            leaf_avg[leaf_avg == np.nan] = -9999
            bloom_avg[bloom_avg == np.nan] = -9999

            write_raster(leaf_save_path, leaf_avg, lons.min(), lons.max(), len(lons), lats.min(), lats.max(), len(lats))
            save_raster_to_postgis(leaf_save_path, best_six_table, 4269)
            set_plant_column(best_six_table, 'average', new_table)
            set_phenophase_column(best_six_table, 'leaf', new_table)
            set_date_column(best_six_table, year_as_date, new_table)
            if table_exists(best_six_leaf_mosaic_table):
                update_time_series(best_six_leaf_mosaic_table, leaf_file_name, year_as_date)
            new_table = False

            write_raster(bloom_save_path, bloom_avg, lons.min(), lons.max(), len(lons), lats.min(), lats.max(),
                         len(lats))
            save_raster_to_postgis(bloom_save_path, best_six_table, 4269)
            set_plant_column(best_six_table, 'average', new_table)
            set_phenophase_column(best_six_table, 'bloom', new_table)
            set_date_column(best_six_table, year_as_date, new_table)
            if table_exists(best_six_bloom_mosaic_table):
                update_time_series(best_six_bloom_mosaic_table, bloom_file_name, year_as_date)


def main():
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script utilities.py*****************')
    logging.info('*****************************************************************************')

    compute_best_six_layers()

    print("test")

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********utilities.py finished in %s seconds***********', t1 - t0)
    logging.info('*****************************************************************************')


if __name__ == "__main__":
    logging.basicConfig(filename=log_path+'gridded_testing.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    error_log = get_error_log()

    try:
        main()
    except (SystemExit, KeyboardInterrupt):
        raise
    except:
        error_log.error('utilities.py failed to finish: ', exc_info=True)
