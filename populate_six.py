import spring_index.postgis_driver as driver
from datetime import *
import time
import logging
import yaml
import os.path

with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]


# This script is used to populate the spring index for historic years. It is not ran nightly.
# Before running this script populate_prism.py must be ran for the years you want to generate spring index maps.
# By default this script will populate 1980 through the current year using prism data.
def main():

    logging.basicConfig(filename=log_path + 'populate_six.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script populate_six.py*****************')
    logging.info('*****************************************************************************')

    today = date.today()
    current_year = today.year
    end_of_this_year = date(current_year, 12, 31)

    start_date = date(2016, 1, 1)
    end_date = today + timedelta(days=6)

    # start_date = date(1980, 1, 1)
    # end_date = end_of_this_year

    climate_data_provider = 'ncep'#"prism"
    time_rez = "day"

    plants = ['lilac', 'arnoldred', 'zabelli']
    phenophases = ['leaf', 'bloom']

    # compute individual plants
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

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********populate_six.py finished in %s seconds***********', t1-t0)
    logging.info('*****************************************************************************')

if __name__ == "__main__":
    main()
