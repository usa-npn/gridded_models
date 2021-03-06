#!/usr/bin/python3
from datetime import date
from prism.importer import unzip
from util.database import save_raster_to_postgis
from util.database import set_date_column
from util.database import table_exists
from util.database import update_time_series
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
from prism.importer import get_prism_data_outdb


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]

def populate_precip():
    start = date(2019, 1, 1)
    end = date.today() - timedelta(days=1)
    get_prism_data_outdb(start, end, ['ppt'])

def clip_to_arizona(raster_file):
    buffelgrass_files_path = "/geo-data/gridded_models/buffelgrass/buffelgrass_prism/"

    arizona_shp_path = Path("/usr/local/scripts/gridded_models/assets/shape_files/arizona/states.shp")

    temp_file = buffelgrass_files_path + 'temp.tif'
    shutil.copy(raster_file, temp_file)
    os.remove(raster_file)

    warp_command = "gdalwarp -cutline {mask_file} -crop_to_cutline -srcnodata 9999 -dstnodata -9999 -t_srs EPSG:4269 {source_file} {dest_file}" \
        .format(mask_file=arizona_shp_path, source_file=temp_file, dest_file=raster_file)
    ps = subprocess.Popen(warp_command, stdout=subprocess.PIPE, shell=True)
    ps.wait()
    os.remove(temp_file)

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

    time_series_table = "buffelgrass_prism"
    buffelgrass_table_name = "prism_buffelgrass"
    new_table = not table_exists(buffelgrass_table_name)

    day = datetime.strptime(start_date, "%Y-%m-%d")
    stop = datetime.strptime(stop_date, "%Y-%m-%d")

    while day <= stop:
        daylag = day - timedelta(days=1)
        # copy start date precip file over to buffelgrass dir
        tif_name = "buffelgrass_{date}.tif".format(date=day.strftime("%Y%m%d"))
        precip_accum_file = buffelgrass_files_path + tif_name
        print('copying' + get_prism_precip_file_name(daylag) + ' to ' + precip_accum_file)
        shutil.copy(get_prism_precip_file_name(daylag), precip_accum_file)
        clip_to_arizona(precip_accum_file)


        window_stop = day
        window_day = day - timedelta(days=24)
        while window_day < window_stop:
            window_daylag = window_day - timedelta(days=1)
            window_day_precip_file = get_prism_precip_file_name(window_daylag)
            temp_precip_file = buffelgrass_files_path + 'temp_precip.tif'
            # window_day_precip_file can be None if we don't have precip data prior to the start date
            if window_day_precip_file is not None:
                shutil.copy(window_day_precip_file, temp_precip_file)
                clip_to_arizona(temp_precip_file)
                subprocess.call("gdal_calc.py -A " + precip_accum_file + " -B " + temp_precip_file + " --outfile=" + precip_accum_file + " --NoDataValue=-9999 --calc='A*(A>0)+B*(B>0)' --overwrite", shell=True)
                clip_to_arizona(precip_accum_file)
            window_day = window_day + timedelta(days=1)
        # convert mm to inches
        subprocess.call("gdal_calc.py -A " + precip_accum_file + " --outfile=" + precip_accum_file + " --NoDataValue=-9999 --calc='A*.0393700787' --overwrite", shell=True)
        #import into postgis
        save_raster_to_postgis(precip_accum_file, buffelgrass_table_name, 4269)
        set_date_column(buffelgrass_table_name, day, new_table)

        if table_exists(time_series_table):
                update_time_series(time_series_table, tif_name, day)

        new_table = False
        day = day + timedelta(days=1)


def main():
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script compute_buffelgrass.py*****************')
    logging.info('*****************************************************************************')

    populate_precip()

    start_date = "2020-01-01"
    # stop_date = "2019-12-27"
    stop_date = date.today().strftime("%Y-%m-%d")
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
