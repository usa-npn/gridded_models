#!/usr/bin/python3
from qc.gdd_checker import *
from qc.six_checker import *
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


def populate_historic_six_qc(year_start=2003, year_end=2016):
    """Inserts/updates qc rows in the mysql climate.six table for PRISM and ACIS for the year range specified."""
    for year in range(year_start, year_end):
        populate_historic_six_points(year)

def populate_historic_best_qc(year_start=1880, year_end=2014):
    """Inserts/updates qc rows in the mysql climate.six table for BEST for the year range specified."""
    for year in range(year_start, year_end):
        populate_historic_best_six_points(year)


def main():
    """Inserts/updates qc rows in the mysql climate.six and aggd tables for URMA, PRISM and ACIS.
    Used by tableau for uncertainty checks: https://www.usanpn.org/agdd_uncertainty"""
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
    populate_agdd_qc(urma_start, urma_end, acis_start, acis_end, prism_start, prism_end)
    populate_six_qc(beginning_of_this_year, urma_end, beginning_of_this_year, acis_end, beginning_of_this_year,
                    prism_end)

    # populate_historic_best_qc(2013, 2014)

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
