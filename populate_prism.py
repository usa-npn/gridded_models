#!/usr/bin/python3
from datetime import date
from prism.importer import get_prism_data
import logging
import time


def main():
    # This script downloads climate data available from January 1981 through yesterday at a 4k resolution.

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

    logging.basicConfig(filename='/usr/local/scripts/gridded_models/populate_prism.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script populate_prism.py*****************')
    logging.info('*****************************************************************************')

    # Specify the climate elements you want to download as well as the date range to download those elements for:
    request_params = ['tmax', 'tmin']
    start = date(2015, 1, 1)
    end = date(2016, 12, 31)

    get_prism_data(start, end, request_params)

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********populate_prism.py finished in %s seconds***********', t1 - t0)
    logging.info('*****************************************************************************')


if __name__ == "__main__":
    main()
