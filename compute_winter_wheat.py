#!/usr/bin/python3
from datetime import date
from util.database import save_raster_to_postgis
from util.database import set_date_column
from util.database import table_exists
from util.database import update_time_series
from util.gdd import get_climate_data_from_file
import logging
import time
import yaml
import os.path
from util.log_manager import get_error_log
import glob
import re
from datetime import datetime
from datetime import timedelta
import contextlib
import subprocess
import shutil
from pathlib import Path
import numpy as np
from osgeo import gdal
from util.raster import *
from spring_index.solar_declination import solar_declination


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]
daily_tmin_path = cfg["daily_tmin_path"]
daily_tmax_path = cfg["daily_tmax_path"]

def vernalization_days(tavg):
    vd = tavg.copy()
    vd[vd < 32] = 0
    vd[vd > 64.4] = 0
    vd[(vd >= 32) & (vd < 44.6)] = 1
    vd[(vd >= 44.6) & (vd <= 64.4)] = -(0.06 * vd[(vd >= 44.6) & (vd <= 64.4)]) + 3.38
    return vd

# returns array[day, lat] = [daylength at each longitude]
def photoperiod(upper_left_y):
    num_lats = 1228
    #num_longs = 2606
    day_max = 365

    ydim = 0.04166666666667

    for day in range(1, day_max):

        # calculate latitudes
        site_latitudes = np.arange(num_lats, dtype=float)
        site_latitudes *= -ydim
        site_latitudes += upper_left_y

        # calculate day lengths
        site_day_lengths = np.empty((day_max, num_lats))
        for day in range(0, day_max):
            temp_lats = np.copy(site_latitudes)
            temp_lats[temp_lats < 40] = 12.14 + 3.34 * np.tan(site_latitudes[site_latitudes < 40] * np.pi / 180) * np.cos(0.0172 * solar_declination[day] - 1.95)
            temp_lats[temp_lats >= 40] = 12.25 + (1.6164 + 1.7643 * (
            np.tan(site_latitudes[site_latitudes >= 40] * np.pi / 180)) ** 2) * np.cos(0.0172 * solar_declination[day] - 1.95)
            site_day_lengths[day, :] = temp_lats
        site_day_lengths[site_day_lengths < 1] = 1
        site_day_lengths[site_day_lengths > 23] = 23
        return site_day_lengths


def compute_winter_wheat(start_date, stop_date):
    
    #don't want to reset agdd until Jan
    inSecondYear = False

    day = datetime.strptime(start_date, "%Y-%m-%d")
    stop = datetime.strptime(stop_date, "%Y-%m-%d")

    temp_unit = 'fahrenheit'

    doy = 274 # day of year for oct 1
    while day <= stop:

        if doy == 365:
            inSecondYear = True
            doy = 0
            agdd = np.zeros_like(tmin)

        print(day.strftime("%Y%m%d"))
        print(doy)

        tmin_tif_path = daily_tmin_path + "tmin_{day}.tif".format(day=day.strftime("%Y%m%d"))
        tmax_tif_path = daily_tmax_path + "tmax_{day}.tif".format(day=day.strftime("%Y%m%d"))
        # tmin_tif_path = "/Users/npn/Documents/geo-data/tmin_tmax/tmin_{day}.tif".format(day=day.strftime("%Y%m%d"))
        # tmax_tif_path = "/Users/npn/Documents/geo-data/tmin_tmax/tmax_{day}.tif".format(day=day.strftime("%Y%m%d"))
        try:
            tmin = get_climate_data_from_file(tmin_tif_path, temp_unit)
            tmax = get_climate_data_from_file(tmax_tif_path, temp_unit)
            tmax[tmax > 78.8] = 78.8
            tavg = (tmin + tmax) / 2
            num_lats = tmin.shape[0]
            num_lngs = tmin.shape[1]
        except:
            logging.error('could not get temp data, aborting winter wheat computation: ', exc_info=True)
            return
        if doy == 274 and not inSecondYear:
            ds = gdal.Open(tmin_tif_path)
            projection = ds.GetProjection()
            transform = ds.GetGeoTransform()
            (upper_left_x, x_size, x_rotation, upper_left_y, y_rotation, y_size) = transform
            ds = None
            # compute photoperiod penalty
            daylengths = photoperiod(upper_left_y)
            photoperiod_penalty = 0.075 * daylengths - 0.24
            # intialize vernalization days accum and agdd to zeros
            vd_accum = np.zeros_like(tmin)
            agdd = np.zeros_like(tmin)
        # compute vernalization days, add it to the accum, and calculate the penalty from the accum
        vd = vernalization_days(tavg)
        vd_accum = vd_accum + vd
        vd_penalty = 0.015 * vd_accum + 0.21

        # begin optimized version of algorithm
        #bases = np.where((750 < agdd) & (agdd < 1265), 35.6, 32)
        bases = np.where((750 < agdd) & (agdd < 1265), 32, 32)
        gdd = tavg - bases
        gdd[gdd < 0] = 0
        # this is to transform dimensions (doy, lat) -> (lat, lng) by repeating the
        # lat penalties across the lng dimension
        photoperiod_penalty_broadcasted = np.swapaxes(np.repeat(photoperiod_penalty[doy,np.newaxis], 2606, 0),0,1)
        
        penalties = np.where((vd_accum < 50) & (photoperiod_penalty_broadcasted > vd_penalty), vd_penalty, photoperiod_penalty_broadcasted)
        gdd *= penalties
        agdd += gdd
        # end optimized version of algorithm
        
        # write the raster to disk
        tif_name = "winter_wheat_{day}.tif".format(day=day.strftime("%Y%m%d"))
        winter_wheat_path = "/geo-data/gridded_models/winter_wheat/" + tif_name
        # winter_wheat_path = "/Users/npn/Documents/geo-data/winter_wheat/" + tif_name
        write_raster(winter_wheat_path, agdd, -9999, num_lngs, num_lats, projection, transform)

        time_series_table = "winter_wheat"
        if table_exists(time_series_table):
            update_time_series(time_series_table, tif_name, day)

        doy += 1
        day = day + timedelta(days=1)


def main():
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script compute_winter_wheat.py*****************')
    logging.info('*****************************************************************************')

    start_date = "2021-10-01"
    #stop_date = "2020-10-01"
    today = date.today()
    one_week_into_future = today + timedelta(days=6)
    stop_date = one_week_into_future.strftime("%Y-%m-%d")
    compute_winter_wheat(start_date, stop_date)

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********compute_winter_wheat.py finished in %s seconds***********', t1 - t0)
    logging.info('*****************************************************************************')


if __name__ == "__main__":
    logging.basicConfig(filename=log_path + 'compute_winter_wheat.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    error_log = get_error_log()

    # try:
    main()
    # except (SystemExit, KeyboardInterrupt):
    #     raise
    # except:
    #     error_log.error('compute_winter_wheat.py failed to finish: ', exc_info=True)
