from datetime import date
import requests
from util.database import update_time_series
from util.database import table_exists
import subprocess
import os.path

today = date.today()
current_year = today.year
today_as_string = today.strftime("%Y-%m-%d")

slf_adult_url = f'https://uspest.org/CAPS/SLF_cohorts/Misc_output/Earliest_PEMp0Excl1_{current_year}1231.tif'
slf_egg_url = f'https://uspest.org/CAPS/SLF_cohorts/Misc_output/Earliest_PEMe0Excl1_{current_year}1231.tif'

def set_srs(tif_file):
    temp_file = str.replace(tif_file, ".tif", "_warpme.tif")
    os.rename(tif_file, temp_file)

    warp_command = "gdalwarp -t_srs EPSG:4269 {source_file} {dest_file}"\
        .format(source_file=temp_file, dest_file=tif_file)

    ps = subprocess.Popen(warp_command, stdout=subprocess.PIPE, shell=True)
    ps.wait()
    os.remove(temp_file)

filename = f'/geo-data/gridded_models/slf/slf_adult/slf_adult_{date.today().strftime("%Y%m%d")}.tif'
with open(filename, 'wb') as out_file:
   content = requests.get(slf_adult_url, stream=True).content
   out_file.write(content)
   time_series_table = 'slf_adult'
   tif_name = f'slf_adult_{date.today().strftime("%Y%m%d")}.tif'
   if table_exists(time_series_table):
      update_time_series(time_series_table, tif_name, today)
set_srs(filename)

filename = f'/geo-data/gridded_models/slf/slf_egg_hatch/slf_egg_hatch_{date.today().strftime("%Y%m%d")}.tif'
with open(filename, 'wb') as out_file:
   content = requests.get(slf_egg_url, stream=True).content
   out_file.write(content)
   time_series_table = 'slf_egg_hatch'
   tif_name = f'slf_egg_hatch_{date.today().strftime("%Y%m%d")}.tif'
   if table_exists(time_series_table):
      update_time_series(time_series_table, tif_name, today)
set_srs(filename)