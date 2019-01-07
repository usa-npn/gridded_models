#!/usr/bin/python3
import spring_index.postgis_driver as driver
from spring_index.spring_index_util import *
from climate.importer import *
from util.gdd import *
from qc.gdd_checker import populate_agdd_qc
from qc.six_checker import *
from compute_tavg import compute_ncep_tavg
from datetime import date
from datetime import datetime
import logging
import time
from datetime import timedelta
import yaml
import os.path
from util.log_manager import get_error_log

# dates
today = date.today()
current_year = today.year
one_week_ago = today - timedelta(days=7)
three_days_ago = today - timedelta(days=3)
one_week_into_future = today + timedelta(days=7)
beginning_of_this_year = date(current_year, 1, 1)
end_of_this_year = date(current_year, 12, 31)
end_of_previous_year = date(current_year - 1, 12, 31)
end_of_next_year = date(current_year + 1, 12, 31)
day_250_of_current_year = beginning_of_this_year + timedelta(days=250)

region = 'conus'
agdd_bases = [32, 50]


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]


# populate spring index for year through six days in the future
def populate_six(beginning_of_this_year, today, plants, phenophases, climate_data_provider, region, time_rez):
    start_date = beginning_of_this_year
    end_date = today + timedelta(days=6)

    driver.Six.load_daily_climate_data(start_date, end_date, climate_data_provider, region)
    for plant in plants:
        for phenophase in phenophases:
            driver.Six.compute_daily_index(plant, phenophase)
            delta = end_date - start_date
            for i in range(delta.days + 1):
                day = start_date + timedelta(days=i)
                driver.Six.create_raster(plant, phenophase, climate_data_provider, region, day, time_rez)
                driver.Six.postgis_import(plant, phenophase, climate_data_provider, region, day, time_rez)
                logging.info('calculated spring index for plant: %s phenophase: %s on day: %s', plant, phenophase, day)
    # compute averages
    driver.Six.leaf_average_array /= len(plants)
    driver.Six.bloom_average_array /= len(plants)
    for phenophase in phenophases:
        delta = end_date - start_date
        for i in range(delta.days + 1):
            day = start_date + timedelta(days=i)
            driver.Six.create_raster("average", phenophase, climate_data_provider, region, day, time_rez)
            driver.Six.postgis_import("average", phenophase, climate_data_provider, region, day, time_rez)
            logging.info('calculated average spring index for phenophase: %s on day: %s', phenophase, day)
    driver.Six.cleanup()


# populate spring index after day 250 by copying day 250 over
def populate_six_from_day_250(beginning_of_this_year, today, plants, phenophases, climate_data_provider, region):
    logging.info('No need to recalculate si-x past day 250, copying day 240 into missing days.')
    day_250_of_current_year = beginning_of_this_year + timedelta(days=250)
    day_240_of_current_year = beginning_of_this_year + timedelta(days=240)
    current_year = today.year

    date_diff = today - day_250_of_current_year
    # copy geotiffs for individual plants
    for plant in plants:
        for phenophase in phenophases:
            for i in range(date_diff.days + 7):
                day = day_250_of_current_year + timedelta(days=i)
                if day.year == current_year:
                    logging.info('attempting to copy si-x plant: %s phenophase: %s for day: %s region: %s',
                                 plant, phenophase, day, region)
                    driver.Six.copy_spring_index_raster(plant, phenophase, climate_data_provider, region,
                                                        day_240_of_current_year, day)
                    driver.Six.postgis_import(plant, phenophase, climate_data_provider, region, day, "day")
    # copy geotiffs for six averages and anomalies
    for phenophase in phenophases:
        for i in range(date_diff.days + 7):
            day = day_250_of_current_year + timedelta(days=i)
            if day.year == current_year:
                logging.info('attempting to copy si-x plant: %s phenophase: %s for day: %s', 'average', phenophase, day)
                driver.Six.copy_spring_index_raster("average", phenophase, climate_data_provider, region,
                                                    day_240_of_current_year, day)
                driver.Six.postgis_import("average", phenophase, climate_data_provider, region, day, "day")
                # copy geotiffs for six anomalies and import them into the database
                logging.info('attempting to copy si-x anomaly: phenophase: %s for day: %s', phenophase, day)
                copy_spring_index_anomaly_raster(phenophase, day_240_of_current_year, day)


