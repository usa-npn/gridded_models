#!/usr/bin/python3
from climate.importer import *
from datetime import date
from prism.importer import get_climate_data


def main():
    # the following two links provide the place and information to get historical rtma data
    # http://nomads.ncdc.noaa.gov/data/ndgd/201510/20151005/
    # http://www.nws.noaa.gov/infoservicechanges/tin11-42rtma_oper.txt

    # download and import ndfd forecast temps for the next week
    download_forecast()

    # downloads hourly rtma temps into our postgis db for the past 24 hours each hour represents GMT
    # overwrites all files previously downloaded files
    download_hourly_temps('rtma')
    download_hourly_temps('urma')

    # download and import rtma data for the date range (never looks for days past yesterday)
    # won't overwrite any previously downloaded files
    start = date(2015, 1, 1)
    end = date(2016, 1, 1)
    download_historical_temps(start, end)

    # compute daily tmin/tmax based on hourly data
    # computation is based on mixture of rtma and urma data; rtma is only used when urma isn't available
    # overwrites files less than 4 days old so the flow of tmin/tmax through time goes from
    # forecast -> urma/rtma -> urma
    start = date(2015, 1, 1)
    end = date(2016, 1, 1)
    hour_shift = -12
    compute_tmin_tmax(start, end, hour_shift)

    # download and import prism data
    request_params = ['tmax', 'tmin']
    start = date(2015, 1, 1)
    end = date(2016, 1, 1)
    # get_climate_data(start, end, request_params)


if __name__ == "__main__":
    main()
