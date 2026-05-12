#!/usr/bin/python3
"""
Compute daily Spring Index (SI-X) rasters from PRISM tmin/tmax files.

This script reads PRISM climate data from the filesystem:
  - /geo-data/climate_data/prism/prism_tmin/prism_tmin_us_25m_YYYYMMDD.tif
  - /geo-data/climate_data/prism/prism_tmax/prism_tmax_us_25m_YYYYMMDD.tif

And outputs daily Spring Index rasters to:
  - /geo-data/gridded_models/new/spring_index/six_{plant}_{phenophase}/

For three plant species (lilac, arnoldred, zabelli) and two phenophases (leaf, bloom),
plus averaged predictions across all three species.

Incremental Mode:
  Use --incremental flag to continue from the most recent SI-X file instead of
  recomputing from January 1st. This is efficient for nightly updates where you
  only need to process new days.

  Example nightly usage:
    python3 compute_prism_six.py 2026 --incremental
"""

import os
import sys
import logging
import glob
import re
from datetime import datetime, date, timedelta
from osgeo import gdal
import numpy as np
from spring_index.spring_index import spring_index
from util.database import update_time_series

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

# Configuration
BASE_OUTPUT_DIR = "/geo-data/gridded_models/new/spring_index"
PRISM_TMIN_DIR = "/geo-data/climate_data/prism/prism_tmin"
PRISM_TMAX_DIR = "/geo-data/climate_data/prism/prism_tmax"

# 30-year average paths for anomaly computation
AVG_SIX_LEAF_DIR = "/geo-data/gridded_models/avg_spring_index/six_30yr_average_4k_leaf"
AVG_SIX_BLOOM_DIR = "/geo-data/gridded_models/avg_spring_index/six_30yr_average_4k_bloom"

# Image mosaic table names for Geoserver
IMAGE_MOSAIC_TABLES = {
    'average_leaf': 'six_average_leaf_ncep',
    'average_bloom': 'six_average_bloom_ncep',
    'leaf_anomaly': 'six_leaf_anomaly',
    'bloom_anomaly': 'six_bloom_anomaly',
}

# Spring Index configuration
BASE_TEMP = 31  # Base temperature for Spring Index (matches driver.Six.base_temp)
PLANTS = ['lilac', 'arnoldred', 'zabelli']
PHENOPHASES = ['leaf', 'bloom']


def get_prism_file_path(data_type, date_obj):
    """
    Get the file path for a PRISM tmin or tmax file.

    Args:
        data_type: 'tmin' or 'tmax'
        date_obj: datetime.date object

    Returns:
        Full path to the PRISM file
    """
    date_str = date_obj.strftime("%Y%m%d")
    if data_type == 'tmin':
        return os.path.join(PRISM_TMIN_DIR, f"prism_tmin_us_25m_{date_str}.tif")
    elif data_type == 'tmax':
        return os.path.join(PRISM_TMAX_DIR, f"prism_tmax_us_25m_{date_str}.tif")
    else:
        raise ValueError(f"Invalid data_type: {data_type}. Must be 'tmin' or 'tmax'")


def read_prism_raster(file_path, convert_to_fahrenheit=False):
    """
    Read a PRISM raster file and return as numpy array.

    Args:
        file_path: Path to the geotiff file
        convert_to_fahrenheit: If True, convert from Celsius to Fahrenheit

    Returns:
        tuple: (data_array, projection, transform, no_data_value, cols, rows)
    """
    if not os.path.exists(file_path):
        logging.error(f"File not found: {file_path}")
        return None

    try:
        dataset = gdal.Open(file_path)
        if dataset is None:
            logging.error(f"Could not open file: {file_path}")
            return None

        band = dataset.GetRasterBand(1)
        data_array = band.ReadAsArray()
        no_data_value = band.GetNoDataValue()

        projection = dataset.GetProjection()
        transform = dataset.GetGeoTransform()
        cols = dataset.RasterXSize
        rows = dataset.RasterYSize

        # Convert no data values to NaN for easier manipulation
        if no_data_value is not None:
            data_array = data_array.astype(np.float32)
            data_array[data_array == no_data_value] = np.nan

        # Convert from Celsius to Fahrenheit if requested
        if convert_to_fahrenheit:
            # F = C * 1.8 + 32
            data_array = data_array * 1.8 + 32.0

        dataset = None  # Close the dataset

        return data_array, projection, transform, no_data_value if no_data_value else -9999, cols, rows

    except Exception as e:
        logging.error(f"Error reading raster {file_path}: {e}")
        return None