def importClimateData():
    # #################### CLIMATE DATA CALCULATIONS ####################################################
    # download and import ndfd forecast temps for the next week
    # overwrites all files previously downloaded files
    logging.info('importing ncep forecast data')
    download_forecast(region)

    # downloads hourly rtma/urma temps into our postgis db for the past 24 hours (each hour represents GMT)
    # overwrites all files previously downloaded files
    logging.info('importing rtma hourly data')
    download_hourly_temps('rtma', region)
    logging.info('importing urma hourly data')
    download_hourly_temps('urma', region)

    # download and import rtma data for the date range that was missed for any reason
    # this looks back one week,
    # another script is in place to delete rtma data older than two weeks for which we also have urma data
    # won't overwrite any previously downloaded files
    logging.info('importing historic rtma hourly data')
    download_historic_climate_data(one_week_ago, today, 'rtma', 'conus')
    # alaska rtma archive doesn't exist
    # download_historic_climate_data(one_week_ago, today, 'rtma', 'alaska')

    # compute daily tmin/tmax based on hourly data
    # computation is based on mixture of rtma and urma data; rtma is only used when urma isn't available
    # overwrites files less than 7 days old so the flow of tmin/tmax through time goes from
    # urma -> urma/rtma -> forecast
    # makes data match prism (prism day goes from -12 utc to +12 utc
    logging.info('computing daily temperatures based on ncep hourly data')
    hour_shift = -12
    compute_tmin_tmax(min(beginning_of_this_year, one_week_ago), one_week_into_future, hour_shift, 7, region)
    
    logging.info('computing daily ncep tavg')
    try:
        compute_ncep_tavg(one_week_ago, one_week_into_future)
    except:
        logging.error('unable to compute tavg, likely that tmin/tmax is missing', exc_info=True)


def importAgdd():
    # #################### AGDD CALCULATIONS ####################################################
    # populate NCEP agdds and anomalies
    # files older than 3 days won't get overwritten, but newer ones will due to tmin/tmax updates
    climate_data_provider = "ncep"

    # calculate AGDDs for current year
    logging.info('computing current year agdds')
    for agdd_base in agdd_bases:
        import_agdd(end_of_this_year, agdd_base, climate_data_provider, region)
    logging.info('computing current year agdd anomalies')
    for agdd_base in agdd_bases:
        import_agdd_anomalies(end_of_this_year, agdd_base)

    # might need compute AGDDs for next year if forecast goes into next year
    if one_week_into_future.year != end_of_this_year.year:
        logging.info('computing next year agdds')
        for agdd_base in agdd_bases:
            import_agdd(end_of_next_year, agdd_base, climate_data_provider, region)
        logging.info('computing next year agdd anomalies')
        for agdd_base in agdd_bases:
            import_agdd_anomalies(end_of_next_year, agdd_base)

    # might need to recompute last year's AGDDs if we're still updating those tmin/tmaxs
    if one_week_ago.year != end_of_this_year.year:
        logging.info('recomputing last year agdds')
        for agdd_base in agdd_bases:
            import_agdd(end_of_previous_year, agdd_base, climate_data_provider, region)
        logging.info('recomputing last year agdd anomalies')
        for agdd_base in agdd_bases:
            import_agdd_anomalies(end_of_previous_year, agdd_base)

    # populate PRISM agdds for year
    # files older than 3 days won't get overwritten, but newer ones will due to tmin/tmax updates
    climate_data_provider = "prism"
    base = 32
    logging.info('computing this year prism agdds')
    import_agdd(end_of_this_year, base, climate_data_provider, "conus")

    # might need to recompute last year's AGDDs if we're still updating those tmin/tmaxs
    if one_week_ago.year != end_of_this_year.year:
        base = 32
        logging.info('recomputing last year prism agdds')
        import_agdd(end_of_previous_year, base, climate_data_provider, "conus")


