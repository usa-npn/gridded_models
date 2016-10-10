#!/usr/bin/python3
from datetime import date
from datetime import datetime
import logging
import time
from datetime import timedelta
from geoserver.catalog import Catalog
from qc.gdd_checker import get_prism_climate_data
from qc.gdd_checker import get_urma_climate_data
from six.spring_index import spring_index_for_point
import numpy as np
from osgeo import gdal
import yaml
import os.path
from util.log_manager import get_error_log
from qc.gdd_checker import populate_six_qc


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]


def pixel2coord(col, row):
    ds = gdal.Open('D:/gridded/climate-tmax.tif')

    # unravel GDAL affine transform parameters
    c, a, b, f, d, e = ds.GetGeoTransform()
    ydim = ds.GetGeoTransform()[1]
    """Returns global coordinates to pixel center using base-0 raster index"""
    xp = a * col + b * row + a * 0.5 + b * 0.5 + c
    yp = d * col + e * row + d * 0.5 + e * 0.5 + f
    return (xp, yp)

def main():
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('***********beginning script migrate_contempory_six_to_historic.py*****************')
    logging.info('*****************************************************************************')




    # test = pixel2coord(2606, 1228)


    # longitude = -109.59961
    # latitude = 33.93677
    # start_date = date(2016, 1, 1)
    # num_days = 240
    #
    # tmin = np.empty(num_days)
    # tmax = np.empty(num_days)
    #
    # for i in range(num_days):
    #     day = start_date + timedelta(days=i)
    #     tmin[i] = get_urma_climate_data(longitude, latitude, day, 'tmin')
    #     if np.isnan(tmin[i]):
    #         tmin[i] = tmin[i-1]
    #     else:
    #         tmin[i] = 1.8 * tmin[i] + 32
    #     tmax[i] = get_urma_climate_data(longitude, latitude, day, 'tmax')
    #     if np.isnan(tmax[i]):
    #         tmax[i] = tmax[i-1]
    #     else:
    #         tmax[i] = 1.8 * tmax[i] + 32
    # latitude = latitude - 2
    # for j in range(40):
    #     latitude = latitude + .1
    #     day = spring_index_for_point(tmax, tmin, 31, 0, 'leaf', 'lilac', latitude)
    #     print(day)



    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('***********migrate_contempory_six_to_historic.py finished in %s seconds***********', t1 - t0)
    logging.info('*****************************************************************************')

# # This is the main gridded models script. It runs nightly to both pull climate data and generate various rasters which
# # are also imported into a postgis database
# def main():
#     t0 = time.time()
#
#     logging.info(' ')
#     logging.info('*****************************************************************************')
#     logging.info('***********beginning script migrate_contempory_six_to_historic.py*****************')
#     logging.info('*****************************************************************************')
#
#     today = date.today()
#     current_year = today.year
#     one_week_ago = today - timedelta(days=7)
#     three_days_ago = today - timedelta(days=3)
#     one_week_into_future = today + timedelta(days=7)
#     beginning_of_this_year = date(current_year, 1, 1)
#     end_of_this_year = date(current_year, 12, 31)
#     end_of_previous_year = date(current_year - 1, 12, 31)
#     end_of_next_year = date(current_year + 1, 12, 31)
#     day_250_of_current_year = beginning_of_this_year + timedelta(days=250)
#     day_240_of_current_year = beginning_of_this_year + timedelta(days=240)
#     import_qc_data = True
#
#     # connect to geoserver instance
#     cat = Catalog("http://localhost:8080/geoserver/rest/",
#                   username="admin", password="geoserver")
#
#     # get or create workspace
#     workspace_name = 'jeffs_workspace'
#     # try:
#     #     ws = cat.create_workspace(workspace_name)
#     # except AssertionError:
#     #     ws = cat.get_workspace(workspace_name)
#
#     # create imagemosaic
#     store_name = 'jeffs_store2'
#     st = cat.create_imagemosaic(store_name, 'D:\gridded\six_average_leaf_ncep.zip', workspace=workspace_name)
#
#     # create style (doesn't yet work)
#     all_styles = cat.get_styles()
#     # with open("D:\gridded\leafout_bimonthly.sld") as f:
#     #     cat.create_style("leafout_bimonthly", f.read(), workspace=workspace_name)
#
#     # set default style of a layer
#     layer = cat.get_layer("jeffs_store2")
#     layer.default_style = cat.get_style("leafout_bimonthly")
#     cat.save(layer)
#
#     print("done")
#
#     # topp = cat.get_workspace("topp")
#     # shapefile_plus_sidecars = shapefile_and_friends("states")
#     # # shapefile_and_friends should look on the filesystem to find a shapefile
#     # # and related files based on the base path passed in
#     # #
#     # # shapefile_plus_sidecars == {
#     # #    'shp': 'states.shp',
#     # #    'shx': 'states.shx',
#     # #    'prj': 'states.prj',
#     # #    'dbf': 'states.dbf'
#     # # }
#     #
#     # # 'data' is required (there may be a 'schema' alternative later, for creating empty featuretypes)
#     # # 'workspace' is optional (GeoServer's default workspace is used by... default)
#     # # 'name' is required
#     # ft = cat.create_featurestore(name, workspace=topp, data=shapefile_plus_sidecars)
#
#
#     t1 = time.time()
#     logging.info('*****************************************************************************')
#     logging.info('***********migrate_contempory_six_to_historic.py finished in %s seconds***********', t1 - t0)
#     logging.info('*****************************************************************************')


if __name__ == "__main__":
    logging.basicConfig(filename=log_path+'gridded_testing.log',
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
