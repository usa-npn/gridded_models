from datetime import date
import requests

today = date.today()
current_year = today.year

eab_adult_url = f'https://uspest.org/CAPS/EAB_cohorts/Earliest_PEMp0Excl1_{current_year}1231.tif'
eab_egg_url = f'https://uspest.org/CAPS/EAB_cohorts/Earliest_PEMe1Excl1_{current_year}1231.tif'


with open(f'/geo-data/gridded_models/eab/eab_adult/eab_adult_{date.today().strftime("%Y-%m-%d")}.tif', 'wb') as out_file:
   content = requests.get(eab_adult_url, stream=True).content
   out_file.write(content)

with open(f'/geo-data/gridded_models/eab/eab_egg/eab_egg_{date.today().strftime("%Y-%m-%d")}.tif', 'wb') as out_file:
   content = requests.get(eab_egg_url, stream=True).content
   out_file.write(content)