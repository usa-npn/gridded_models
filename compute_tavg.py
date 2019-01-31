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


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]


def compute_tavg_from_prism_zips(start_date, stop_date):
    tmax_zipped_files_path = "/geo-vault/climate_data/prism/prism_data/zipped/tmax/"
    tmin_zipped_files_path = "/geo-vault/climate_data/prism/prism_data/zipped/tmin/"
    unzip_to_path = "/geo-data/climate_data/prism/prism_data/tavg/"

    os.makedirs(unzip_to_path, exist_ok=True)

    tavg_table_name = "prism_tavg"
    new_table = not table_exists(tavg_table_name)

    day = datetime.strptime(start_date, "%Y-%m-%d")
    stop = datetime.strptime(stop_date, "%Y-%m-%d")

    while day <= stop:
        tmin_zip_file = "PRISM_tmin_stable_4kmD1_{date}_bil.zip".format(date=day.strftime("%Y%m%d"))
        tmax_zip_file = "PRISM_tmax_stable_4kmD1_{date}_bil.zip".format(date=day.strftime("%Y%m%d"))

        unzip(tmax_zipped_files_path + tmax_zip_file, unzip_to_path)
        unzip(tmin_zipped_files_path + tmin_zip_file, unzip_to_path)

        tmin_bilfile = unzip_to_path + tmin_zip_file.replace('.zip', '.bil')
        tmax_bilfile = unzip_to_path + tmax_zip_file.replace('.zip', '.bil')

        tmin_tiffile = unzip_to_path + tmin_zip_file.replace('.zip', '.tif')
        tmax_tiffile = unzip_to_path + tmax_zip_file.replace('.zip', '.tif')

        #convert from bil to tif
        subprocess.call(["gdal_translate", "-of", "GTiff", tmin_bilfile, tmin_tiffile])
        subprocess.call(["gdal_translate", "-of", "GTiff", tmax_bilfile, tmax_tiffile])

        #compute avg tif
        avg_tiffile = unzip_to_path + "tavg_{date}.tif".format(date=day.strftime("%Y%m%d"))
        subprocess.call("gdal_calc.py -A " + tmin_tiffile + " -B " + tmax_tiffile + " --outfile=" + avg_tiffile + " --NoDataValue=-9999 --calc='((A*1.8+32)+(B*1.8+32))/2'", shell=True)


        #remove extraneous files
        with contextlib.suppress(FileNotFoundError):
            os.remove(tmin_bilfile.replace('.bil', '.bil.aux.xml'))
            os.remove(tmin_bilfile.replace('.bil', '.hdr'))
            os.remove(tmin_bilfile.replace('.bil', '.info.txt'))
            os.remove(tmin_bilfile.replace('.bil', '.stn.csv'))
            os.remove(tmin_bilfile.replace('.bil', '.stx'))
            os.remove(tmin_bilfile.replace('.bil', '.prj'))
            os.remove(tmin_bilfile.replace('.bil', '.xml'))
            os.remove(tmin_bilfile)
            os.remove(tmin_tiffile)

            os.remove(tmax_bilfile.replace('.bil', '.bil.aux.xml'))
            os.remove(tmax_bilfile.replace('.bil', '.hdr'))
            os.remove(tmax_bilfile.replace('.bil', '.info.txt'))
            os.remove(tmax_bilfile.replace('.bil', '.stn.csv'))
            os.remove(tmax_bilfile.replace('.bil', '.stx'))
            os.remove(tmax_bilfile.replace('.bil', '.prj'))
            os.remove(tmax_bilfile.replace('.bil', '.xml'))
            os.remove(tmax_tiffile)
            os.remove(tmax_bilfile)

        # save tavg raster to postgis
        save_raster_to_postgis(avg_tiffile, tavg_table_name, 4269)
        set_date_column(tavg_table_name, day, new_table)
        new_table = False

        day = day + timedelta(days=1)


def compute_ncep_tavg(start_date, stop_date):
    tmax_files_path = "/geo-data/climate_data/daily_data/tmax/"
    tmin_files_path = "/geo-data/climate_data/daily_data/tmin/"
    tavg_files_path = "/geo-data/climate_data/daily_data/tavg/"

    os.makedirs(tavg_files_path, exist_ok=True)

    tavg_table_name = "ncep_tavg"
    new_table = not table_exists(tavg_table_name)

    day = datetime.strptime(start_date, "%Y-%m-%d")
    stop = datetime.strptime(stop_date, "%Y-%m-%d")

    while day <= stop:
        tmin_file = "tmin_{date}.tif".format(date=day.strftime("%Y%m%d"))
        tmax_file = "tmax_{date}.tif".format(date=day.strftime("%Y%m%d"))

        tmin_tiffile = tmin_files_path + tmin_file
        tmax_tiffile = tmax_files_path + tmax_file

        #remove avg file if already present
        avg_tiffile = tavg_files_path + "tavg_{date}.tif".format(date=day.strftime("%Y%m%d"))
        with contextlib.suppress(FileNotFoundError):
            os.remove(avg_tiffile)
        #compute avg tif
        subprocess.call("gdal_calc.py -A " + tmin_tiffile + " -B " + tmax_tiffile + " --outfile=" + avg_tiffile + " --NoDataValue=-9999 --calc='((A*1.8+32)+(B*1.8+32))/2'", shell=True)

        #import into postgis
        save_raster_to_postgis(avg_tiffile, tavg_table_name, 4269)
        set_date_column(tavg_table_name, day, new_table)
        new_table = False

        day = day + timedelta(days=1)


def main():
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script compute_tavg.py*****************')
    logging.info('*****************************************************************************')

    # generate prism tavg
    # start_date = "2017-01-01"
    # stop_date = "2017-12-31"
    # compute_tavg_from_prism_zips(start_date, stop_date)

    #generate ncep tavg
    #start_date = "2018-10-15"
    start_date = datetime.today() - timedelta(days=7)
    stop_date = datetime.today() + timedelta(days=6)
    compute_ncep_tavg(start_date.strftime('%Y-%m-%d'), stop_date.strftime('%Y-%m-%d'))

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
