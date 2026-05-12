#!/usr/bin/env python3
"""
Change all -2 raster cells to nodata (nan) in 2026 pest model rasters.
"""

import glob
import numpy as np
from osgeo import gdal


DIRECTORIES = [
    '/geo-data/gridded_models/slf/slf_adult',
    '/geo-data/gridded_models/slf/slf_egg_hatch',
    '/geo-data/gridded_models/eab/eab_adult',
    '/geo-data/gridded_models/eab/eab_egg_hatch',
    '/geo-data/gridded_models/japanese_beetle/japanese_beetle_adult',
    '/geo-data/gridded_models/japanese_beetle/japanese_beetle_egg_hatch',
]


def fix_negative2_in_raster(filepath):
    """Replace -2 values with nan (nodata) in a raster file."""
    ds = gdal.Open(filepath, gdal.GA_Update)
    if ds is None:
        print(f"  ERROR: Could not open {filepath}")
        return 0

    band = ds.GetRasterBand(1)
    data = band.ReadAsArray()

    count = np.sum(data == -2)
    if count > 0:
        data[data == -2] = np.nan
        band.WriteArray(data)
        band.FlushCache()

    ds = None
    return count


def main():
    total_files = 0
    total_cells_fixed = 0

    for directory in DIRECTORIES:
        print(f"\nProcessing: {directory}")

        # Find all 2026 tif files
        pattern = f"{directory}/*2026*.tif"
        files = sorted(glob.glob(pattern))

        if not files:
            print("  No 2026 rasters found")
            continue

        print(f"  Found {len(files)} rasters")

        for filepath in files:
            filename = filepath.split('/')[-1]
            cells_fixed = fix_negative2_in_raster(filepath)
            total_files += 1
            total_cells_fixed += cells_fixed

            if cells_fixed > 0:
                print(f"  {filename}: fixed {cells_fixed} cells")
            else:
                print(f"  {filename}: no -2 values")

    print(f"\n--- Summary ---")
    print(f"Total files processed: {total_files}")
    print(f"Total cells changed from -2 to nodata: {total_cells_fixed}")


if __name__ == '__main__':
    main()
