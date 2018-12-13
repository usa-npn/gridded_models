#!/usr/bin/python3
from util.get_postgis_raster import *
from datetime import timedelta
import datetime as dt
from datetime import date
from util.gdd import *
import sys


def main():

    agddMethod = sys.argv[1]
    climateProvider = sys.argv[2]
    tempUnit = sys.argv[3]
    start = sys.argv[4]
    end = sys.argv[5]
    lowerThreshold = sys.argv[6]

    start_date = dt.datetime.strptime(start, '%Y-%m-%d')
    end_date = dt.datetime.strptime(end, '%Y-%m-%d')

    delta = end_date - start_date
    num_days = delta.days

    print('agddMethod: ' + agddMethod)
    print('start_date: ' + start)
    print('end_date: ' + end)
    print('lowerThreshold' + lowerThreshold)

    if agddMethod == 'simple':
        dynamic_agdd(start_date, num_days, int(lowerThreshold), climateProvider, 'conus', tempUnit)
    elif agddMethod == 'double-sine':
        upperThreshold = sys.argv[7]
        print('upperThreshold' + upperThreshold)
        dynamic_double_sine_agdd(start_date, num_days, int(lowerThreshold), int(upperThreshold), climateProvider, 'conus', tempUnit)
    else:
        print('invalid agddMethod, only simple and double-sine are accepted')

    # testing
    # dynamic_double_sine_agdd(dt.datetime.strptime('2018-01-01', '%Y-%m-%d'), 20, 50, 86, 'ncep', 'conus', 'fahrenheit')


if __name__ == "__main__":
    main()
