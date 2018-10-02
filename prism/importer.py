from datetime import timedelta
from datetime import datetime
from urllib import request
from cgi import parse_header
import zipfile
import os.path
import psycopg2
from psycopg2.extensions import AsIs
import subprocess
import re
import glob
import yaml
import datetime as dt
import http
import logging
import contextlib
from util.database import save_raster_to_postgis 
from util.database import update_time_series
from util.database import delete_from_time_series
from util.database import table_exists
from util.database import remove_from_table_by_filename
from util.database import set_date_column
import re


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), os.path.pardir, 'config.yml')), 'r') as yml_file:
    cfg = yaml.load(yml_file)
db = cfg["postgis"]
prism_path = cfg["prism_path"]
prism_archive_path = cfg["prism_archive_path"]

conn = psycopg2.connect(dbname=db["db"], port=db["port"], user=db["user"],
                        password=db["password"], host=db["host"])
curs = conn.cursor()


def unzip(source_filename, destination_dir):
    # try:
    with zipfile.ZipFile(source_filename) as zf:
        for member in zf.infolist():
            words = member.filename.split(os.sep)
            path = destination_dir
            for word in words[:-1]:
                drive, word = os.path.splitdrive(word)
                head, word = os.path.split(word)
                if word in (os.curdir, os.pardir, ''):
                    continue
                path = os.path.join(path, word)
            zf.extract(member, path)
    # except zipfile.BadZipfile as e:
    #     print(e)


def postgis_import(filename, raster_date, climate_variable):
    logging.info('populating ' + climate_variable + ' for ' + raster_date)
    table_name = "prism_" + climate_variable + '_' + raster_date[:4]
    # check if we need to create a new table
    new_table = True
    query = "SELECT COUNT(*) FROM information_schema.tables WHERE table_name = %s;"
    curs.execute(query, [table_name])
    if curs.fetchone()[0] == 1:
        new_table = False

    # remove old entry if one already exists for the date that we're inserting for.
    # this allows us to upgrade data from early to provisional to stable
    if not new_table:
        query = "DELETE FROM %(table)s WHERE rast_date = to_date(%(raster_date)s, 'YYYY-MM-DD');"
        data = {"table": AsIs(table_name), "raster_date": raster_date}
        curs.execute(query, data)
        conn.commit()

    # insert the raster (either create a new table or append to previously created table)
    if new_table:
        import_command = "raster2pgsql -s 4269 -c -I -C -M -F -t auto {file} public.{table}"\
            .format(file=filename, table=table_name)
    else:
        import_command = "raster2pgsql -s 4269 -a -M -F -t auto {file} public.{table}"\
            .format(file=filename, table=table_name)
    import_command2 = "psql -h {host} -p {port} -d {database} -U {user} --no-password"\
        .format(host=db["host"], port=db["port"], database=db["db"], user=db["user"])
    ps = subprocess.Popen(import_command, stdout=subprocess.PIPE, shell=True)
    subprocess.check_output(import_command2, stdin=ps.stdout, shell=True)
    ps.wait()

    # possibly set up extra table structure
    if new_table:
        query = "ALTER TABLE %(table)s ADD rast_date date;"
        curs.execute(query, {"table": AsIs(table_name)})
        conn.commit()
        query = "CREATE INDEX ON %(table)s (rast_date);"
        curs.execute(query, {"table": AsIs(table_name)})
        conn.commit()
    query = "UPDATE %(table)s SET rast_date = to_date(%(raster_date)s, 'YYYY-MM-DD') WHERE rast_date IS NULL;"
    data = {"table": AsIs(table_name), "raster_date": raster_date}
    curs.execute(query, data)
    conn.commit()


