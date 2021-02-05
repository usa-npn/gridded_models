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
from prism.importer import get_prism_data_outdb
import numpy as np
from osgeo import gdal
from util.raster import *


solar_declination = [307,
                     308,
                     309,
                     310,
                     311,
                     312,
                     313,
                     314,
                     315,
                     316,
                     317,
                     318,
                     319,
                     320,
                     321,
                     322,
                     323,
                     324,
                     325,
                     326,
                     327,
                     328,
                     329,
                     330,
                     331,
                     332,
                     333,
                     334,
                     335,
                     336,
                     337,
                     338,
                     339,
                     340,
                     341,
                     342,
                     343,
                     344,
                     345,
                     346,
                     347,
                     348,
                     349,
                     350,
                     351,
                     352,
                     353,
                     354,
                     355,
                     356,
                     357,
                     358,
                     359,
                     360,
                     361,
                     362,
                     363,
                     364,
                     365,
                     366,
                     1,
                     2,
                     3,
                     4,
                     5,
                     6,
                     7,
                     8,
                     9,
                     10,
                     11,
                     12,
                     13,
                     14,
                     15,
                     16,
                     17,
                     18,
                     19,
                     20,
                     21,
                     22,
                     23,
                     24,
                     25,
                     26,
                     27,
                     28,
                     29,
                     30,
                     31,
                     32,
                     33,
                     34,
                     35,
                     36,
                     37,
                     38,
                     39,
                     40,
                     41,
                     42,
                     43,
                     44,
                     45,
                     46,
                     47,
                     48,
                     49,
                     50,
                     51,
                     52,
                     53,
                     54,
                     55,
                     56,
                     57,
                     58,
                     59,
                     60,
                     61,
                     62,
                     63,
                     64,
                     65,
                     66,
                     67,
                     68,
                     69,
                     70,
                     71,
                     72,
                     73,
                     74,
                     75,
                     76,
                     77,
                     78,
                     79,
                     80,
                     81,
                     82,
                     83,
                     84,
                     85,
                     86,
                     87,
                     88,
                     89,
                     90,
                     91,
                     92,
                     93,
                     94,
                     95,
                     96,
                     97,
                     98,
                     99,
                     100,
                     101,
                     102,
                     103,
                     104,
                     105,
                     106,
                     107,
                     108,
                     109,
                     110,
                     111,
                     112,
                     113,
                     114,
                     115,
                     116,
                     117,
                     118,
                     119,
                     120,
                     121,
                     122,
                     123,
                     124,
                     125,
                     126,
                     127,
                     128,
                     129,
                     130,
                     131,
                     132,
                     133,
                     134,
                     135,
                     136,
                     137,
                     138,
                     139,
                     140,
                     141,
                     142,
                     143,
                     144,
                     145,
                     146,
                     147,
                     148,
                     149,
                     150,
                     151,
                     152,
                     153,
                     154,
                     155,
                     156,
                     157,
                     158,
                     159,
                     160,
                     161,
                     162,
                     163,
                     164,
                     165,
                     166,
                     167,
                     168,
                     169,
                     170,
                     171,
                     172,
                     173,
                     174,
                     175,
                     176,
                     177,
                     178,
                     179,
                     180,
                     181,
                     182,
                     183,
                     184,
                     185,
                     186,
                     187,
                     188,
                     189,
                     190,
                     191,
                     192,
                     193,
                     194,
                     195,
                     196,
                     197,
                     198,
                     199,
                     200,
                     201,
                     202,
                     203,
                     204,
                     205,
                     206,
                     207,
                     208,
                     209,
                     210,
                     211,
                     212,
                     213,
                     214,
                     215,
                     216,
                     217,
                     218,
                     219,
                     220,
                     221,
                     222,
                     223,
                     224,
                     225,
                     226,
                     227,
                     228,
                     229,
                     230,
                     231,
                     232,
                     233,
                     234,
                     235,
                     236,
                     237,
                     238,
                     239,
                     240,
                     241,
                     242,
                     243,
                     244,
                     245,
                     246,
                     247,
                     248,
                     249,
                     250,
                     251,
                     252,
                     253,
                     254,
                     255,
                     256,
                     257,
                     258,
                     259,
                     260,
                     261,
                     262,
                     263,
                     264,
                     265,
                     266,
                     267,
                     268,
                     269,
                     270,
                     271,
                     272,
                     273,
                     274,
                     275,
                     276,
                     277,
                     278,
                     279,
                     280,
                     281,
                     282,
                     283,
                     284,
                     285,
                     286,
                     287,
                     288,
                     289,
                     290,
                     291,
                     292,
                     293,
                     294,
                     295,
                     296,
                     297,
                     298,
                     299,
                     300,
                     301,
                     302,
                     303,
                     304,
                     305,
                     306]


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]
daily_tmin_path = cfg["daily_tmin_path"]
daily_tmax_path = cfg["daily_tmax_path"]

