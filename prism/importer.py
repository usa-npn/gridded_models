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


# def get_prism_data_outdb(start_date, end_date, climate_variables):
#     #prism_archive_path: /geo-vault/climate_data/prism/prism_data/
    
#     # create directory structure to store zips
#     for climate_variable in climate_variables:
#         zipped_files_path = prism_path + "zipped" + os.sep + climate_variable + os.sep
#         os.makedirs(zipped_files_path, exist_ok=True)
    

#     # make sure unzipped files path is cleaned out
#     # unzipped_files_path = unzip_path + "*.*"
#     # for unzipped_file in glob.glob(unzipped_files_path):
#     #     os.remove(unzipped_file)

#     delta = end_date - start_date
#     for climate_variable in climate_variables:
#         unzip_path = prism_archive_path + climate_variable + os.sep
#         os.makedirs(unzip_path, exist_ok=True)

#         # zipped_files_path = prism_path + "zipped" + os.sep + climate_variable + os.sep
#         zipped_files_path = prism_archive_path + "zipped" + os.sep + climate_variable + os.sep
#         for i in range(delta.days + 1):
#             downloaded = False
#             while not downloaded:
#                 day = start_date + timedelta(days=i)

#                 # prism data is only historical, never look for today or in the future
#                 if day >= dt.datetime.today().date() - timedelta(days=1):
#                     downloaded = True
#                     continue

#                 # only download file if we don't already have the stable version
#                 if not os.path.isfile(zipped_files_path + 'PRISM_' + climate_variable + '_stable_4kmD1_' + day.strftime("%Y%m%d") + '_bil.zip')\
#                         and not os.path.isfile(zipped_files_path + 'PRISM_' + climate_variable + '_stable_4kmD1_' + day.strftime("%Y%m%d") + '_bil.zip'):
#                     request_url = "http://services.nacse.org/prism/data/public/4km/{climate_var}/{date}"\
#                         .format(climate_var=climate_variable, date=day.strftime("%Y%m%d"))
#                     try:
#                         response = request.urlopen(request_url)
#                     except http.client.HTTPException as e:
#                         print('error downloading ' + request_url)
#                         downloaded = False
#                         continue
#                     downloaded = True
#                     filename, _ = parse_header(response.headers.get('Content-Disposition'))
#                     filename = filename.replace("filename=", "").replace("\"", "")

#                     # open zip file for writing (overwrites if file already exists)
#                     with open(os.path.join(zipped_files_path, filename), "wb") as local_file:
#                         local_file.write(response.read())

#                     # unzip the file
#                     zip_file = zipped_files_path + filename
#                     unzip(zip_file, unzip_path)
#                     bil_file = unzip_path + filename.replace('.zip', '.bil')
#                     tif_file = unzip_path + filename.replace('.bil', '.tif')

#                     #convert from bil to tif
#                     subprocess.call(["gdal_translate", "-of", "GTiff", bil_file, tif_file])

#                     save_raster_to_postgis(tif_file, "prism_precip", 4269, True)

#                     # # import bil file into database as a raster
#                     # bil_files_path = unzip_path + "*.bil"
#                     # for bil_file in glob.glob(bil_files_path):
#                     #     raster_date = re.search('4kmD1_(.*)_bil.bil', bil_file).group(1)
#                     #     raster_date = '-'.join([raster_date[:4], raster_date[4:6], raster_date[6:]])
#                     #     postgis_import(bil_file, raster_date, climate_variable)

#                     # remove bil & associated files that were unzipped (we only want the geotif)
#                     os.remove(bil_file.replace('.bil', '.bil.aux.xml'))
#                     os.remove(bil_file.replace('.bil', '.hdr'))
#                     os.remove(bil_file.replace('.bil', '.info.txt'))
#                     os.remove(bil_file.replace('.bil', '.stn.csv'))
#                     os.remove(bil_file.replace('.bil', '.stx'))
#                     os.remove(bil_file.replace('.bil', '.prj'))
#                     os.remove(bil_file.replace('.bil', '.xml'))
#                     os.remove(bil_file)
                   
