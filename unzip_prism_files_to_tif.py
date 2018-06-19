#!/usr/bin/python3
from datetime import date
from prism.importer import unzip_prism_data
import logging
import time
import yaml
import os.path
from util.log_manager import get_error_log


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]


def main():
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script unzip_prism_files_to_tif.py*****************')
    logging.info('*****************************************************************************')

    unzip_prism_data()

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********unzip_prism_files_to_tif.py finished in %s seconds***********', t1 - t0)
    logging.info('*****************************************************************************')


if __name__ == "__main__":
    logging.basicConfig(filename=log_path + 'populate_prism.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    error_log = get_error_log()

    try:
        main()
    except (SystemExit, KeyboardInterrupt):
        raise
    except:
        error_log.error('unzip_prism_files_to_tif.py failed to finish: ', exc_info=True)
