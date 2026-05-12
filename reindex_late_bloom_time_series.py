"""
Re-index the six_late_bloom_prism and six_late_bloom_anomaly_prism time series
tables by scanning existing raster files on disk and calling update_time_series
for each one.

Use this to repair the time series tables without re-running the full SDIpy.py
raster generation pipeline.
"""

import os
import datetime
import re

from util.database import update_time_series

LATE_BLOOM_DIR = "/geo-data/gridded_models/spring_index/six_late_bloom_prism"
ANOMALY_DIR = "/geo-data/gridded_models/spring_index_anomaly/six_late_bloom_anomaly_prism"

LATE_BLOOM_PATTERN = re.compile(r"^late_bloom_prism_(\d{8})\.tif$")
ANOMALY_PATTERN = re.compile(r"^six_bloom_anomaly_(\d{8})\.tif$")


def process_directory(directory, filename_pattern, table_name):
    if not os.path.isdir(directory):
        print(f"Directory not found, skipping: {directory}")
        return

    files = sorted(os.listdir(directory))
    matched = [(m.group(1), f) for f in files if (m := filename_pattern.match(f))]

    print(f"\nProcessing {len(matched)} files for table '{table_name}' from {directory}")
    for date_str, filename in matched:
        rast_date = datetime.datetime.strptime(date_str, "%Y%m%d").date()
        update_time_series(table_name, filename, rast_date)
        print(f"  Updated: {filename} -> {rast_date}")

    print(f"Done: {len(matched)} rows updated in '{table_name}'")


process_directory(LATE_BLOOM_DIR, LATE_BLOOM_PATTERN, "six_late_bloom_prism")
process_directory(ANOMALY_DIR, ANOMALY_PATTERN, "six_late_bloom_anomaly_prism")
