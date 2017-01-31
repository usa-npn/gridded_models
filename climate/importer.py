import os.path
from urllib.request import urlretrieve
import urllib
import glob
import datetime as dt
from util.database import *
from util.raster import *
from shutil import copy
from datetime import *
import re
import logging
import numpy as np
from time import sleep


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), os.path.pardir, 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)


def retrieve_from_url(url_to_get, path_to_save):
    logging.info('downloading %s to %s', url_to_get, path_to_save)
    retry_count = 0
    while retry_count < 25:
        try:
            urlretrieve(url_to_get, path_to_save)
        except urllib.error.URLError as e:
            logging.warning('error retrieving file (retrying in 5 seconds): %s', str(e))
            sleep(5)
            retry_count += 1
        except urllib.error.ContentTooShortError as e:
            logging.warning('error retrieving file (retrying in 5 seconds): %s', str(e))
            sleep(5)
            retry_count += 1
        else:
            return True
    logging.warning('error retrieving file (giving up)')
    return False


def download_forecast(region):
    logging.info(' ')
    logging.info("-----------------populating ndfd forecast {region} data-----------------"
                 .format(region=region))
    # download next 7 days of min and max temp predictions starting with tomorrow
    # two files are provided with 3 bands in the first and 4 bands in the second
    # each band represents a day

    # So far it looks like projections are updated every 3 hours UTC(0000, 0300, 0600, 0900, 1200, 1500, 1800, 2100).
    # For more details on the ndfd data see: http://www.nws.noaa.gov/ndfd/technical.htm
    # For more details on ndfd spacial reference see: http://graphical.weather.gov/docs/ndfdSRS.htm

    working_path = cfg["temp_path"]
    if region == 'conus':
        tmin_save_path = cfg["daily_tmin_path"]
        tmax_save_path = cfg["daily_tmax_path"]
    elif region == 'alaska':
        tmin_save_path = cfg["daily_tmin_alaska_path"]
        tmax_save_path = cfg["daily_tmax_alaska_path"]
    os.makedirs(working_path, exist_ok=True)
    os.makedirs(tmin_save_path, exist_ok=True)
    os.makedirs(tmax_save_path, exist_ok=True)
    cleanup(working_path)

    url_tmax1 = "ftp://tgftp.nws.noaa.gov/SL.us008001/ST.opnl/DF.gr2/DC.ndfd/AR.{region}/VP.001-003/ds.maxt.bin"\
        .format(region=region)
    url_tmax2 = "ftp://tgftp.nws.noaa.gov/SL.us008001/ST.opnl/DF.gr2/DC.ndfd/AR.{region}/VP.004-007/ds.maxt.bin"\
        .format(region=region)
    url_tmin1 = "ftp://tgftp.nws.noaa.gov/SL.us008001/ST.opnl/DF.gr2/DC.ndfd/AR.{region}/VP.001-003/ds.mint.bin"\
        .format(region=region)
    url_tmin2 = "ftp://tgftp.nws.noaa.gov/SL.us008001/ST.opnl/DF.gr2/DC.ndfd/AR.{region}/VP.004-007/ds.mint.bin"\
        .format(region=region)

    forecasts = ({'url': url_tmax1, 'file_name': 'maxt1-3.bin'},
                 {'url': url_tmax2, 'file_name': 'maxt4-7.bin'},
                 {'url': url_tmin1, 'file_name': 'mint1-3.bin'},
                 {'url': url_tmin2, 'file_name': 'mint4-7.bin'})

    for forecast in forecasts:
        # grab the multiband raster
        file_name = forecast['file_name']
        retrieved = retrieve_from_url(forecast['url'], working_path + file_name)

        if not retrieved:
            continue

        # each band is a different day
        forecast_data = gdal.Open(working_path + file_name)
        num_bands = forecast_data.RasterCount
        for band in range(1, num_bands+1):
            data_band = forecast_data.GetRasterBand(band)
            meta = data_band.GetMetadata()
            element = meta['GRIB_ELEMENT']

            # get timestamp in utc for when the raster map is valid
            rast_utc = int(re.findall('\d+', meta['GRIB_VALID_TIME'])[0])
            rast_date = datetime.fromtimestamp(rast_utc, timezone.utc)

            file = working_path + element + '_' + rast_date.strftime("%Y%m%d") + '.bin'
            if element == 'MinT':
                dest_file = 'tmin_' + rast_date.strftime("%Y%m%d") + '.tif'
                dest_path = tmin_save_path + dest_file
                if region == 'conus':
                    table_name = "tmin_" + str(rast_date.year)
                    time_series_table = 'tmin'
                elif region == 'alaska':
                    table_name = "tmin_alaska_" + str(rast_date.year)
                    time_series_table = 'tmin_alaska'
            elif element == 'MaxT':
                dest_file = 'tmax_' + rast_date.strftime("%Y%m%d") + '.tif'
                dest_path = tmax_save_path + dest_file
                if region == 'conus':
                    table_name = "tmax_" + str(rast_date.year)
                    time_series_table = 'tmax'
                elif region == 'alaska':
                    table_name = "tmax_alaska_" + str(rast_date.year)
                    time_series_table = 'tmax_alaska'
            else:
                logging.warning('invalid element: %s', element)
                continue
            extract_command = "gdal_translate -b {band_number} {source_file} {dest_file}"\
                .format(band_number=band, source_file=working_path + file_name, dest_file=file)
            ps = subprocess.Popen(extract_command, stdout=subprocess.PIPE, shell=True)
            ps.wait()

            # warp to match prism extent, projection, and size
            if region == 'conus':
                gdalwarp_file(file)
            elif region == 'alaska':
                os.rename(file, file + '_maskme')
                apply_alaska_mask(file + '_maskme', file)

            src_ds = gdal.Open(file)
            rast_band = src_ds.GetRasterBand(1)

            # create new raster with non land areas masked out
            rast_array = rast_band.ReadAsArray()
            if region == 'conus':
                apply_usa_mask(rast_array)

            write_raster(dest_path, rast_array, -9999, src_ds.RasterXSize, src_ds.RasterYSize, src_ds.GetProjection(), src_ds.GetGeoTransform())

            # import raster to db
            rtma_import(dest_path, table_name, False, rast_date, rast_date.hour, 'ndfd')

            # add to geoserver image mosaic
            if table_exists(time_series_table):
                update_time_series(time_series_table, dest_file, rast_date)
            logging.info('imported %s', dest_path)

            src_ds = None
        forecast_data = None
    cleanup(working_path)


