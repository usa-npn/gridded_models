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
from util.raster import write_best_raster
from qc.utils import get_acis_missing_climate_data
from climate.importer import import_missed_alaska_urma
from qc.utils import load_stations_and_station_attributes


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


# used to convert toby's netcdfs to geotiffs for BEST si-x comparisons
def extract_tif_from_toby_netcdf(year):
    toby_best_root_group = Dataset("D:\\gridded\\best\\toby\\si-x_Ayear_Berkeley-Earth_historical_v201507_1880-2013.nc")
    toby_leaf = toby_best_root_group.variables['bloom_index']
    leaf = toby_leaf[year - 1880, :, :180]
    leaf = np.flipud(leaf)
    leaf_save_path = "D:\\gridded\\best\\toby2\\toby_best_bloom_{year}.tif".format(year=year)
    lats = toby_best_root_group.variables['lat'][:]
    lons = toby_best_root_group.variables['lon'][:180]
    write_best_raster(leaf_save_path, leaf, lons.min(), lons.max(), len(lons), lats.min(), lats.max(), len(lats))

# this is just a scratchpad used for throw away scripts that come up overtime
def main():
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script utilities.py*****************')
    logging.info('*****************************************************************************')

    # for year in range(1880, 2014):
    #     extract_tif_from_toby_netcdf(year)

    # get_acis_missing_climate_data()

    import_missed_alaska_urma(2016, 12, 31)
    # import_missed_alaska_urma(2017, 1, 1)
    # import_missed_alaska_urma(2017, 1, 2)
    # import_missed_alaska_urma(2017, 1, 3)
    # import_missed_alaska_urma(2017, 1, 4)
    # import_missed_alaska_urma(2017, 1, 5)
    # import_missed_alaska_urma(2017, 1, 6)
    # import_missed_alaska_urma(2017, 1, 7)

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
