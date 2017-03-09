#!/usr/bin/python3
import psycopg2
from psycopg2.extensions import AsIs
from osgeo import gdal
import numpy as np
from datetime import date
from datetime import timedelta as td
import subprocess
from spring_index.spring_index import spring_index
from spring_index.spring_index import spring_index_hourly
import os.path
import yaml
import osr
from util.raster import *
import time
import shutil


class Six:
    #TODO was 31 in matlab code - change to 0 and keep things in celcius (or at least change it to 32 which is freezing)
    base_temp = 31

    with open(os.path.abspath(os.path.join(os.path.dirname(__file__), os.path.pardir, 'config.yml')), 'r') as ymlfile:
        cfg = yaml.load(ymlfile)
    db = cfg["postgis"]
    conn = psycopg2.connect(dbname=db["db"], port=db["port"], user=db["user"],
                        password=db["password"], host=db["host"])
    save_path = cfg["six_path"]

    projection = None
    geo_transform = None
    no_data_value = None
    xdim = None
    ydim = None
    min_temps = None
    max_temps = None
    gdh = None
    leaf_array = None
    bloom_array = None
    leaf_average_array = None
    bloom_average_array = None


    @staticmethod
    def load_hourly_climate_data(end_date, climate_data_provider):
        year = end_date.year
        start_date = date(year, 1, 1)
        num_days = (end_date - start_date).days + 1
        if num_days > 240:
            num_days = 240

        # Load raster from postgis into a virtual memory file
        vsipath = '/vsimem/from_postgis'
        table_name = climate_data_provider + '_' + str(year)
        for day in range(0, num_days):
            t00 = time.time()
            print('day: ' + str(day))
            current_date = start_date + td(days=day)

            #get daily tmax
            tmax_table_name = climate_data_provider + '_tmax_' + str(year)
            curs = Six.conn.cursor()
            query = "SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff') FROM %s WHERE rast_date = %s;"
            data = (AsIs(tmax_table_name), current_date.strftime("%Y-%m-%d"))
            curs.execute(query, data)
            gdal.FileFromMemBuffer(vsipath, bytes(curs.fetchone()[0]))
            ds = gdal.Open(vsipath)
            tmax_band = ds.GetRasterBand(1)
            tmax = tmax_band.ReadAsArray()
            # convert -9999 values to not a number so we don't have to worry about manipulating them
            tmax[tmax == -9999.0] = np.nan
            # convert to fahrenheit
            tmax *= 1.8
            tmax += 32
            if day == 0:
                Six.max_temps = np.zeros((num_days, ds.RasterYSize, ds.RasterXSize))
            Six.max_temps[day] = tmax
            curs.close()

            for hour in range (0, 24):
                curs = Six.conn.cursor()
                print('hour: ' + str(hour))
                query = "SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff') FROM %s WHERE rast_date = %s AND rast_hour = %s;"
                data = (AsIs(table_name), current_date.strftime("%Y-%m-%d"), hour)
                curs.execute(query, data)

                gdal.FileFromMemBuffer(vsipath, bytes(curs.fetchone()[0]))
                curs.close()

                # Read first band of raster with GDAL
                ds = gdal.Open(vsipath)
                band = ds.GetRasterBand(1)
                if day == 0 and hour == 0:
                    Six.gdh = np.zeros((num_days, ds.RasterYSize, ds.RasterXSize))
                    # get the x and y dimensions of the input rasters, they will be used later to create the output rasters
                    Six.ydim = ds.GetGeoTransform()[5] # pixel height (note: can be negative)
                    Six.xdim = ds.GetGeoTransform()[1] # pixel width

                hour_temps = band.ReadAsArray()

                # convert -9999 values to not a number so we don't have to worry about manipulating them
                hour_temps[hour_temps == -9999.0] = np.nan

                # convert to fahrenheit
                hour_temps *= 1.8
                hour_temps += 32

                # compute growing degree hours from the hourly temps
                hour_temps -= Six.base_temp
                hour_temps[hour_temps < 0] = 0

                Six.gdh[day] += hour_temps

            t01 = time.time()
            print('time for day: ')
            print(t01-t00)

        # reshape the array to be station lat, station long, day of year, temperature
        Six.gdh = np.swapaxes(Six.gdh, 1, 0)
        Six.gdh = np.swapaxes(Six.gdh, 2, 1)
        Six.max_temps = np.swapaxes(Six.max_temps, 1, 0)
        Six.max_temps = np.swapaxes(Six.max_temps, 2, 1)

        # Get geometry information from raster
        Six.geo_transform = ds.GetGeoTransform()
        # Get projection information from raster
        Six.projection = ds.GetProjection()
        # Get additional information about the raster
        Six.no_data_value = band.GetNoDataValue()

        # Close and clean up virtual memory file
        gdal.Unlink(vsipath)


    @staticmethod
    def load_daily_climate_data(start_date, end_date, climate_data_provider, region):
        year = start_date.year
        num_days = (end_date - start_date).days + 1
        if num_days > 240:
            num_days = 240

        # Load raster from postgis into a virtual memory file
        vsipath = '/vsimem/from_postgis'
        if climate_data_provider == 'prism':
            table_name = "prism_tmin_" + str(year)
        elif region == 'alaska':
            table_name = "tmin_alaska_" + str(year)
        else:
            table_name = "tmin_" + str(year)
        for day in range(0, num_days):
            curs = Six.conn.cursor()
            current_date = start_date + td(days=day)
            # print('getting ' + table_name + ' ' + current_date.strftime("%Y-%m-%d"))
            query = "SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff') FROM %s WHERE rast_date = %s;"
            data = (AsIs(table_name), current_date.strftime("%Y-%m-%d"))
            curs.execute(query, data)

            gdal.FileFromMemBuffer(vsipath, bytes(curs.fetchone()[0]))
            curs.close()

            # Read first band of raster with GDAL
            ds = gdal.Open(vsipath)
            band = ds.GetRasterBand(1)
            if day == 0:
                Six.min_temps = np.empty((num_days, ds.RasterYSize, ds.RasterXSize))
                # get the x and y dimensions of the input rasters, they will be used later to create the output rasters
                Six.xdim = Six.ydim = -ds.GetGeoTransform()[5]
                # Six.xdim = Six.ydim = ds.GetGeoTransform()[1]
            Six.min_temps[day] = band.ReadAsArray()

        # reshape the array to be station lat, station long, day of year, temperature
        Six.min_temps = np.swapaxes(Six.min_temps, 1, 0)
        Six.min_temps = np.swapaxes(Six.min_temps, 2, 1)

        if climate_data_provider == 'prism':
            table_name = "prism_tmax_" + str(year)
        elif region == 'alaska':
            table_name = "tmax_alaska_" + str(year)
        else:
            table_name = "tmax_" + str(year)
        for day in range(0, num_days):
            curs = Six.conn.cursor()
            current_date = start_date + td(days=day)
            query = "SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff') FROM %s WHERE rast_date = %s;"
            data = (AsIs(table_name), current_date.strftime("%Y-%m-%d"))
            curs.execute(query, data)

            gdal.FileFromMemBuffer(vsipath, bytes(curs.fetchone()[0]))
            curs.close()

            # Read first band of raster with GDAL
            ds = gdal.Open(vsipath)
            band = ds.GetRasterBand(1)
            if day == 0:
                Six.max_temps = np.empty((num_days, ds.RasterYSize, ds.RasterXSize))
            Six.max_temps[day] = band.ReadAsArray()

        # Get geometry information from raster
        Six.geo_transform = ds.GetGeoTransform()

        # Get projection information from raster
        Six.projection = ds.GetProjection()
        # prj = ds.GetProjectionRef()
        # srs = osr.SpatialReference(prj.title())
        # srid = srs.GetAuthorityCode('GEOGCS')

        # Get additional information about the raster
        Six.no_data_value = band.GetNoDataValue()
        # band_minimum = band.GetMinimum()
        # band_maximum = band.GetMaximum()
        # scale = band.GetScale()
        # band_unit_type = band.GetUnitType()

        # Close and clean up virtual memory file
        gdal.Unlink(vsipath)

        # reshape the array to be station lat, station long, day of year, temperature
        Six.max_temps = np.swapaxes(Six.max_temps, 1, 0)
        Six.max_temps = np.swapaxes(Six.max_temps, 2, 1)

        # convert -9999 values to not a number so we don't have to worry about manipulating them
        Six.max_temps[Six.max_temps == -9999.0] = np.nan
        Six.min_temps[Six.min_temps == -9999.0] = np.nan

        # convert to fahrenheit
        Six.max_temps *= 1.8
        Six.max_temps += 32
        Six.min_temps *= 1.8
        Six.min_temps += 32


    @staticmethod
    def compute_daily_index(plant, phenophase):
        (upper_left_x, x_size, x_rotation, upper_left_y, y_rotation, y_size) = Six.geo_transform

        # calculate latitudes
        num_lats = Six.max_temps.shape[0]
        site_latitudes = np.arange(num_lats, dtype=float)
        site_latitudes *= -Six.ydim
        site_latitudes += upper_left_y

        if phenophase == 'leaf':
            Six.leaf_array = spring_index(Six.max_temps, Six.min_temps, Six.base_temp, Six.leaf_array, phenophase, plant, site_latitudes)
            leaf_copy = np.copy(Six.leaf_array)
            leaf_copy[leaf_copy < 0] = np.nan
            if Six.leaf_average_array == None:
                Six.leaf_average_array = leaf_copy
            else:
                Six.leaf_average_array = Six.leaf_average_array + leaf_copy
        elif phenophase == 'bloom':
            Six.bloom_array = spring_index(Six.max_temps, Six.min_temps, Six.base_temp, Six.leaf_array, phenophase, plant, site_latitudes)
            bloom_copy = np.copy(Six.bloom_array)
            bloom_copy[bloom_copy < 0] = np.nan
            if Six.bloom_average_array == None:
                Six.bloom_average_array = bloom_copy
            else:
                Six.bloom_average_array = Six.bloom_average_array + bloom_copy
        else:
            print('invalid phenophase: ' + phenophase)


    @staticmethod
    def compute_hourly_index(plant, phenophase):
        if phenophase == 'leaf':
            Six.leaf_array = spring_index_hourly(Six.max_temps, Six.gdh, Six.base_temp, Six.leaf_array, phenophase, plant)
            if Six.leaf_average_array == None:
                Six.leaf_average_array = np.copy(Six.leaf_array)
            else:
                Six.leaf_average_array = Six.leaf_average_array + Six.leaf_array
        elif phenophase == 'bloom':
            Six.bloom_array = spring_index_hourly(Six.max_temps, Six.gdh, Six.base_temp, Six.leaf_array, phenophase, plant)
            if Six.bloom_average_array == None:
                Six.bloom_average_array = np.copy(Six.bloom_array)
            else:
                Six.bloom_average_array = Six.bloom_average_array + Six.bloom_array
        else:
            print('invalid phenophase: ' + phenophase)


    @staticmethod
    def copy_spring_index_raster(plant, phenophase, climate_source, from_date, to_date):
        folder_name = "six_" + plant + "_" + phenophase + "_" + climate_source + os.sep

        source_file_name = plant + '_' + phenophase + '_' + climate_source + '_' + from_date.strftime("%Y%m%d") + '.tif'
        dest_file_name = plant + '_' + phenophase + '_' + climate_source + '_' + to_date.strftime("%Y%m%d") + '.tif'

        source_file_path = Six.save_path + folder_name + source_file_name
        dest_file_path = Six.save_path + folder_name + dest_file_name

        if os.path.isfile(source_file_path) and not os.path.isfile(dest_file_path):
            shutil.copyfile(source_file_path, dest_file_path)


    @staticmethod
    def create_raster(plant, phenophase, climate_source, region, date, time_rez):
        if time_rez == 'year':
            date_string = date.strftime("%Y")
        else:
            date_string = date.strftime("%Y%m%d")
        year_string = date.strftime("%Y")

        # set up path
        if climate_source == 'prism' and time_rez == 'day':
            folder_name = "six_" + plant + "_" + phenophase + "_" + climate_source + "_" + year_string + os.sep
        elif climate_source == 'ncep' and time_rez == 'year' and region == 'conus':
            folder_name = "six_" + plant + "_" + phenophase + "_" + climate_source + "_historic" + os.sep
        elif climate_source == 'ncep' and time_rez == 'year' and region == 'alaska':
            folder_name = "six_" + plant + "_" + phenophase + "_" + climate_source + "_alaska_historic" + os.sep
        elif climate_source == 'ncep' and time_rez == 'day' and region == 'alaska':
            folder_name = "six_" + plant + "_" + phenophase + "_" + climate_source + "_alaska" + os.sep
        else: # prism yearly goes here
            folder_name = "six_" + plant + "_" + phenophase + "_" + climate_source + os.sep
        file_name = plant + '_' + phenophase + '_' + climate_source + '_' + date_string + '.tif'
        os.makedirs(os.path.dirname(Six.save_path + folder_name), exist_ok=True)
        file_path = Six.save_path + folder_name + file_name

        # set out_array to plant/phenophase of interest
        if phenophase == 'leaf':
            if plant == 'average':
                out_array = np.copy(Six.leaf_average_array)
            else:
                out_array = np.copy(Six.leaf_array)
        elif phenophase == 'bloom':
            if plant == 'average':
                out_array = np.copy(Six.bloom_average_array)
            else:
                out_array = np.copy(Six.bloom_array)
        else:
            print('Invalid phenophase: ' + phenophase)
            return

        # remove days beyond day's doy from outarray
        if climate_source == 'prism' and time_rez == 'year':
            day_of_year = 240
        else:
            day_of_year = date.timetuple().tm_yday
        out_array[out_array > day_of_year] = -9999
        out_array[np.isnan(out_array)] = -9999
        # out_array[out_array == 0] = -9999

        # convert to 16 bit unsigned integers
        out_array = out_array.astype(np.int16, copy=False)

        Six.write_int16_raster(file_path, out_array, Six.no_data_value, out_array.shape[1], out_array.shape[0], Six.projection, Six.geo_transform)
        out_array = None


    @staticmethod
    def postgis_import(plant, phenophase, climate_source, region, date, time_rez):
        date_string = date.strftime("%Y%m%d")
        year_string = date.strftime("%Y")
        if time_rez == 'year':
            file_name = plant + '_' + phenophase + '_' + climate_source + '_' + year_string + '.tif'
        else:
            file_name = plant + '_' + phenophase + '_' + climate_source + '_' + date_string + '.tif'

        file_path = Six.save_path + 'six_' + plant + '_' + phenophase + '_' + climate_source + os.sep + file_name

        if climate_source == 'ncep' and time_rez == 'year' and region == 'conus':
            table_name = climate_source + '_spring_index_historic'
            file_path = Six.save_path + 'six_' + plant + '_' + phenophase + '_' + climate_source + "_historic" + os.sep + file_name
        elif climate_source == 'ncep' and time_rez == 'year' and region == 'alaska':
            table_name = climate_source + '_spring_index_alaska_historic'
            file_path = Six.save_path + 'six_' + plant + '_' + phenophase + '_' + climate_source + "_alaska_historic" + os.sep + file_name
        elif climate_source == 'ncep' and time_rez == 'day' and region == 'conus':
            table_name = climate_source + '_spring_index'
            file_path = Six.save_path + 'six_' + plant + '_' + phenophase + '_' + climate_source + os.sep + file_name
        elif climate_source == 'ncep' and time_rez == 'day' and region == 'alaska':
            table_name = climate_source + '_spring_index_alaska'
            file_path = Six.save_path + 'six_' + plant + '_' + phenophase + '_' + climate_source + "_alaska" + os.sep + file_name
        elif climate_source == 'prism' and time_rez == 'day':
            table_name = climate_source + '_spring_index_' + year_string
            file_path = Six.save_path + 'six_' + plant + '_' + phenophase + '_' + climate_source + "_" + year_string + os.sep + file_name
        elif time_rez == 'year': # prism yearly goes here
            table_name = climate_source + '_spring_index'
        else:
            table_name = climate_source + '_spring_index'

        conn = Six.conn
        curs = conn.cursor()

        # check if we need to create a new table
        new_table = True
        query = "SELECT COUNT(*) FROM information_schema.tables WHERE table_name = %s;"
        curs.execute(query, [table_name])
        if curs.fetchone()[0] == 1:
            new_table = False

        # insert the raster (either create a new table or append to previously created table)
        if new_table:
            import_command = "raster2pgsql -s 4269 -c -R -I -C -F -t auto {file} public.{table}"\
                .format(file=file_path, table=table_name)
        else:
            # overwrite raster if already exists
            query = "DELETE FROM %(table)s WHERE rast_date = to_date(%(rast_date)s, 'YYYYMMDD') AND plant = %(plant)s AND phenophase = %(phenophase)s;"
            data = {"table": AsIs(table_name), "rast_date": date_string, "plant": plant, "phenophase": phenophase}
            curs.execute(query, data)
            conn.commit()
            import_command = 'raster2pgsql -s 4269 -a -R -F -t auto ' + file_path + ' public.' + table_name

        import_command2 = "psql -h {host} -p {port} -d {database} --username={user}"\
            .format(host=Six.db["host"], port=Six.db["port"], database=Six.db["db"], user=Six.db["user"])
        ps = subprocess.Popen(import_command, stdout=subprocess.PIPE, shell=True)
        subprocess.check_output(import_command2, stdin=ps.stdout, shell=True)
        ps.wait()

        # get rid of generated enforce_max_extent_rast constraint because rounding error was preventing some rasters from being saved to db
        if new_table:
            query = "ALTER TABLE %(table)s DROP CONSTRAINT IF EXISTS enforce_max_extent_rast;"
            data = {"table": AsIs(table_name)}
            curs.execute(query, data)
            conn.commit()

        # add and populate rast_date, plant, and phenophase columns
        if new_table:
            query = "ALTER TABLE %s ADD rast_date DATE, ADD plant TEXT, ADD phenophase TEXT;"
            curs.execute(query, [AsIs(table_name)])
            conn.commit()
        query = "UPDATE %(table)s SET rast_date = to_date(%(rast_date)s, 'YYYYMMDD'), plant = %(plant)s, phenophase = %(phenophase)s WHERE rast_date IS NULL;"
        data = {"table": AsIs(table_name), "rast_date": date_string, "plant": plant, "phenophase": phenophase}
        curs.execute(query, data)
        conn.commit()

        # add indexes
        if new_table:
            query1 = "CREATE INDEX ON %(table)s (filename);"
            query2 = "CREATE INDEX ON %(table)s (rast_date);"
            data = {"table": AsIs(table_name)}
            curs.execute(query1, data)
            curs.execute(query2, data)
            conn.commit()

        # get rid of generated enforce_max_extent_rast constraint because rounding error was preventing some rasters from being saved to db
        if new_table:
            query = "ALTER TABLE %(table)s DROP CONSTRAINT IF EXISTS enforce_max_extent_rast;"
            data = {"table": AsIs(table_name)}
            curs.execute(query, data)
            conn.commit()

        # populate image mosaic time series table if it exists
        # check if time series table exists
        if climate_source == 'ncep' and time_rez == 'year' and region == 'conus':
            time_series_table = 'six' + '_' + plant + '_' + phenophase + '_' + climate_source + '_historic'
        elif climate_source == 'ncep' and time_rez == 'year' and region == 'alaska':
            time_series_table = 'six' + '_' + plant + '_' + phenophase + '_' + climate_source + '_alaska_historic'
        elif climate_source == 'ncep' and time_rez == 'day' and region == 'alaska':
            time_series_table = 'six' + '_' + plant + '_' + phenophase + '_' + climate_source + '_alaska'
        else:
            time_series_table = 'six' + '_' + plant + '_' + phenophase + '_' + climate_source
        time_series_exists = False
        query = "SELECT COUNT(*) FROM information_schema.tables WHERE table_name = %s;"
        curs.execute(query, [time_series_table])
        if curs.fetchone()[0] == 1:
            time_series_exists = True
        if time_series_exists:
            query = "DELETE FROM %(table)s WHERE location = %(filename)s;"
            data = {"table": AsIs(time_series_table), "filename": file_name}
            curs.execute(query, data)

            query = """INSERT INTO %(table)s (the_geom, location, ingestion) (
              SELECT the_geom, %(filename)s, to_timestamp(%(rast_date)s, 'YYYYMMDD')  FROM %(table)s LIMIT 1
              );"""
            data = {"table": AsIs(time_series_table), "filename": file_name, "rast_date": date_string}
            curs.execute(query, data)

            curs.close()


    @staticmethod
    def write_int16_raster(file_path, rast_array, no_data_value, rast_cols, rast_rows, projection, transform):
        driver = gdal.GetDriverByName('Gtiff')
        raster = driver.Create(file_path, rast_cols, rast_rows, 1, gdal.GDT_Int16)
        band = raster.GetRasterBand(1)
        band.SetNoDataValue(no_data_value)
        band.WriteArray(rast_array)
        raster.SetProjection(projection)
        raster.SetGeoTransform(transform)
        band.FlushCache()


    @staticmethod
    def cleanup():
        Six.leaf_array = None
        Six.bloom_array = None
        Six.leaf_average_array = None
        Six.bloom_average_array = None