def download_hourly_temps(dataset, region):
    working_path = cfg["temp_path"]
    if region == 'conus':
        save_path = cfg["hourly_temp_path"]
    elif region == 'alaska':
        save_path = cfg["hourly_temp_alaska_path"]
    os.makedirs(working_path, exist_ok=True)
    os.makedirs(save_path, exist_ok=True)
    cleanup(working_path)

    logging.info(' ')
    logging.info("-----------------populating past 24 hours of {region} {dataset} data-----------------"
                 .format(region=region, dataset=dataset))

    if dataset == 'urma' and region == 'alaska':
        # urma alaska doesn't exist on tgftp.nws.noaa, so we have to grab from ncep ftp
        # ncep ftp files are larger because you have to download all bands instead of just the temperature band
        start_date = date.today() - timedelta(days=2)
        end_date = date.today()
        download_historic_climate_data(start_date, end_date, dataset, region)
        return
    else:
        base_url_temp = "ftp://tgftp.nws.noaa.gov/SL.us008001/ST.opnl/DF.gr2/DC.ndgd/GT.{dataset}/AR.{region}/" \
            .format(dataset=dataset, region=region)

    # hour is UTC
    for hour in range(0, 24):
        zero_padded_hour = "{0:0=2d}".format(hour)

        # download the file (we keep retrying if there are network issues)
        # DS.TEMP.BIN   =   TEMPERATURE ANALYSIS
        url = base_url_temp + 'RT.' + zero_padded_hour + '/ds.temp.bin'
        file_name = dataset + '_' + zero_padded_hour + '.bin'
        retrieved = retrieve_from_url(url, working_path + file_name)

        if not retrieved:
            continue

        # warp the downloaded raster to EPSG 4269
        # for alaska warping and masking happen at the same time, this is because by the time we got to
        # implementing alaska we learned how to use a shapefile instead of a tif to do the masking
        if region == 'conus':
            gdalwarp_file(working_path + file_name)
        elif region == 'alaska':
            os.rename(working_path + file_name, working_path + file_name + '_maskme')
            apply_alaska_mask(working_path + file_name + '_maskme', working_path + file_name)

        src_ds = gdal.Open(working_path + file_name)
        rast_band = src_ds.GetRasterBand(1)

        # get timestamp in utc for when the raster map is valid
        band_meta_data = rast_band.GetMetadata()
        rast_utc = int(re.findall('\d+', band_meta_data["GRIB_VALID_TIME"])[0])
        rast_date = datetime.fromtimestamp(rast_utc, timezone.utc)

        if region == 'alaska':
            table_name = "hourly_temp_alaska_" + str(rast_date.year)
        else:
            table_name = "hourly_temp_" + str(rast_date.year)

        # create new raster with non land areas masked out
        rast_array = rast_band.ReadAsArray()
        masked_file_path = save_path + dataset + '_' + rast_date.strftime("%Y%m%d") + zero_padded_hour + '.tif'
        if region == 'conus':
            apply_usa_mask(rast_array)
        # write tif to disk
        write_raster(masked_file_path, rast_array, -9999, src_ds.RasterXSize,
                     src_ds.RasterYSize, src_ds.GetProjection(), src_ds.GetGeoTransform())
        # import raster to db
        rtma_import(masked_file_path, table_name, True, rast_date, rast_date.hour, dataset)
        logging.info('imported %s', masked_file_path)
        src_ds = None
        cleanup(working_path)


