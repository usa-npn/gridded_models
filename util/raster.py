from osgeo import gdal
import ogr
import osr
import os
import subprocess


def write_raster(file_path, rast_array, no_data_value, rast_cols, rast_rows, projection, transform):
    driver = gdal.GetDriverByName('Gtiff')
    raster = driver.Create(file_path, rast_cols, rast_rows, 1, gdal.GDT_Float32)
    band = raster.GetRasterBand(1)
    band.SetNoDataValue(no_data_value)
    band.WriteArray(rast_array)
    raster.SetProjection(projection)
    raster.SetGeoTransform(transform)
    band.FlushCache()


def write_int16_raster(file_path, rast_array, no_data_value, rast_cols, rast_rows, projection, transform):
    driver = gdal.GetDriverByName('Gtiff')
    raster = driver.Create(file_path, rast_cols, rast_rows, 1, gdal.GDT_Int16)
    band = raster.GetRasterBand(1)
    band.SetNoDataValue(no_data_value)
    band.WriteArray(rast_array)
    raster.SetProjection(projection)
    raster.SetGeoTransform(transform)
    band.FlushCache()


def write_best_raster(file_path, array, min_lon, max_lon, num_lons, min_lat, max_lat, num_lats):
    driver = gdal.GetDriverByName('Gtiff')
    no_data_value = -9999

    srs = osr.SpatialReference()
    srs.ImportFromEPSG(4269)

    # the below .5s are because we want the outer edges of the min/max lat/lon squares not the center,
    # and each best grid cell has a height/width of 1
    xmin, ymin, xmax, ymax = [min_lon - .5, min_lat - .5, max_lon + .5, max_lat + .5]
    nrows = num_lats
    ncols = num_lons
    xres = (xmax - xmin) / float(ncols)
    yres = (ymax - ymin) / float(nrows)
    geotransform = (xmin, xres, 0, ymax, 0, -yres)

    raster = driver.Create(file_path, num_lons, num_lats, 1, gdal.GDT_Float32)
    band = raster.GetRasterBand(1)
    band.SetNoDataValue(no_data_value)
    band.WriteArray(array)

    raster.SetGeoTransform(geotransform)
    raster.SetProjection(srs.ExportToWkt())
    band.FlushCache()


def apply_usa_mask(rast_array):
    mask = gdal.Open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'usa_mask.tif')))
    mask_band = mask.GetRasterBand(1)
    mask_array = mask_band.ReadAsArray()
    rast_array[rast_array == 0] = .0001
    rast_array *= mask_array
    rast_array[rast_array == 0] = -9999


def apply_alaska_mask(source_file, dest_file):
    mask_shape_file = os.path.abspath(os.path.join(os.path.dirname(__file__), os.path.join('alaska_shapefile', 'alaska.shp')))

    # rtma/urma alaska file has 2976.56 meter pixelsize (ncep advertises as 3km rez, but use gdalinfo for exact rez) and is 1649 x 1105 pixels
    # 1 degree = 111.325 km
    # we need to specify resolution in degrees for epsg 4269 so we convert 2976.56 meters to degrees = .02673757
    # gdalwarp -cutline alaska.shp -crop_to_cutline -srcnodata -9999 -dstnodata -9999 -tr .02673757 .02673757 -t_srs EPSG:4269 ds.temp.bin testmask.tif
    warp_command = "gdalwarp -cutline {mask_file} -crop_to_cutline -srcnodata 9999 -dstnodata -9999 -tr .02673757 .02673757 -t_srs EPSG:4269 {source_file} {dest_file}" \
        .format(mask_file=mask_shape_file, source_file=source_file, dest_file=dest_file)
    ps = subprocess.Popen(warp_command, stdout=subprocess.PIPE, shell=True)
    ps.wait()
    os.remove(source_file)


def warp_to_rtma_resolution(source_file, dest_file):
    warp_command = "gdalwarp -overwrite -r bilinear -ts 2606 1228 -srcnodata -9999 -dstnodata -9999 {source_file} {dest_file}"\
        .format(source_file=source_file, dest_file=dest_file)
    ps = subprocess.Popen(warp_command, stdout=subprocess.PIPE, shell=True)
    ps.wait()


def get_point_as_long_lat(coord_x, coord_y, input_epsg):
    # Spatial Reference System
    output_epsg = 4326

    # create a geometry from coordinates
    point = ogr.Geometry(ogr.wkbPoint)
    point.AddPoint(coord_x, coord_y)

    # create coordinate transformation
    in_spatial_ref = osr.SpatialReference()
    in_spatial_ref.ImportFromEPSG(input_epsg)

    out_spatial_ref = osr.SpatialReference()
    out_spatial_ref.ImportFromEPSG(output_epsg)

    coord_transform = osr.CoordinateTransformation(in_spatial_ref, out_spatial_ref)

    # transform point
    point.Transform(coord_transform)

    # print point in EPSG 4326
    return point.GetX(), point.GetY()
