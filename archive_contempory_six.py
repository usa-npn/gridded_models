#!/usr/bin/python3
from datetime import date
import logging
import time
import yaml
import os.path
from util.log_manager import get_error_log
import shutil
import smtplib
from email.mime.text import MIMEText
from datetime import timedelta
from util.database import remove_from_time_series
from util.database import remove_from_daily_six
from util.database import remove_from_daily_six_anomaly


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]
six_path = cfg["six_path"]
six_anomaly_path = cfg["six_anomaly_path"]
archive_six_path = cfg["archive_six_path"]
archive_six_anomaly_path = cfg["archive_six_anomaly_path"]
email = cfg["email"]


def email_log_results(log_to_email, from_address, to_address, subject):
    with open(log_to_email) as fp:
        msg = MIMEText(fp.read())

    msg['Subject'] = 'The contents of %s' % subject
    msg['From'] = from_address
    msg['To'] = to_address

    s = smtplib.SMTP('localhost')
    s.send_message(msg)
    s.quit()


def archive_daily_six_data_for_year(year, plant, phenophase):
    logging.info("-----------------archiving six {plant} {phenophase} daily data for year {year}-----------------"
                 .format(plant=plant, phenophase=phenophase, year=year))
    contempory_file_dir = six_path + 'six_' + plant + '_' + phenophase + '_ncep' + os.sep
    archive_file_dir = archive_six_path + 'six_' + plant + '_' + phenophase + '_ncep' + os.sep

    if not os.path.exists(archive_file_dir):
        os.makedirs(archive_file_dir)

    start_date = date(year, 1, 1)
    end_date = date(year, 12, 31)

    delta = end_date - start_date
    for i in range(delta.days + 1):
        day = start_date + timedelta(days=i)

        contempory_file_name = plant + '_' + phenophase + '_ncep' + '_' + day.strftime("%Y%m%d") + '.tif'
        contempory_file_path = contempory_file_dir + contempory_file_name
        archive_file_path = archive_file_dir + contempory_file_name

        if os.path.exists(contempory_file_path):
            # mv file to storage drive
            shutil.copy(contempory_file_path, archive_file_path)

            # delete from timeseries
            time_series_table = 'six' + '_' + plant + '_' + phenophase + '_ncep'
            remove_from_time_series(time_series_table, contempory_file_name)

            # delete from postgis database
            table_name = 'ncep_spring_index'
            remove_from_daily_six(table_name, day.strftime("%Y%m%d"), plant, phenophase)

            # delete file from disk
            os.remove(contempory_file_path)


def archive_daily_six_anomaly_data_for_year(year, phenophase):
    logging.info("-----------------archiving six anomaly {phenophase} daily data for year {year}-----------------"
                 .format(phenophase=phenophase, year=year))
    contempory_file_dir = six_anomaly_path + 'six_' + phenophase + '_anomaly' + os.sep
    archive_file_dir = archive_six_anomaly_path + 'six_' + phenophase + '_anomaly' + os.sep

    if not os.path.exists(archive_file_dir):
        os.makedirs(archive_file_dir)

    start_date = date(year, 1, 1)
    end_date = date(year, 12, 31)

    delta = end_date - start_date
    for i in range(delta.days + 1):
        day = start_date + timedelta(days=i)

        contempory_file_name = 'six_' + phenophase + '_anomaly' + '_' + day.strftime("%Y%m%d") + '.tif'
        contempory_file_path = contempory_file_dir + contempory_file_name
        archive_file_path = archive_file_dir + contempory_file_name

        if os.path.exists(contempory_file_path):
            # mv file to storage drive
            shutil.copy(contempory_file_path, archive_file_path)

            # delete from timeseries
            time_series_table = 'six_' + phenophase + '_anomaly'
            remove_from_time_series(time_series_table, contempory_file_name)

            # delete from postgis database
            table_name = 'six_anomaly'
            remove_from_daily_six_anomaly(table_name, day.strftime("%Y%m%d"), phenophase)

            # delete file from disk
            os.remove(contempory_file_path)



# this copies ncep si-x layers for specified year to the archive drive and deletes them from the main drive / geoserver
# redmine enhancement #620
def main():
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script archive_contempory_six.py*****************')
    logging.info('*****************************************************************************')

    logging.info("\nReminder!!! - This year's NCEP SI-X layers are being deleted from the database and moved to the archive drive.\n")

    if not os.path.exists(archive_six_path):
        os.makedirs(archive_six_path)

    plants = ['lilac', 'arnoldred', 'zabelli', 'average']
    phenophases = ['leaf', 'bloom']

    year = 2017

    for plant in plants:
        for phenophase in phenophases:
            archive_daily_six_data_for_year(year, plant, phenophase)

    for phenophase in phenophases:
        archive_daily_six_anomaly_data_for_year(year, phenophase)

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********archive_contempory_six.py finished in %s seconds***********', t1 - t0)
    logging.info('*****************************************************************************')

    email_log_results(log_path+'archive_contempory_six.log',
                      email["from_address"], email["to_address"],
                      "archive_contempory_six_to_historic.log")

if __name__ == "__main__":
    logging.basicConfig(filename=log_path+'archive_contempory_six.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    error_log = get_error_log()

    try:
        main()
    except (SystemExit, KeyboardInterrupt):
        raise
    except:
        error_log.error('archive_contempory_six.py failed to finish: ', exc_info=True)
