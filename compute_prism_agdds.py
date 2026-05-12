#!/usr/bin/python3
"""
Compute AGDD and AGDD anomaly rasters from PRISM tmin/tmax files (2026+ format).

This script reads PRISM climate data from the new file format:
  - /geo-data/climate_data/prism/prism_tmin/prism_tmin_us_25m_YYYYMMDD.tif
  - /geo-data/climate_data/prism/prism_tmax/prism_tmax_us_25m_YYYYMMDD.tif

And outputs daily AGDD rasters to:
  - /geo-data/gridded_models/new/agdd/agdd_YYYYMMDD_base_thirtytwo_f.tif
  - /geo-data/gridded_models/new/agdd_50f/agdd_YYYYMMDD_base_fifty_f.tif

And AGDD anomaly rasters (compared to 30-year averages) to:
  - /geo-data/gridded_models/new/agdd_anomaly/agdd_anomaly_YYYYMMDD_base_thirtytwo_f.tif
  - /geo-data/gridded_models/new/agdd_anomaly_50f/agdd_anomaly_YYYYMMDD_base_fifty_f.tif

30-year average AGDD files are read from:
  - /geo-data/gridded_models/new/avg_agdd/agdd_{DOY}_base_thirtytwo_f.tif
  - /geo-data/gridded_models/new/avg_agdd_50f/agdd_{DOY}_base_fifty_f.tif

Incremental Mode:
  Use --incremental flag to continue from the most recent AGDD file instead of
  recomputing from January 1st. This is efficient for nightly updates where you
  only need to process new days.

  Example nightly usage:
    python3 compute_prism_agdds.py 2026 --incremental
"""

import os
import sys
import logging
import glob
import re
from datetime import datetime, date, timedelta
from osgeo import gdal
import numpy as np
from util.raster import write_raster
from util.database import update_time_series

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

# Configuration
PRISM_TMIN_DIR = "/geo-data/climate_data/prism/prism_tmin"
PRISM_TMAX_DIR = "/geo-data/climate_data/prism/prism_tmax"
OUTPUT_DIR_BASE32 = "/geo-data/gridded_models/new/agdd"
OUTPUT_DIR_BASE50 = "/geo-data/gridded_models/new/agdd_50f"
AVG_AGDD_DIR_BASE32 = "/geo-data/gridded_models/new/avg_agdd"
AVG_AGDD_DIR_BASE50 = "/geo-data/gridded_models/new/avg_agdd_50f"
ANOMALY_DIR_BASE32 = "/geo-data/gridded_models/new/agdd_anomaly"
ANOMALY_DIR_BASE50 = "/geo-data/gridded_models/new/agdd_anomaly_50f"

# AGDD bases to compute
AGDD_BASES = [32, 50]


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


def compute_gdd(tmin, tmax, base):
    """
    Compute Growing Degree Days from tmin and tmax.

    Args:
        tmin: numpy array of minimum temperatures
        tmax: numpy array of maximum temperatures
        base: base temperature threshold

    Returns:
        numpy array of GDD values
    """
    # GDD = (tmin + tmax) / 2 - base
    gdd = (tmin + tmax) / 2.0 - base

    # GDD cannot be negative
    gdd[gdd < 0] = 0

    return gdd


def get_agdd_output_path(output_date, base):
    """
    Get the output file path for an AGDD raster.

    Args:
        output_date: datetime.date object
        base: Base temperature (32 or 50)

    Returns:
        Full path to the AGDD output file
    """
    if base == 32:
        output_dir = OUTPUT_DIR_BASE32
    elif base == 50:
        output_dir = OUTPUT_DIR_BASE50
    else:
        raise ValueError(f"Unsupported base temperature: {base}")

    date_str = output_date.strftime("%Y%m%d")
    if base == 50:
        filename = f"agdd_{date_str}_base_fifty_f.tif"
    else:
        filename = f"agdd_{date_str}_base_thirtytwo_f.tif"

    return os.path.join(output_dir, filename)


def get_avg_agdd_file_path(day_of_year, base):
    """
    Get the file path for a 30-year average AGDD file.

    Args:
        day_of_year: Day of year (1-366)
        base: Base temperature (32 or 50)

    Returns:
        Full path to the 30-year average AGDD file
    """
    if base == 32:
        avg_dir = AVG_AGDD_DIR_BASE32
    elif base == 50:
        avg_dir = AVG_AGDD_DIR_BASE50
    else:
        raise ValueError(f"Unsupported base temperature: {base}")

    if base == 50:
        filename = f"agdd_{day_of_year}_base_fifty_f.tif"
    else:
        filename = f"agdd_{day_of_year}_base_thirtytwo_f.tif"

    return os.path.join(avg_dir, filename)