def get_prism_data_outdb(start_date, end_date, climate_variables):    
    delta = end_date - start_date
    for climate_variable in climate_variables:
        # create directory to store zip files
        zipped_files_path = prism_path + "zipped" + os.sep + climate_variable + os.sep
        os.makedirs(zipped_files_path, exist_ok=True)

        # check if data and time series tables have been created yet
        table_name = "prism_ppt_data"
        time_series_table = "prism_" + climate_variable
        new_table = not table_exists(table_name)
        new_time_series = not table_exists(time_series_table)

        # create directory to unzip bil files to
        unzip_path = prism_path + time_series_table + os.sep
        os.makedirs(unzip_path, exist_ok=True)

        for i in range(delta.days + 1):
            downloaded = False
            while not downloaded:
                day = start_date + timedelta(days=i)

                # prism data is only historical, never look for today or in the future
                if day >= dt.datetime.today().date() - timedelta(days=1):
                    downloaded = True
                    continue

                # only download file if we don't already have the stable version
                if not os.path.isfile(unzip_path + 'PRISM_' + climate_variable + '_stable_4kmD2_' + day.strftime("%Y%m%d") + '_bil.tif'):
                    request_url = "http://services.nacse.org/prism/data/public/4km/{climate_var}/{date}"\
                        .format(climate_var=climate_variable, date=day.strftime("%Y%m%d"))
                    try:
                        response = request.urlopen(request_url)
                    except http.client.HTTPException as e:
                        print('error downloading ' + request_url)
                        downloaded = False
                        continue
                    downloaded = True
                    filename, _ = parse_header(response.headers.get('Content-Disposition'))
                    filename = filename.replace("filename=", "").replace("\"", "")

                    # if zip file already exists don't want to redownload it
                    if os.path.isfile(os.path.join(zipped_files_path, filename)):
                        logging.info('already have file: ' + filename)
                        continue

                    # open zip file for writing (overwrites if file already exists)
                    with open(os.path.join(zipped_files_path, filename), "wb") as local_file:
                        local_file.write(response.read())

                    # unzip the file
                    zip_file = zipped_files_path + filename
                    unzip(zip_file, unzip_path)
                    bil_file = unzip_path + filename.replace('.zip', '.bil')
                    tif_file = unzip_path + filename.replace('.zip', '.tif')

                    #convert from bil to tif
                    subprocess.call(["gdal_translate", "-of", "GTiff", bil_file, tif_file])

                    save_raster_to_postgis(tif_file, table_name, 4269, True)

                    if not new_time_series:
                        update_time_series(time_series_table, filename.replace('.zip', '.tif'), day)
                    
                    set_date_column(table_name, day, new_table)
                    new_table = False

                    # remove bil & associated files that were unzipped (we only want the geotif)
                    os.remove(bil_file.replace('.bil', '.bil.aux.xml'))
                    os.remove(bil_file.replace('.bil', '.hdr'))
                    os.remove(bil_file.replace('.bil', '.info.txt'))
                    os.remove(bil_file.replace('.bil', '.stn.csv'))
                    os.remove(bil_file.replace('.bil', '.stx'))
                    os.remove(bil_file.replace('.bil', '.prj'))
                    os.remove(bil_file.replace('.bil', '.xml'))
                    os.remove(bil_file)
                    # also remove zip file
                    os.remove(zip_file)
                   
                    # delete early and provisional files if needed
                    if 'provisional' in filename:
                        # we have provisional so we don't need the early anymore
                        file_to_delete = zipped_files_path + filename.replace('provisional', 'early')
                        if os.path.isfile(file_to_delete):
                            os.remove(file_to_delete)
                            # remove tif file from disk, postgis, and timeseries
                            early_tif_file = tif_file.replace('provisional', 'early')
                            remove_from_table_by_filename(early_tif_file, table_name)
                            if not new_time_series:
                                delete_from_time_series(time_series_table, early_tif_file)
                            os.remove(early_tif_file)


                    if 'stable' in filename:
                        # we have stable so we don't need the early or provisional anymore
                        file_to_delete = zipped_files_path + filename.replace('stable', 'early')
                        if os.path.isfile(file_to_delete):
                            os.remove(file_to_delete)
                            # remove tif file from disk, postgis, and timeseries
                            early_tif_file = tif_file.replace('provisional', 'early')
                            remove_from_table_by_filename(early_tif_file, table_name)
                            if not new_time_series:
                                delete_from_time_series(time_series_table, early_tif_file)
                            os.remove(early_tif_file)
                        file_to_delete = zipped_files_path + filename.replace('stable', 'provisional')
                        if os.path.isfile(file_to_delete):
                            os.remove(file_to_delete)
                            # remove tif file from disk, postgis, and timeseries
                            provisional_tif_file = tif_file.replace('stable', 'provisional')
                            remove_from_table_by_filename(provisional_tif_file, table_name)
                            if not new_time_series:
                                delete_from_time_series(time_series_table, provisional_tif_file)
                            os.remove(provisional_tif_file)
                else:
                    downloaded = True
                    logging.info('already have stable file for ' + day.strftime("%Y%m%d"))


# def get_prism_data_outdb(start_date, end_date, climate_variables):
#     for climate_variable in climate_variables:
#         zipped_files_path = prism_archive_path + "zipped" + os.sep + climate_variable + os.sep
#         unzip_path = prism_archive_path + climate_variable + os.sep

#         for zip_file in glob.glob(zipped_files_path + "*.zip"):
#             # unzip the file
#             unzip(zip_file, unzip_path)

#         for bil_file in glob.glob(unzip_path + "*.bil"):
#             tif_file = bil_file.replace('.bil', '.tif')
#             #convert from bil to tif
#             subprocess.call(["gdal_translate", "-of", "GTiff", bil_file, tif_file])

#             save_raster_to_postgis(tif_file, "prism_ppt", 4269, True)