def vernalization_days(tavg):
    vd = tavg.copy()
    vd[vd < 32] = 0
    vd[vd > 64.4] = 0
    vd[(vd >= 32) & (vd <= 42.8)] = 1
    vd[(vd >= 44.6) & (vd <= 64.4)] = -(0.06 * vd[(vd >= 44.6) & (vd <= 64.4)]) + 3.38
    return vd

def photoperiod(upper_left_y):
    num_lats = 1228#621
    num_longs = 2606#1405
    day_max = 365

    ydim = 0.04166666666667

    for day in range(1, day_max):

        # calculate latitudes
        site_latitudes = np.arange(num_lats, dtype=float)
        site_latitudes *= -ydim
        site_latitudes += upper_left_y

        # calculate day lengths and rounded day lengths
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
    day = datetime.strptime(start_date, "%Y-%m-%d")
    stop = datetime.strptime(stop_date, "%Y-%m-%d")

    temp_unit = 'fahrenheit'

    doy = 0
    while day <= stop:

        tmin_tif_path = daily_tmin_path + "tmin_{day}.tif".format(day=day.strftime("%Y%m%d"))
        tmax_tif_path = daily_tmax_path + "tmax_{day}.tif".format(day=day.strftime("%Y%m%d"))
        # tmin_tif_path = "/Users/npn/Documents/geo-data/tmin_tmax/tmin_{day}.tif".format(day=day.strftime("%Y%m%d"))
        # tmax_tif_path = "/Users/npn/Documents/geo-data/tmin_tmax/tmax_{day}.tif".format(day=day.strftime("%Y%m%d"))
        try:
            tmin = get_climate_data_from_file(tmin_tif_path, temp_unit)
            tmax = get_climate_data_from_file(tmax_tif_path, temp_unit)
            num_lats = tmin.shape[0]
            num_lngs = tmin.shape[1]
        except:
            logging.error('could not get temp data, aborting agdd computation: ', exc_info=True)
            return
        if doy == 0:
            ds = gdal.Open(tmin_tif_path)
            projection = ds.GetProjection()
            transform = ds.GetGeoTransform()
            (upper_left_x, x_size, x_rotation, upper_left_y, y_rotation, y_size) = transform
            daylengths = photoperiod(upper_left_y)
            photoperiod_penalty = 0.075 * daylengths - 0.24
            ds = None

        tmax[tmax > 78.8] = 78.8
        tavg = (tmin + tmax) / 2

        # compute vernalization days and photoperiod
        if doy == 0:
            vd_accum = np.zeros_like(tmin)
            gdd = np.zeros_like(tmin)
            agdd = np.zeros_like(tmin)
        vd = vernalization_days(tavg)
        vd_accum = vd_accum + vd
        vd_penalty = 0.015 * vd_accum + 0.21

        # optimized version
        bases = np.where(agdd <= 752, 35.6, 32)
        gdd = tavg - bases
        gdd[gdd < 0] = 0
        # this is to transform dimensions (doy, lat) -> (lat, lng) by repeating the
        # lat penalties across the lng dimension
        photoperiod_penalty_broadcasted = np.swapaxes(np.repeat(photoperiod_penalty[doy,np.newaxis], 2606, 0),0,1)
        
        penalties = np.where((vd_accum < 50) & (photoperiod_penalty_broadcasted > vd_penalty), vd_penalty, photoperiod_penalty_broadcasted)
        gdd *= penalties
        agdd += gdd

        # nonoptimized version
        # for lat in range(0, num_lats):
        #     for lng in range(0, num_lngs):
        #         base = 35.6
        #         if agdd[lat, lng] > 752:
        #             base = 32
        #         if tavg[lat, lng] - base < 0:
        #             gdd[lat, lng] = 0
        #         else:
        #             # vd_penalty = 0.015 * vd_accum[lat, lng] + 0.21
        #             if vd_accum[lat, lng] < 50 and vd_penalty[lat, lng] < photoperiod_penalty[doy, lat]:
        #                 gdd[lat, lng] = (tavg[lat, lng] - base) * vd_penalty[lat, lng]
        #             else:
        #                 gdd[lat, lng] = (tavg[lat, lng] - base) * photoperiod_penalty[doy, lat]
        #         agdd[lat, lng] += gdd[lat, lng]
        
        # write the raster to disk
        winter_wheat_path = "/geo-data/gridded_models/winter_wheat/winter_wheat_{day}.tif".format(day=day.strftime("%Y%m%d"))
        # winter_wheat_path = "/Users/npn/Documents/geo-data/winter_wheat/winter_wheat_{day}.tif".format(day=day.strftime("%Y%m%d"))
        write_raster(winter_wheat_path, agdd, -9999, num_lngs, num_lats, projection, transform)

        doy += 1
        day = day + timedelta(days=1)


def main():
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script compute_buffelgrass.py*****************')
    logging.info('*****************************************************************************')

    start_date = "2020-01-01"
    stop_date = "2020-12-31"
    #stop_date = date.today().strftime("%Y-%m-%d")
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