#                     # delete early and provisional zip files if needed
#                     if 'provisional' in filename:
#                         # we have provisional so we don't need the early anymore
#                         file_to_delete = zipped_files_path + filename.replace('provisional', 'early')
#                         if os.path.isfile(file_to_delete):
#                             os.remove(file_to_delete)
#                     if 'stable' in filename:
#                         # we have stable so we don't need the early or provisional anymore
#                         file_to_delete = zipped_files_path + filename.replace('stable', 'early')
#                         if os.path.isfile(file_to_delete):
#                             os.remove(file_to_delete)
#                         file_to_delete = zipped_files_path + filename.replace('stable', 'provisional')
#                         if os.path.isfile(file_to_delete):
#                             os.remove(file_to_delete)
#                 else:
#                     downloaded = True
#                     logging.info('already have stable file for ' + day.strftime("%Y%m%d"))


def get_prism_data_outdb(start_date, end_date, climate_variables):
    for climate_variable in climate_variables:
        zipped_files_path = prism_archive_path + "zipped" + os.sep + climate_variable + os.sep
        unzip_path = prism_archive_path + climate_variable + os.sep

        for zip_file in glob.glob(zipped_files_path + "*.zip"):
            # unzip the file
            unzip(zip_file, unzip_path)

        for bil_file in glob.glob(unzip_path + "*.bil"):
            tif_file = bil_file.replace('.bil', '.tif')
            #convert from bil to tif
            subprocess.call(["gdal_translate", "-of", "GTiff", bil_file, tif_file])

            save_raster_to_postgis(tif_file, "prism_ppt", 4269, True)

            # remove bil & associated files that were unzipped (we only want the geotif)
            os.remove(bil_file.replace('.bil', '.bil.aux.xml'))
            os.remove(bil_file.replace('.bil', '.hdr'))
            os.remove(bil_file.replace('.bil', '.info.txt'))
            os.remove(bil_file.replace('.bil', '.stn.csv'))
            os.remove(bil_file.replace('.bil', '.stx'))
            os.remove(bil_file.replace('.bil', '.prj'))
            os.remove(bil_file.replace('.bil', '.xml'))
            os.remove(bil_file)


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

def compute_tavg_from_prism_zips(start_date, stop_date):
    tmax_zipped_files_path = "/geo-vault/climate_data/prism/prism_data/zipped/tmax/"
    tmin_zipped_files_path = "/geo-vault/climate_data/prism/prism_data/zipped/tmin/"
    unzip_to_path = "/geo-vault/climate_data/prism/prism_data/tavg/"

    day = datetime.strptime(start_date, "%Y-%m-%d")
    stop = datetime.strptime(stop_date, "%Y-%m-%d")

    while day <= stop:
        tmin_zip_file = "PRISM_tmin_stable_4kmD1_{date}_bil.zip".format(date=day.strftime("%Y%m%d"))
        tmax_zip_file = "PRISM_tmax_stable_4kmD1_{date}_bil.zip".format(date=day.strftime("%Y%m%d"))

        unzip(tmax_zipped_files_path + tmax_zip_file, unzip_to_path)
        unzip(tmin_zipped_files_path + tmin_zip_file, unzip_to_path)

        tmin_bilfile = unzip_to_path + tmin_zip_file.replace('.zip', '.bil')
        tmax_bilfile = unzip_to_path + tmax_zip_file.replace('.zip', '.bil')

        tmin_tiffile = unzip_to_path + tmin_zip_file.replace('.zip', '.tif')
        tmax_tiffile = unzip_to_path + tmax_zip_file.replace('.zip', '.tif')

        #convert from bil to tif
        subprocess.call(["gdal_translate", "-of", "GTiff", tmin_bilfile, tmin_tiffile])
        subprocess.call(["gdal_translate", "-of", "GTiff", tmax_bilfile, tmax_tiffile])

        #compute avg tif
        avg_tiffile = unzip_to_path + "tavg_{date}.tif".format(date=day.strftime("%Y%m%d"))
        subprocess.call("gdal_calc.py -A " + tmin_tiffile + " -B " + tmax_tiffile + " --outfile=" + avg_tiffile + " --NoDataValue=-9999 --calc='((A*1.8+32)+(B*1.8+32))/2'", shell=True)


        #remove extraneous files
        with contextlib.suppress(FileNotFoundError):
            os.remove(tmin_bilfile.replace('.bil', '.bil.aux.xml'))
            os.remove(tmin_bilfile.replace('.bil', '.hdr'))
            os.remove(tmin_bilfile.replace('.bil', '.info.txt'))
            os.remove(tmin_bilfile.replace('.bil', '.stn.csv'))
            os.remove(tmin_bilfile.replace('.bil', '.stx'))
            os.remove(tmin_bilfile.replace('.bil', '.prj'))
            os.remove(tmin_bilfile.replace('.bil', '.xml'))
            os.remove(tmin_bilfile)
            os.remove(tmin_tiffile)

            os.remove(tmax_bilfile.replace('.bil', '.bil.aux.xml'))
            os.remove(tmax_bilfile.replace('.bil', '.hdr'))
            os.remove(tmax_bilfile.replace('.bil', '.info.txt'))
            os.remove(tmax_bilfile.replace('.bil', '.stn.csv'))
            os.remove(tmax_bilfile.replace('.bil', '.stx'))
            os.remove(tmax_bilfile.replace('.bil', '.prj'))
            os.remove(tmax_bilfile.replace('.bil', '.xml'))
            os.remove(tmax_tiffile)
            os.remove(tmax_bilfile)

        day = day + timedelta(days=1)