def get_anomaly_output_path(output_date, base):
    """
    Get the output file path for an AGDD anomaly raster.

    Args:
        output_date: datetime.date object
        base: Base temperature (32 or 50)

    Returns:
        Full path to the AGDD anomaly output file
    """
    if base == 32:
        anomaly_dir = ANOMALY_DIR_BASE32
    elif base == 50:
        anomaly_dir = ANOMALY_DIR_BASE50
    else:
        raise ValueError(f"Unsupported base temperature: {base}")

    date_str = output_date.strftime("%Y%m%d")
    if base == 50:
        filename = f"agdd_anomaly_{date_str}_base_fifty_f.tif"
    else:
        filename = f"agdd_anomaly_{date_str}_base_thirtytwo_f.tif"

    return os.path.join(anomaly_dir, filename)


def compute_and_save_anomaly(agdd_array, output_date, base, projection, transform, no_data_value, cols, rows):
    """
    Compute AGDD anomaly by comparing against 30-year average and save to disk.

    Args:
        agdd_array: Current AGDD array (numpy array with NaN for no data)
        output_date: datetime.date object
        base: Base temperature (32 or 50)
        projection: GDAL projection string
        transform: GDAL geotransform
        no_data_value: No data value to use in output
        cols: Number of columns
        rows: Number of rows

    Returns:
        None (writes file to disk)
    """
    # Determine anomaly output directory
    if base == 32:
        anomaly_dir = ANOMALY_DIR_BASE32
    elif base == 50:
        anomaly_dir = ANOMALY_DIR_BASE50
    else:
        logging.error(f"Unsupported base temperature: {base}")
        return

    # Create output directory if it doesn't exist
    os.makedirs(anomaly_dir, exist_ok=True)

    # Get day of year
    day_of_year = output_date.timetuple().tm_yday

    # Get 30-year average file path
    avg_file_path = get_avg_agdd_file_path(day_of_year, base)

    if not os.path.exists(avg_file_path):
        logging.warning(f"Skipping anomaly for {output_date.strftime('%Y-%m-%d')} - 30-year average file not found: {avg_file_path}")
        return

    # Read 30-year average AGDD
    avg_result = read_prism_raster(avg_file_path)

    if avg_result is None:
        logging.warning(f"Skipping anomaly for {output_date.strftime('%Y-%m-%d')} - could not read 30-year average file")
        return

    avg_agdd, _, _, _, _, _ = avg_result

    # Compute anomaly (current AGDD - 30-year average AGDD)
    # Both arrays should already have NaN for no data values from read_prism_raster
    diff_agdd = agdd_array - avg_agdd

    # Replace NaN with no_data_value for output
    output_array = diff_agdd.copy()
    output_array[np.isnan(output_array)] = no_data_value

    # Get anomaly output path
    anomaly_path = get_anomaly_output_path(output_date, base)

    # Write the anomaly raster to disk
    try:
        write_raster(anomaly_path, output_array, no_data_value, cols, rows, projection, transform)
        logging.info(f"Wrote AGDD anomaly raster: {anomaly_path}")

        # Update PostGIS image mosaic table for anomaly
        anomaly_filename = os.path.basename(anomaly_path)
        time_series_table = "agdd_anomaly" if base == 32 else "agdd_anomaly_50f"
        update_time_series(time_series_table, anomaly_filename, output_date)
        logging.info(f"Updated {time_series_table} time series table")
    except Exception as e:
        logging.error(f"Error writing anomaly raster {anomaly_path}: {e}")


def parse_date_from_agdd_filename(filename):
    """
    Parse date from AGDD filename.

    Args:
        filename: Filename like 'agdd_20260108_base_thirtytwo_f.tif'

    Returns:
        datetime.date object or None if parsing fails
    """
    # Pattern: agdd_YYYYMMDD_base_(thirtytwo|fifty)_f.tif
    match = re.match(r'agdd_(\d{8})_base_(thirtytwo|fifty)_f\.tif', filename)
    if match:
        date_str = match.group(1)
        try:
            return datetime.strptime(date_str, "%Y%m%d").date()
        except ValueError:
            return None
    return None