def find_latest_prism_date(year):
    """
    Find the most recent date for which PRISM data is available.

    Args:
        year: Year to search

    Returns:
        datetime.date object or None if no data found
    """
    start_date = date(year, 1, 1)
    current_date = date.today()

    # Don't search beyond today
    if start_date.year < current_date.year:
        end_date = date(year, 12, 31)
    else:
        end_date = current_date

    # Search backwards from end_date to find most recent available data
    check_date = end_date
    while check_date >= start_date:
        tmin_path = get_prism_file_path('tmin', check_date)
        tmax_path = get_prism_file_path('tmax', check_date)

        if os.path.exists(tmin_path) and os.path.exists(tmax_path):
            return check_date

        check_date -= timedelta(days=1)

    return None


def get_six_output_path(plant, phenophase, output_date):
    """
    Get the output file path for a Spring Index raster.

    Args:
        plant: Plant name (lilac, arnoldred, zabelli, or average)
        phenophase: Phenophase (leaf or bloom)
        output_date: datetime.date object

    Returns:
        Full path to the output file
    """
    folder_name = f"six_{plant}_{phenophase}"
    output_dir = os.path.join(BASE_OUTPUT_DIR, folder_name)
    os.makedirs(output_dir, exist_ok=True)

    date_str = output_date.strftime("%Y%m%d")
    filename = f"{plant}_{phenophase}_{date_str}.tif"

    return os.path.join(output_dir, filename)


def get_anomaly_output_path(phenophase, output_date):
    """
    Get the output file path for a Spring Index anomaly raster.

    Args:
        phenophase: Phenophase (leaf or bloom)
        output_date: datetime.date object

    Returns:
        Full path to the anomaly output file
    """
    folder_name = f"six_{phenophase}_anomaly"
    output_dir = os.path.join(BASE_OUTPUT_DIR, folder_name)
    os.makedirs(output_dir, exist_ok=True)

    date_str = output_date.strftime("%Y%m%d")
    filename = f"six_{phenophase}_anomaly_{date_str}.tif"

    return os.path.join(output_dir, filename)


def load_30yr_average_raster(phenophase, day_of_year):
    """
    Load the 30-year average Spring Index raster for a given day of year.

    Args:
        phenophase: Phenophase (leaf or bloom)
        day_of_year: Day of year (1-365)

    Returns:
        tuple: (avg_array, projection, transform, no_data_value, cols, rows) or None if file not found
    """
    if phenophase == 'leaf':
        avg_dir = AVG_SIX_LEAF_DIR
    else:
        avg_dir = AVG_SIX_BLOOM_DIR

    avg_file = os.path.join(avg_dir, f"six_average_unwarped_{phenophase}_{day_of_year}.tif")

    if not os.path.exists(avg_file):
        logging.warning(f"30-year average file not found: {avg_file}")
        return None

    try:
        dataset = gdal.Open(avg_file)
        if dataset is None:
            logging.error(f"Could not open 30-year average file: {avg_file}")
            return None

        band = dataset.GetRasterBand(1)
        avg_array = band.ReadAsArray()
        no_data_value = band.GetNoDataValue()

        projection = dataset.GetProjection()
        transform = dataset.GetGeoTransform()
        cols = dataset.RasterXSize
        rows = dataset.RasterYSize

        # Convert no data values to NaN
        avg_array = avg_array.astype(np.float32)
        if no_data_value is not None:
            avg_array[avg_array == no_data_value] = np.nan
        avg_array[avg_array == -9999] = np.nan

        dataset = None

        return avg_array, projection, transform, no_data_value if no_data_value else -9999, cols, rows

    except Exception as e:
        logging.error(f"Error reading 30-year average raster {avg_file}: {e}")
        return None


def parse_date_from_six_filename(filename):
    """
    Parse date from Spring Index filename.

    Args:
        filename: Filename like 'lilac_leaf_20260108.tif'

    Returns:
        datetime.date object or None if parsing fails
    """
    # Pattern: {plant}_{phenophase}_YYYYMMDD.tif
    match = re.match(r'(\w+)_(\w+)_(\d{8})\.tif', filename)
    if match:
        date_str = match.group(3)
        try:
            return datetime.strptime(date_str, "%Y%m%d").date()
        except ValueError:
            return None
    return None


