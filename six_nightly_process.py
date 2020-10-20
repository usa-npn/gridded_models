from datetime import date
from datetime import datetime
from datetime import timedelta
import numpy as np
from osgeo import gdal
import os.path

solar_declination = [307,
                     308,
                     309,
                     310,
                     311,
                     312,
                     313,
                     314,
                     315,
                     316,
                     317,
                     318,
                     319,
                     320,
                     321,
                     322,
                     323,
                     324,
                     325,
                     326,
                     327,
                     328,
                     329,
                     330,
                     331,
                     332,
                     333,
                     334,
                     335,
                     336,
                     337,
                     338,
                     339,
                     340,
                     341,
                     342,
                     343,
                     344,
                     345,
                     346,
                     347,
                     348,
                     349,
                     350,
                     351,
                     352,
                     353,
                     354,
                     355,
                     356,
                     357,
                     358,
                     359,
                     360,
                     361,
                     362,
                     363,
                     364,
                     365,
                     366,
                     1,
                     2,
                     3,
                     4,
                     5,
                     6,
                     7,
                     8,
                     9,
                     10,
                     11,
                     12,
                     13,
                     14,
                     15,
                     16,
                     17,
                     18,
                     19,
                     20,
                     21,
                     22,
                     23,
                     24,
                     25,
                     26,
                     27,
                     28,
                     29,
                     30,
                     31,
                     32,
                     33,
                     34,
                     35,
                     36,
                     37,
                     38,
                     39,
                     40,
                     41,
                     42,
                     43,
                     44,
                     45,
                     46,
                     47,
                     48,
                     49,
                     50,
                     51,
                     52,
                     53,
                     54,
                     55,
                     56,
                     57,
                     58,
                     59,
                     60,
                     61,
                     62,
                     63,
                     64,
                     65,
                     66,
                     67,
                     68,
                     69,
                     70,
                     71,
                     72,
                     73,
                     74,
                     75,
                     76,
                     77,
                     78,
                     79,
                     80,
                     81,
                     82,
                     83,
                     84,
                     85,
                     86,
                     87,
                     88,
                     89,
                     90,
                     91,
                     92,
                     93,
                     94,
                     95,
                     96,
                     97,
                     98,
                     99,
                     100,
                     101,
                     102,
                     103,
                     104,
                     105,
                     106,
                     107,
                     108,
                     109,
                     110,
                     111,
                     112,
                     113,
                     114,
                     115,
                     116,
                     117,
                     118,
                     119,
                     120,
                     121,
                     122,
                     123,
                     124,
                     125,
                     126,
                     127,
                     128,
                     129,
                     130,
                     131,
                     132,
                     133,
                     134,
                     135,
                     136,
                     137,
                     138,
                     139,
                     140,
                     141,
                     142,
                     143,
                     144,
                     145,
                     146,
                     147,
                     148,
                     149,
                     150,
                     151,
                     152,
                     153,
                     154,
                     155,
                     156,
                     157,
                     158,
                     159,
                     160,
                     161,
                     162,
                     163,
                     164,
                     165,
                     166,
                     167,
                     168,
                     169,
                     170,
                     171,
                     172,
                     173,
                     174,
                     175,
                     176,
                     177,
                     178,
                     179,
                     180,
                     181,
                     182,
                     183,
                     184,
                     185,
                     186,
                     187,
                     188,
                     189,
                     190,
                     191,
                     192,
                     193,
                     194,
                     195,
                     196,
                     197,
                     198,
                     199,
                     200,
                     201,
                     202,
                     203,
                     204,
                     205,
                     206,
                     207,
                     208,
                     209,
                     210,
                     211,
                     212,
                     213,
                     214,
                     215,
                     216,
                     217,
                     218,
                     219,
                     220,
                     221,
                     222,
                     223,
                     224,
                     225,
                     226,
                     227,
                     228,
                     229,
                     230,
                     231,
                     232,
                     233,
                     234,
                     235,
                     236,
                     237,
                     238,
                     239,
                     240,
                     241,
                     242,
                     243,
                     244,
                     245,
                     246,
                     247,
                     248,
                     249,
                     250,
                     251,
                     252,
                     253,
                     254,
                     255,
                     256,
                     257,
                     258,
                     259,
                     260,
                     261,
                     262,
                     263,
                     264,
                     265,
                     266,
                     267,
                     268,
                     269,
                     270,
                     271,
                     272,
                     273,
                     274,
                     275,
                     276,
                     277,
                     278,
                     279,
                     280,
                     281,
                     282,
                     283,
                     284,
                     285,
                     286,
                     287,
                     288,
                     289,
                     290,
                     291,
                     292,
                     293,
                     294,
                     295,
                     296,
                     297,
                     298,
                     299,
                     300,
                     301,
                     302,
                     303,
                     304,
                     305,
                     306]

