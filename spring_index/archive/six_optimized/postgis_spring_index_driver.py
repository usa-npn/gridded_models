#!/usr/bin/python3

import os.path
import subprocess
import time
from datetime import date
from datetime import timedelta as td
import numpy as np
import osr
import psycopg2
from osgeo import gdal
from psycopg2.extensions import AsIs
from six_optimized.spring_index import spring_index



t0 = time.time()

year = 2014

# save_path = "D:\\temp\\"
# database_server = "localhost"
# database_name = "prism"
# database_user = "postgres"
# database_password = "npn"
# database_port = 5432

save_path = "/home/jswitzer/prism_data/spring_index/"
database_server = "150.135.175.19"
database_name = "prism"
database_user = "postgres"
database_password = "usanpn123"
database_port = 5432

conn = psycopg2.connect(dbname=database_name, port=database_port, user=database_user,
                        password=database_password, host=database_server)
curs = conn.cursor()

os.makedirs(os.path.dirname(save_path), exist_ok=True)


def postgis_import(filename, year, plant, phenophase):
    table_name = 'spring_index'
    # check if we need to create a new table
    new_table = True
    query = "SELECT COUNT(*) FROM information_schema.tables WHERE table_name = %s;"
    curs.execute(query, [table_name])
    if curs.fetchone()[0] == 1:
        new_table = False

    # insert the raster (either create a new table or append to previously created table)
    if new_table:
        import_command = "raster2pgsql -s 4269 -c -I -C -M -t auto {file} public.{table}"\
            .format(file=filename, table=table_name)
    else:
        # overwrite raster if already exists
        query = "DELETE FROM %s WHERE year = %s AND plant = %s AND phenophase = %s;"
        data = (AsIs(table_name), year, plant, phenophase)
        curs.execute(query, data)
        conn.commit()
        import_command = 'raster2pgsql -s 4269 -a -M -t auto ' + filename + ' public.' + table_name
    import_command2 = "psql -h {host} -p {port} -d {database} --username={user}"\
        .format(host=database_server, port=database_port, database=database_name, user=database_user)
    ps = subprocess.Popen(import_command, stdout=subprocess.PIPE, shell=True)
    subprocess.check_output(import_command2, stdin=ps.stdout, shell=True)
    ps.wait()

    # possibly set up extra table structure
    if new_table:
        query = "ALTER TABLE %s ADD year smallint, ADD plant text, ADD phenophase text;"
        curs.execute(query, [AsIs(table_name)])
        conn.commit()
    query = "UPDATE %s SET year = %s, plant = %s, phenopahse = %s WHERE year IS NULL;"
    data = (AsIs(table_name), year, plant, phenophase)
    curs.execute(query, data)
    conn.commit()

    # create entry in mosaic table (for geoserver to work)
    if new_table:
        query = """
          CREATE TABLE IF NOT EXISTS mosaic(
          name text,
          tiletable text,
          minx float,
          miny float,
          maxx float,
          maxy float,
          resx float,
          resy float);"""
        curs.execute(query)
        conn.commit()

        query = "DELETE FROM mosaic WHERE tiletable = %s"
        curs.execute(query, [table_name])
        conn.commit()

        query = """
          INSERT INTO mosaic (name, tiletable, minx, miny, maxx, maxy, resx, resy)
          VALUES (%s, %s, %s, %s, %s, %s, %s, %s);"""
        data = (table_name, table_name, -125, 49.9166666666687, -66.9, 24.2, 0.04166666666667, 0.04166666666667)
        curs.execute(query, data)
        conn.commit()


# Load raster from postgis into a virtual memory file
vsipath = '/vsimem/from_postgis'

min_temps = np.empty((240, 621, 1405))
start_date = date(year, 1, 1)
for day in range(0, 240):
    date = start_date + td(days=day)

    query = "SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff') FROM tmin_2013 WHERE rast_date = %s;"
    curs.execute(query, [date.strftime("%Y-%m-%d")])

    gdal.FileFromMemBuffer(vsipath, bytes(curs.fetchone()[0]))

    # Read first band of raster with GDAL
    ds = gdal.Open(vsipath)
    band = ds.GetRasterBand(1)
    min_temps[day] = band.ReadAsArray()

# reshape the array to be station lat, station long, day of year, temperature
min_temps = np.swapaxes(min_temps, 1, 0)
min_temps = np.swapaxes(min_temps, 2, 1)

max_temps = np.empty((240, 621, 1405))
for day in range(0, 240):
    date = start_date + td(days=day)
    query = "SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff') FROM tmax_2013 WHERE rast_date = %s;"
    curs.execute(query, [date.strftime("%Y-%m-%d")])

    gdal.FileFromMemBuffer(vsipath, bytes(curs.fetchone()[0]))

    # Read first band of raster with GDAL
    ds = gdal.Open(vsipath)
    band = ds.GetRasterBand(1)
    max_temps[day] = band.ReadAsArray()

# Get geometry information from raster
geo_transform = (upper_left_x, x_size, x_rotation, upper_left_y, y_rotation, y_size) = ds.GetGeoTransform()

# Get projection information from raster
projection = ds.GetProjection()
prj = ds.GetProjectionRef()
srs = osr.SpatialReference(prj.title())
srid = srs.GetAuthorityCode('GEOGCS')

# Get additional information about the raster
no_data_value = band.GetNoDataValue()
band_minimum = band.GetMinimum()
band_maximum = band.GetMaximum()
scale = band.GetScale()
band_unit_type = band.GetUnitType()

# Close and clean up virtual memory file
ds = band = None
gdal.Unlink(vsipath)

# reshape the array to be station lat, station long, day of year, temperature
max_temps = np.swapaxes(max_temps, 1, 0)
max_temps = np.swapaxes(max_temps, 2, 1)

# convert to fahrenheit
max_temps[max_temps != -9999.0] *= 1.8
max_temps[max_temps != -9999.0] += 32
min_temps[min_temps != -9999.0] *= 1.8
min_temps[min_temps != -9999.0] += 32

# manipulate array(s) here via spring index code
result_array = np.empty((621, 1405))
rasterOrigin = (upper_left_x, upper_left_y)
pixelWidth = x_size
pixelHeight = y_size

cols = result_array.shape[1]
rows = result_array.shape[0]
originX = rasterOrigin[0]
originY = rasterOrigin[1]

xdim = 0.04166666666667
ydim = 0.04166666666667
base_temp = 31
start_date = 0
plants = ['lilac', 'arnold_red', 'zabelli']
phenophases = ['leaf', 'bloom']
phenophase = 'leaf'
plant = 'lilac'
daystop = 180

result_array = spring_index(max_temps, min_temps, base_temp, start_date, phenophase, plant, upper_left_y, ydim, daystop)

t1 = time.time()
print('finished computing spring index:')
print(t1-t0)

# Create a new raster using the manipulated arrays data
file_name = save_path + plant + '_' + phenophase + '_' + str(year) + '.tiff'
driver = gdal.GetDriverByName('Gtiff')
outRaster = driver.Create(file_name, cols, rows, 1, gdal.GDT_Int16)
outRaster.SetGeoTransform(geo_transform)
outband = outRaster.GetRasterBand(1)
outband.SetNoDataValue(no_data_value)
outband.WriteArray(result_array)
outRaster.SetProjection(projection)
outband.FlushCache()

# write raster out to postgis spring_index table
postgis_import(file_name, year, plant, phenophase)
