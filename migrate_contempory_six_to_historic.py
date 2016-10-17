#!/usr/bin/python3
from datetime import date
import logging
import time
import yaml
import os.path
from util.log_manager import get_error_log
import shutil


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]
six_path = cfg["six_path"]


def main():
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script migrate_contempory_six_to_historic.py*****************')
    logging.info('*****************************************************************************')

    six_layers = ['arnoldred_leaf_ncep',
                  'arnoldred_bloom_ncep',
                  'lilac_leaf_ncep',
                  'lilac_bloom_ncep',
                  'zabelli_leaf_ncep',
                  'zabelli_bloom_ncep',
                  'average_leaf_ncep',
                  'average_bloom_ncep']

    property_files = ['datastore.properties',
                      'indexer.properties',
                      'timeregex.properties']

    today = date.today()
    year = today.year

    for layer in six_layers:
        contempory_file_dir = six_path + 'six_' + layer + os.sep
        historic_file_dir = six_path + 'six_' + layer + '_historic' + os.sep

        contempory_file_name = layer + '_' + str(year) + '1001.tif'
        historic_file_name = layer + '_' + str(year) + '.tif'

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

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********migrate_contempory_six_to_historic.py finished in %s seconds***********', t1 - t0)
    logging.info('*****************************************************************************')


if __name__ == "__main__":
    logging.basicConfig(filename=log_path+'migrate_contempory_six_to_historic',
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