def find_most_recent_agdd_file(year, base):
    """
    Find the most recent AGDD file for a given year and base.

    Args:
        year: Year to search
        base: Base temperature (32 or 50)

    Returns:
        tuple: (most_recent_date, file_path) or (None, None) if no files found
    """
    if base == 32:
        output_dir = OUTPUT_DIR_BASE32
    elif base == 50:
        output_dir = OUTPUT_DIR_BASE50
    else:
        return None, None

    if not os.path.exists(output_dir):
        return None, None

    # Get all AGDD files for this year and base
    if base == 50:
        pattern = os.path.join(output_dir, f"agdd_{year}*_base_fifty_f.tif")
    else:
        pattern = os.path.join(output_dir, f"agdd_{year}*_base_thirtytwo_f.tif")

    files = glob.glob(pattern)

    if not files:
        return None, None

    # Parse dates and find the most recent
    most_recent_date = None
    most_recent_file = None

    for file_path in files:
        filename = os.path.basename(file_path)
        file_date = parse_date_from_agdd_filename(filename)

        if file_date and file_date.year == year:
            if most_recent_date is None or file_date > most_recent_date:
                most_recent_date = file_date
                most_recent_file = file_path

    return most_recent_date, most_recent_file


def compute_agdd_for_year(year, base, incremental=False):
    """
    Compute accumulated GDD for an entire year.

    Args:
        year: Year to process (integer)
        base: Base temperature (32 or 50)
        incremental: If True, continue from most recent AGDD file; if False, recompute from Jan 1

    Returns:
        None (writes files to disk)
    """
    logging.info(f"Computing AGDD for year {year} with base {base}F (incremental={incremental})")

    # Determine output directory
    if base == 32:
        output_dir = OUTPUT_DIR_BASE32
    elif base == 50:
        output_dir = OUTPUT_DIR_BASE50
    else:
        logging.error(f"Unsupported base temperature: {base}")
        return

    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)

    # Start from January 1st by default
    current_date = date(year, 1, 1)
    delta = timedelta(days=1)

    # Track AGDD accumulation
    agdd = None

    # Get metadata from first available file
    projection = None
    transform = None
    no_data_value = -9999
    cols = None
    rows = None

    # If incremental mode, try to load the most recent AGDD file
    if incremental:
        most_recent_date, most_recent_file = find_most_recent_agdd_file(year, base)

        if most_recent_date and most_recent_file:
            logging.info(f"Incremental mode: Loading existing AGDD from {most_recent_date.strftime('%Y-%m-%d')}")

            # Load the most recent AGDD raster
            agdd_result = read_prism_raster(most_recent_file)

            if agdd_result:
                agdd, projection, transform, no_data_value, cols, rows = agdd_result
                # Start from the day after the most recent file
                current_date = most_recent_date + delta
                logging.info(f"Continuing computation from {current_date.strftime('%Y-%m-%d')}")
            else:
                logging.warning(f"Could not read existing AGDD file {most_recent_file}, starting from Jan 1")
                current_date = date(year, 1, 1)
                agdd = None
        else:
            logging.info(f"No existing AGDD files found for {year}, starting from Jan 1")
            current_date = date(year, 1, 1)

    # Process each day of the year
    while current_date.year == year:
        logging.info(f"Processing {current_date.strftime('%Y-%m-%d')} (base {base}F)")

        # Get file paths
        tmin_path = get_prism_file_path('tmin', current_date)
        tmax_path = get_prism_file_path('tmax', current_date)

        # Check if files exist
        if not os.path.exists(tmin_path):
            logging.warning(f"Skipping {current_date.strftime('%Y-%m-%d')} - tmin file not found: {tmin_path}")
            current_date += delta
            continue

        if not os.path.exists(tmax_path):
            logging.warning(f"Skipping {current_date.strftime('%Y-%m-%d')} - tmax file not found: {tmax_path}")
            current_date += delta
            continue

        # Read tmin and tmax (convert from Celsius to Fahrenheit)
        tmin_result = read_prism_raster(tmin_path, convert_to_fahrenheit=True)
        tmax_result = read_prism_raster(tmax_path, convert_to_fahrenheit=True)

        if tmin_result is None or tmax_result is None:
            logging.warning(f"Skipping {current_date.strftime('%Y-%m-%d')} - could not read raster files")
            current_date += delta
            continue

        tmin, tmin_proj, tmin_transform, tmin_nodata, tmin_cols, tmin_rows = tmin_result
        tmax, tmax_proj, tmax_transform, tmax_nodata, tmax_cols, tmax_rows = tmax_result

        # Initialize metadata from first successful read
        if projection is None:
            projection = tmin_proj
            transform = tmin_transform
            no_data_value = tmin_nodata
            cols = tmin_cols
            rows = tmin_rows

        # Compute GDD for this day
        gdd = compute_gdd(tmin, tmax, base)

        # Accumulate AGDD
        if agdd is None:
            # First day of year
            agdd = gdd.copy()
        else:
            # Add today's GDD to accumulated total
            agdd = agdd + gdd

        # Replace NaN with no_data_value for output
        output_array = agdd.copy()
        output_array[np.isnan(output_array)] = no_data_value

        # Create output filename
        date_str = current_date.strftime("%Y%m%d")
        if base == 50:
            filename = f"agdd_{date_str}_base_fifty_f.tif"
        else:
            filename = f"agdd_{date_str}_base_thirtytwo_f.tif"

        output_path = os.path.join(output_dir, filename)

        # Write the raster to disk
        try:
            write_raster(output_path, output_array, no_data_value, cols, rows, projection, transform)
            logging.info(f"Wrote AGDD raster: {output_path}")

            # Update PostGIS image mosaic table
            time_series_table = "agdd" if base == 32 else "agdd_50f"
            update_time_series(time_series_table, filename, current_date)
            logging.info(f"Updated {time_series_table} time series table")

            # Compute and save anomaly
            compute_and_save_anomaly(agdd, current_date, base, projection, transform, no_data_value, cols, rows)

        except Exception as e:
            logging.error(f"Error writing raster {output_path}: {e}")

        # Move to next day
        current_date += delta