def find_most_recent_six_file(year, plant, phenophase):
    """
    Find the most recent Spring Index file for a given year, plant, and phenophase.

    Args:
        year: Year to search
        plant: Plant name
        phenophase: Phenophase (leaf or bloom)

    Returns:
        tuple: (most_recent_date, file_path) or (None, None) if no files found
    """
    folder_name = f"six_{plant}_{phenophase}"
    output_dir = os.path.join(BASE_OUTPUT_DIR, folder_name)

    if not os.path.exists(output_dir):
        return None, None

    # Get all SI-X files for this year
    pattern = os.path.join(output_dir, f"{plant}_{phenophase}_{year}*.tif")
    files = glob.glob(pattern)

    if not files:
        return None, None

    # Parse dates and find the most recent
    most_recent_date = None
    most_recent_file = None

    for file_path in files:
        filename = os.path.basename(file_path)
        file_date = parse_date_from_six_filename(filename)

        if file_date and file_date.year == year:
            if most_recent_date is None or file_date > most_recent_date:
                most_recent_date = file_date
                most_recent_file = file_path

    return most_recent_date, most_recent_file


def write_int16_raster(file_path, rast_array, no_data_value, rast_cols, rast_rows, projection, transform):
    """
    Write a 16-bit signed integer raster to disk.

    Args:
        file_path: Output file path
        rast_array: Numpy array to write
        no_data_value: No data value
        rast_cols: Number of columns
        rast_rows: Number of rows
        projection: GDAL projection string
        transform: GDAL geotransform tuple
    """
    driver = gdal.GetDriverByName('Gtiff')
    raster = driver.Create(file_path, rast_cols, rast_rows, 1, gdal.GDT_Int16)
    band = raster.GetRasterBand(1)
    band.SetNoDataValue(no_data_value)
    band.WriteArray(rast_array)
    raster.SetProjection(projection)
    raster.SetGeoTransform(transform)
    band.FlushCache()
    raster = None  # Close the raster


def load_prism_climate_data(start_date, end_date):
    """
    Load PRISM tmin and tmax data from filesystem for the date range.

    Args:
        start_date: Start date (datetime.date)
        end_date: End date (datetime.date)

    Returns:
        tuple: (min_temps, max_temps, projection, geo_transform, no_data_value, cols, rows, ydim)
        where min_temps and max_temps are 3D arrays (num_lats, num_longs, num_days)
    """
    num_days = (end_date - start_date).days + 1

    # Limit to day 240 (Spring Index convention)
    if num_days > 240:
        num_days = 240
        end_date = start_date + timedelta(days=239)

    logging.info(f"Loading PRISM data for {num_days} days from {start_date.strftime('%Y-%m-%d')} to {end_date.strftime('%Y-%m-%d')}")

    min_temps = None
    max_temps = None
    projection = None
    geo_transform = None
    no_data_value = -9999
    cols = None
    rows = None
    ydim = None

    # Load tmin data
    for day in range(num_days):
        current_date = start_date + timedelta(days=day)
        tmin_path = get_prism_file_path('tmin', current_date)

        if not os.path.exists(tmin_path):
            logging.error(f"Missing tmin file: {tmin_path}")
            return None

        result = read_prism_raster(tmin_path, convert_to_fahrenheit=True)
        if result is None:
            logging.error(f"Failed to read tmin file: {tmin_path}")
            return None

        tmin_array, proj, transform, nodata, c, r = result

        # Initialize arrays on first iteration
        if day == 0:
            projection = proj
            geo_transform = transform
            no_data_value = nodata
            cols = c
            rows = r
            ydim = -transform[5]  # pixel height (negative of y_size)

            # Initialize 3D arrays (days, rows, cols)
            min_temps = np.empty((num_days, rows, cols), dtype=np.float32)
            max_temps = np.empty((num_days, rows, cols), dtype=np.float32)

        min_temps[day] = tmin_array

    # Load tmax data
    for day in range(num_days):
        current_date = start_date + timedelta(days=day)
        tmax_path = get_prism_file_path('tmax', current_date)

        if not os.path.exists(tmax_path):
            logging.error(f"Missing tmax file: {tmax_path}")
            return None

        result = read_prism_raster(tmax_path, convert_to_fahrenheit=True)
        if result is None:
            logging.error(f"Failed to read tmax file: {tmax_path}")
            return None

        tmax_array, _, _, _, _, _ = result
        max_temps[day] = tmax_array

    # Reshape arrays to (num_lats, num_longs, num_days) as expected by spring_index()
    # Current shape: (num_days, rows, cols) = (num_days, num_lats, num_longs)
    # Target shape: (num_lats, num_longs, num_days)
    min_temps = np.swapaxes(min_temps, 1, 0)  # (rows, days, cols)
    min_temps = np.swapaxes(min_temps, 2, 1)  # (rows, cols, days) = (num_lats, num_longs, num_days)

    max_temps = np.swapaxes(max_temps, 1, 0)  # (rows, days, cols)
    max_temps = np.swapaxes(max_temps, 2, 1)  # (rows, cols, days) = (num_lats, num_longs, num_days)

    # Convert -9999 to NaN (spring_index expects NaN for no data)
    min_temps[min_temps == -9999.0] = np.nan
    max_temps[max_temps == -9999.0] = np.nan

    return min_temps, max_temps, projection, geo_transform, no_data_value, cols, rows, ydim


