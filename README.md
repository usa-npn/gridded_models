# USA-NPN gridded models platform

This repository contains the python code used to generate the [USA-NPN phenology maps.](https://www.usanpn.org/data/phenology_maps)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisities

There are several moving parts to the creation and delivery of the maps. Notable dependancies needed for these scripts to function are:

* [Python 3](https://www.python.org/downloads/)
* [GDAL with appropriate python bindings](http://gdal.org/)
* [Numpy](http://www.numpy.org/) is used for most of the raster math
* Postgres with Postgis extension and connect from Python using psycopg2
* Mysql connected from Python using mysql.connector

Additionally a [Geoserver](http://geoserver.org/) instance is used to ingest the geotiffs produced by these scripts and in turn deliver them via WMS and WCS.

### Installing

After cloning the project you will need to take the following steps.

Install the Mysql, Postgres, and PostGis databases and set up the database schema and tables for each

```
TODO: import schema.sql
```

Fill out the config file specifying database connection params and various paths where geotiffs will both be read from and written to.

```
vi config.yml
```

Import some climate data.

```
python3 populate_climate_data.py
```

Generate some maps

```
python3 gridded_models_nightly_update.py
```

At this point you should have geotiffs generated for both AGDD and SI-X products.


## Deployment

The populate_climate_data.py and gridded_models_nightly_update.py scripts are ran nightly through cronjobs. This maintains the flow of incoming climate data, production of new geotiffs, communication with Geoserver about the location of the new maps.


## Related Projects

This repository only contains server code used for the generation of phenology maps. The following repositories contain code used to view these maps through a web browser.

* [USA-NPN Geoserver Request Builder](https://github.com/usa-npn/geoserver-request-builder)
* [USA-NPN Visualization Tool](https://github.com/usa-npn/npn-viz-tool)

## Authors

* **Jeff Switzer** - *Coding* - [NPN](https://github.com/usa-npn)
* **Lee Marsh** - *Geoserver and Database Administration* - [NPN](https://github.com/usa-npn)

See also the list of [contributors](https://www.usanpn.org/about/staff) who participated in this project.
