import yaml
import psycopg2
from psycopg2.extensions import AsIs
from osgeo import gdal
import os.path
from osgeo import osr
from osgeo import ogr


with open("config.yml", 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
db = cfg["postgis"]
conn = psycopg2.connect(dbname=db["db"], port=db["port"], user=db["user"],
                    password=db["password"], host=db["host"])
save_path = cfg["postgis_raster_path"]


def get_six_raster(year, plant, phenophase):
    curs = conn.cursor()
    vsipath = '/vsimem/from_postgis'
    table_name = "spring_index"

    query = "SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff') FROM %s WHERE year = %s AND plant = %s AND phenophase = %s;"
    data = (AsIs(table_name), year, plant, phenophase)
    curs.execute(query, data)

    gdal.FileFromMemBuffer(vsipath, bytes(curs.fetchone()[0]))

    ds = gdal.Open(vsipath)
    band = ds.GetRasterBand(1)
    rast_array = band.ReadAsArray()

    geo_transform = ds.GetGeoTransform()
    projection = ds.GetProjection()
    no_data_value = band.GetNoDataValue()

    gdal.Unlink(vsipath)

    cols = rast_array.shape[1]
    rows = rast_array.shape[0]

    os.makedirs(os.path.dirname(save_path), exist_ok=True)
    file_name = save_path + plant + '_' + phenophase + '_' + str(year) + '.tif'
    driver = gdal.GetDriverByName('Gtiff')
    outRaster = driver.Create(file_name, cols, rows, 1, gdal.GDT_Int16)
    outRaster.SetGeoTransform(geo_transform)
    outband = outRaster.GetRasterBand(1)
    outband.SetNoDataValue(no_data_value)
    outband.WriteArray(rast_array)
    outRaster.SetProjection(projection)
    outband.FlushCache()


def get_ndfd_raster(year, month, day, climate_var, resolution):
    curs = conn.cursor()
    vsipath = '/vsimem/from_postgis'
    table_name = climate_var + '_forecast_' + resolution

    # query = "SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff') FROM %s;"
    query = "SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff') FROM %s WHERE forecast_date = %s;"
    data = (AsIs(table_name), year + '-' + month + '-' + day)
    curs.execute(query, data)

    gdal.FileFromMemBuffer(vsipath, bytes(curs.fetchone()[0]))

    ds = gdal.Open(vsipath)
    band = ds.GetRasterBand(1)
    rast_array = band.ReadAsArray()

    geo_transform = ds.GetGeoTransform()
    projection = ds.GetProjection()
    no_data_value = band.GetNoDataValue()

    gdal.Unlink(vsipath)

    cols = rast_array.shape[1]
    rows = rast_array.shape[0]

    os.makedirs(os.path.dirname(save_path), exist_ok=True)
    file_name = save_path + 'ndfd_' + climate_var + '_' + year + '_' + month + '_' + day + '_' + resolution + '.tif'
    driver = gdal.GetDriverByName('Gtiff')
    outRaster = driver.Create(file_name, cols, rows, 1, gdal.GDT_Float64)
    outRaster.SetGeoTransform(geo_transform)
    outband = outRaster.GetRasterBand(1)
    outband.SetNoDataValue(no_data_value)
    outband.WriteArray(rast_array)
    outRaster.SetProjection(projection)
    outband.FlushCache()


def get_daily_temp_raster(climate_provider, climate_var, year, month, day):
    curs = conn.cursor()
    vsipath = '/vsimem/from_postgis'
    table_name = climate_provider + '_' + climate_var + '_' + year

    # query = "SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff') FROM %s;"
    query = "SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff') FROM %s WHERE rast_date = %s;"
    data = (AsIs(table_name), year + '-' + month + '-' + day)
    curs.execute(query, data)

    gdal.FileFromMemBuffer(vsipath, bytes(curs.fetchone()[0]))

    ds = gdal.Open(vsipath)
    band = ds.GetRasterBand(1)
    rast_array = band.ReadAsArray()

    geo_transform = ds.GetGeoTransform()
    projection = ds.GetProjection()
    no_data_value = band.GetNoDataValue()

    gdal.Unlink(vsipath)

    cols = rast_array.shape[1]
    rows = rast_array.shape[0]

    os.makedirs(os.path.dirname(save_path), exist_ok=True)
    file_name = save_path + climate_provider + climate_var + '_' + year + month + day + '.tif'
    driver = gdal.GetDriverByName('Gtiff')
    outRaster = driver.Create(file_name, cols, rows, 1, gdal.GDT_Float32)
    outRaster.SetGeoTransform(geo_transform)
    outband = outRaster.GetRasterBand(1)
    outband.SetNoDataValue(no_data_value)
    outband.WriteArray(rast_array)
    outRaster.SetProjection(projection)
    outband.FlushCache()


def get_rtma_hourly_temp_raster(year, month, day, hour):
    curs = conn.cursor()
    vsipath = '/vsimem/from_postgis'
    table_name = 'rtma_' + year

    # query = "SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff') FROM %s;"
    query = "SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff') FROM %s WHERE rast_date = %s AND rast_hour = %s;"
    data = (AsIs(table_name), year + '-' + month + '-' + day, hour)
    curs.execute(query, data)

    gdal.FileFromMemBuffer(vsipath, bytes(curs.fetchone()[0]))

    ds = gdal.Open(vsipath)
    band = ds.GetRasterBand(1)
    rast_array = band.ReadAsArray()

    geo_transform = ds.GetGeoTransform()
    projection = ds.GetProjection()
    no_data_value = band.GetNoDataValue()

    gdal.Unlink(vsipath)

    cols = rast_array.shape[1]
    rows = rast_array.shape[0]

    os.makedirs(os.path.dirname(save_path), exist_ok=True)
    file_name = save_path + 'rtma_' + '_' + year + '_' + month + '_' + day + '_' + hour + '.tif'
    driver = gdal.GetDriverByName('Gtiff')
    outRaster = driver.Create(file_name, cols, rows, 1, gdal.GDT_Float32)
    outRaster.SetGeoTransform(geo_transform)
    outband = outRaster.GetRasterBand(1)
    outband.SetNoDataValue(no_data_value)
    outband.WriteArray(rast_array)
    outRaster.SetProjection(projection)
    outband.FlushCache()


def get_point_as_long_lat(coord_x, coord_y, srs):
  # Spatial Reference System
  output_epsg = 4326

  # create a geometry from coordinates
  point = ogr.Geometry(ogr.wkbPoint)
  point.AddPoint(coord_x, coord_y)

  # create coordinate transformation
  in_spatial_ref = srs
  # in_spatial_ref.ImportFromEPSG(input_epsg)

  out_spatial_ref = osr.SpatialReference()
  out_spatial_ref.ImportFromEPSG(output_epsg)

  coord_transform = osr.CoordinateTransformation(in_spatial_ref, out_spatial_ref)

  # transform point
  point.Transform(coord_transform)

  # return point in EPSG 4326
  return point.GetX(), point.GetY()


def get_raster_by_filename(table_name, file_name):
    curs = conn.cursor()
    vsipath = '/vsimem/from_postgis'

    query = "SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff') FROM %s WHERE filename = %s;"
    data = (AsIs(table_name), file_name)
    curs.execute(query, data)

    gdal.FileFromMemBuffer(vsipath, bytes(curs.fetchone()[0]))

    ds = gdal.Open(vsipath)
    band = ds.GetRasterBand(1)
    rast_array = band.ReadAsArray()

    geo_transform = ds.GetGeoTransform()
    projection = ds.GetProjection()
    no_data_value = band.GetNoDataValue()

    # srs = osr.SpatialReference()
    # prjText = projection
    # srs.ImportFromWkt(prjText)  # this will now raise RuntimeError for corrupt data
    # proj4 = srs.ExportToProj4()  # another RuntimeError will be raised on failure
    # epsg = srs.GetAuthorityCode(None)
    #
    # long_lat = get_point_as_long_lat(geo_transform[0], geo_transform[3], srs)

    gdal.Unlink(vsipath)

    cols = rast_array.shape[1]
    rows = rast_array.shape[0]

    os.makedirs(os.path.dirname(save_path), exist_ok=True)
    file_name = save_path + table_name + '_' + file_name + '.tif'
    driver = gdal.GetDriverByName('Gtiff')
    outRaster = driver.Create(file_name, cols, rows, 1, gdal.GDT_Float64)
    outRaster.SetGeoTransform(geo_transform)
    outband = outRaster.GetRasterBand(1)
    outband.SetNoDataValue(no_data_value)
    outband.WriteArray(rast_array)
    outRaster.SetProjection(projection)
    outband.FlushCache()


if __name__ == "__main__":
    print('this module should be called from get_raster_from_postgis.py')