geo_transform = None
projection = None
ydim = None
xdim = None
base_path = "/geo-data/testing"

def load_temperature(fp, temp_type, day, doy):
    temperature_files_path = "/geo-data/climate_data/daily_data/{temp_type}/".format(temp_type=temp_type)
    file_name = temperature_files_path + "{temp_type}_{date}.tif".format(temp_type=temp_type, date=day.strftime("%Y%m%d"))
    ds = gdal.Open(file_name)
    #todo optimize, only set once
    global geo_transform
    global projection
    global ydim
    global xdim
    geo_transform = ds.GetGeoTransform()
    projection = ds.GetProjection()
    ydim = ds.GetGeoTransform()[5] # pixel height (note: can be negative)
    xdim = ds.GetGeoTransform()[1] # pixel width
    temperature_array = np.array(ds.GetRasterBand(1).ReadAsArray())

    # convert -9999 values to not a number so we don't have to worry about manipulating them
    temperature_array[temperature_array == -9999.0] = np.nan
   
    # convert to fahrenheit
    temperature_array *= 1.8
    temperature_array += 32

    #temperature_shape = temperature_array.shape
    fp[doy] = temperature_array[:]

def temperatures_to_memmap(start_date, stop_date):
    temperature_shape = (1228, 2606)
    for temperature_type in ("tmin", "tmax"):
        mem_map_file = f"{base_path}/mem_map_{temperature_type}.dat"
        #if memmap already exists, just update the past 2 weeks
        memmap_mode = 'w+' #create or overwrite
        if os.path.exists(mem_map_file):
            start_date = datetime.strftime((date.today() - timedelta(days=14)), "%Y-%m-%d")
            memmap_mode = 'r+' #open for read and write
        fp = np.memmap(mem_map_file, dtype='float32', mode=memmap_mode, shape=(365, temperature_shape[0], temperature_shape[1]))
        day = datetime.strptime(start_date, "%Y-%m-%d")
        stop = datetime.strptime(stop_date, "%Y-%m-%d")
        doy = 0
        while day <= stop:
            print("loading {d}".format(d=day.strftime("%Y%m%d")))
            load_temperature(fp, temperature_type, day, doy)
            day = day + timedelta(days=1)
            doy += 1


def get_day_lengths():
    (upper_left_x, x_size, x_rotation, upper_left_y, y_rotation, y_size) = geo_transform
    num_lats = 1228
    num_longs = 2606
    day_max = 240

    # calculate latitudes
    site_latitudes = np.arange(num_lats, dtype=float)
    site_latitudes *= -ydim
    site_latitudes += upper_left_y

    # calculate day lengths and rounded day lengths
    site_day_lengths = np.empty((day_max, num_lats))
    for day in range(0, day_max):
        temp_lats = np.copy(site_latitudes)
        for i, temp_lat in enumerate(temp_lats):
            if temp_lat < 40:
                temp_lats[i] = 12.14 + 3.34 * np.tan(temp_lat * np.pi / 180) * np.cos(0.0172 * solar_declination[day] - 1.95)
            else:
                temp_lats[i] = 12.25 + (1.6164 + 1.7643 * (np.tan(temp_lat * np.pi / 180)) ** 2) * np.cos(0.0172 * solar_declination[day] - 1.95)
                # print(str(day) + ' ' + str(i) + ' ' + str(temp_lats[i]))
        site_day_lengths[day, :] = temp_lats
    site_day_lengths[site_day_lengths < 1] = 1
    site_day_lengths[site_day_lengths > 23] = 23

    return site_day_lengths