def compute_agdd_for_date_range(start_date, end_date, base, incremental=False):
    """
    Compute accumulated GDD for a date range.

    Args:
        start_date: Start date (datetime.date)
        end_date: End date (datetime.date)
        base: Base temperature (32 or 50)
        incremental: If True, continue from most recent AGDD file; if False, recompute from Jan 1

    Returns:
        None (writes files to disk)
    """
    logging.info(f"Computing AGDD from {start_date} to {end_date} with base {base}F (incremental={incremental})")

    # Determine output directory
    if base == 32:
        output_dir = OUTPUT_DIR_BASE32
    elif base == 50:
        output_dir = OUTPUT_DIR_BASE50
    else:
        logging.error(f"Unsupported base temperature: {base}")
        return

    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)

    # Start from beginning of the year containing start_date
    year_start = date(start_date.year, 1, 1)
    current_date = year_start
    delta = timedelta(days=1)

    # Track AGDD accumulation
    agdd = None

    # Get metadata from first available file
    projection = None
    transform = None
    no_data_value = -9999
    cols = None
    rows = None

    # If incremental mode, try to load the most recent AGDD file
    if incremental:
        most_recent_date, most_recent_file = find_most_recent_agdd_file(start_date.year, base)

        if most_recent_date and most_recent_file:
            # Only use the existing file if it's before our start_date
            if most_recent_date < start_date:
                logging.info(f"Incremental mode: Loading existing AGDD from {most_recent_date.strftime('%Y-%m-%d')}")

                # Load the most recent AGDD raster
                agdd_result = read_prism_raster(most_recent_file)

                if agdd_result:
                    agdd, projection, transform, no_data_value, cols, rows = agdd_result
                    # Continue from the day after the most recent file
                    current_date = most_recent_date + delta
                    logging.info(f"Continuing computation from {current_date.strftime('%Y-%m-%d')}")
                else:
                    logging.warning(f"Could not read existing AGDD file {most_recent_file}, starting from Jan 1")
                    current_date = year_start
                    agdd = None
            elif most_recent_date >= start_date:
                # Most recent file is at or after start_date, use it and skip ahead
                logging.info(f"Incremental mode: Most recent AGDD is {most_recent_date.strftime('%Y-%m-%d')}, skipping to next day")
                agdd_result = read_prism_raster(most_recent_file)

                if agdd_result:
                    agdd, projection, transform, no_data_value, cols, rows = agdd_result
                    current_date = most_recent_date + delta
                    logging.info(f"Continuing computation from {current_date.strftime('%Y-%m-%d')}")
                else:
                    logging.warning(f"Could not read existing AGDD file {most_recent_file}, starting from Jan 1")
                    current_date = year_start
                    agdd = None
        else:
            logging.info(f"No existing AGDD files found for {start_date.year}, starting from Jan 1")
            current_date = year_start

    # Process each day
    while current_date <= end_date:
        # Get file paths
        tmin_path = get_prism_file_path('tmin', current_date)
        tmax_path = get_prism_file_path('tmax', current_date)

        # Check if files exist
        if not os.path.exists(tmin_path) or not os.path.exists(tmax_path):
            if current_date >= start_date:
                logging.warning(f"Skipping {current_date.strftime('%Y-%m-%d')} - files not found")
            current_date += delta
            continue

        # Read tmin and tmax (convert from Celsius to Fahrenheit)
        tmin_result = read_prism_raster(tmin_path, convert_to_fahrenheit=True)
        tmax_result = read_prism_raster(tmax_path, convert_to_fahrenheit=True)

        if tmin_result is None or tmax_result is None:
            if current_date >= start_date:
                logging.warning(f"Skipping {current_date.strftime('%Y-%m-%d')} - could not read raster files")
            current_date += delta
            continue

        tmin, tmin_proj, tmin_transform, tmin_nodata, tmin_cols, tmin_rows = tmin_result
        tmax, tmax_proj, tmax_transform, tmax_nodata, tmax_cols, tmax_rows = tmax_result

        # Initialize metadata from first successful read
        if projection is None:
            projection = tmin_proj
            transform = tmin_transform
            no_data_value = tmin_nodata
            cols = tmin_cols
            rows = tmin_rows

        # Compute GDD for this day
        gdd = compute_gdd(tmin, tmax, base)

        # Accumulate AGDD
        if agdd is None:
            agdd = gdd.copy()
        else:
            agdd = agdd + gdd

        # Only write output for dates within the requested range
        if current_date >= start_date:
            logging.info(f"Processing {current_date.strftime('%Y-%m-%d')} (base {base}F)")

            # Replace NaN with no_data_value for output
            output_array = agdd.copy()
            output_array[np.isnan(output_array)] = no_data_value

            # Create output filename
            date_str = current_date.strftime("%Y%m%d")
            if base == 50:
                filename = f"agdd_{date_str}_base_fifty_f.tif"
            else:
                filename = f"agdd_{date_str}_base_thirtytwo_f.tif"

            output_path = os.path.join(output_dir, filename)

            # Write the raster to disk
            try:
                write_raster(output_path, output_array, no_data_value, cols, rows, projection, transform)
                logging.info(f"Wrote AGDD raster: {output_path}")

                # Update PostGIS image mosaic table
                time_series_table = "agdd" if base == 32 else "agdd_50f"
                update_time_series(time_series_table, filename, current_date)
                logging.info(f"Updated {time_series_table} time series table")

                # Compute and save anomaly
                compute_and_save_anomaly(agdd, current_date, base, projection, transform, no_data_value, cols, rows)

            except Exception as e:
                logging.error(f"Error writing raster {output_path}: {e}")

        # Move to next day
        current_date += delta


