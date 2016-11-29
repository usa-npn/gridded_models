#!/usr/bin/python3
from climate.importer import *
from prism.importer import get_prism_data
from datetime import date
from datetime import timedelta
import logging
import time
from qc.gdd_checker import populate_agdd_qc
from qc.six_checker import populate_six_qc
import yaml
import os.path
from util.log_manager import get_error_log


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]


# This script grabs historic urma data and populates npn databases/geoserver.
# It isn't ran nightly, but only in cases where you want to grab data from further back in time.
def main():
    t0 = time.time()

    today = date.today()
    current_year = today.year
    beginning_of_this_year = date(current_year, 1, 1)

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script populate_historic_urma.py*****************')
    logging.info('*****************************************************************************')

    # downloads hourly urma temps into our postgis db for the past 24 hours (each hour represents GMT)
    # overwrites all files previously downloaded files
    download_hourly_temps('urma')

    # download and import urma data for the date range that was missed for any reason
    # won't overwrite any previously downloaded files
    days_ago = date.today() - timedelta(days=9)
    end = date(2016, 12, 31)
    download_historical_urma(days_ago, end)

    # compute daily tmin/tmax based on hourly data
    # computation is based on mixture of rtma and urma data; rtma is only used when urma isn't available
    # overwrites files less than 9 days old so the flow of tmin/tmax through time goes from
    # urma -> urma/rtma -> forecast
    start = date(2016, 1, 1)
    end = date(2016, 12, 31)
    # makes data match prism (prism day goes from -12 utc to +12 utc
    hour_shift = -12
    compute_tmin_tmax(start, end, hour_shift, 9)

    # populates various climate variables in the climate agdds mysql db
    urma_start = datetime.now().date() - timedelta(days=9)
    urma_end = datetime.now().date()
    acis_start = datetime.now().date() - timedelta(days=9)
    acis_end = datetime.now().date()
    prism_start = datetime.now().date() - timedelta(days=9)
    prism_end = datetime.now().date() - timedelta(days=3)
    populate_agdd_qc(urma_start, urma_end, acis_start, acis_end, prism_start, prism_end)
    populate_six_qc(beginning_of_this_year, urma_end, beginning_of_this_year, acis_end, beginning_of_this_year, prism_end)

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********populate_historic_urma.py finished in %s seconds***********', t1 - t0)
    logging.info('*****************************************************************************')


if __name__ == "__main__":
    logging.basicConfig(filename=log_path + 'populate_historic_urma.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    error_log = get_error_log()

    try:
        main()
    except (SystemExit, KeyboardInterrupt):
        raise
    except:
        error_log.error('populate_historic_urma.py failed to finish: ', exc_info=True)