def gdh_to_memmap(site_day_lengths):
    print("computing growing degree hours")
    base_temp = 31
    temperature_shape = (1228, 2606)
    gdh_mem_map_file = f"{base_path}/mem_map_gdh.dat"
    #if memmap already exists, just update the past 2 weeks
    memmap_mode = 'w+' #create or overwrite
    if os.path.exists(gdh_mem_map_file):
        memmap_mode = 'r+' #open for read and write
    growing_deg_hrs = np.memmap(gdh_mem_map_file, dtype='float32', mode=memmap_mode, shape=(temperature_shape[0], temperature_shape[1], 240))
        
    #load temperatures
    min_temps = np.memmap(f"{base_path}/mem_map_tmin.dat", dtype='float32', mode='r', shape=(365, temperature_shape[0], temperature_shape[1]))
    max_temps = np.memmap(f"{base_path}/mem_map_tmax.dat", dtype='float32', mode='r', shape=(365, temperature_shape[0], temperature_shape[1]))

    # reshape the array to be station lat, station long, day of year, temperature
    min_temps = np.swapaxes(min_temps, 1, 0)
    min_temps = np.swapaxes(min_temps, 2, 1)
    max_temps = np.swapaxes(max_temps, 1, 0)
    max_temps = np.swapaxes(max_temps, 2, 1)

    # todo what is this for?
    # for day in range(1, day_max):
    #     max_temps[:, :, day] = np.maximum(max_temps[:, :, day], min_temps[:, :, day - 1])
    #     min_temps[:, :, day] = np.minimum(min_temps[:, :, day], max_temps[:, :, day - 1])

    #calculate temperature differences
    # min_temps[min_temps == 0] = 0.01
    # max_temps[max_temps == min_temps] += 0.01
    temperature_differences = max_temps - min_temps

    num_lats = max_temps.shape[0]
    num_longs = max_temps.shape[1]
    day_max = 240#max_temps.shape[2]

    print(num_lats)
    print(num_longs)
    print(day_max)

    site_day_lengths_rounded = site_day_lengths.astype(int)

    # min day of year is either two weeks ago or beginning of the year
    # today = datetime.now()
    # day_of_year = (today - datetime(today.year, 1, 1)).days + 1
    # day_min = max(0, day_of_year - 14)
    day_min = 0 #todo fix

    # calculate growing degree hours (parallelized across all longitudes on a latitude)
    for lat in range(0, num_lats):
        lat_gdh = np.empty((day_max, num_longs))
        for day in range(day_min, day_max):
            lat_temp_difs = temperature_differences[lat, :, day]
            lat_day_length = site_day_lengths[day, lat]
            lat_min_temps = min_temps[lat, :, day]
            daily_lat_gdh = np.copy(min_temps[lat, :, day])
            daily_lat_gdh -= base_temp
            daily_lat_gdh[daily_lat_gdh < 0] = 0
            # calculate day time hourly temperatures
            for hour in range(1, site_day_lengths_rounded[day, lat] + 1):
                # gdh[hour] = dt * np.sin(np.pi/(day_length+4)*(hour)) + site_min_temp
                aprox_temps_for_hour = lat_temp_difs * np.sin(np.pi / (lat_day_length + 4) * hour) + lat_min_temps
                aprox_temps_for_hour -= base_temp
                aprox_temps_for_hour[aprox_temps_for_hour < 0] = 0
                daily_lat_gdh += aprox_temps_for_hour
            # calculate sunset time and temperature
            ts1 = lat_temp_difs * np.sin(np.pi / (lat_day_length + 4) * lat_day_length) + lat_min_temps
            ts1[ts1 <= 0] = 0.01
            # calculate night time hourly temperatures
            count = 0
            for hour in range(site_day_lengths_rounded[day, lat] + 1, 24):
                count += 1
                aprox_temps_for_hour = ts1 - (ts1 - lat_min_temps) / (np.log(24 - lat_day_length)) * np.log(count)
                aprox_temps_for_hour -= base_temp
                aprox_temps_for_hour[aprox_temps_for_hour < 0] = 0
                daily_lat_gdh += aprox_temps_for_hour
            lat_gdh[day] = daily_lat_gdh
        gdh = np.swapaxes(lat_gdh, 0, 1)
        # print(gdh.shape) #(2606, 240)
        #todo add lat dimension and save to disk
        gdh = gdh.tolist()
        growing_deg_hrs[lat] = gdh
    return growing_deg_hrs


