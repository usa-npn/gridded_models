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
import glob, os
from climate.importer import rtma_import
from netCDF4 import Dataset
import json
from time import sleep
from qc.six_checker import *
from qc.gdd_checker import *


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


def main():
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script utilities.py*****************')
    logging.info('*****************************************************************************')

    #get_acis_missing_climate_data()

    for year in range(2003, 2016):
        populate_historic_six_points(year)


    # root_group = Dataset("D:\\gridded\\best\\Complete_TMIN_Daily_LatLong1_2010.nc", "r", format="NETCDF4")
    # root_dims = root_group.dimensions
    #
    # lats = root_group.variables['latitude'][:]
    # lons = root_group.variables['longitude'][:]
    # years = root_group.variables['year'][:]
    # months = root_group.variables['month'][:]
    # days = root_group.variables['day'][:]
    #
    # days_dim = root_group.variables['day'].dimensions
    #
    # climatology = root_group.variables['climatology']
    # climatoloy_dim = climatology.dimensions
    #
    # min_temps = climatology[:]
    #
    # mint = climatology[364,:,:]
    #
    # date_number = root_group['date_number'][:]
    # temperature = root_group['temperature'][:]
    # print("test")



    # load_geotiff_directory_into_postgis('D:\\gridded\\climate\\daily_temps\\tmax\\', 'tmax', 'urma')

    # daymet_file = 'D:\Daymet_V3_CFMosaics\data\daymet_v3_dayl_2015_na.nc4'
    # fh = Dataset(daymet_file, mode='r')
    # print('test')

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
