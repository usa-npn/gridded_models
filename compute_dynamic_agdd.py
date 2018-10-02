#!/usr/bin/python3
from util.get_postgis_raster import *
from datetime import timedelta
import datetime as dt
from datetime import date
from util.gdd import *
import sys


def main():

    climateProvider = sys.argv[1]
    start = sys.argv[2]
    end = sys.argv[3]
    base = sys.argv[4]

    start_date = dt.datetime.strptime(start, '%Y-%m-%d')
    end_date = dt.datetime.strptime(end, '%Y-%m-%d')

    delta = end_date - start_date
    num_days = delta.days

    print('start_date: ' + start)
    print('end_date: ' + end)
    print('base' + base)
   
    dynamic_agdd(start_date, num_days, int(base), climateProvider, 'conus')

if __name__ == "__main__":
    main()