def get_mem_map(base_path, filename, map_shape, type):
    mem_map_file = f"{base_path}/{filename}.dat"
    memmap_mode = 'w+' #create or overwrite
    if os.path.exists(mem_map_file):
        memmap_mode = 'r+' #open for read and write
    fp = np.memmap(mem_map_file, dtype='float32', mode=memmap_mode, shape=map_shape)
    return fp


def leaf(site_max_temps, base_temp, start_date, day_max, pheno_event, plant, gdh, lat, long, cached_six):
    error = False
    lag = np.zeros(7)
    synop, agdh, mdsum1 = 0, 0, 0
    out_date = 0
    #todo get today's doy
 
    limit = 0
    if pheno_event == 'leaf':
        limit = 637
    elif pheno_event == 'bloom':
        limit = 2001
    else:
        print('error: pheno_event not found - ' + pheno_event)

    for day in range(0, day_max):
        # if day == daystop:
        #         return agdh
        if error is True:
            cached_six[lat, long] = out_date + 1

            return out_date + 1

        # if site_max_temps[day] >= base_temp: # this line was present in matlab six code, but removed because it messes up lag window
        # calculate the growing degree hours value and synoptic info
        growing_degree_hours = gdh[day]
        # set all lag values to day 1 first time through
        if day == 0 and pheno_event == 'leaf':
            lag[0] = growing_degree_hours
            lag[1] = growing_degree_hours

        # print('day:' + str(day))
        # print(growing_degree_hours)
        # print(lag[0])
        # print(lag[1])

        dde2 = growing_degree_hours + lag[0] + lag[1]
        dd57 = sum(lag[4:7])

        if dde2 >= limit:
            syn_flag = 1
        else:
            syn_flag = 0

        if day >= start_date:
            agdh += growing_degree_hours
            if syn_flag == 1:
                synop += 1

        # set agdh and synop accumulations
        if day >= start_date:
            mds0 = day - start_date
            if pheno_event == 'leaf':
                if plant == 'lilac':
                    mdsum1 = (3.306 * mds0) + (13.878 * synop) + (0.201 * dde2) + (0.153 * dd57)
                elif plant == 'arnoldred':
                    mdsum1 = (4.266 * mds0) + (20.899 * synop) + (0.000 * dde2) + (0.248 * dd57)
                elif plant == 'zabelli':
                    mdsum1 = (2.802 * mds0) + (21.433 * synop) + (0.266 * dde2) + (0.000 * dd57)
                else:
                    print('error: plant not found - ' + plant)
            elif pheno_event == 'bloom':
                if plant == 'lilac':
                    mdsum1 = (-23.934 * mds0) + (0.116 * agdh)
                elif plant == 'arnoldred':
                    mdsum1 = (-24.825 * mds0) + (0.127 * agdh)
                elif plant == 'zabelli':
                    mdsum1 = (-11.368 * mds0) + (0.096 * agdh)
                else:
                    print('error: plant not found - ' + plant)
            else:
                print('error: pheno_event not found - ' + pheno_event)
        else:
            mdsum1 = 1

        if mdsum1 >= 999.5 and error is False:
            error = True
            if pheno_event == 'leaf':
                if plant == 'lilac':
                    out_date = day
                elif plant == 'arnoldred':
                    out_date = day + 1
                elif plant == 'zabelli':
                    out_date = day
                else:
                    print('error: plant not found - ' + plant)
            elif pheno_event == 'bloom':
                out_date = day
            else:
                print('error: pheno_event not found - ' + pheno_event)

        # lag = np.roll(lag, 1)
        lag[1:7] = lag[0:6]
        lag[0] = growing_degree_hours
        # end if #####
    if error is False:
        return np.nan
    cached_six[lat, long] = round(out_date + 1)
    return round(out_date + 1)