def compute_six_for_year(year, incremental=False):
    """
    Compute Spring Index for an entire year.

    Args:
        year: Year to process (integer)
        incremental: If True, continue from most recent SI-X file; if False, recompute from Jan 1

    Returns:
        None (writes files to disk)
    """
    logging.info(f"Computing Spring Index for year {year} (incremental={incremental})")

    # Determine date range
    start_date = date(year, 1, 1)

    # Find the latest date with PRISM data
    latest_prism_date = find_latest_prism_date(year)

    if latest_prism_date is None:
        logging.error(f"No PRISM data found for year {year}")
        return

    logging.info(f"Latest PRISM data available: {latest_prism_date.strftime('%Y-%m-%d')}")

    # Spring Index calculations stop at day 250 (September 7)
    day_250 = start_date + timedelta(days=250)
    end_date = min(latest_prism_date, day_250)

    logging.info(f"Computing Spring Index from {start_date.strftime('%Y-%m-%d')} to {end_date.strftime('%Y-%m-%d')}")

    # Check if we should skip computation in incremental mode
    if incremental:
        # Find the most recent SI-X file across all plants/phenophases
        most_recent_overall = None

        for plant in PLANTS:
            for phenophase in PHENOPHASES:
                recent_date, _ = find_most_recent_six_file(year, plant, phenophase)
                if recent_date:
                    if most_recent_overall is None or recent_date > most_recent_overall:
                        most_recent_overall = recent_date

        if most_recent_overall and most_recent_overall >= end_date:
            logging.info(f"Incremental mode: All Spring Index files up to date (most recent: {most_recent_overall.strftime('%Y-%m-%d')})")
            return
        elif most_recent_overall:
            logging.info(f"Incremental mode: Most recent Spring Index is {most_recent_overall.strftime('%Y-%m-%d')}, will compute through {end_date.strftime('%Y-%m-%d')}")

    # Load climate data from filesystem
    logging.info("Loading PRISM climate data from filesystem...")
    result = load_prism_climate_data(start_date, end_date)

    if result is None:
        logging.error("Failed to load PRISM climate data")
        return

    min_temps, max_temps, projection, geo_transform, no_data_value, cols, rows, ydim = result

    # Calculate latitudes for each row
    (upper_left_x, x_size, x_rotation, upper_left_y, y_rotation, y_size) = geo_transform
    num_lats = max_temps.shape[0]
    site_latitudes = np.arange(num_lats, dtype=float)
    site_latitudes *= -ydim
    site_latitudes += upper_left_y

    # Initialize average arrays
    leaf_average_array = None
    bloom_average_array = None

    # Compute Spring Index for each plant
    logging.info("Computing Spring Index for individual plants...")
    for plant in PLANTS:
        logging.info(f"Computing Spring Index for {plant}...")

        # Compute leaf phenophase
        logging.info(f"  Computing {plant} leaf...")
        leaf_array = spring_index(max_temps, min_temps, BASE_TEMP, None, 'leaf', plant, site_latitudes)

        # Add to average (copy to avoid negative values affecting average)
        leaf_copy = np.copy(leaf_array)
        leaf_copy[leaf_copy < 0] = np.nan
        if leaf_average_array is None:
            leaf_average_array = leaf_copy
        else:
            leaf_average_array = leaf_average_array + leaf_copy

        # Save daily leaf rasters
        num_days = (end_date - start_date).days + 1
        for i in range(num_days):
            day = start_date + timedelta(days=i)
            day_of_year = day.timetuple().tm_yday

            # Prepare output array
            out_array = np.copy(leaf_array)
            out_array[out_array > day_of_year] = -9999
            out_array[np.isnan(out_array)] = -9999
            out_array = out_array.astype(np.int16)

            # Write raster
            file_path = get_six_output_path(plant, 'leaf', day)
            write_int16_raster(file_path, out_array, no_data_value, cols, rows, projection, geo_transform)

        logging.info(f'  Saved {plant} leaf rasters')

        # Compute bloom phenophase
        logging.info(f"  Computing {plant} bloom...")
        bloom_array = spring_index(max_temps, min_temps, BASE_TEMP, leaf_array, 'bloom', plant, site_latitudes)

        # Add to average
        bloom_copy = np.copy(bloom_array)
        bloom_copy[bloom_copy < 0] = np.nan
        if bloom_average_array is None:
            bloom_average_array = bloom_copy
        else:
            bloom_average_array = bloom_average_array + bloom_copy

        # Save daily bloom rasters
        for i in range(num_days):
            day = start_date + timedelta(days=i)
            day_of_year = day.timetuple().tm_yday

            # Prepare output array
            out_array = np.copy(bloom_array)
            out_array[out_array > day_of_year] = -9999
            out_array[np.isnan(out_array)] = -9999
            out_array = out_array.astype(np.int16)

            # Write raster
            file_path = get_six_output_path(plant, 'bloom', day)
            write_int16_raster(file_path, out_array, no_data_value, cols, rows, projection, geo_transform)

        logging.info(f'  Saved {plant} bloom rasters')

    # Compute and save averages
    logging.info("Computing average Spring Index...")
    leaf_average_array /= len(PLANTS)
    bloom_average_array /= len(PLANTS)

    # Save average leaf rasters
    for i in range(num_days):
        day = start_date + timedelta(days=i)
        day_of_year = day.timetuple().tm_yday

        # Prepare output array
        out_array = np.copy(leaf_average_array)
        out_array[out_array > day_of_year] = -9999
        out_array[np.isnan(out_array)] = -9999
        out_array = out_array.astype(np.int16)

        # Write raster
        file_path = get_six_output_path('average', 'leaf', day)
        write_int16_raster(file_path, out_array, no_data_value, cols, rows, projection, geo_transform)

        # Update image mosaic table
        update_time_series(IMAGE_MOSAIC_TABLES['average_leaf'], os.path.basename(file_path), day)

    logging.info('Saved average leaf rasters')

    # Save average bloom rasters
    for i in range(num_days):
        day = start_date + timedelta(days=i)
        day_of_year = day.timetuple().tm_yday

        # Prepare output array
        out_array = np.copy(bloom_average_array)
        out_array[out_array > day_of_year] = -9999
        out_array[np.isnan(out_array)] = -9999
        out_array = out_array.astype(np.int16)

        # Write raster
        file_path = get_six_output_path('average', 'bloom', day)
        write_int16_raster(file_path, out_array, no_data_value, cols, rows, projection, geo_transform)

        # Update image mosaic table
        update_time_series(IMAGE_MOSAIC_TABLES['average_bloom'], os.path.basename(file_path), day)

    logging.info('Saved average bloom rasters')

    # Compute and save anomaly rasters for average leaf and bloom
    logging.info("Computing Spring Index anomalies...")

    # Compute leaf anomalies
    for i in range(num_days):
        day = start_date + timedelta(days=i)
        day_of_year = day.timetuple().tm_yday

        # Load 30-year average for this day of year
        #note actually do this for doy 365
        avg_result = load_30yr_average_raster('leaf', 365)
        if avg_result is None:
            logging.warning(f"Skipping leaf anomaly for {day.strftime('%Y-%m-%d')} - no 30-year average available")
            continue

        avg_array, _, _, _, _, _ = avg_result

        # Prepare current SI-X array (mask values > day_of_year as in the average raster output)
        current_six = np.copy(leaf_average_array)
        current_six[current_six > day_of_year] = np.nan

        # Compute anomaly: current - average (negative = early, positive = late)
        anomaly = current_six - avg_array
        anomaly[np.isnan(anomaly)] = -9999
        anomaly = anomaly.astype(np.int16)

        # Write anomaly raster
        anomaly_path = get_anomaly_output_path('leaf', day)
        write_int16_raster(anomaly_path, anomaly, -9999, cols, rows, projection, geo_transform)

        # Update image mosaic table
        update_time_series(IMAGE_MOSAIC_TABLES['leaf_anomaly'], os.path.basename(anomaly_path), day)

    logging.info('Saved leaf anomaly rasters')

    # Compute bloom anomalies
    for i in range(num_days):
        day = start_date + timedelta(days=i)
        day_of_year = day.timetuple().tm_yday

        # Load 30-year average for this day of year
        # note actually do this for doy 365
        avg_result = load_30yr_average_raster('bloom', 365)
        if avg_result is None:
            logging.warning(f"Skipping bloom anomaly for {day.strftime('%Y-%m-%d')} - no 30-year average available")
            continue

        avg_array, _, _, _, _, _ = avg_result

        # Prepare current SI-X array (mask values > day_of_year as in the average raster output)
        current_six = np.copy(bloom_average_array)
        current_six[current_six > day_of_year] = np.nan

        # Compute anomaly: current - average (negative = early, positive = late)
        anomaly = current_six - avg_array
        anomaly[np.isnan(anomaly)] = -9999
        anomaly = anomaly.astype(np.int16)

        # Write anomaly raster
        anomaly_path = get_anomaly_output_path('bloom', day)
        write_int16_raster(anomaly_path, anomaly, -9999, cols, rows, projection, geo_transform)

        # Update image mosaic table
        update_time_series(IMAGE_MOSAIC_TABLES['bloom_anomaly'], os.path.basename(anomaly_path), day)

    logging.info('Saved bloom anomaly rasters')

    logging.info("Spring Index computation complete!")