def download_hourly_temp_uncertainty(dataset):
    working_path = cfg["temp_path"]
    save_path = cfg["hourly_utemp_path"]
    os.makedirs(working_path, exist_ok=True)
    os.makedirs(save_path, exist_ok=True)
    cleanup(working_path)

    if dataset == 'rtma':
        logging.info(' ')
        logging.info('-----------------populating past 24 hours of rtma uncertainty-----------------')
        base_url_temp = 'ftp://tgftp.nws.noaa.gov/SL.us008001/ST.opnl/DF.gr2/DC.ndgd/GT.rtma/AR.conus/'
    elif dataset == 'urma':
        logging.info(' ')
        logging.info('-----------------populating past 24 hours of urma uncertainty-----------------')
        base_url_temp = 'ftp://tgftp.nws.noaa.gov/SL.us008001/ST.opnl/DF.gr2/DC.ndgd/GT.urma/AR.conus/'
    else:
        logging.warning('invalid dataset: %s', dataset)

    # hour is UTC
    for hour in range(0, 24):
        zero_padded_hour = "{0:0=2d}".format(hour)

        # download the file (we keep retrying if there are network issues)
        # DS.UTEMP.BIN  =  TEMPERATURE ANALYSIS UNCERTAINTY
        url = base_url_temp + 'RT.' + zero_padded_hour + '/ds.utemp.bin'
        file_name = dataset + '_' + zero_padded_hour + '.bin'
        retrieved = retrieve_from_url(url, working_path + file_name)

        if not retrieved:
            continue

        # warp to match prism extent, projection, and size
        gdalwarp_file(working_path + file_name)

        src_ds = gdal.Open(working_path + file_name)
        rast_band = src_ds.GetRasterBand(1)

        # get timestamp in utc for when the raster map is valid
        band_meta_data = rast_band.GetMetadata()
        rast_utc = int(re.findall('\d+', band_meta_data["GRIB_VALID_TIME"])[0])
        rast_date = datetime.fromtimestamp(rast_utc, timezone.utc)
        table_name = "hourly_temp_uncertainty_" + str(rast_date.year)

        # create new raster with non land areas masked out
        rast_array = rast_band.ReadAsArray()
        apply_usa_mask(rast_array)
        masked_file_path = save_path + dataset + '_' + rast_date.strftime("%Y%m%d") + zero_padded_hour + '.tif'
        write_raster(masked_file_path, rast_array, -9999, src_ds.RasterXSize, src_ds.RasterYSize, src_ds.GetProjection(), src_ds.GetGeoTransform())

        # import raster to db
        rtma_import(masked_file_path, table_name, True, rast_date, rast_date.hour, dataset)
        logging.info('imported %s', masked_file_path)
        src_ds = None
        cleanup(working_path)


