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

hourly_temp_alaska_path = cfg["hourly_temp_alaska_path"]


def reimport_hourly_data(dataset, region):
    logging.info("reimporting {region} {dataset} hourly temps".format(region=region, dataset=dataset))

    thirty_days_ago = datetime.now() - timedelta(days=30)

    if region == 'alaska':
        path_to_search = hourly_temp_alaska_path + dataset + '*'
    else:
        path_to_search = hourly_temp_path + dataset + '*'

    print(path_to_search)
    for file_path in glob.iglob(path_to_search):
        file_name = os.path.basename(file_path)

        year = file_name[5:9]
        month = file_name[9:11]
        day = file_name[11:13]
        hour = int(file_name[13:15])

        if month == '01' and year == '2021' and (day == '01' or day == '02' or day == '03' or day == '04'):

            if region == 'alaska':
                table_name = 'hourly_temp_alaska_' + year
            else:
                table_name = 'hourly_temp_' + year

            hourly_data_date = datetime.strptime(year + month + day, '%Y%m%d')

            logging.info("reimporting {file_path} to {table_name}"
                            .format(file_path=file_path, table_name=table_name))
            rtma_import(file_path, table_name, True, hourly_data_date, hour, dataset)
            

def main():
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script reimport_missing_alaska.py*****************')
    logging.info('*****************************************************************************')

    reimport_hourly_data("urma", "alaska")

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********reimport_missing_alaska.py finished in %s seconds***********', t1 - t0)
    logging.info('*****************************************************************************')

if __name__ == "__main__":
    logging.basicConfig(filename=log_path+'reimport_missing_alaska.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    error_log = get_error_log()

    try:
        main()
    except (SystemExit, KeyboardInterrupt):
        raise
    except:
        error_log.error('reimport_missing_alaska.py failed to finish: ', exc_info=True)

