#!/usr/bin/python3
from datetime import date
import logging
import time
import yaml
import os.path
from util.log_manager import get_error_log
import shutil
import spring_index.postgis_driver as driver
import smtplib
from email.mime.text import MIMEText
from spring_index.spring_index_util import import_six_postgis


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]
six_path = cfg["six_path"]
six_anomaly_path = cfg["six_anomaly_path"]
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


def copy_geoserver_property_files(historic_file_dir):
    property_files = ['datastore.properties',
                      'indexer.properties',
                      'timeregex.properties']

    # we get yearly property files from a prism mosaic layer since it's a yearly mosaic we've already built
    prism_dir = six_path + 'six_average_leaf_prism' + os.sep
    if not os.path.exists(historic_file_dir):
        logging.info('creating historic ncep directory: ' + historic_file_dir)
        os.makedirs(historic_file_dir)
        for property_file in property_files:
            logging.info('copying: ' + prism_dir + property_file + ' to: ' + historic_file_dir + property_file)
            shutil.copy(prism_dir + property_file, historic_file_dir + property_file)


# this script migrates ncep si-x layers for day 250 (september 7th) to a historic yearly layer
# redmine enhancement #216
def main():
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script migrate_contempory_six_to_historic.py*****************')
    logging.info('*****************************************************************************')

    logging.info("\nReminder!!! - This year's NCEP SI-X layers are being copied to the historic layers.\n")

    plants = ['lilac', 'arnoldred', 'zabelli', 'average']
    phenophases = ['leaf', 'bloom']

    # todo can make year not hard coded only when we know if this script will run at end of year or beginning of year
    # today = date.today()
    year = 2016
    beginning_of_the_year = date(year, 1, 1)

    # migrate 8 six layers
    for plant in plants:
        for phenophase in phenophases:
            contempory_file_dir = six_path + 'six_' + plant + '_' + phenophase + '_ncep' + os.sep
            historic_file_dir = six_path + 'six_' + plant + '_' + phenophase + '_ncep' + '_historic' + os.sep

            contempory_file_name = plant + '_' + phenophase + '_ncep' + '_' + str(year) + '0907.tif'
            historic_file_name = plant + '_' + phenophase + '_ncep' + '_' + str(year) + '.tif'

            contempory_file_path = contempory_file_dir + contempory_file_name
            historic_file_path = historic_file_dir + historic_file_name

            copy_geoserver_property_files(historic_file_dir)

            if os.path.isfile(contempory_file_path) and not os.path.isfile(historic_file_path):
                logging.info('copying: ' + contempory_file_path + ' to: ' + historic_file_path)
                shutil.copy(contempory_file_path, historic_file_path)
                logging.info('importing to postgis: ' + historic_file_path)
                driver.Six.postgis_import(plant, phenophase, 'ncep', beginning_of_the_year, "year")

    # migrate 2 six anomaly layers
    for phenophase in phenophases:

        time_series_table_name = 'six_' + phenophase + '_anomaly_historic'
        six_anomaly_table_name = 'six_anomaly_historic'

        contempory_file_dir = six_anomaly_path + 'six_' + phenophase + '_anomaly' + os.sep
        historic_file_dir = six_anomaly_path + 'six_' + phenophase + '_anomaly' + '_historic' + os.sep

        contempory_file_name = 'six_' + phenophase + '_anomaly' + '_' + str(year) + '0907.tif'
        historic_file_name = 'six_' + phenophase + '_anomaly' + '_' + str(year) + '.tif'

        contempory_file_path = contempory_file_dir + contempory_file_name
        historic_file_path = historic_file_dir + historic_file_name

        copy_geoserver_property_files(historic_file_dir)

        if os.path.isfile(contempory_file_path) and not os.path.isfile(historic_file_path):
            logging.info('copying: ' + contempory_file_path + ' to: ' + historic_file_path)
            shutil.copy(contempory_file_path, historic_file_path)
            logging.info('importing to postgis: ' + historic_file_path)
            import_six_postgis(historic_file_path, historic_file_name, six_anomaly_table_name, time_series_table_name,
                               "average", phenophase, beginning_of_the_year)

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********migrate_contempory_six_to_historic.py finished in %s seconds***********', t1 - t0)
    logging.info('*****************************************************************************')

    email_log_results(log_path+'migrate_contempory_six_to_historic.log',
                      email["from_address"], email["to_address"],
                      "migrate_contempory_six_to_historic.log")

if __name__ == "__main__":
    logging.basicConfig(filename=log_path+'migrate_contempory_six_to_historic.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    error_log = get_error_log()

    try:
        main()
    except (SystemExit, KeyboardInterrupt):
        raise
    except:
        error_log.error('migrate_contempory_six_to_historic.py failed to finish: ', exc_info=True)
