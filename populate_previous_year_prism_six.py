import spring_index.postgis_driver as driver
from datetime import *
import time
import logging
import yaml
import os.path
import smtplib
from email.mime.text import MIMEText
from spring_index.spring_index_util import import_prism_on_prism_six_anomaly
import psycopg2


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]
email = cfg["email"]

db = cfg["postgis"]
conn = psycopg2.connect(dbname=db["db"], port=db["port"], user=db["user"], password=db["password"], host=db["host"])


def email_log_results(log_to_email, from_address, to_address, subject):
    with open(log_to_email) as fp:
        msg = MIMEText(fp.read())

    msg['Subject'] = 'The contents of %s' % subject
    msg['From'] = from_address
    msg['To'] = to_address

    s = smtplib.SMTP('localhost')
    s.send_message(msg)
    s.quit()


def populate_yearly_prism_six(year):

    start_date = date(year, 1, 1)
    end_date = start_date + timedelta(days=250)

    climate_data_provider = 'prism'
    time_rez = 'year'

    plants = ['lilac', 'arnoldred', 'zabelli']
    phenophases = ['leaf', 'bloom']

    # compute individual plants
    driver.Six.load_daily_climate_data(start_date, end_date, climate_data_provider, 'conus', conn)
    for plant in plants:
        for phenophase in phenophases:
            driver.Six.compute_daily_index(plant, phenophase)
            day = start_date
            driver.Six.create_raster(plant, phenophase, climate_data_provider, 'conus', day, time_rez)
            driver.Six.postgis_import(plant, phenophase, climate_data_provider, 'conus', day, time_rez)
            logging.info('calculated spring index for plant: %s phenophase: %s on day: %s', plant, phenophase, day)
    # compute averages
    driver.Six.leaf_average_array /= len(plants)
    driver.Six.bloom_average_array /= len(plants)
    for phenophase in phenophases:
        day = start_date
        driver.Six.create_raster("average", phenophase, climate_data_provider, 'conus', day, time_rez)
        driver.Six.postgis_import("average", phenophase, climate_data_provider, 'conus', day, time_rez)
        logging.info('calculated average spring index for phenophase: %s on day: %s', phenophase, day)
    driver.Six.cleanup()


def populate_yearly_prism_six_anomaly(year):
    phenophases = ['leaf', 'bloom']
    for phenophase in phenophases:
        import_prism_on_prism_six_anomaly(year, phenophase)


# This script is used to populate the spring index for historic years. It is not ran nightly.
# Before running this script populate_prism.py must be ran for the years you want to generate spring index maps.
# Unless the prism climate data has been populated somewhere else.
def main():

    logging.basicConfig(filename=log_path + 'populate_previous_year_prism_six.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script populate_previous_year_prism_six.py*****************')
    logging.info('*****************************************************************************')
    logging.info("Please verify that last year's prism temperatures are stable through day 240.")

    today = date.today()
    current_year = today.year
    previous_year = current_year - 1

    logging.info('populating previous year si-x')
    populate_yearly_prism_six(previous_year)
    
    logging.info('populating previous year si-x anomalies')
    populate_yearly_prism_six_anomaly(previous_year)

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********populate_previous_year_prism_six.py finished in %s seconds***********', t1-t0)
    logging.info('*****************************************************************************')

    email_log_results(log_path + 'populate_previous_year_prism_six.log',
                      email["from_address"], email["to_address"],
                      "populate_previous_year_prism_six.log")

if __name__ == "__main__":
    main()
