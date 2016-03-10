import six.postgis_driver as driver
from datetime import *
import time
import logging


def main():

    logging.basicConfig(filename='/usr/local/scripts/gridded_models/populate_six.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script populate_six.py*****************')
    logging.info('*****************************************************************************')


    # populate spring index daily for a year
    climate_data_provider = "prism"
    time_rez = "day"
    start_date = date(2015, 1, 1)
    end_date = start_date + timedelta(days=240)

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


    # # climate_data_provider = "rtma"
    # # time_rez = "day"
    # climate_data_provider = "prism"
    # time_rez = "year"
    #
    #
    # for year in range(1981,2016):
    #
    #     # calculate the spring index through this date
    #     start_date = date(year, 1, 1)
    #     end_date = date(year, 12, 31)
    #     # forecast_start_date = datetime.now().date()
    #     # forecast_end_date = datetime.now().date()
    #
    #
    #     plants = ['lilac', 'arnoldred', 'zabelli']
    #     phenophases = ['leaf', 'bloom']
    #
    #     driver.Six.load_daily_climate_data(start_date, end_date, climate_data_provider)
    #     for plant in plants:
    #         for phenophase in phenophases:
    #             driver.Six.compute_daily_index(plant, phenophase, climate_data_provider)
    #             driver.Six.create_raster(plant, phenophase, climate_data_provider, end_date, time_rez)
    #             driver.Six.postgis_import(plant, phenophase, climate_data_provider, end_date, time_rez)
    #     #compute averages
    #     driver.Six.leaf_average_array /= len(plants)
    #     driver.Six.bloom_average_array /= len(plants)
    #     for phenophase in phenophases:
    #         driver.Six.create_raster("average", phenophase, climate_data_provider, end_date, time_rez)
    #         driver.Six.postgis_import("average", phenophase, climate_data_provider, end_date, time_rez)
    #     driver.Six.cleanup()

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********gridded_models_nightly_update.py finished in %s seconds***********', t1-t0)
    logging.info('*****************************************************************************')

    # driver.Six.conn.close()

if __name__ == "__main__":
    main()
