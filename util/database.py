import yaml
import psycopg2
from psycopg2.extensions import AsIs
import os.path
import subprocess
from util.log_manager import get_error_log
from osgeo import gdal
import mysql.connector

error_log = get_error_log()

with open(os.path.abspath(os.path.join(os.path.dirname(__file__), os.path.pardir, 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
db = cfg["postgis"]


try:
    conn = psycopg2.connect(dbname=db["db"], port=db["port"], user=db["user"],
                        password=db["password"], host=db["host"])
except:
    error_log.error('database.py failed to connect to the database: ', exc_info=True)


mysql_db = cfg["mysql"]
try:
    mysql_conn = mysql.connector.connect(database=mysql_db["db"], port=mysql_db["port"], user=mysql_db["user"],
                        password=mysql_db["password"], host=mysql_db["host"])
except:
    error_log.error('database.py failed to connect to the database: ', exc_info=True)


def table_exists(table_name):
    curs = conn.cursor()
    query = "SELECT COUNT(*) FROM information_schema.tables WHERE table_name = %s;"
    curs.execute(query, [table_name])
    if curs.fetchone()[0] == 1:
        return True
    else:
        return False


def six_row_exists(table_name, plant, phenophase, date):
    curs = conn.cursor()

    query = "SELECT EXISTS (SELECT TRUE FROM %s WHERE plant = %s AND phenophase = %s AND rast_date = %s);"
    data = (AsIs(table_name), plant, phenophase, date.strftime("%Y-%m-%d"))
    curs.execute(query, data)

    result = curs.fetchone()[0]
    curs.close()
    return result


def agdd_row_exists(table_name, scale, base, date):
    curs = conn.cursor()

    query = "SELECT EXISTS (SELECT TRUE FROM %s WHERE scale = %s AND base = %s AND rast_date = %s);"
    data = (AsIs(table_name), scale, base, date.strftime("%Y-%m-%d"))
    curs.execute(query, data)

    result = curs.fetchone()[0]
    curs.close()
    return result


def save_raster_to_postgis(raster_path, table_name, srid, tile=True):
    curs = conn.cursor()
    new_table = not table_exists(table_name)
    if tile:
        tile_arg = "-t auto "
    else:
        tile_arg = ""

    # remove old entry if already exists
    if not new_table:
        query = "DELETE FROM %(table)s WHERE filename = %(filename)s;"
        data = {"table": AsIs(table_name), "filename": os.path.basename(raster_path)}
        curs.execute(query, data)
        conn.commit()

    # insert the raster (either create a new table or append to previously created table)
    if new_table:
        if srid:
            import_command = "raster2pgsql -s {srid} -c -R -I -C -F {tile_arg}{file} public.{table}"\
                .format(file=raster_path, table=table_name, srid=srid, tile_arg=tile_arg)
        else:
            import_command = "raster2pgsql -c -R -I -C -F {tile_arg}{file} public.{table}"\
                .format(file=raster_path, table=table_name, tile_arg=tile_arg)
    else:
        if srid:
            import_command = "raster2pgsql -s {srid} -a -R -F {tile_arg}{file} public.{table}"\
                .format(file=raster_path, table=table_name, srid=srid, tile_arg=tile_arg)
        else:
            import_command = "raster2pgsql -a -R -F {tile_arg}{file} public.{table}"\
                .format(file=raster_path, table=table_name, tile_arg=tile_arg)
    import_command2 = "psql -h {host} -p {port} -d {database} -U {user} --no-password"\
        .format(host=db["host"], port=db["port"], database=db["db"], user=db["user"])

    # for windows machine (also works on linux, but i think has mem leak)
    # ps = subprocess.Popen(import_command, stdout=subprocess.PIPE, shell=True)
    # subprocess.check_output(import_command2, stdin=ps.stdout, shell=True)
    # ps.wait()

    # for linux machine
    subprocess.check_output(import_command + " | " + import_command2, shell=True)

    # get rid of generated enforce_max_extent_rast constraint because rounding error was preventing some rasters from being saved to db
    if new_table:
        query = "ALTER TABLE %(table)s DROP CONSTRAINT IF EXISTS enforce_max_extent_rast;"
        data = {"table": AsIs(table_name)}
        curs.execute(query, data)
        conn.commit()


def set_date_column(table_name, rast_date, new_table):
    curs = conn.cursor()
    if new_table:
        query = "ALTER TABLE %(table)s ADD rast_date DATE;"
        curs.execute(query, {"table": AsIs(table_name)})
        query = "CREATE INDEX ON %(table)s (rast_date);"
        curs.execute(query, {"table": AsIs(table_name)})
        query = "CREATE INDEX ON %(table)s (filename);"
        curs.execute(query, {"table": AsIs(table_name)})
        conn.commit()
    query = "UPDATE %(table)s SET rast_date = to_date(%(rast_date)s, 'YYYYMMDD') WHERE rast_date IS NULL;"
    data = {"table": AsIs(table_name), "rast_date": rast_date.strftime("%Y%m%d")}
    curs.execute(query, data)
    conn.commit()


def set_plant_column(table_name, plant, new_table):
    curs = conn.cursor()
    if new_table:
        query = "ALTER TABLE %(table)s ADD plant TEXT;"
        curs.execute(query, {"table": AsIs(table_name)})
        query = "CREATE INDEX ON %(table)s (plant);"
        curs.execute(query, {"table": AsIs(table_name)})
        conn.commit()
    query = "UPDATE %(table)s SET plant = %(plant)s WHERE plant IS NULL;"
    data = {"table": AsIs(table_name), "plant": plant}
    curs.execute(query, data)
    conn.commit()


def set_phenophase_column(table_name, phenophase, new_table):
    curs = conn.cursor()
    if new_table:
        query = "ALTER TABLE %(table)s ADD phenophase TEXT;"
        curs.execute(query, {"table": AsIs(table_name)})
        query = "CREATE INDEX ON %(table)s (phenophase);"
        curs.execute(query, {"table": AsIs(table_name)})
        conn.commit()
    query = "UPDATE %(table)s SET phenophase = %(phenophase)s WHERE phenophase IS NULL;"
    data = {"table": AsIs(table_name), "phenophase": phenophase}
    curs.execute(query, data)
    conn.commit()


def set_scale_column(table_name, scale, new_table):
    curs = conn.cursor()
    if new_table:
        query = "ALTER TABLE %(table)s ADD scale TEXT;"
        curs.execute(query, {"table": AsIs(table_name)})
        query = "CREATE INDEX ON %(table)s (scale);"
        curs.execute(query, {"table": AsIs(table_name)})
        conn.commit()
    query = "UPDATE %(table)s SET scale = %(scale)s WHERE scale IS NULL;"
    data = {"table": AsIs(table_name), "scale": scale}
    curs.execute(query, data)
    conn.commit()


def set_base_column(table_name, base, new_table):
    curs = conn.cursor()
    if new_table:
        query = "ALTER TABLE %(table)s ADD base INTEGER;"
        curs.execute(query, {"table": AsIs(table_name)})
        query = "CREATE INDEX ON %(table)s (base);"
        curs.execute(query, {"table": AsIs(table_name)})
        conn.commit()
    query = "UPDATE %(table)s SET base = %(base)s WHERE base IS NULL;"
    data = {"table": AsIs(table_name), "base": base}
    curs.execute(query, data)
    conn.commit()


def set_doy_column(table_name, doy, new_table):
    curs = conn.cursor()
    if new_table:
        query = "ALTER TABLE %(table)s ADD doy INTEGER;"
        curs.execute(query, {"table": AsIs(table_name)})
        query = "CREATE INDEX ON %(table)s (doy);"
        curs.execute(query, {"table": AsIs(table_name)})
        conn.commit()
    query = "UPDATE %(table)s SET doy = %(doy)s WHERE doy IS NULL;"
    data = {"table": AsIs(table_name), "doy": doy}
    curs.execute(query, data)
    conn.commit()


def update_time_series(time_series_table, file_name, rast_date):
    curs = conn.cursor()

    query = "DELETE FROM %(table)s WHERE location = %(filename)s;"
    data = {"table": AsIs(time_series_table), "filename": file_name}
    curs.execute(query, data)

    query = """INSERT INTO %(table)s (the_geom, location, ingestion) (
      SELECT the_geom, %(filename)s, to_timestamp(%(rast_date)s, 'YYYY-MM-DD') FROM %(table)s LIMIT 1
      );"""
    data = {"table": AsIs(time_series_table), "filename": file_name, "rast_date": rast_date.strftime("%Y-%m-%d")}
    curs.execute(query, data)
    conn.commit()

# convenience wrapper for get_raster_info_from_query(query, data)
# returns (num_cols, num_rows, transform, projection, no_data_value) from table_name where rast_date = date
def get_raster_info(table_name, date):
    query = "SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff') FROM %s WHERE rast_date = %s;"
    data = (AsIs(table_name), date.strftime("%Y-%m-%d"))

    return get_raster_info_from_query(query, data)


# returns (num_cols, num_rows, transform, projection, no_data_value) based on query and data
def get_raster_info_from_query(query, data):
    vsipath = '/vsimem/from_postgis'

    curs = conn.cursor()

    curs.execute(query, data)

    gdal.FileFromMemBuffer(vsipath, bytes(curs.fetchone()[0]))
    curs.close()

    # Read first band of raster with GDAL
    ds = gdal.Open(vsipath)
    band = ds.GetRasterBand(1)

    # Grab all the info to return
    num_cols = ds.RasterXSize
    num_rows = ds.RasterYSize
    transform = ds.GetGeoTransform()
    projection = ds.GetProjection()
    no_data_value = band.GetNoDataValue()

    # Close and clean up virtual memory file
    gdal.Unlink(vsipath)

    return (num_cols, num_rows, transform, projection, no_data_value)


# convenience wrapper for get_raster_from_query(query, data)
# returns array for raster from table table_name where column_name matches value
def get_raster_array(table_name, column_name, value):

    query = "SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff') FROM %s WHERE %s = %s;"
    data = (AsIs(table_name), AsIs(column_name), value)
    return get_raster_from_query(query, data)


# returns array for raster
def get_raster_from_query(query, data):
    # Load raster from postgis into a virtual memory file
    vsipath = '/vsimem/from_postgis'

    curs = conn.cursor()

    curs.execute(query, data)

    result = curs.fetchone()[0]

    if result is None:
        return None

    gdal.FileFromMemBuffer(vsipath, bytes(result))
    curs.close()

    # Read first band of raster with GDAL
    ds = gdal.Open(vsipath)
    band = ds.GetRasterBand(1)

    outarray = band.ReadAsArray()

    # Close and clean up virtual memory file
    gdal.Unlink(vsipath)

    return outarray