def compute_six_for_date_range(start_date, end_date, incremental=False):
    """
    Compute Spring Index for a date range.

    Note: Spring Index is cumulative from Jan 1, so we always load data from Jan 1
    but only save rasters for the requested date range.

    Args:
        start_date: Start date (datetime.date)
        end_date: End date (datetime.date)
        incremental: If True, skip computation if files already exist

    Returns:
        None (writes files to disk)
    """
    logging.info(f"Computing Spring Index from {start_date} to {end_date} (incremental={incremental})")

    if start_date.year != end_date.year:
        logging.error("Start and end dates must be in the same year")
        return

    year = start_date.year

    # Find the latest date with PRISM data
    latest_prism_date = find_latest_prism_date(year)

    if latest_prism_date is None:
        logging.error(f"No PRISM data found for year {year}")
        return

    # Limit end_date to available data and day 250
    day_250 = date(year, 1, 1) + timedelta(days=250)
    end_date = min(end_date, latest_prism_date, day_250)

    logging.info(f"Computing Spring Index from {start_date.strftime('%Y-%m-%d')} to {end_date.strftime('%Y-%m-%d')}")

    # Check if we should skip computation in incremental mode
    if incremental:
        most_recent_overall = None

        for plant in PLANTS:
            for phenophase in PHENOPHASES:
                recent_date, _ = find_most_recent_six_file(year, plant, phenophase)
                if recent_date:
                    if most_recent_overall is None or recent_date > most_recent_overall:
                        most_recent_overall = recent_date

        if most_recent_overall and most_recent_overall >= end_date:
            logging.info(f"Incremental mode: All Spring Index files up to date (most recent: {most_recent_overall.strftime('%Y-%m-%d')})")
            return

    # Always load from Jan 1 (Spring Index is cumulative)
    year_start = date(year, 1, 1)

    # Load climate data from filesystem
    logging.info("Loading PRISM climate data from filesystem...")
    result = load_prism_climate_data(year_start, end_date)

    if result is None:
        logging.error("Failed to load PRISM climate data")
        return

    min_temps, max_temps, projection, geo_transform, no_data_value, cols, rows, ydim = result

    # Calculate latitudes for each row
    (upper_left_x, x_size, x_rotation, upper_left_y, y_rotation, y_size) = geo_transform
    num_lats = max_temps.shape[0]
    site_latitudes = np.arange(num_lats, dtype=float)
    site_latitudes *= -ydim
    site_latitudes += upper_left_y

    # Initialize average arrays
    leaf_average_array = None
    bloom_average_array = None

    # Compute Spring Index for each plant
    logging.info("Computing Spring Index for individual plants...")
    for plant in PLANTS:
        logging.info(f"Computing Spring Index for {plant}...")

        # Compute leaf phenophase
        logging.info(f"  Computing {plant} leaf...")
        leaf_array = spring_index(max_temps, min_temps, BASE_TEMP, None, 'leaf', plant, site_latitudes)

        # Add to average
        leaf_copy = np.copy(leaf_array)
        leaf_copy[leaf_copy < 0] = np.nan
        if leaf_average_array is None:
            leaf_average_array = leaf_copy
        else:
            leaf_average_array = leaf_average_array + leaf_copy

        # Save daily leaf rasters (only for requested range)
        delta = end_date - start_date
        for i in range(delta.days + 1):
            day = start_date + timedelta(days=i)
            day_of_year = day.timetuple().tm_yday

            # Prepare output array
            out_array = np.copy(leaf_array)
            out_array[out_array > day_of_year] = -9999
            out_array[np.isnan(out_array)] = -9999
            out_array = out_array.astype(np.int16)

            # Write raster
            file_path = get_six_output_path(plant, 'leaf', day)
            write_int16_raster(file_path, out_array, no_data_value, cols, rows, projection, geo_transform)

        logging.info(f'  Saved {plant} leaf rasters')

        # Compute bloom phenophase
        logging.info(f"  Computing {plant} bloom...")
        bloom_array = spring_index(max_temps, min_temps, BASE_TEMP, leaf_array, 'bloom', plant, site_latitudes)

        # Add to average
        bloom_copy = np.copy(bloom_array)
        bloom_copy[bloom_copy < 0] = np.nan
        if bloom_average_array is None:
            bloom_average_array = bloom_copy
        else:
            bloom_average_array = bloom_average_array + bloom_copy

        # Save daily bloom rasters (only for requested range)
        for i in range(delta.days + 1):
            day = start_date + timedelta(days=i)
            day_of_year = day.timetuple().tm_yday

            # Prepare output array
            out_array = np.copy(bloom_array)
            out_array[out_array > day_of_year] = -9999
            out_array[np.isnan(out_array)] = -9999
            out_array = out_array.astype(np.int16)

            # Write raster
            file_path = get_six_output_path(plant, 'bloom', day)
            write_int16_raster(file_path, out_array, no_data_value, cols, rows, projection, geo_transform)

        logging.info(f'  Saved {plant} bloom rasters')

    # Compute and save averages
    logging.info("Computing average Spring Index...")
    leaf_average_array /= len(PLANTS)
    bloom_average_array /= len(PLANTS)

    # Save average leaf rasters (only for requested range)
    delta = end_date - start_date
    for i in range(delta.days + 1):
        day = start_date + timedelta(days=i)
        day_of_year = day.timetuple().tm_yday

        # Prepare output array
        out_array = np.copy(leaf_average_array)
        out_array[out_array > day_of_year] = -9999
        out_array[np.isnan(out_array)] = -9999
        out_array = out_array.astype(np.int16)

        # Write raster
        file_path = get_six_output_path('average', 'leaf', day)
        write_int16_raster(file_path, out_array, no_data_value, cols, rows, projection, geo_transform)

        # Update image mosaic table
        update_time_series(IMAGE_MOSAIC_TABLES['average_leaf'], os.path.basename(file_path), day)

    logging.info('Saved average leaf rasters')

    # Save average bloom rasters (only for requested range)
    for i in range(delta.days + 1):
        day = start_date + timedelta(days=i)
        day_of_year = day.timetuple().tm_yday

        # Prepare output array
        out_array = np.copy(bloom_average_array)
        out_array[out_array > day_of_year] = -9999
        out_array[np.isnan(out_array)] = -9999
        out_array = out_array.astype(np.int16)

        # Write raster
        file_path = get_six_output_path('average', 'bloom', day)
        write_int16_raster(file_path, out_array, no_data_value, cols, rows, projection, geo_transform)

        # Update image mosaic table
        update_time_series(IMAGE_MOSAIC_TABLES['average_bloom'], os.path.basename(file_path), day)

    logging.info('Saved average bloom rasters')

    # Compute and save anomaly rasters for average leaf and bloom (only for requested range)
    logging.info("Computing Spring Index anomalies...")

    # Compute leaf anomalies
    for i in range(delta.days + 1):
        day = start_date + timedelta(days=i)
        day_of_year = day.timetuple().tm_yday

        # Load 30-year average for this day of year
        avg_result = load_30yr_average_raster('leaf', day_of_year)
        if avg_result is None:
            logging.warning(f"Skipping leaf anomaly for {day.strftime('%Y-%m-%d')} - no 30-year average available")
            continue

        avg_array, _, _, _, _, _ = avg_result

        # Prepare current SI-X array (mask values > day_of_year as in the average raster output)
        current_six = np.copy(leaf_average_array)
        current_six[current_six > day_of_year] = np.nan

        # Compute anomaly: current - average (negative = early, positive = late)
        anomaly = current_six - avg_array
        anomaly[np.isnan(anomaly)] = -9999
        anomaly = anomaly.astype(np.int16)

        # Write anomaly raster
        anomaly_path = get_anomaly_output_path('leaf', day)
        write_int16_raster(anomaly_path, anomaly, -9999, cols, rows, projection, geo_transform)

        # Update image mosaic table
        update_time_series(IMAGE_MOSAIC_TABLES['leaf_anomaly'], os.path.basename(anomaly_path), day)

    logging.info('Saved leaf anomaly rasters')

    # Compute bloom anomalies
    for i in range(delta.days + 1):
        day = start_date + timedelta(days=i)
        day_of_year = day.timetuple().tm_yday

        # Load 30-year average for this day of year
        avg_result = load_30yr_average_raster('bloom', day_of_year)
        if avg_result is None:
            logging.warning(f"Skipping bloom anomaly for {day.strftime('%Y-%m-%d')} - no 30-year average available")
            continue

        avg_array, _, _, _, _, _ = avg_result

        # Prepare current SI-X array (mask values > day_of_year as in the average raster output)
        current_six = np.copy(bloom_average_array)
        current_six[current_six > day_of_year] = np.nan

        # Compute anomaly: current - average (negative = early, positive = late)
        anomaly = current_six - avg_array
        anomaly[np.isnan(anomaly)] = -9999
        anomaly = anomaly.astype(np.int16)

        # Write anomaly raster
        anomaly_path = get_anomaly_output_path('bloom', day)
        write_int16_raster(anomaly_path, anomaly, -9999, cols, rows, projection, geo_transform)

        # Update image mosaic table
        update_time_series(IMAGE_MOSAIC_TABLES['bloom_anomaly'], os.path.basename(anomaly_path), day)

    logging.info('Saved bloom anomaly rasters')

    logging.info("Spring Index computation complete!")


