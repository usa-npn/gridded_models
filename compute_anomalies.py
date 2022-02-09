import numpy as np
from osgeo import gdal
import time
from util.raster import *
from util.database import *
from datetime import date
from datetime import timedelta
import logging

with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]
email = cfg["email"]


def compute_agdd_historic_anomalies():
    bases = [32, 50]
    for base in bases:
        years = range(2016,2022)
        for year in years:
            anom_date = date(year, 1, 1)
            for doy in range(1,366):
                agdd_file = f"/geo-data/gridded_models/agdd_anomaly/agdd_anomaly_{anom_date:%Y%m%d}_base_thirtytwo_f.tif"
                agdd_avg_file = f"/geo-data/gridded_models/avg_agdd/agdd_{doy}_base_thirtytwo_f.tif"

                if base == 50:
                    agdd_file = f"/geo-data/gridded_models/agdd_anomaly_50f/agdd_anomaly_{anom_date:%Y%m%d}_base_fifty_f.tif"
                    agdd_avg_file = f"/geo-data/gridded_models/avg_agdd_50f/agdd_{doy}_base_fifty_f.tif"

                agdd_ds = gdal.Open(agdd_file)
                av_agdd_ds = gdal.Open(agdd_avg_file)
        
                rast_cols = agdd_ds.RasterXSize
                rast_rows = agdd_ds.RasterYSize
                transform = agdd_ds.GetGeoTransform()
                projection = agdd_ds.GetProjection()

                agdd_band = agdd_ds.GetRasterBand(1)
                agdd = agdd_band.ReadAsArray()
                av_agdd_band = av_agdd_ds.GetRasterBand(1)
                av_agdd = av_agdd_band.ReadAsArray()
                
                av_agdd = av_agdd.astype(np.float32, copy=False)
                av_agdd[av_agdd == -9999] = np.nan
                agdd = agdd.astype(np.float32, copy=False)
                agdd[agdd == -9999] = np.nan

                diff_agdd = agdd - av_agdd
                diff_agdd[np.isnan(diff_agdd)] = -9999

                diff_agdd = diff_agdd.astype(np.int16, copy=False)

                agdd_anomaly_path = f"/geo-data/gridded_models/agdd_anomaly/"
                agdd_anomaly_file_name = f"agdd_anomaly_{anom_date:%Y%m%d}_base_thirtytwo_f.tif"
                if base == 50:
                    agdd_anomaly_path = f"/geo-data/gridded_models/agdd_anomaly_50f/"
                    agdd_anomaly_file_name = f"agdd_anomaly_{anom_date:%Y%m%d}_base_fifty_f.tif"
                agdd_anomaly_file = agdd_anomaly_path + agdd_anomaly_file_name

                write_raster(agdd_anomaly_file, diff_agdd, -9999, rast_cols, rast_rows, projection, transform)

                agdd_anomaly_table_name = f"agdd_anomaly_{year}"
                new_table = False
                save_raster_to_postgis(agdd_anomaly_file, agdd_anomaly_table_name, 4269)
                set_date_column(agdd_anomaly_table_name, anom_date, new_table)
                set_scale_column(agdd_anomaly_table_name, 'fahrenheit', new_table)
                set_base_column(agdd_anomaly_table_name, base, new_table)
                anom_date = anom_date + timedelta(days=1)
                # import_six_postgis(six_anomaly_file, six_anomaly_file_name, six_anomaly_table_name, time_series_table_name, plant, phenophase,
                #                     day)


def compute_six_historic_anomalies(climate_data):
    phenophases = ['leaf', 'bloom']
    years = range(2016,2022)
    if climate_data == 'prism':
        years = range(1981,2022)
    for year in years:
        for phenophase in phenophases:
            six_file = f"/geo-data/gridded_models/spring_index/six_average_{phenophase}_ncep_historic/average_{phenophase}_ncep_{year}.tif"
            six_avg_file = f"/geo-data/gridded_models/avg_spring_index/six_30yr_average_{phenophase}/six_average_{phenophase}_365.tif"
            if climate_data == 'prism':
                six_file = f"/geo-data/gridded_models/spring_index/six_average_{phenophase}_prism/average_{phenophase}_prism_{year}.tif"
                six_avg_file = f"/geo-data/gridded_models/avg_spring_index/six_30yr_average_4k_{phenophase}/six_average_unwarped_{phenophase}_365.tif"

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
            if climate_data == 'prism':
                six_anomaly_path = f"/geo-data/gridded_models/spring_index_anomaly/six_{phenophase}_anomaly_prism/"
            six_anomaly_file_name = f"six_{phenophase}_anomaly_{year}.tif"
            six_anomaly_file = six_anomaly_path + six_anomaly_file_name

            write_raster(six_anomaly_file, diff_six, -9999, rast_cols, rast_rows, projection, transform)

            six_anomaly_table_name = 'six_anomaly_historic'
            if climate_data == 'prism':
                six_anomaly_table_name = 'six_anomaly_historic_prism'
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

    compute_six_historic_anomalies('ncep')
    compute_six_historic_anomalies('prism')
    #only have agdd anom for ncep against prism normal
    compute_agdd_historic_anomalies()

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