def compute_spring_index(plant, pheno_event, growing_deg_hrs, leaf_out_days):
    print("computing spring index")
    base_temp = 31
    num_lats = 1228
    num_longs = 2606
    day_max = 240

    max_temps = np.memmap(f"{base_path}/mem_map_tmax.dat", dtype='float32', mode='r', shape=(365, num_lats, num_longs))
    max_temps = np.swapaxes(max_temps, 1, 0)
    max_temps = np.swapaxes(max_temps, 2, 1)
    #max_temps = np.swapaxes(max_temps, 1, 0) #double check why this needed added
    print(max_temps.shape)

    spring_index_array = np.empty((num_lats, num_longs))

    cached_six = get_mem_map(base_path, f"{plant}_{pheno_event}", (num_lats, num_longs), 'float32')
    #todo initialize to -9999s?

    # now we have all the data structures built that could be parallelized, so now run the main six algorithm
    for lat in range(0, num_lats):    
        for long in range(0, num_longs):
            print(lat)
            #print(long)
            # print(max_temps[lat, long])
            # print(growing_deg_hrs[lat, long])
            #if not np.isnan(np.sum(max_temps[lat, long])):
            if not np.isnan(max_temps[lat,long,0]):
                if pheno_event == 'leaf':
                    start_date = 0
                elif pheno_event == 'bloom':
                    start_date = leaf_out_days[lat, long]
                else:
                    print('error: pheno_event not found - ' + pheno_event)
                    return spring_index_array
                if cached_six[lat,long] != 0.0:
                    # print('using cached value')
                    spring_index_array[lat, long] = cached_six[lat,long]
                else:
                    # print(cached_six[lat,long])
                    spring_index_array[lat, long] = leaf(max_temps[lat, long].tolist(), base_temp, start_date, day_max, pheno_event, plant, growing_deg_hrs[lat, long], lat, long, cached_six)
            else:
                # print('ocean')
                spring_index_array[lat, long] = -9999.0
    spring_index_array[np.isnan(spring_index_array)] = -9999.0
    return spring_index_array


def write_int16_raster(file_path, rast_array, no_data_value, rast_cols, rast_rows, projection, transform):
        print("writing geotiff to disk")
        driver = gdal.GetDriverByName('Gtiff')
        raster = driver.Create(file_path, rast_cols, rast_rows, 1, gdal.GDT_Int16)
        band = raster.GetRasterBand(1)
        band.SetNoDataValue(no_data_value)
        band.WriteArray(rast_array)
        raster.SetProjection(projection)
        raster.SetGeoTransform(transform)
        band.FlushCache()

        
if __name__ == "__main__":
    start_date = "2020-01-01"
    # stop_date = "2020-01-22"

    climate_provider = ['ncep']
    plants = ['lilac']
    phenophases = ['leaf']
    # plants = ['lilac', 'arnoldred', 'zabelli']
    # phenophases = ['leaf', 'bloom']

    num_lats = 1228
    num_longs = 2606
    spring_index_average_leaf_array = np.empty((num_lats, num_longs))
    spring_index_average_bloom_array = np.empty((num_lats, num_longs))

    stop_date = datetime.strftime((date.today() + timedelta(days=6)), "%Y-%m-%d")
    temperatures_to_memmap(start_date,stop_date)
    growing_deg_hrs = gdh_to_memmap(get_day_lengths())
    first_plant = True
    for plant in plants:
        for phenophase in phenophases:
            print(f"computing spring index for {plant} {phenophase}")
            if phenophase == 'leaf':
                print('SHOULD SEE THIS')
                spring_index_array = compute_spring_index(plant, phenophase, growing_deg_hrs, None)
            else:
                spring_index_array = compute_spring_index(plant, phenophase, growing_deg_hrs, spring_index_array)
            write_int16_raster(f"{base_path}/{plant}_{phenophase}.tif", spring_index_array, -9999, spring_index_array.shape[1], spring_index_array.shape[0], projection, geo_transform)
            #add to average array
            print("adding to average")
            if first_plant and phenophase == 'leaf':
                spring_index_average_leaf_array = spring_index_array
            elif first_plant and phenophase == 'bloom':
                spring_index_average_bloom_array = spring_index_array
            elif phenophase == 'leaf':
                spring_index_average_leaf_array += spring_index_array
            else: 
                spring_index_average_bloom_array += spring_index_array
            #todo anomalies
        first_plant = False
    #write out the average spring index tiffs
    print("dividing averages by 3 and writing out")
    spring_index_average_leaf_array /= 3
    spring_index_average_bloom_array /= 3
    write_int16_raster(f"{base_path}/average_leaf.tif", spring_index_average_leaf_array, -9999, spring_index_average_leaf_array.shape[1], spring_index_average_leaf_array.shape[0], projection, geo_transform)
    write_int16_raster(f"{base_path}/average_bloom.tif", spring_index_average_bloom_array, -9999, spring_index_average_bloom_array.shape[1], spring_index_average_bloom_array.shape[0], projection, geo_transform)