#!/usr/bin/python3
from util.get_postgis_raster import *
from datetime import timedelta
import datetime as dt
from datetime import date
from util.gdd import *


# This is a utility script used to extract geotiffs from the postgis database. It's only used for debugging purposes.
def main():
    # year, plant, phenophase
    # get_six_raster('2014', 'lilac', 'leaf')

    # year, month, day, climate_var, resolution
    # get_ndfd_raster('2015', '10', '22', 'tmax', '4k')

    # get_daily_temp_raster('prism', 'tmin', '2015', '04', '01')

    # get_rtma_hourly_temp_raster('2014', '08', '19', '15')

    # get_raster_by_filename('agdd_2015', 'agdd_20150205.tif')

    # get_hourly_temp_raster(2016, 2, 3, 4, 'urma')

    # testing in db dynamic agdd calc
    # dynamic_agdd_in_db('prism_tmin_1989', date(1989, 9, 1), 25)

    # testing dynamic agdd using numpy
    start_date = date(2015, 1, 16)
    num_days = 5
    base = 14
    dynamic_agdd_test(start_date, num_days, base, 'prism', 'conus')

    # start_date = date(2015, 1, 16)
    # end_date = date(2015, 1, 16)
    #
    # delta = end_date - start_date
    # for i in range(delta.days + 1):
    #     day = start_date + timedelta(days=i)
    #     get_daily_temp_raster('rtma', 'tmax', day.strftime("%Y"), day.strftime("%m"), day.strftime("%d"))

if __name__ == "__main__":
    main()