#             # remove bil & associated files that were unzipped (we only want the geotif)
#             os.remove(bil_file.replace('.bil', '.bil.aux.xml'))
#             os.remove(bil_file.replace('.bil', '.hdr'))
#             os.remove(bil_file.replace('.bil', '.info.txt'))
#             os.remove(bil_file.replace('.bil', '.stn.csv'))
#             os.remove(bil_file.replace('.bil', '.stx'))
#             os.remove(bil_file.replace('.bil', '.prj'))
#             os.remove(bil_file.replace('.bil', '.xml'))
#             os.remove(bil_file)


def get_prism_data(start_date, end_date, climate_variables):
    # create directory structure to store zips
    for climate_variable in climate_variables:
        zipped_files_path = prism_path + "zipped" + os.sep + climate_variable + os.sep
        os.makedirs(zipped_files_path, exist_ok=True)
    unzip_path = prism_path + "zipped" + os.sep + "temp" + os.sep
    os.makedirs(unzip_path, exist_ok=True)

    # make sure unzipped files path is cleaned out
    unzipped_files_path = unzip_path + "*.*"
    for unzipped_file in glob.glob(unzipped_files_path):
        os.remove(unzipped_file)

    delta = end_date - start_date
    for climate_variable in climate_variables:
        zipped_files_path = prism_path + "zipped" + os.sep + climate_variable + os.sep
        zipped_files_archive_path = prism_archive_path + "zipped" + os.sep + climate_variable + os.sep
        for i in range(delta.days + 1):
            downloaded = False
            while not downloaded:
                day = start_date + timedelta(days=i)

                # prism data is only historical, never look for today or in the future
                if day >= dt.datetime.today().date() - timedelta(days=1):
                    downloaded = True
                    continue

                # only download file if we don't already have the stable version
                if not os.path.isfile(zipped_files_path + 'PRISM_' + climate_variable + '_stable_4kmD1_' + day.strftime("%Y%m%d") + '_bil.zip')\
                        and not os.path.isfile(zipped_files_archive_path + 'PRISM_' + climate_variable + '_stable_4kmD1_' + day.strftime("%Y%m%d") + '_bil.zip'):
                    request_url = "http://services.nacse.org/prism/data/public/4km/{climate_var}/{date}"\
                        .format(climate_var=climate_variable, date=day.strftime("%Y%m%d"))
                    try:
                        response = request.urlopen(request_url)
                    except http.client.HTTPException as e:
                        print('error downloading ' + request_url)
                        downloaded = False
                        continue
                    downloaded = True
                    filename, _ = parse_header(response.headers.get('Content-Disposition'))
                    filename = filename.replace("filename=", "").replace("\"", "")

                    # open zip file for writing (overwrites if file already exists)
                    with open(os.path.join(zipped_files_path, filename), "wb") as local_file:
                        local_file.write(response.read())

                    # unzip the file
                    unzip(zipped_files_path + filename, unzip_path)

                    # import bil file into database as a raster
                    bil_files_path = unzip_path + "*.bil"
                    for bil_file in glob.glob(bil_files_path):
                        raster_date = re.search('4kmD1_(.*)_bil.bil', bil_file).group(1)
                        raster_date = '-'.join([raster_date[:4], raster_date[4:6], raster_date[6:]])
                        postgis_import(bil_file, raster_date, climate_variable)

                    # delete unzipped files
                    unzipped_files_path = unzip_path + "*.*"
                    for unzipped_file in glob.glob(unzipped_files_path):
                        os.remove(unzipped_file)

                    # delete early and provisional zip files if needed
                    if 'provisional' in filename:
                        # we have provisional so we don't need the early anymore
                        file_to_delete = zipped_files_path + filename.replace('provisional', 'early')
                        if os.path.isfile(file_to_delete):
                            os.remove(file_to_delete)
                    if 'stable' in filename:
                        # we have stable so we don't need the early or provisional anymore
                        file_to_delete = zipped_files_path + filename.replace('stable', 'early')
                        if os.path.isfile(file_to_delete):
                            os.remove(file_to_delete)
                        file_to_delete = zipped_files_path + filename.replace('stable', 'provisional')
                        if os.path.isfile(file_to_delete):
                            os.remove(file_to_delete)
                else:
                    downloaded = True
                    logging.info('already have stable file for ' + day.strftime("%Y%m%d"))


#testing for dynamic agdd
def unzip_prism_data():
    zipped_files_path = "/geo-data/climate_data/prism/prism_data/zipped/tmax/" + "*201505*.zip"
    unzip_to_path = "/geo-data/climate_data/prism/tmax_test/"
    for zipped_file in glob.glob(zipped_files_path):
        print("unzipping " + zipped_file + " to " + unzip_to_path)
        unzip(zipped_file, unzip_to_path)

def convert_bil_to_tif():
    bil_path = "/geo-data/climate_data/prism/tmax_test/"
    bilfiles = glob.glob(bil_path + "*.bil")
    for bilfile in bilfiles:
        subprocess.call(["gdal_translate", "-of", "GTiff", bilfile, bilfile.replace('.bil', '.tif')])
