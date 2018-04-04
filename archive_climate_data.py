#!/usr/bin/python3
import logging
import time
import yaml
import os.path
from util.log_manager import get_error_log
import shutil
from datetime import datetime
from datetime import timedelta
import glob
from climate.importer import rtma_import
from util.database import remove_from_table_by_filename
import re


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]

hourly_temp_path = cfg["hourly_temp_path"]
hourly_temp_archive_path = cfg["hourly_temp_archive_path"]

hourly_temp_alaska_path = cfg["hourly_temp_alaska_path"]
hourly_temp_alaska_archive_path = cfg["hourly_temp_alaska_archive_path"]

prism_path = cfg["prism_path"]
prism_archive_path = cfg["prism_archive_path"]


def archive_and_delete_hourly_data(dataset, region):
    logging.info("archiving {region} {dataset} hourly temps".format(region=region, dataset=dataset))

    thirty_days_ago = datetime.now() - timedelta(days=30)

    if region == 'alaska':
        path_to_search = hourly_temp_alaska_path + dataset + '*'
    else:
        path_to_search = hourly_temp_path + dataset + '*'

    for file_path in glob.iglob(path_to_search):
        file_name = os.path.basename(file_path)

        if region == 'alaska':
            archive_file_path = hourly_temp_alaska_archive_path + file_name
        else:
            archive_file_path = hourly_temp_archive_path + file_name

        year = file_name[5:9]
        month = file_name[9:11]
        day = file_name[11:13]
        hour = int(file_name[13:15])

        if region == 'alaska':
            table_name = 'hourly_temp_alaska_' + year
        else:
            table_name = 'hourly_temp_' + year

        hourly_data_date = datetime.strptime(year + month + day, '%Y%m%d')

        if hourly_data_date < thirty_days_ago:
            if dataset == "urma":
                logging.info("moving {file_path} to {archive_file_path}"
                             .format(file_path=file_path, archive_file_path=archive_file_path))
                shutil.move(file_path, archive_file_path)
                logging.info("reimporting {archive_file_path} to {table_name}"
                             .format(archive_file_path=archive_file_path, table_name=table_name))
                rtma_import(archive_file_path, table_name, True, hourly_data_date, hour, dataset)
            elif dataset == "rtma":
                if ((region == 'alaska' and os.path.exists(hourly_temp_alaska_path + file_name.replace("rtma", "urma"))) or 
                    (region == 'conus' and os.path.exists(hourly_temp_path + file_name.replace("rtma", "urma")))):
                    logging.info("urma exists - deleting {file_name}".format(file_name=file_name))
                    os.remove(file_path)
                    logging.info("removing {file_path} from {table_name}"
                                 .format(file_path=file_path, table_name=table_name))
                    remove_from_table_by_filename(file_path, table_name)
                else:
                    logging.info("moving {file_path} to {archive_file_path}"
                                 .format(file_path=file_path, archive_file_path=archive_file_path))
                    shutil.move(file_path, archive_file_path)
                    logging.info("reimporting {archive_file_path} to {table_name}"
                                 .format(archive_file_path=archive_file_path, table_name=table_name))
                    rtma_import(archive_file_path, table_name, True, hourly_data_date, hour, dataset)
        # else:
        #     logging.info("skipping since {file_name} is not older than thirty days".format(file_name=file_name))


def archive_and_delete_prism_data(climate_type):
    logging.info("archiving PRISM {climate_type} temp zip files".format(climate_type=climate_type))
    path_to_search = prism_path + 'zipped' + os.sep + climate_type + os.sep + "PRISM_{climate_type}_stable_4kmD1_*"\
        .format(climate_type=climate_type)

    six_months_ago = datetime.now() - timedelta(days=6*31)

    archive_path = prism_archive_path + 'zipped' + os.sep + climate_type + os.sep
    if not os.path.exists(archive_path):
        os.makedirs(archive_path)

    for file_path in glob.iglob(path_to_search):
        file_name = os.path.basename(file_path)

        archive_file_path = archive_path + file_name

        # file name example: PRISM_tmax_stable_4kmD1_19930707_bil.zip
        date_string = re.search(r'\d\d\d\d\d\d\d\d', file_name).group()
        prism_file_date = datetime.strptime(date_string, '%Y%m%d')

        if prism_file_date < six_months_ago:
            logging.info("moving {file_path} to {archive_file_path}"
                         .format(file_path=file_path, archive_file_path=archive_file_path))
            shutil.move(file_path, archive_file_path)


# this archives old climate data: specifically ncep hourly temps, and prism daily data
# redmine enhancement #622
def main():
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script archive_climate_data.py*****************')
    logging.info('*****************************************************************************')

    if not os.path.exists(hourly_temp_archive_path):
        os.makedirs(hourly_temp_archive_path)
    if not os.path.exists(hourly_temp_alaska_archive_path):
        os.makedirs(hourly_temp_alaska_archive_path)

    # note order is important here, archive the rtma before archiving the urma
    # this is because when we archive rtma, we need to check if there is a corresponding urma file and we won't
    # find it if it was already archived

    # delete RTMA older than 1 month if matching URMA exists, otherwise archive
    # archive URMA older than 1 month
    archive_and_delete_hourly_data("rtma", "conus")
    archive_and_delete_hourly_data("urma", "conus")
    archive_and_delete_hourly_data("rtma", "alaska")
    archive_and_delete_hourly_data("urma", "alaska")

    # archive PRISM older than 6 Months
    archive_and_delete_prism_data("tmin")
    archive_and_delete_prism_data("tmax")

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********archive_climate_data.py finished in %s seconds***********', t1 - t0)
    logging.info('*****************************************************************************')

if __name__ == "__main__":
    logging.basicConfig(filename=log_path+'archive_climate_data.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    error_log = get_error_log()

    try:
        main()
    except (SystemExit, KeyboardInterrupt):
        raise
    except:
        error_log.error('archive_climate_data.py failed to finish: ', exc_info=True)
