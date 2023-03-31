from datetime import date
import requests
from util.database import update_time_series
from util.database import table_exists
import subprocess
import os.path

today = date.today()
current_year = today.year
today_as_string = today.strftime("%Y-%m-%d")

eab_adult_url = f'https://uspest.org/CAPS/EAB2_cohorts/Misc_output/Earliest_PEMp0Excl1_{current_year}1231.tif'
eab_egg_url = f'https://uspest.org/CAPS/EAB2_cohorts/Misc_output/Earliest_PEMe1Excl1_{current_year}1231.tif'

def set_srs(tif_file):
    temp_file = str.replace(tif_file, ".tif", "_warpme.tif")
    os.rename(tif_file, temp_file)

    warp_command = "gdalwarp -t_srs EPSG:4269 {source_file} {dest_file}"\
        .format(source_file=temp_file, dest_file=tif_file)

    ps = subprocess.Popen(warp_command, stdout=subprocess.PIPE, shell=True)
    ps.wait()
    os.remove(temp_file)

filename = f'/geo-data/gridded_models/eab/eab_adult/eab_adult_{date.today().strftime("%Y%m%d")}.tif'
with open(filename, 'wb') as out_file:
   content = requests.get(eab_adult_url, stream=True).content
   out_file.write(content)
   time_series_table = 'eab_adult'
   tif_name = f'eab_adult_{date.today().strftime("%Y%m%d")}.tif'
   if table_exists(time_series_table):
      update_time_series(time_series_table, tif_name, today)
set_srs(filename)

filename = f'/geo-data/gridded_models/eab/eab_egg_hatch/eab_egg_hatch_{date.today().strftime("%Y%m%d")}.tif'
with open(filename, 'wb') as out_file:
   content = requests.get(eab_egg_url, stream=True).content
   out_file.write(content)
   time_series_table = 'eab_egg_hatch'
   tif_name = f'eab_egg_hatch_{date.today().strftime("%Y%m%d")}.tif'
   if table_exists(time_series_table):
      update_time_series(time_series_table, tif_name, today)
set_srs(filename)