def compute_tmin_tmax(start_date, end_date, shift, skip_older_than_x_days, region):
    logging.info(' ')
    logging.info("-----------------populating {region} tmin/tmax based on hourly temps-----------------"
                 .format(region=region))
    # hourly_temp_path = cfg["hourly_temp_path"]
    if region == 'conus':
        tmin_save_path = cfg["daily_tmin_path"]
        tmax_save_path = cfg["daily_tmax_path"]
    elif region == 'alaska':
        tmin_save_path = cfg["daily_tmin_alaska_path"]
        tmax_save_path = cfg["daily_tmax_alaska_path"]
    os.makedirs(tmin_save_path, exist_ok=True)
    os.makedirs(tmax_save_path, exist_ok=True)

    delta = end_date - start_date
    retrieved_raster_info = False
    for i in range(delta.days + 1):
        day = start_date + timedelta(days=i)
        # tmin_file_name = 'tmin_shift_' + str(shift) + '_' + day.strftime("%Y%m%d") + '.tif'
        # tmax_file_name = 'tmax_shift_' + str(shift) + '_' + day.strftime("%Y%m%d") + '.tif'
        tmin_file_name = 'tmin_' + day.strftime("%Y%m%d") + '.tif'
        tmax_file_name = 'tmax_' + day.strftime("%Y%m%d") + '.tif'

        # skip if the file already has been imported and is older than 7 days
        today = dt.datetime.now().date()
        day_dif = (today - day).days
        if day_dif > skip_older_than_x_days and os.path.isfile(tmin_save_path + tmin_file_name) and os.path.isfile(tmax_save_path + tmax_file_name):
            continue

        # skip if day is more than 7 days into the future
        day_dif = (day - today).days
        if day_dif > 7:
            continue

        temps = []
        if region == 'conus':
            daily_tmin_table_name = "tmin_" + str(day.year)
            daily_tmax_table_name = "tmax_" + str(day.year)
        elif region == 'alaska':
            daily_tmin_table_name = "tmin_alaska_" + str(day.year)
            daily_tmax_table_name = "tmax_alaska_" + str(day.year)
        contains_urma = False
        contains_rtma = False

        for hour in range(0,24):
            shifted_hour = hour + shift
            shifted_day = day
            if shifted_hour < 0:
                shifted_hour += 24
                shifted_day -= timedelta(1)
            elif shifted_hour > 23:
                shifted_hour -= 24
                shifted_day += timedelta(1)
            # print('shifted day: ' + shifted_day.strftime("%Y%m%d"))
            # print('shifted hour: ' + str(shifted_hour))
            if region == 'conus':
                hourly_temp_table_name = 'hourly_temp_' + shifted_day.strftime("%Y")
            elif region == 'alaska':
                hourly_temp_table_name = 'hourly_temp_alaska_' + shifted_day.strftime("%Y")

            arr = get_climate_data(hourly_temp_table_name, shifted_day, shifted_hour, 'urma')
            if arr is not None:
                temps.append(arr)
                if not retrieved_raster_info:
                    (rast_cols, rast_rows, transform, projection, no_data_value) = get_raster_info(hourly_temp_table_name, shifted_day, shifted_hour, 'urma')
                    retrieved_raster_info = True
                contains_urma = True
            else:
                arr = get_climate_data(hourly_temp_table_name, shifted_day, shifted_hour, 'rtma')
                if arr is not None:
                    temps.append(arr)
                    if not retrieved_raster_info:
                        (rast_cols, rast_rows, transform, projection, no_data_value) = get_raster_info(hourly_temp_table_name, shifted_day, shifted_hour, 'rtma')
                        retrieved_raster_info = True
                    contains_rtma = True

        if len(temps) == 24:
            tmin = np.minimum.reduce(temps)
            tmax = np.maximum.reduce(temps)
            tmin[tmin == np.nan] = -9999
            tmax[tmax == np.nan] = -9999

            tmin_path = tmin_save_path + tmin_file_name
            tmax_path = tmax_save_path + tmax_file_name
            write_raster(tmin_path, tmin, -9999, tmin.shape[1], tmin.shape[0], projection, transform)
            write_raster(tmax_path, tmax, -9999, tmax.shape[1], tmax.shape[0], projection, transform)

            # save tmin/tmax rasters to the db
            if contains_rtma and contains_urma:
                source_data_string = "urma_and_rtma"
            elif contains_urma:
                source_data_string = "urma"
            else:
                source_data_string = "rtma"
            rtma_import(tmin_path, daily_tmin_table_name, False, day, None, source_data_string)
            rtma_import(tmax_path, daily_tmax_table_name, False, day, None, source_data_string)

            # add to geoserver image mosaic
            if region == 'conus':
                if table_exists('tmin'):
                    update_time_series('tmin', tmin_file_name, day)
                if table_exists('tmax'):
                    update_time_series('tmax', tmax_file_name, day)
            elif region == 'alaska':
                if table_exists('tmin_alaska'):
                    update_time_series('tmin_alaska', tmin_file_name, day)
                if table_exists('tmax_alaska'):
                    update_time_series('tmax_alaska', tmax_file_name, day)
            logging.info('imported %s based on %s data', tmin_path, source_data_string)
            logging.info('imported %s based on %s data', tmax_path, source_data_string)

        else:
            logging.warning('not enough hours to compute tmin/tmax for: %s', day.strftime("%Y%m%d"))
            logging.warning('the day only had %s hourly temps recorded', str(len(temps)))


