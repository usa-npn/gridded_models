import os.path
from urllib.request import urlretrieve
import urllib
from datetime import timedelta
from util.database import *
from datetime import date
import time

with open(os.path.abspath(os.path.join(os.path.dirname(__file__), os.path.pardir, 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
save_path = cfg["rtma_path"]


# walks through rtma historical database and reports any missing hourly data
def check_rtma_availability(start_date, end_date):

    log = open('missing_rtma.log', 'w')
    base_url_temp = 'http://nomads.ncdc.noaa.gov/data/ndgd/'

    delta = end_date - start_date
    for i in range(delta.days + 1):
        day = start_date + timedelta(days=i)
        print(day.strftime("%Y%m%d"))
        log.write(day.strftime("%Y%m%d") + "\n")
        for hour in range(0, 24):
            time.sleep(.5)
            file_name = 'LTIA98_KWBR_' + day.strftime("%Y%m%d") + "{0:0=2d}".format(hour) + "00"
            url = base_url_temp + day.strftime("%Y%m") + '/' + day.strftime("%Y%m%d") + '/' \
                  + file_name
            try:
                urllib.request.urlopen(url)
            except urllib.error.URLError as e:
                print(str(e) + ' error retrieving : ' + url)
                log.write(str(e) + ' error retrieving : ' + url + "\n")
    log.close()


if __name__ == "__main__":
    start = date(2015, 1, 1)
    end = date(2015, 12, 6)
    check_rtma_availability(start, end)
