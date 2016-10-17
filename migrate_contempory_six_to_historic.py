#!/usr/bin/python3
from datetime import date
import logging
import time
import yaml
import os.path
from util.log_manager import get_error_log
import shutil
import six.postgis_driver as driver


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]
six_path = cfg["six_path"]


# this script migrates ncep si-x layers for day 250 (september 7th) to a historic yearly layer
# redmine enhancement #216
def main():
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script migrate_contempory_six_to_historic.py*****************')
    logging.info('*****************************************************************************')

    plants = ['lilac', 'arnoldred', 'zabelli', 'average']
    phenophases = ['leaf', 'bloom']

    property_files = ['datastore.properties',
                      'indexer.properties',
                      'timeregex.properties']

    today = date.today()
    year = today.year
    beginning_of_this_year = date(year, 1, 1)

    for plant in plants:
        for phenophase in phenophases:
            contempory_file_dir = six_path + 'six_' + plant + '_' + phenophase + '_ncep' + os.sep
            historic_file_dir = six_path + 'six_' + plant + '_' + phenophase + '_ncep' + '_historic' + os.sep

            contempory_file_name = plant + '_' + phenophase + '_ncep' + '_' + str(year) + '0907.tif'
            historic_file_name = plant + '_' + phenophase + '_ncep' + '_' + str(year) + '.tif'

            contempory_file_path = contempory_file_dir + contempory_file_name
            historic_file_path = historic_file_dir + historic_file_name

            # we get yearly property files from a prism layer since it's a yearly mosaic we've already built
            prism_dir = six_path + 'six_average_leaf_prism' + os.sep
            if not os.path.exists(historic_file_dir):
                logging.info('creating historic ncep directory: ' + historic_file_dir)
                os.makedirs(historic_file_dir)
                for property_file in property_files:
                    logging.info('copying: ' + prism_dir + property_file + ' to: ' + historic_file_dir + property_file)
                    shutil.copy(prism_dir + property_file, historic_file_dir + property_file)

            if os.path.isfile(contempory_file_path) and not os.path.isfile(historic_file_path):
                logging.info('copying: ' + contempory_file_path + ' to: ' + historic_file_path)
                shutil.copy(contempory_file_path, historic_file_path)
                driver.Six.postgis_import(plant, phenophase, 'ncep', beginning_of_this_year, "year")

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********migrate_contempory_six_to_historic.py finished in %s seconds***********', t1 - t0)
    logging.info('*****************************************************************************')


if __name__ == "__main__":
    logging.basicConfig(filename=log_path+'migrate_contempory_six_to_historic.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    error_log = get_error_log()

    try:
        main()
    except (SystemExit, KeyboardInterrupt):
        raise
    except:
        error_log.error('migrate_contempory_six_to_historic.py failed to finish: ', exc_info=True)