def main():
    """Main entry point for the script."""

    # Parse command line arguments
    if len(sys.argv) < 2:
        print("Usage:")
        print("  Compute for entire year:")
        print("    python3 compute_prism_six.py <year> [--incremental]")
        print("  Compute for date range:")
        print("    python3 compute_prism_six.py <start_date> <end_date> [--incremental]")
        print("")
        print("Options:")
        print("  --incremental    Skip computation if files already exist (for nightly updates)")
        print("")
        print("Examples:")
        print("    python3 compute_prism_six.py 2026")
        print("    python3 compute_prism_six.py 2026 --incremental")
        print("    python3 compute_prism_six.py 2026-01-01 2026-09-07")
        print("    python3 compute_prism_six.py 2026-01-01 2026-09-07 --incremental")
        sys.exit(1)

    # Check for --incremental flag
    incremental = '--incremental' in sys.argv
    args = [arg for arg in sys.argv[1:] if arg != '--incremental']

    # Determine if computing for year or date range
    if len(args) == 1:
        # Year mode
        try:
            year = int(args[0])
            logging.info(f"Computing Spring Index for year {year} (incremental={incremental})")

            compute_six_for_year(year, incremental=incremental)

        except ValueError:
            logging.error(f"Invalid year: {args[0]}")
            sys.exit(1)

    elif len(args) == 2:
        # Date range mode
        try:
            start_date = datetime.strptime(args[0], "%Y-%m-%d").date()
            end_date = datetime.strptime(args[1], "%Y-%m-%d").date()

            if start_date > end_date:
                logging.error("Start date must be before or equal to end date")
                sys.exit(1)

            if start_date.year != end_date.year:
                logging.error("Start and end dates must be in the same year")
                sys.exit(1)

            logging.info(f"Computing Spring Index from {start_date} to {end_date} (incremental={incremental})")

            compute_six_for_date_range(start_date, end_date, incremental=incremental)

        except ValueError as e:
            logging.error(f"Invalid date format. Use YYYY-MM-DD: {e}")
            sys.exit(1)

    else:
        logging.error("Invalid number of arguments")
        sys.exit(1)


if __name__ == "__main__":
    main()
