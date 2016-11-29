#!/usr/bin/python3
import time
import os.path
import os
from netCDF4 import Dataset
from qc.six_checker import *
from qc.gdd_checker import *
from spring_index.spring_index import spring_index
from util.database import *
from util.raster import write_best_raster


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]


def convert_to_f(temps):
    temps *= 1.8
    temps += 32
    return temps


def compute_best_six_layers():
    """Computes and saves yearly historic si-x leaf and bloom average maps based on berkeley earth data"""
    best_temperatures_path = cfg["best_temperatures_path"]
    save_path = cfg["six_path"]
    best_six_table = 'best_spring_index'
    new_table = not table_exists(best_six_table)
    # best temperature data is partitioned into a tmin and tmax file per decade
    decades = [1880, 1890, 1900, 1910, 1920, 1930, 1940, 1950, 1960, 1970, 1980, 1990, 2000, 2010]
    for decade in decades:
        tmin_root_group = Dataset(best_temperatures_path + "Complete_TMIN_Daily_LatLong1_{decade}.nc"
                                  .format(decade=decade), "r", format="NETCDF4")
        tmax_root_group = Dataset(best_temperatures_path + "Complete_TMAX_Daily_LatLong1_{decade}.nc"
                                  .format(decade=decade), "r", format="NETCDF4")

        lats = tmin_root_group.variables['latitude'][90:]
        lats = np.flipud(lats)
        lons = tmin_root_group.variables['longitude'][:180]
        years = tmin_root_group.variables['year'][:]
        # months = tmin_root_group.variables['month'][:]
        # days = tmin_root_group.variables['day'][:]
        # doys = tmin_root_group.variables['day_of_year'][:]

        tmin_climatology = tmin_root_group.variables['climatology']
        tmin_anomaly = tmin_root_group.variables['temperature']
        tmax_climatology = tmax_root_group.variables['climatology']
        tmax_anomaly = tmax_root_group.variables['temperature']

        prev_seen_year = None
        year_start_index, index = 0, 0
        for year in years:
            logging.info('Computing best spring index for year {year}'.format(year=int(year)))
            year_as_date = date(int(year), 1, 1)
            if prev_seen_year is None or int(prev_seen_year) != int(year):
                year_start_index = index
                prev_seen_year = int(year)
                index += 1
            else:
                index += 1
                continue

            # get the min and max temps for each day of year
            min_temps = np.empty((240, len(lats), len(lons)))
            max_temps = np.empty((240, len(lats), len(lons)))
            for doy in range(240):
                # 90: and :180 are to specify the quarter earth we're interested in
                daily_tmin_climatology = tmin_climatology[doy, 90:, :180]
                daily_tmax_climatology = tmax_climatology[doy, 90:, :180]
                daily_tmin_anomaly = tmin_anomaly[year_start_index + doy, 90:, :180]
                daily_tmax_anomaly = tmax_anomaly[year_start_index + doy, 90:, :180]

                daily_min_temps = np.add(daily_tmin_climatology, daily_tmin_anomaly)
                daily_min_temps = convert_to_f(daily_min_temps)
                daily_min_temps = np.flipud(daily_min_temps)
                min_temps[doy] = daily_min_temps

                daily_max_temps = np.add(daily_tmax_climatology, daily_tmax_anomaly)
                daily_max_temps = convert_to_f(daily_max_temps)
                daily_max_temps = np.flipud(daily_max_temps)
                max_temps[doy] = daily_max_temps

            # reshape the array to be station lat, station long, day of year, temperature
            min_temps = np.swapaxes(min_temps, 1, 0)
            min_temps = np.swapaxes(min_temps, 2, 1)
            max_temps = np.swapaxes(max_temps, 1, 0)
            max_temps = np.swapaxes(max_temps, 2, 1)

            # sum up leaf and bloom six results over each species
            base_temp = 31
            leaf_out_days, bloom_days = np.zeros((len(lats), len(lons))), np.zeros((len(lats), len(lons)))
            plants = ['lilac', 'arnoldred', 'zabelli']
            phenophases = ['leaf', 'bloom']
            for plant in plants:
                temp_leaf = None
                for phenophase in phenophases:
                    if phenophase == 'leaf':
                        temp_leaf = spring_index(max_temps, min_temps, base_temp, None, phenophase, plant, lats)
                        temp_leaf[temp_leaf == -9999] = np.nan
                        leaf_out_days += temp_leaf
                    else:
                        temp_bloom = spring_index(max_temps, min_temps, base_temp, temp_leaf, phenophase, plant, lats)
                        temp_bloom[temp_bloom == -9999] = np.nan
                        bloom_days += temp_bloom

            # calculate six average for each phenophase and save the results
            for phenophase in phenophases:
                file_name = "best_{phenophase}_{year}.tif".format(phenophase=phenophase, year=int(year))
                folder_name = "six_" + 'average' + "_" + phenophase + "_" + 'best'
                file_path = save_path + folder_name + os.sep + file_name

                if phenophase == 'leaf':
                    six_avg = leaf_out_days / 3
                else:
                    six_avg = bloom_days / 3
                six_avg[six_avg == np.nan] = -9999

                write_best_raster(file_path, six_avg,
                                  lons.min(), lons.max(), len(lons), lats.min(), lats.max(), len(lats))
                save_raster_to_postgis(file_path, best_six_table, 4269, False)
                set_plant_column(best_six_table, 'average', new_table)
                set_phenophase_column(best_six_table, phenophase, new_table)
                set_date_column(best_six_table, year_as_date, new_table)
                new_table = False
                time_series_table = 'six_average_{phenophase}_best'.format(phenophase=phenophase)
                if table_exists(time_series_table):
                    update_time_series(time_series_table, file_name, year_as_date)


def main():
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script populate_six_best.py*****************')
    logging.info('*****************************************************************************')

    compute_best_six_layers()

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********populate_six_best.py finished in %s seconds***********', t1 - t0)
    logging.info('*****************************************************************************')


if __name__ == "__main__":
    logging.basicConfig(filename=log_path+'populate_six_best.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    error_log = get_error_log()

    try:
        main()
    except (SystemExit, KeyboardInterrupt):
        raise
    except:
        error_log.error('populate_six_best.py failed to finish: ', exc_info=True)
