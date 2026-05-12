#!/usr/bin/python3
"""
One-time script to resample 30-year average AGDD files to match new PRISM resolution.

This script reads existing 30-year average AGDD files and resamples them to match
the new PRISM resolution (621x1405) for use with the new PRISM-based AGDD computation.

Input directories:
  - /geo-data/gridded_models/avg_agdd
  - /geo-data/gridded_models/avg_agdd_50f

Output directories (resampled to PRISM resolution):
  - /geo-data/gridded_models/new/avg_agdd
  - /geo-data/gridded_models/new/avg_agdd_50f

The script uses one of the new PRISM files as a reference for the target resolution.
"""

import os
import glob
import logging
from osgeo import gdal

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

# Configuration
SOURCE_AVG_AGDD_BASE32 = "/geo-data/gridded_models/avg_agdd"
SOURCE_AVG_AGDD_BASE50 = "/geo-data/gridded_models/avg_agdd_50f"
OUTPUT_AVG_AGDD_BASE32 = "/geo-data/gridded_models/new/avg_agdd"
OUTPUT_AVG_AGDD_BASE50 = "/geo-data/gridded_models/new/avg_agdd_50f"

# Reference PRISM file to get target resolution
# Use the first available PRISM tmin file
PRISM_TMIN_DIR = "/geo-data/climate_data/prism/prism_tmin"


def get_reference_prism_file():
    """
    Find the first available PRISM file to use as a resolution reference.

    Returns:
        Path to reference PRISM file or None if not found
    """
    pattern = os.path.join(PRISM_TMIN_DIR, "prism_tmin_us_25m_*.tif")
    files = sorted(glob.glob(pattern))

    if files:
        return files[0]

    return None


def get_target_geotransform_and_projection(reference_file):
    """
    Get the geotransform and projection from a reference PRISM file.

    Args:
        reference_file: Path to reference PRISM file

    Returns:
        tuple: (cols, rows, geotransform, projection) or None on error
    """
    try:
        ds = gdal.Open(reference_file)
        if ds is None:
            logging.error(f"Could not open reference file: {reference_file}")
            return None

        cols = ds.RasterXSize
        rows = ds.RasterYSize
        geotransform = ds.GetGeoTransform()
        projection = ds.GetProjection()

        ds = None

        logging.info(f"Reference PRISM resolution: {cols}x{rows}")
        logging.info(f"GeoTransform: {geotransform}")

        return cols, rows, geotransform, projection

    except Exception as e:
        logging.error(f"Error reading reference file: {e}")
        return None


def resample_file(source_file, output_file, target_cols, target_rows, target_bounds, target_projection):
    """
    Resample a source file to match target resolution.

    Args:
        source_file: Path to source file
        output_file: Path to output file
        target_cols: Target number of columns
        target_rows: Target number of rows
        target_bounds: Target bounds (minX, minY, maxX, maxY)
        target_projection: Target projection

    Returns:
        True if successful, False otherwise
    """
    try:
        # Use GDAL Warp to resample
        warp_options = gdal.WarpOptions(
            format='GTiff',
            width=target_cols,
            height=target_rows,
            dstSRS=target_projection,
            outputBounds=target_bounds,
            resampleAlg='bilinear',
            srcNodata=-9999,
            dstNodata=-9999
        )

        result = gdal.Warp(output_file, source_file, options=warp_options)

        if result is None:
            logging.error(f"Failed to warp {source_file}")
            return False

        result = None  # Close the dataset
        return True

    except Exception as e:
        logging.error(f"Error resampling {source_file}: {e}")
        return False


def resample_avg_agdd_files(source_dir, output_dir, target_cols, target_rows, target_bounds, target_projection, base):
    """
    Resample all AGDD average files in a directory.

    Args:
        source_dir: Source directory containing average AGDD files
        output_dir: Output directory for resampled files
        target_cols: Target number of columns
        target_rows: Target number of rows
        target_bounds: Target bounds (minX, minY, maxX, maxY)
        target_projection: Target projection
        base: Base temperature (32 or 50) for logging
    """
    # Create output directory
    os.makedirs(output_dir, exist_ok=True)

    # Get all average AGDD files
    if base == 32:
        pattern = os.path.join(source_dir, "agdd_*_base_thirtytwo_f.tif")
    else:
        pattern = os.path.join(source_dir, "agdd_*_base_fifty_f.tif")

    files = sorted(glob.glob(pattern))

    if not files:
        logging.warning(f"No files found matching pattern: {pattern}")
        return

    logging.info(f"Found {len(files)} average AGDD files (base {base}F) to resample")

    success_count = 0
    fail_count = 0

    for source_file in files:
        filename = os.path.basename(source_file)
        output_file = os.path.join(output_dir, filename)

        logging.info(f"Resampling {filename}...")

        if resample_file(source_file, output_file, target_cols, target_rows, target_bounds, target_projection):
            success_count += 1
            logging.info(f"  -> Successfully resampled to {output_file}")
        else:
            fail_count += 1
            logging.error(f"  -> Failed to resample {filename}")

    logging.info(f"Base {base}F: {success_count} files resampled successfully, {fail_count} failed")


def main():
    """Main entry point for the script."""

    logging.info("Starting 30-year average AGDD resampling process")

    # Get reference PRISM file
    reference_file = get_reference_prism_file()

    if reference_file is None:
        logging.error("No reference PRISM file found. Please ensure PRISM files exist in:")
        logging.error(f"  {PRISM_TMIN_DIR}")
        return 1

    logging.info(f"Using reference file: {reference_file}")

    # Get target resolution and projection
    target_info = get_target_geotransform_and_projection(reference_file)

    if target_info is None:
        logging.error("Failed to get target resolution information")
        return 1

    target_cols, target_rows, target_geotransform, target_projection = target_info

    # Calculate target bounds from geotransform
    minX = target_geotransform[0]
    maxY = target_geotransform[3]
    maxX = minX + target_cols * target_geotransform[1]
    minY = maxY + target_rows * target_geotransform[5]  # geotransform[5] is negative

    target_bounds = (minX, minY, maxX, maxY)

    logging.info(f"Target bounds: {target_bounds}")

    # Resample base 32F files
    logging.info("")
    logging.info("=" * 80)
    logging.info("Resampling Base 32F average AGDD files")
    logging.info("=" * 80)
    resample_avg_agdd_files(
        SOURCE_AVG_AGDD_BASE32,
        OUTPUT_AVG_AGDD_BASE32,
        target_cols,
        target_rows,
        target_bounds,
        target_projection,
        32
    )

    # Resample base 50F files
    logging.info("")
    logging.info("=" * 80)
    logging.info("Resampling Base 50F average AGDD files")
    logging.info("=" * 80)
    resample_avg_agdd_files(
        SOURCE_AVG_AGDD_BASE50,
        OUTPUT_AVG_AGDD_BASE50,
        target_cols,
        target_rows,
        target_bounds,
        target_projection,
        50
    )

    logging.info("")
    logging.info("=" * 80)
    logging.info("Resampling complete!")
    logging.info("=" * 80)
    logging.info(f"Output directories:")
    logging.info(f"  Base 32F: {OUTPUT_AVG_AGDD_BASE32}")
    logging.info(f"  Base 50F: {OUTPUT_AVG_AGDD_BASE50}")

    return 0


if __name__ == "__main__":
    exit(main())
