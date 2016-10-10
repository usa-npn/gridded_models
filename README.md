# USA-NPN gridded models platform

This repository contains the python code used to generate the [USA-NPN phenology maps.](https://www.usanpn.org/data/phenology_maps) 


## Overview
Python scripts from this repository are ran nightly to generate the maps. At a high level each night new climate data ([NDFD](http://www.nws.noaa.gov/ndfd/), [RTMA](http://www.nco.ncep.noaa.gov/pmb/products/rtma/), [URMA](http://www.nco.ncep.noaa.gov/pmb/products/rtma/#URMA), and [PRISM](http://prism.oregonstate.edu/)) is downloaded and used to create various accumulated growing degree day and spring index maps. These maps are saved as geotiffs and their raster data is also imported into a postgis database in such a way that a Geoserver instance can serve out the maps. The following steps contained in the gridded_models_nightly_update.py script describe this process in more detail.

1. Retrieve NDFD daily forecast tmin/tmax data for the next 6 days, import the data into a postgis database and create daily tmin/tmax rasters.
2. Retrieve RTMA hourly temperature data and import it into postgis.
3. Retrieve URMA hourly temperature data and import it into postgis.
4. Use the RTMA and URMA hourly temperature data to create daily tmin/tmax rasters and import the raster data into postgis. When generating the tmin/tmax rasters URMA is used if available, otherwise RTMA is used.
5. Use the daily tmin/tmax rasters to generate daily accumulated growing degree day rasters in both base 32 and base 50. Import these rasters into postgis.
6. Generate daily accumulated growing degree anomaly rasters for both base 32 and base 50. These anomalies are calculated using a historic 30 year average set of rasters (one per day of year) generated via the populate_30yr_averages.py script. These historic averages are based on PRISM daily tmin/tmax data.
7. Use the daily tmin/tmax rasters to generate daily spring index first leaf and first bloom rasters for three different species. Import these rasters into postgis.
8. Use the individual species first leaf and first bloom rasters to generate averaged over species first leaf and first bloom rasters. Import these rasters into postgis.
9. For each of the first leaf and first bloom rasters created, generated an anomaly raster calculated using a historic 30 year average set of rasters (one per day of year) generated from the populate_30yr_averages.py script. These historic averages are based on PRISM daily tmin/tmax data.
10. The accumulated growing degree day data is imported into a Mysql database along with retrieved [Climate Reference Network Station] (http://www.rcc-acis.org/) accumulated growing degree day data where it is used to estimate uncertainty.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisities

There are several moving parts to the creation and delivery of the maps. Notable dependancies needed for these scripts to function are:

* [Python 3](https://www.python.org/downloads/)
* [GDAL with appropriate python bindings](http://gdal.org/)
* [Numpy](http://www.numpy.org/) is used for most of the raster math
* [Postgres](https://www.postgresql.org/) with [PostGIS extension](http://postgis.net/) and connect from Python using [psycopg2](http://initd.org/psycopg/)
* [Mysql](https://www.mysql.com/) connected from Python using mysql.connector

Additionally a [Geoserver](http://geoserver.org/) instance is used to ingest the geotiffs produced by these scripts and in turn deliver them via WMS and WCS.

### Installing

After cloning the project you will need to take the following steps.

Install Postgres with the PostGIS extension and import the schema.sql

```
psql databasename < schema.sql
```

Optionally import qc_schema.sql into a mysql database. If you don't do this make sure to set import_qc_data = False in gridded_models_nightly_update.py

```
mysql databasename < qc_schema.sql
```

Fill out the config file specifying database connection params and the various paths where geotiffs will both be read from and written to. When configuring your Geoserver instance you will point it's layers to these paths.

```
vi config.yml
```

Import historic [PRISM](http://prism.oregonstate.edu/) daily tmin and tmax data from 1980 through the current year.

```
python3 populate_prism.py
```

Import historic spring index layers from 1980 through the current year.

```
python3 populate_six.py
```

Create 30 year average maps for both accumulated growing degree days and spring index.

```
python3 populate_30yr_averages.py
```

While you only need to run the above scripts once. The below scripts need to be ran nightly to keep everything up to date.

Import some climate data - the following script will create daily tmin/tmax geotiffs through querying various climate web services ([NDFD](http://www.nws.noaa.gov/ndfd/), [RTMA](http://www.nco.ncep.noaa.gov/pmb/products/rtma/), [URMA](http://www.nco.ncep.noaa.gov/pmb/products/rtma/#URMA), and [PRISM](http://prism.oregonstate.edu/)).

```
python3 populate_climate_data.py
```

Generate some phenology maps - the following script will generate [AGDD](https://www.usanpn.org/data/agdd_maps) and [SI-X](https://www.usanpn.org/data/spring_indices) geotiffs.

```
python3 gridded_models_nightly_update.py
```

At this point if you look in the paths configured in config.yml you should have geotiffs for daily min temp, max temp, as well as AGDD and SI-X products which can all be served out by Geoserver.


## Deployment

The populate_climate_data.py and gridded_models_nightly_update.py scripts are ran nightly through cronjobs. This maintains the flow of incoming climate data, production of new geotiffs, and communication with the Geoserver instance that these maps are available. The original environment for these scripts is Ubuntu 14.04.5 LTS.


## Versioning

The actively developed version of this project is found at https://github.com/usa-npn/gridded_models


## Related Projects

This repository only contains server code used for the generation of phenology maps. The following repositories contain code used to view these maps through a web browser.

* [USA-NPN Geoserver Request Builder](https://github.com/usa-npn/geoserver-request-builder)
* [USA-NPN Visualization Tool](https://github.com/usa-npn/npn-viz-tool)

## Authors

* **Jeff Switzer** - *Coding* - [NPN](https://github.com/usa-npn)
* **Lee Marsh** - *Geoserver and Database Administration* - [NPN](https://github.com/usa-npn)

See also the list of [contributors](https://www.usanpn.org/about/staff) who participated in this project.
