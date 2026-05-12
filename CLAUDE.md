# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository generates USA-NPN phenology maps (https://www.usanpn.org/data/maps) by processing climate data from multiple sources (NDFD, RTMA, URMA, PRISM) to create Accumulated Growing Degree Day (AGDD) and Spring Index (SI-X) geotiffs. Scripts run nightly via cron to download climate data, generate geotiffs, and import raster data into PostGIS for serving via Geoserver.

## Core Workflow

The nightly update process follows two main stages:

1. **Climate Data Collection** (`populate_climate_data.py`):
   - Download NDFD forecast temps (next 6 days)
   - Download RTMA/URMA hourly temps (past 24 hours)
   - Backfill missed RTMA data (past week)
   - Compute daily tmin/tmax from hourly data with -12 hour shift to match PRISM format
   - Download PRISM historical data (1 year ago to present)

2. **Phenology Map Generation** (`gridded_models_nightly_update.py`):
   - Generate daily AGDD rasters (base 32 and base 50) for CONUS and Alaska
   - Calculate AGDD anomalies using 30-year averages
   - Compute Spring Index (SI-X) first leaf and first bloom for three plant species (lilac, arnoldred, zabelli)
   - Generate species-averaged SI-X rasters
   - Calculate SI-X anomalies using 30-year averages
   - Import QC data into MySQL for uncertainty estimation

## Running the Code

### Nightly Production Scripts
```bash
# Run climate data collection first
python3 populate_climate_data.py

# Then run phenology model generation
python3 gridded_models_nightly_update.py
```

### One-time Setup Scripts
```bash
# Import PostGIS schema
psql databasename < schema.sql

# Optionally import QC schema (MySQL)
mysql databasename < qc_schema.sql

# Import historic PRISM data (1980-present)
python3 populate_prism.py

# Import historic spring index layers (1980-present)
python3 populate_six.py

# Create 30-year average maps for AGDD and SI-X
python3 populate_30yr_averages.py
```

### Alaska-specific Processing
```bash
python3 gridded_models_nightly_update_ak.py
```

## Architecture

### Module Structure

- **`util/`** - Core utilities used across the codebase
  - `database.py` - PostGIS and MySQL connection management, raster import/export via raster2pgsql
  - `raster.py` - GDAL-based geotiff creation and manipulation
  - `gdd.py` - Growing degree day calculations
  - `log_manager.py` - Logging configuration

- **`climate/`** - Climate data downloaders
  - `importer.py` - Downloads NDFD, RTMA, URMA, and computes daily tmin/tmax from hourly data

- **`prism/`** - PRISM data handling
  - `importer.py` - Downloads and imports PRISM tmin/tmax data

- **`spring_index/`** - Spring Index model implementation
  - `spring_index.py` - Core SI-X algorithm (leaf/bloom phenology models for lilac, arnoldred, zabelli)
  - `postgis_driver.py` - Loads climate data from PostGIS, runs SI-X calculations, exports geotiffs
  - `spring_index_util.py` - SI-X utilities including anomaly calculations

- **`qc/`** - Quality control and uncertainty estimation
  - `gdd_checker.py` - Compare gridded AGDD against Climate Reference Network stations
  - `six_checker.py` - Compare gridded SI-X against station data
  - `utils.py` - Fetch station data from ACIS API

### Key Data Flow

1. Climate data sources → geotiffs → PostGIS tables (via raster2pgsql with `-R` for out-of-db storage)
2. PostGIS hourly temps → daily tmin/tmax rasters → AGDD/SI-X models
3. Current year data + 30-year averages → anomaly rasters
4. Geotiffs stored at paths in `config.yml` for Geoserver to serve via WMS/WCS

### PostGIS Raster Pattern

The codebase uses out-of-db PostGIS rasters (registered with `-R` flag in raster2pgsql):
- Metadata and file paths stored in database
- Actual pixel data remains in geotiff files
- Enables efficient raster queries without loading full images into DB
- Tables are tiled: CONUS (1303x307), Alaska (613x377), PRISM (281x207)

### Date Conventions

- Climate data uses UTC with -12 hour shift to align with PRISM (PRISM day runs -12 UTC to +12 UTC)
- SI-X calculations stop at day 250 (September 7); beyond that, day 240 values are copied forward
- Year transitions handled carefully (forecast can extend into next year)

### Plant Models

Spring Index uses three lilac cultivar models:
- `lilac` - Common lilac (Syringa vulgaris)
- `arnoldred` - Arnold Red honeysuckle (Lonicera korolkowii 'Arnold Red')
- `zabelli` - Zabelli honeysuckle (Lonicera korolkowii var. zabelli)

Each has calibrated coefficients for leaf and bloom phenophases. The "average" product averages predictions across all three species.

## Configuration

`config.yml` contains:
- Database connection params (PostGIS, MySQL)
- File paths for all geotiff products
- Archive paths for historical data
- Log paths

Paths follow pattern: `/geo-data/` for current data, `/geo-vault/` for archives.

## Database Tables

PostGIS tables follow naming conventions:
- `{provider}_tmin_{year}` / `{provider}_tmax_{year}` - Daily temperature rasters
- `{provider}_{year}` - Hourly temperature rasters (with rast_hour column)
- `{provider}_agdd_{base}f_{year}` - AGDD rasters with scale/base/rast_date columns
- `{provider}_six_{time_rez}` - SI-X rasters with plant/phenophase/rast_date columns

Table columns set dynamically in `util/database.py` helper functions (set_date_column, set_plant_column, etc).

## Common Development Patterns

### Adding a new climate data source

1. Add downloader in `climate/importer.py` following existing patterns (download_forecast, download_hourly_temps)
2. Convert to geotiffs and save to configured path
3. Import to PostGIS via `util/database.py::save_raster_to_postgis()`
4. Update main scripts to call new downloader

### Adding a new phenology model

1. Implement model algorithm in new module (see `spring_index/spring_index.py` for example)
2. Create driver class to load climate data from PostGIS (see `spring_index/postgis_driver.py`)
3. Add generation function to `gridded_models_nightly_update.py`
4. Configure output paths in `config.yml`

### Working with rasters

Always use `util/raster.py` helpers:
- `write_raster()` - Write float32 geotiff
- `write_int16_raster()` - Write int16 geotiff
- `apply_usa_mask()` / `apply_alaska_mask()` - Mask to region boundaries

Always use `util/database.py` for PostGIS operations:
- `get_raster_array()` - Retrieve raster as numpy array
- `save_raster_to_postgis()` - Import geotiff to PostGIS
- `agdd_row_exists()` / `six_row_exists()` - Check before reimporting

## Troubleshooting

- **Missing RTMA/URMA data**: Check `climate/missing_rtma_checker.py` to identify gaps
- **QC failures**: Review MySQL climate.agdds table for station comparisons
- **Geoserver issues**: Verify geotiff paths in config.yml match Geoserver layer configuration
- **Memory issues**: SI-X calculations use large numpy arrays; see gc calls in main script

## Dependencies

- Python 3 with GDAL bindings
- PostgreSQL with PostGIS extension (psycopg2)
- MySQL (mysql.connector)
- NumPy for raster math
- raster2pgsql CLI tool for PostGIS imports
- Geoserver (external, serves the generated geotiffs)