# This function was for beginning of year 2017 when alaska code was not yet written and we needed to temporarily
# collect urma data without processing. It is not part of the normal workflow.
def import_missed_alaska_urma(year, month, day):
    logging.info(' ')
    logging.info("-----------------populating missed alaska urma data-----------------")
    alaska_save_path2 = cfg["alaska_save_path"] # temp holding place for raw urma data
    if year:
        alaska_save_path2 += "{year}0{month}0{day}/".format(year=year, month=month, day=day)
    save_path = cfg["hourly_temp_alaska_path"] # path where processed imported urma data
    os.makedirs(save_path, exist_ok=True)
    os.makedirs(alaska_save_path2, exist_ok=True)
    logging.info("searching for files in: " + alaska_save_path2 + 'akurma*z.2dvaranl_ndfd_3p0.grb2')

    for file_path in glob.iglob(alaska_save_path2 + 'akurma*z.2dvaranl_ndfd_3p0.grb2'):
        file_name = os.path.basename(file_path)
        unmasked_file_path = file_path
        masked_file_path = file_path + '_masked'

        apply_alaska_mask(unmasked_file_path, masked_file_path)

        if not year:
            year = file_name[5:9]
            month = file_name[9:11]
            day = file_name[11:13]
            hour = int(file_name[13:15])
        else:
            hour = re.search(r'\d\d', file_name).group()

        # urma_date = datetime.strptime(year + month + day, '%Y%m%d')
        urma_date = datetime.date(year, month, day)
        hourly_table_name = "hourly_temp_alaska_" + year

        ds = gdal.Open(masked_file_path)

        temp_band_found = False
        band3 = ds.GetRasterBand(3)

        if band3 is not None:
            mean = band3.GetStatistics(0, 1)[2]
            if -30 < mean < 50:
                temps_array = band3.ReadAsArray()
                temp_band_found = True
        if not temp_band_found:
            logging.warning('temperature band not found!!!!')

        if temp_band_found:
            projection = ds.GetProjection()
            transform = ds.GetGeoTransform()

            #masked_tif_file_path = save_path + file_name + '.tif'
            masked_tif_file_path = save_path + 'urma_' + str(year) + str(month) + str(day) + str(hour) + '.tif'

            write_raster(masked_tif_file_path, temps_array, -9999, temps_array.shape[1], temps_array.shape[0],
                         projection, transform)

            # import raster into database
            rtma_import(masked_tif_file_path, hourly_table_name, True, urma_date, hour, 'urma')
        ds = None