def main():
    """Main entry point for the script."""

    # Parse command line arguments
    if len(sys.argv) < 2:
        print("Usage:")
        print("  Compute for entire year:")
        print("    python3 compute_prism_agdds.py <year> [--incremental]")
        print("  Compute for date range:")
        print("    python3 compute_prism_agdds.py <start_date> <end_date> [--incremental]")
        print("")
        print("Options:")
        print("  --incremental    Continue from most recent AGDD file instead of recomputing from Jan 1")
        print("")
        print("Examples:")
        print("    python3 compute_prism_agdds.py 2026")
        print("    python3 compute_prism_agdds.py 2026 --incremental")
        print("    python3 compute_prism_agdds.py 2026-01-01 2026-12-31")
        print("    python3 compute_prism_agdds.py 2026-01-01 2026-12-31 --incremental")
        sys.exit(1)

    # Check for --incremental flag
    incremental = '--incremental' in sys.argv
    args = [arg for arg in sys.argv[1:] if arg != '--incremental']

    # Determine if computing for year or date range
    if len(args) == 1:
        # Year mode
        try:
            year = int(args[0])
            logging.info(f"Computing AGDD for year {year} (incremental={incremental})")

            for base in AGDD_BASES:
                compute_agdd_for_year(year, base, incremental=incremental)

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

            logging.info(f"Computing AGDD from {start_date} to {end_date} (incremental={incremental})")

            for base in AGDD_BASES:
                compute_agdd_for_date_range(start_date, end_date, base, incremental=incremental)

        except ValueError as e:
            logging.error(f"Invalid date format. Use YYYY-MM-DD: {e}")
            sys.exit(1)

    else:
        logging.error("Invalid number of arguments")
        sys.exit(1)

    logging.info("AGDD computation complete!")


if __name__ == "__main__":
    main()
