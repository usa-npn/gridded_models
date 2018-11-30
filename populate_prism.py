#!/usr/bin/python3
from datetime import date
from datetime import timedelta
from prism.importer import get_prism_data
from prism.importer import get_prism_data_outdb
from prism.importer import clean_prism_precip_early_and_provisional
import logging
import time
import yaml
import os.path
from util.log_manager import get_error_log


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]

def populate_precip():
    start = date(2018, 1, 1)
    end = date.today() #+ timedelta(days=1)
    get_prism_data_outdb(start, end, ['ppt'])

# todo extend get_prism_data_outdb for temp data or use importer.get_prism_data(start_date, end_date, climate_variables)
# get_prism_data_outdb is only written for ppt (precip) at the moment
# def populate_temp():
#     today = date.today()
#     current_year = today.year
#     end_of_this_year = date(current_year, 12, 31)

#     start = date(1980, 1, 1)
#     end = end_of_this_year
#     get_prism_data_outdb(start, end, ['tmax', 'tmin'])


def main():
    # This script downloads climate data available from January 1981 through yesterday at a 4k resolution.
    # This script doesn't run nightly but is used to download historical blocks of PRISM data.
    # By default this script will populate years 1980 through the current year.

    # The data is broken into 3 categories: early, provisional, and stable.
    # early = this months data: climatologically-aided interpolation is used to fill in missing data points
    # provisional = prior 6 months data: quality is better than early, but refinements are still being made
    # stable = data older than 6 months: by this point no more changes should be made to the data
    # For more info on when PRISM data is updated see: http://prism.nacse.org/calendar/

    # The script downloads zip files to prism_path: which is defined in config.yml
    # It then unzips and imports the bil file into either the tmin_<year> or tmax_<year> table in the climate db
    # as well as putting an entry in the mosaic table for geoserver to create a coverage from.
    # This script can be ran multiple times, inserting new rows for new data
    # and overwriting old rows for data we already retrieved. For example if we have provisional data for a specific
    # day already and the script is reran when stable data has become available then the provisional data will be
    # replaced with the stable data. All early and provisional data gets overwritten every time the script is ran
    # so that we always have the most recent data. We never try to re-retrieve stable data unless the local zip files
    # are deleted for the corresponding days.
    # Look in config.yml to specify prism_path: <loc where zip files are downloaded> and database connection variables.
    # We don't delete the zip files in prism_path:

    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script populate_prism.py*****************')
    logging.info('*****************************************************************************')

    #populate_temp()

    # get precip data using out db method 
    # (keep files on disk, should have done this with tmin / tmax long ago but didn't know at the time)
    populate_precip()
    # clean_prism_precip_early_and_provisional()

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********populate_prism.py finished in %s seconds***********', t1 - t0)
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
        error_log.error('populate_prism.py failed to finish: ', exc_info=True)
