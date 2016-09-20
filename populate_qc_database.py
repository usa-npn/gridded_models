#!/usr/bin/python3
from qc.gdd_checker import *
from datetime import date
import logging
import time
from datetime import timedelta


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

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********populate_qc_database.py finished in %s seconds***********', t1 - t0)
    logging.info('*****************************************************************************')


if __name__ == "__main__":
    # logging.basicConfig(filename='D:\gridded_models_nightly_update.log',
    logging.basicConfig(filename='/usr/local/scripts/gridded_models/populate_qc_database.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')

    formatter = logging.Formatter('%(asctime)s : %(message)s')
    error_log = logging.getLogger('error_log')
    error_log.addHandler(logging.FileHandler('/usr/local/scripts/gridded_models/error.log', mode='w'))
    error_log.addHandler(logging.StreamHandler().setFormatter(formatter))
    error_log.setLevel(logging.ERROR)

    try:
        main()
    except (SystemExit, KeyboardInterrupt):
        raise
    except:
        error_log.error('populate_qc_database.py failed to finish: ', exc_info=True)