# def compute_tavg_from_ncep_zips(start_date, stop_date):
#     tmax_zipped_files_path = "/geo-data/climate_data/daily_data/tmax/"
#     tmin_zipped_files_path = "/geo-data/climate_data/daily_data/tmin/"

#     day = datetime.strptime(start_date, "%Y-%m-%d")
#     stop = datetime.strptime(stop_date, "%Y-%m-%d")

#     while day <= stop:
#         tmin_zip_file = "PRISM_tmin_stable_4kmD1_{date}_bil.zip".format(date=day.strftime("%Y%m%d"))
#         tmax_zip_file = "PRISM_tmax_stable_4kmD1_{date}_bil.zip".format(date=day.strftime("%Y%m%d"))

#         unzip(tmax_zipped_files_path + tmax_zip_file, unzip_to_path)
#         unzip(tmin_zipped_files_path + tmin_zip_file, unzip_to_path)

#         tmin_bilfile = unzip_to_path + tmin_zip_file.replace('.zip', '.bil')
#         tmax_bilfile = unzip_to_path + tmax_zip_file.replace('.zip', '.bil')

#         tmin_tiffile = unzip_to_path + tmin_zip_file.replace('.zip', '.tif')
#         tmax_tiffile = unzip_to_path + tmax_zip_file.replace('.zip', '.tif')

#         #convert from bil to tif
#         subprocess.call(["gdal_translate", "-of", "GTiff", tmin_bilfile, tmin_tiffile])
#         subprocess.call(["gdal_translate", "-of", "GTiff", tmax_bilfile, tmax_tiffile])

#         #compute avg tif
#         avg_tiffile = unzip_to_path + "tavg_{date}.tif".format(date=day.strftime("%Y%m%d"))
#         subprocess.call("gdal_calc.py -A " + tmin_tiffile + " -B " + tmax_tiffile + " --outfile=" + avg_tiffile + " --NoDataValue=-9999 --calc='((A*1.8+32)+(B*1.8+32))/2'", shell=True)


#         #remove extraneous files
#         with contextlib.suppress(FileNotFoundError):
#             os.remove(tmin_bilfile.replace('.bil', '.bil.aux.xml'))
#             os.remove(tmin_bilfile.replace('.bil', '.hdr'))
#             os.remove(tmin_bilfile.replace('.bil', '.info.txt'))
#             os.remove(tmin_bilfile.replace('.bil', '.stn.csv'))
#             os.remove(tmin_bilfile.replace('.bil', '.stx'))
#             os.remove(tmin_bilfile.replace('.bil', '.prj'))
#             os.remove(tmin_bilfile.replace('.bil', '.xml'))
#             os.remove(tmin_bilfile)
#             os.remove(tmin_tiffile)

#             os.remove(tmax_bilfile.replace('.bil', '.bil.aux.xml'))
#             os.remove(tmax_bilfile.replace('.bil', '.hdr'))
#             os.remove(tmax_bilfile.replace('.bil', '.info.txt'))
#             os.remove(tmax_bilfile.replace('.bil', '.stn.csv'))
#             os.remove(tmax_bilfile.replace('.bil', '.stx'))
#             os.remove(tmax_bilfile.replace('.bil', '.prj'))
#             os.remove(tmax_bilfile.replace('.bil', '.xml'))
#             os.remove(tmax_tiffile)
#             os.remove(tmax_bilfile)
            
#         day = day + timedelta(days=1)