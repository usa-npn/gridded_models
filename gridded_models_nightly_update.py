#!/usr/bin/python3
import six.postgis_driver as driver
from six.spring_index_util import *
from climate.importer import *
from util.gdd import *
from qc.gdd_checker import *
from datetime import date
from datetime import datetime
import logging
import time


def main():
    # logging.basicConfig(filename='D:\gridded_models_nightly_update.log',
    logging.basicConfig(filename='/usr/local/scripts/gridded_models/gridded_models_nightly_update.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script gridded_models_nightly_update.py*****************')
    logging.info('*****************************************************************************')

    # download and import ndfd forecast temps for the next week
    # overwrites all files previously downloaded files
    download_forecast()

    # downloads hourly rtma/urma temps into our postgis db for the past 24 hours (each hour represents GMT)
    # overwrites all files previously downloaded files
    download_hourly_temps('rtma')
    download_hourly_temps('urma')

    # downloads hourly rtma/urma uncertainty into our postgis db for the past 24 hours (each hour represents GMT)
    # overwrites all files previously downloaded files
    download_hourly_temp_uncertainty('rtma')
    download_hourly_temp_uncertainty('urma')

    # download and import rtma data for the date range (never looks for days past yesterday)
    # won't overwrite any previously downloaded files
    start = date(2016, 1, 1)
    end = date(2016, 12, 31)
    download_historical_temps(start, end)

    # compute daily tmin/tmax based on hourly data
    # computation is based on mixture of rtma and urma data; rtma is only used when urma isn't available
    # overwrites files less than 4 days old so the flow of tmin/tmax through time goes from
    # urma -> urma/rtma -> forecast
    start = date(2016, 1, 1)
    end = date(2016, 12, 31)
    # makes data match prism (prism day goes from -12 utc to +12 utc
    hour_shift = -12
    compute_tmin_tmax(start, end, hour_shift)

    # populate NCEP agdds for year
    # files older than 3 days won't get overwritten, but newer ones will due to tmin/tmax updates
    climate_data_provider = "ncep"
    agdd_date = date(2016, 12, 31)
    base = 32
    import_agdd(agdd_date, base, climate_data_provider)
    base = 50
    import_agdd(agdd_date, base, climate_data_provider)

    # populate PRISM agdds for year
    # files older than 3 days won't get overwritten, but newer ones will due to tmin/tmax updates
    climate_data_provider = "prism"
    agdd_date = date(2016, 12, 31)
    base = 32
    import_agdd(agdd_date, base, climate_data_provider)
    # base = 50
    # import_agdd(agdd_date, base, climate_data_provider)

    # populate agdd anomalies
    # files older than 3 days won't get overwritten, but newer ones will due to tmin/tmax updates
    agdd_anom_date = date(2016, 12, 31)
    base = 32
    import_agdd_anomalies(agdd_anom_date, base)
    base = 50
    import_agdd_anomalies(agdd_anom_date, base)

    # populate spring index for year through six days in the future
    # # climate_data_provider = "ncep"
    # # time_rez = "year"
    # # start_date = date(2015, 1, 1)
    # # end_date = date(2015, 12, 31)
    climate_data_provider = "ncep"
    time_rez = "day"
    start_date = date(2016, 1, 1)
    end_date = datetime.now().date()
    end_date += timedelta(days=6)

    plants = ['lilac', 'arnoldred', 'zabelli']
    phenophases = ['leaf', 'bloom']

    driver.Six.load_daily_climate_data(start_date, end_date, climate_data_provider)
    for plant in plants:
        for phenophase in phenophases:
            driver.Six.compute_daily_index(plant, phenophase)
            delta = end_date - start_date
            for i in range(delta.days + 1):
                day = start_date + timedelta(days=i)
                driver.Six.create_raster(plant, phenophase, climate_data_provider, day, time_rez)
                driver.Six.postgis_import(plant, phenophase, climate_data_provider, day, time_rez)
                logging.info('calculated spring index for plant: %s phenophase: %s on day: %s', plant, phenophase, day)
    # compute averages
    driver.Six.leaf_average_array /= len(plants)
    driver.Six.bloom_average_array /= len(plants)
    for phenophase in phenophases:
        delta = end_date - start_date
        for i in range(delta.days + 1):
            day = start_date + timedelta(days=i)
            driver.Six.create_raster("average", phenophase, climate_data_provider, day, time_rez)
            driver.Six.postgis_import("average", phenophase, climate_data_provider, day, time_rez)
            logging.info('calculated average spring index for phenophase: %s on day: %s', phenophase, day)
    driver.Six.cleanup()

    # populate spring index anomalies
    # files older than 3 days won't get overwritten, but newer ones will due to tmin/tmax updates
    spring_index_anom_date = date(2016, 12, 31)
    phenophase = 'leaf'
    import_six_anomalies(spring_index_anom_date, phenophase)
    phenophase = 'bloom'
    import_six_anomalies(spring_index_anom_date, phenophase)

    # # populates various climate variables in the climate agdds mysql db
    # urma_start = datetime.now().date() - timedelta(days=3)
    # urma_end = datetime.now().date()
    # acis_start = datetime.now().date() - timedelta(days=7)
    # acis_end = datetime.now().date()
    # prism_start = datetime.now().date() - timedelta(days=7)
    # prism_end = datetime.now().date() - timedelta(days=3)
    # populate_climate_qc(urma_start, urma_end, acis_start, acis_end, prism_start, prism_end)

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********gridded_models_nightly_update.py finished in %s seconds***********', t1 - t0)
    logging.info('*****************************************************************************')


if __name__ == "__main__":
    main()
