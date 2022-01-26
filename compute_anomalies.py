import numpy as np
from osgeo import gdal
import time
from util.raster import *
from util.database import *
from datetime import date
import logging

with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]
email = cfg["email"]


def compute_six_ncep_anomalies():
    phenophases = ['leaf', 'bloom']
    years = range(2016,2022)
    for year in years:
        for phenophase in phenophases:
            six_file = f"/geo-data/gridded_models/spring_index/six_average_{phenophase}_ncep_historic/average_{phenophase}_ncep_{year}.tif"
            six_avg_file = f"/geo-data/gridded_models/avg_spring_index/six_30yr_average_{phenophase}/six_average_{phenophase}_365.tif"

            six_ds = gdal.Open(six_file)
            av_six_ds = gdal.Open(six_avg_file)
    
            rast_cols = six_ds.RasterXSize
            rast_rows = six_ds.RasterYSize
            transform = six_ds.GetGeoTransform()
            projection = six_ds.GetProjection()

            six_band = six_ds.GetRasterBand(1)
            six = six_band.ReadAsArray()
            av_six_band = av_six_ds.GetRasterBand(1)
            av_six = av_six_band.ReadAsArray()
            
            av_six = av_six.astype(np.float32, copy=False)
            av_six[av_six == -9999] = np.nan
            six = six.astype(np.float32, copy=False)
            six[six == -9999] = np.nan

            diff_six = six - av_six
            diff_six[np.isnan(diff_six)] = -9999

            diff_six = diff_six.astype(np.int16, copy=False)

            six_anomaly_path = f"/geo-data/gridded_models/spring_index_anomaly/six_{phenophase}_anomaly_historic/"
            six_anomaly_file_name = f"six_{phenophase}_anomaly_{year}.tif"
            six_anomaly_file = six_anomaly_path + six_anomaly_file_name

            write_raster(six_anomaly_file, diff_six, -9999, rast_cols, rast_rows, projection, transform)

            six_anomaly_table_name = 'six_anomaly_historic'
            plant = 'average'
            new_table = False
            day = date(year, 1, 1)
            save_raster_to_postgis(six_anomaly_file, six_anomaly_table_name, 4269)
            set_date_column(six_anomaly_table_name, day, new_table)
            set_plant_column(six_anomaly_table_name, plant, new_table)
            set_phenophase_column(six_anomaly_table_name, phenophase, new_table)
            # import_six_postgis(six_anomaly_file, six_anomaly_file_name, six_anomaly_table_name, time_series_table_name, plant, phenophase,
            #                     day)


def main():
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script compute_anomalies.py*****************')
    logging.info('*****************************************************************************')

    compute_six_ncep_anomalies()

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********compute_anomalies.py finished in %s seconds***********', t1 - t0)
    logging.info('*****************************************************************************')


if __name__ == "__main__":
    logging.basicConfig(filename=log_path + 'compute_anomalies.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    error_log = get_error_log()

    try:
        main()
    except (SystemExit, KeyboardInterrupt):
        raise
    except:
        error_log.error('compute_anomalies.py failed to finish: ', exc_info=True)
