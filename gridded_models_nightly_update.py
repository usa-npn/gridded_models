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
from datetime import timedelta
import yaml
import os.path
from util.log_manager import get_error_log


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]

# This is the main gridded models script. It runs nightly to both pull climate data and generate various rasters which
# are also imported into a postgis database
def main():
    t0 = time.time()

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
    day_240_of_current_year = beginning_of_this_year + timedelta(days=240)
    import_qc_data = True

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script gridded_models_nightly_update.py*****************')
    logging.info('*****************************************************************************')

    # #################### CLIMATE DATA CALCULATIONS ####################################################
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

    # download and import rtma data for the date range that was missed for any reason
    # this looks back one week,
    # another script is in place to delete rtma data older than two weeks for which we also have urma data
    # won't overwrite any previously downloaded files
    download_historical_temps(one_week_ago, today)

    # compute daily tmin/tmax based on hourly data
    # computation is based on mixture of rtma and urma data; rtma is only used when urma isn't available
    # overwrites files less than 7 days old so the flow of tmin/tmax through time goes from
    # urma -> urma/rtma -> forecast
    # makes data match prism (prism day goes from -12 utc to +12 utc
    hour_shift = -12
    compute_tmin_tmax(min(beginning_of_this_year, one_week_ago), one_week_into_future, hour_shift, 7)

    # #################### AGDD CALCULATIONS ####################################################
    # populate NCEP agdds and anomalies
    # files older than 3 days won't get overwritten, but newer ones will due to tmin/tmax updates
    climate_data_provider = "ncep"

    # calculate AGDDs for current year
    base = 32
    import_agdd(end_of_this_year, base, climate_data_provider)
    import_agdd_anomalies(end_of_this_year, base)
    base = 50
    import_agdd(end_of_this_year, base, climate_data_provider)
    import_agdd_anomalies(end_of_this_year, base)

    # might need compute AGDDs for next year if forecast goes into next year
    if one_week_into_future.year != end_of_this_year.year:
        base = 32
        import_agdd(end_of_next_year, base, climate_data_provider)
        import_agdd_anomalies(end_of_next_year, base)
        base = 50
        import_agdd(end_of_next_year, base, climate_data_provider)
        import_agdd_anomalies(end_of_next_year, base)

    # might need to recompute last year's AGDDs if we're still updating those tmin/tmaxs
    if one_week_ago.year != end_of_this_year.year:
        base = 32
        import_agdd(end_of_previous_year, base, climate_data_provider)
        import_agdd_anomalies(end_of_previous_year, base)
        base = 50
        import_agdd(end_of_previous_year, base, climate_data_provider)
        import_agdd_anomalies(end_of_previous_year, base)

    # populate PRISM agdds for year
    # files older than 3 days won't get overwritten, but newer ones will due to tmin/tmax updates
    climate_data_provider = "prism"
    base = 32
    import_agdd(end_of_this_year, base, climate_data_provider)

    # might need to recompute last year's AGDDs if we're still updating those tmin/tmaxs
    if one_week_ago.year != end_of_this_year.year:
        base = 32
        import_agdd(end_of_previous_year, base, climate_data_provider)


    # #################### SI-X CALCULATIONS ####################################################
    plants = ['lilac', 'arnoldred', 'zabelli']
    phenophases = ['leaf', 'bloom']

    climate_data_provider = "ncep"
    time_rez = "day"

    if today > day_250_of_current_year:
        logging.info('No need to recalculate si-x past day 250, copying day 240 into missing days.')
        date_diff = today - day_250_of_current_year
        # copy geotiffs for individual plants
        for plant in plants:
            for phenophase in phenophases:
                for i in range(date_diff.days + 7):
                    day = day_250_of_current_year + timedelta(days=i)
                    if day.year == current_year:
                        logging.info('attempting to copy si-x plant: %s phenophase: %s for day: %s', plant, phenophase, day)
                        driver.Six.copy_spring_index_raster(plant, phenophase, climate_data_provider, day_240_of_current_year, day)
                        driver.Six.postgis_import(plant, phenophase, climate_data_provider, day, "day")
        # copy geotiffs for six averages and anomalies
        for phenophase in phenophases:
            for i in range(date_diff.days + 7):
                day = day_250_of_current_year + timedelta(days=i)
                if day.year == current_year:
                    logging.info('attempting to copy si-x plant: %s phenophase: %s for day: %s', 'average', phenophase, day)
                    driver.Six.copy_spring_index_raster("average", phenophase, climate_data_provider, day_240_of_current_year, day)
                    driver.Six.postgis_import("average", phenophase, climate_data_provider, day, "day")
                    # copy geotiffs for six anomalies and import them into the database
                    logging.info('attempting to copy si-x anomaly: phenophase: %s for day: %s', phenophase, day)
                    copy_spring_index_anomaly_raster(phenophase, day_240_of_current_year, day)
    else:
        # populate spring index for year through six days in the future
        start_date = beginning_of_this_year
        end_date = today + timedelta(days=6)

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
        phenophase = 'leaf'
        import_six_anomalies(end_of_this_year, phenophase)
        phenophase = 'bloom'
        import_six_anomalies(end_of_this_year, phenophase)

    if import_qc_data:
        # populates various climate variables in the climate agdds mysql db
        urma_start = three_days_ago
        urma_end = today
        acis_start = one_week_ago
        acis_end = today
        prism_start = one_week_ago
        prism_end = three_days_ago
        populate_climate_qc(urma_start, urma_end, acis_start, acis_end, prism_start, prism_end)
        populate_six_qc(beginning_of_this_year, urma_end, beginning_of_this_year, acis_end, beginning_of_this_year, prism_end)

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********gridded_models_nightly_update.py finished in %s seconds***********', t1 - t0)
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