def download_historic_climate_data(start_date, end_date, dataset, region):
    logging.info(' ')
    logging.info("-----------------populating historic {region} {dataset} data-----------------"
                 .format(region=region, dataset=dataset))
    working_path = cfg["temp_path"]
    alaska_save_path = cfg["alaska_save_path"]
    if region == 'conus':
        save_path = cfg["hourly_temp_path"]
    else:
        save_path = cfg["hourly_temp_alaska_path"]
    tmin_save_path = cfg["daily_tmin_path"]
    tmax_save_path = cfg["daily_tmin_path"]
    os.makedirs(working_path, exist_ok=True)
    os.makedirs(save_path, exist_ok=True)
    os.makedirs(tmin_save_path, exist_ok=True)
    os.makedirs(tmax_save_path, exist_ok=True)
    os.makedirs(alaska_save_path, exist_ok=True)
    cleanup(working_path)

    if dataset == 'urma' and region == 'conus':
        base_url_temp = 'ftp://ftp.ncep.noaa.gov/pub/data/nccf/com/urma/prod/urma2p5.'
    elif dataset == 'urma' and region == 'alaska':
        base_url_temp = 'ftp://ftp.ncep.noaa.gov/pub/data/nccf/com/urma/prod/akurma.'
    elif dataset == 'rtma':
        base_url_temp = 'http://nomads.ncdc.noaa.gov/data/ndgd/'
    else:
        return

    delta = end_date - start_date
    year = None
    previous_file_name = None

    for i in range(delta.days + 1):
        day = start_date + timedelta(days=i)

        # data is only historical, never look for today or in the future
        if day >= dt.datetime.today().date():
            continue

        # hit a new year
        if year != day.year:
            year = day.year

        if region == 'alaska':
            hourly_table_name = "hourly_temp_alaska_" + str(year)
        else:
            hourly_table_name = "hourly_temp_" + str(year)

        day_unavailable = False
        for hour in range(0, 24):
            if day_unavailable:
                break

            zero_padded_hour = "{0:0=2d}".format(hour)
            if dataset == 'urma' and region == 'conus':
                url_file_name = 'urma2p5.t' + zero_padded_hour + 'z.2dvaranl_ndfd.grb2'
            elif dataset == 'urma' and region == 'alaska':
                url_file_name = 'akurma.t' + zero_padded_hour + 'z.2dvaranl_ndfd_3p0.grb2'
            elif dataset == 'rtma' and region == 'conus':
                url_file_name = 'LTIA98_KWBR_' + day.strftime("%Y%m%d") + zero_padded_hour + "00"
            elif dataset == 'rtma' and region == 'alaska':
                url_file_name = 'LTAA98_KWBR_' + day.strftime("%Y%m%d") + zero_padded_hour + "00"

            if dataset == 'urma':
                url = base_url_temp + day.strftime("%Y%m%d") + '/' + url_file_name
            elif dataset == 'rtma':
                url = base_url_temp + day.strftime("%Y%m") + '/' + day.strftime("%Y%m%d") + '/' + url_file_name

            file_name = dataset + '_' + day.strftime("%Y%m%d") + zero_padded_hour

            # skip if the file already has been imported
            if os.path.isfile(save_path + file_name + '.tif'):
                previous_file_name = file_name
                continue

            retrieved = False
            file_not_found = False
            while not retrieved and not file_not_found:
                try:
                    logging.info('downloading %s to %s', url, working_path + file_name)
                    urlretrieve(url, working_path + file_name)
                except urllib.error.URLError as e:
                    if "550 Failed to change directory" in str(e):
                        logging.warning("That day is currently not available, moving onto next day.", str(e))
                        day_unavailable = True
                        file_not_found = True
                    elif str(e) == "HTTP Error 404: Not Found":
                        logging.warning("file not found so copying last retrieved hour to this hour: %s", str(e))
                        file_not_found = True
                    else:
                        logging.warning("couldn't retrieve file (retrying): %s", str(e))
                except urllib.error.ContentTooShortError as e:
                    logging.warning("couldn't retrieve file (retrying): %s", str(e))
                else:
                    retrieved = True

            if retrieved:
                file_size = os.path.getsize(working_path + file_name)
                if file_size == 0:
                    os.remove(working_path + file_name)
                    logging.warning("retrieved file has file size: %s so copying last retrieved hour to this hour", str(file_size))
                    retrieved = False

            if retrieved:

                # todo eventually remove this, just here to save source alaska data while getting things right
                if region == 'alaska':
                    copy(working_path + file_name, alaska_save_path + file_name)

                # warp the downloaded raster to EPSG 4269
                # for alaska warping and masking happen at the same time, this is because by the time we got to
                # implementing alaska we learned how to use a shapefile instead of a tif to do the masking
                if region == 'conus':
                    gdalwarp_file(working_path + file_name)
                elif region == 'alaska':
                    os.rename(working_path + file_name, working_path + file_name + '_maskme')
                    apply_alaska_mask(working_path + file_name + '_maskme', working_path + file_name)

                ds = gdal.Open(working_path + file_name)

                # hack to grab the temp band rather than the temp error band
                # by checking if the mean temp makes any sense (between -30 and 50 celsius)
                # todo find a better way
                temp_band_found = False
                band1 = None
                band2 = None
                band3 = None
                if dataset == 'rtma':
                    band1 = ds.GetRasterBand(1)
                    band2 = ds.GetRasterBand(2)
                if dataset == 'urma':
                    band3 = ds.GetRasterBand(3)
                if band1 is not None:
                    mean = band1.GetStatistics(0, 1)[2]
                    if -30 < mean < 50:
                        temps_array = band1.ReadAsArray()
                        temp_band_found = True
                if band2 is not None:
                    mean = band2.GetStatistics(0, 1)[2]
                    if -30 < mean < 50:
                        temps_array = band2.ReadAsArray()
                        temp_band_found = True
                if band3 is not None:
                    mean = band3.GetStatistics(0, 1)[2]
                    if -30 < mean < 50:
                        temps_array = band3.ReadAsArray()
                        temp_band_found = True
                if not temp_band_found:
                    logging.warning('temperature band not found, using previous hour')

                if temp_band_found:
                    projection = ds.GetProjection()
                    transform = ds.GetGeoTransform()

                    masked_file_path = save_path + file_name + '.tif'
                    # mask out non land areas for conus (it's already done for alaska at this point)
                    if region == 'conus':
                        apply_usa_mask(temps_array)
                    # write the tif file to disk
                    write_raster(masked_file_path, temps_array, -9999, temps_array.shape[1], temps_array.shape[0],
                                 projection, transform)
                    # import raster into database
                    rtma_import(masked_file_path, hourly_table_name, True, day, hour, dataset)

            if not day_unavailable and (not retrieved or not temp_band_found):
                if previous_file_name == None:
                    logging.warning("the first file you tried to retrieve either doesn't exist or doesn't have a temp band. Try rerunning this script starting with an earlier date.")
                    return
                # copy last successfully retrieved temp band in place of the missing hour
                copy(save_path + previous_file_name + '.tif', save_path + file_name + '.tif')
                rtma_import(save_path + file_name + '.tif', hourly_table_name, True, day, hour, dataset)
                logging.info('imported %s', save_path + file_name + '.tif')

            previous_file_name = file_name
            ds = None
            cleanup(working_path)


