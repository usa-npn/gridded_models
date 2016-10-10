#!/usr/bin/python3
from qc.gdd_checker import *
from datetime import date
import logging
import time
from datetime import timedelta
import yaml
import os.path
from util.log_manager import get_error_log


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]


# This script populates climate data and agdds from urma, acis, and prism into a mysql database
# It's then used by tableau for uncertainty checks: https://www.usanpn.org/agdd_uncertainty
def main():
    t0 = time.time()

    today = date.today()
    current_year = today.year
    three_days_ago = today - timedelta(days=3)
    beginning_of_this_year = date(current_year, 1, 1)

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script populate_qc_database.py*****************')
    logging.info('*****************************************************************************')

    urma_start = beginning_of_this_year
    urma_end = today
    acis_start = beginning_of_this_year
    acis_end = today
    prism_start = beginning_of_this_year
    prism_end = three_days_ago
    populate_climate_qc(urma_start, urma_end, acis_start, acis_end, prism_start, prism_end)
    populate_six_qc(beginning_of_this_year, urma_end, beginning_of_this_year, acis_end, beginning_of_this_year,
                    prism_end)

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********populate_qc_database.py finished in %s seconds***********', t1 - t0)
    logging.info('*****************************************************************************')


if __name__ == "__main__":
    logging.basicConfig(filename=log_path + 'populate_qc_database.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    error_log = get_error_log()

    try:
        main()
    except (SystemExit, KeyboardInterrupt):
        raise
    except:
        error_log.error('populate_qc_database.py failed to finish: ', exc_info=True)
