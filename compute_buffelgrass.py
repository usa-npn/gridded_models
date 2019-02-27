#!/usr/bin/python3
from datetime import date
from prism.importer import unzip
from util.database import save_raster_to_postgis
from util.database import set_date_column
from util.database import table_exists
import logging
import time
import yaml
import os.path
from util.log_manager import get_error_log
import glob
import re
from datetime import datetime
from datetime import timedelta
import contextlib
import subprocess
import shutil
from pathlib import Path


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]

def get_prism_precip_file_name(day):
    precip_files_path = "/geo-data/climate_data/prism/prism_data/prism_ppt/"
    stable_file_name = precip_files_path + "PRISM_ppt_stable_4kmD2_{date}_bil.tif".format(date=day.strftime("%Y%m%d"))
    provisional_file_name = precip_files_path + "PRISM_ppt_provisional_4kmD2_{date}_bil.tif".format(date=day.strftime("%Y%m%d"))
    early_file_name = precip_files_path + "PRISM_ppt_early_4kmD2_{date}_bil.tif".format(date=day.strftime("%Y%m%d"))
    if Path(stable_file_name).is_file():
        return stable_file_name
    elif Path(provisional_file_name).is_file():
        return provisional_file_name
    elif Path(early_file_name).is_file():
        return early_file_name
    else:
        return None


def compute_buffelgrass(start_date, stop_date):
    buffelgrass_files_path = "/geo-data/gridded_models/buffelgrass/buffelgrass_prism/"

    os.makedirs(buffelgrass_files_path, exist_ok=True)

    # buffelgrass_table_name = "prism_buffelgrass"
    # new_table = not table_exists(buffelgrass_table_name)

    day = datetime.strptime(start_date, "%Y-%m-%d")
    stop = datetime.strptime(stop_date, "%Y-%m-%d")

    temp = buffelgrass_files_path + "temp.tif"

    while day <= stop:
        # copy start date precip file over to buffelgrass dir
        precip_accum_file = buffelgrass_files_path + "buffelgrass_{date}.tif".format(date=day.strftime("%Y%m%d"))
        print('copying' + get_prism_precip_file_name(day) + ' to ' + precip_accum_file)
        shutil.copy(get_prism_precip_file_name(day), precip_accum_file)

        window_stop = day
        window_day = day - timedelta(days=24)
        while window_day <= window_stop:
            os.rename(precip_accum_file, temp)
            window_day_precip_file = get_prism_precip_file_name(window_day)
            # window_day_precip_file can be None if we don't have precip data prior to the start date
            if window_day_precip_file is not None:
                # .0393700787 is to convert mm to inches
                subprocess.call("gdal_calc.py -A " + temp + " -B " + window_day_precip_file + " --outfile=" + precip_accum_file + " --NoDataValue=-9999 --calc='(A*(A>0)+B*(B>0))*.0393700787' --overwrite", shell=True)
            if os.path.isfile(temp):
                os.remove(temp)
            window_day = window_day + timedelta(days=1)

        #import into postgis
        # save_raster_to_postgis(avg_tiffile, tavg_table_name, 4269)
        # set_date_column(tavg_table_name, day, new_table)
        # new_table = False
        day = day + timedelta(days=1)


def main():
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script compute_buffelgrass.py*****************')
    logging.info('*****************************************************************************')

    # generate prism tavg
    start_date = "2018-01-01"
    stop_date = "2018-12-31"
    compute_buffelgrass(start_date, stop_date)

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********compute_buffelgrass.py finished in %s seconds***********', t1 - t0)
    logging.info('*****************************************************************************')


if __name__ == "__main__":
    logging.basicConfig(filename=log_path + 'compute_buffelgrass.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    error_log = get_error_log()

    try:
        main()
    except (SystemExit, KeyboardInterrupt):
        raise
    except:
        error_log.error('compute_buffelgrass.py failed to finish: ', exc_info=True)
