#!/usr/bin/python3
from datetime import date
from prism.importer import compute_tavg_from_prism_zips
from util.database import save_raster_to_postgis
from util.database import set_date_column
import logging
import time
import yaml
import os.path
from util.log_manager import get_error_log
import glob
import re
import datetime


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]


def main():
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script compute_tavg.py*****************')
    logging.info('*****************************************************************************')

    # start_date = "2017-01-01"
    # stop_date = "2017-12-31"
    # compute_tavg_from_prism_zips(start_date, stop_date)

    tavg_table_name = "prism_tavg"
    tavg_path = "/geo-vault/climate_data/prism/prism_data/tavg/"
    tavg_files_path = tavg_path + "*.tif"
    new_table = True
    for tavg_tif_path in glob.glob(tavg_files_path):
        tavg_datestring = re.search(r'\d+', tavg_tif_path).group()
        tavg_date = datetime.datetime.strptime(tavg_datestring, "%Y%m%d").date()
        save_raster_to_postgis(tavg_tif_path, tavg_table_name, 4269)
        set_date_column(tavg_table_name, tavg_date, new_table)
        new_table = False

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********compute_tavg.py finished in %s seconds***********', t1 - t0)
    logging.info('*****************************************************************************')


if __name__ == "__main__":
    logging.basicConfig(filename=log_path + 'compute_tavg.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    error_log = get_error_log()

    try:
        main()
    except (SystemExit, KeyboardInterrupt):
        raise
    except:
        error_log.error('compute_tavg.py failed to finish: ', exc_info=True)