def importSix():
    # #################### SI-X CALCULATIONS ####################################################
    plants = ['lilac', 'arnoldred', 'zabelli']
    phenophases = ['leaf', 'bloom']

    climate_data_provider = "ncep"
    time_rez = "day"

    if today > day_250_of_current_year:
        logging.info('poplulating six maps by copying doy 250')
        populate_six_from_day_250(beginning_of_this_year, today, plants, phenophases, climate_data_provider, region)
    else:
        logging.info('computing six maps')
        populate_six(beginning_of_this_year, today, plants, phenophases, climate_data_provider, region, time_rez)

    # populate spring index anomalies
    # files older than 3 days won't get overwritten, but newer ones will due to tmin/tmax updates
    logging.info('computing six anomaly maps')
    for phenophase in phenophases:
        import_six_anomalies(end_of_this_year, phenophase)


def importCustomPestMapAgdd():
    ############## PEST MAP CUSTOM AGDD RASTER CACHE POPULATOR #######################################
    # pine needle scale, bagworm, and eastern tent caterpillar
    march_first_start = date(current_year, 3, 1)
    delta = one_week_into_future - march_first_start
    num_days = delta.days
    logging.info('poplulating simple agdd base 50 with March 1 start date for pestMaps')
    dynamic_agdd(march_first_start, num_days, 50, 'ncep', 'conus', 'fahrenheit', True)

    # asian lng horned beetle
    lowerThreshold = 50
    upperThreshold = 86
    delta = one_week_into_future - beginning_of_this_year
    num_days = delta.days
    logging.info('poplulating double-sine agdd base 50 with Jan 1 start date for pestMaps')
    dynamic_double_sine_agdd(beginning_of_this_year, num_days, lowerThreshold, upperThreshold, 'ncep', 'conus', 'fahrenheit', True)

    # gypsy moth #todo get thresholds from alyssa
    # lowerThreshold = 0
    # upperThreshold = 37.4
    # delta = one_week_into_future - beginning_of_this_year
    # num_days = delta.days
    # logging.info('poplulating double-sine agdd base 37.4 with Jan 1 start date for pestMaps')
    # dynamic_double_sine_agdd(beginning_of_this_year, num_days, lowerThreshold, upperThreshold, 'ncep', 'conus', 'fahrenheit', True)


def importQcData():
    # populates various climate variables in the climate agdds mysql db
    urma_start = three_days_ago
    urma_end = today
    acis_start = one_week_ago
    acis_end = today
    prism_start = one_week_ago
    prism_end = three_days_ago
    logging.info('populating agdd qc')
    populate_agdd_qc(urma_start, urma_end, acis_start, acis_end, prism_start, prism_end)
    logging.info('populating six qc')
    populate_six_qc(beginning_of_this_year, urma_end, beginning_of_this_year, acis_end, beginning_of_this_year, prism_end)


# This is the main gridded models script. It runs nightly to both pull climate data and generate various rasters which
# are also imported into a postgis database
def main():
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script gridded_models_nightly_update.py*****************')
    logging.info('*****************************************************************************')

    importClimateData()
    t1 = time.time()
    
    importAgdd()
    t2 = time.time()
    
    importSix()
    t3 = time.time()
    
    #importCustomPestMapAgdd()
    t4 = time.time()
    
    importQcData()
    t5 = time.time()

    logging.info('***time stats***')
    logging.info('importClimateData() finished in %s seconds', t1 - t0)
    logging.info('importAgdd() finished in %s seconds', t2 - t1)
    logging.info('importSix() finished in %s seconds', t3 - t2)
    logging.info('importCustomPestMapAgdd() finished in %s seconds', t4 - t3)
    logging.info('importQcData() finished in %s seconds', t5 - t4)

    logging.info('*****************************************************************************')
    logging.info('***********gridded_models_nightly_update.py finished in %s seconds***********', t5 - t0)
    logging.info('*****************************************************************************')


if __name__ == "__main__":
    logging.basicConfig(filename=log_path+'gridded_models_nightly_update.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    error_log = get_error_log()

    try:
        main()
    except (SystemExit, KeyboardInterrupt):
        raise
    except:
        error_log.error('gridded_models_nightly_update.py failed to finish: ', exc_info=True)