def rtma_import(rast_path, table_name, hourly, date, hour, dataset):
    curs = conn.cursor()
    new_table = not table_exists(table_name)

    save_raster_to_postgis(rast_path, table_name, None)

    if new_table:
        # create entry in mosaic table (for geoserver to work)
        # add_mosaic_entry(table_name, -2764486.928, -265060.521, 2683176.007, 3232110.510, 2539.703000000000000, 2539.703000000000000)
        #add_mosaic_entry(table_name, -130.1228935, 52.8168964, -60.8601260, 20.1788770, 0.026578191679851, 0.026578191679851)

        # add rast_date and possible rast_hour columns
        query = "ALTER TABLE %(table)s ADD rast_date DATE;"
        curs.execute(query, {"table": AsIs(table_name)})
        query = "ALTER TABLE %(table)s ADD dataset TEXT;"
        curs.execute(query, {"table": AsIs(table_name)})
        query = "CREATE INDEX ON %(table)s (rast_date);"
        curs.execute(query, {"table": AsIs(table_name)})
        query = "CREATE INDEX ON %(table)s (filename);"
        curs.execute(query, {"table": AsIs(table_name)})
        if hourly:
            query = "ALTER TABLE %(table)s ADD rast_hour INTEGER;"
            curs.execute(query, {"table": AsIs(table_name)})
        conn.commit()

    query = "UPDATE %(table)s SET rast_date = to_date(%(rast_date)s, 'YYYYMMDD') WHERE rast_date IS NULL;"
    data = {"table": AsIs(table_name), "rast_date": date.strftime("%Y%m%d")}
    curs.execute(query, data)

    if hourly:
        query = "UPDATE %(table)s SET rast_hour = %(rast_hour)s WHERE rast_hour IS NULL;"
        data = {"table": AsIs(table_name), "rast_hour": "{0:0=2d}".format(hour)}
        curs.execute(query, data)

    query = "UPDATE %(table)s SET dataset = %(dataset)s WHERE dataset IS NULL;"
    data = {"table": AsIs(table_name), "dataset": dataset}
    curs.execute(query, data)

    conn.commit()


def get_raster_info(table_name, rast_date, hour, data_set):
    try:
        vsipath = '/vsimem/from_postgis'

        curs = conn.cursor()

        gdal.Unlink(vsipath)
        query = "SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff') FROM %s WHERE rast_date = %s AND rast_hour = %s AND dataset = %s;"
        data = (AsIs(table_name), rast_date.strftime("%Y%m%d"), hour, data_set)
        curs.execute(query, data)

        result = curs.fetchone()
        if result[0] == 0:
            curs.close()
            return None

        gdal.FileFromMemBuffer(vsipath, bytes(result[0]))

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
    except Exception as e:
        gdal.Unlink(vsipath)
        return None


def get_climate_data(table_name, date, hour, data_set):
    try:
        # Load raster from postgis into a virtual memory file
        vsipath = '/vsimem/from_postgis'

        curs = conn.cursor()

        query = "SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff') FROM %s WHERE rast_date = %s AND rast_hour = %s AND dataset = %s;"
        data = (AsIs(table_name), date.strftime("%Y%m%d"), hour, data_set)
        curs.execute(query, data)

        result = curs.fetchone()
        if result[0] is None:
            curs.close()
            return None

        gdal.FileFromMemBuffer(vsipath, bytes(result[0]))

        curs.close()

        # Read first band of raster with GDAL
        ds = gdal.Open(vsipath)
        band = ds.GetRasterBand(1)

        outarray = band.ReadAsArray()

        # Close and clean up virtual memory file
        gdal.Unlink(vsipath)

        # convert -9999 values to not a number so we don't have to worry about manipulating them
        outarray[outarray == -9999.0] = np.nan

        return outarray
    except Exception as e:
        return None


def gdalwarp_file(bin_file):
    if '.bin' in bin_file:
        temp_file = str.replace(bin_file, ".bin", "_warpme.bin")
    else:
        temp_file = bin_file + "_warpme.bin"
    os.rename(bin_file, temp_file)

    extent = "-125.0208333 24.0625000 -66.4791667 49.9375000"
    warp_command = "gdalwarp -of ENVI -srcnodata 9999 -dstnodata -9999 -t_srs EPSG:4269 -ts 2606 1228 -te {extent} {source_file} {dest_file}"\
        .format(extent=extent, source_file=temp_file, dest_file=bin_file)

    ps = subprocess.Popen(warp_command, stdout=subprocess.PIPE, shell=True)
    ps.wait()
    os.remove(temp_file)


def cleanup(path):
    for file in glob.glob(path + "*"):
        os.remove(file)


if __name__ == "__main__":
    download_hourly_temps()
