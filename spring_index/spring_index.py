import numpy as np
from spring_index.solar_declination import solar_declination


def leaf(site_max_temps, base_temp, start_date, day_max, pheno_event, plant, gdh): #site_max_temps,
    error = False
    lag = [0, 0, 0, 0, 0, 0, 0]
    synop, agdh, mdsum1 = 0, 0, 0
    out_date = 0

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
    return round(out_date + 1)


# compute spring index using hourly temps
def spring_index_hourly(max_temps, gdh, base_temp, leaf_out_days, pheno_event, plant):
    num_lats = gdh.shape[0]
    num_longs = gdh.shape[1]
    day_max = gdh.shape[2]
    spring_index_array = np.empty((num_lats, num_longs))

    for lat in range(0, num_lats):
        for long in range(0, num_longs):
            if not np.isnan(np.sum(gdh[lat, long])):
                if pheno_event == 'leaf':
                    start_date = 0
                elif pheno_event == 'bloom':
                    start_date = leaf_out_days[lat, long]
                else:
                    print('error: pheno_event not found - ' + pheno_event)
                    return spring_index_array
                spring_index_array[lat, long] = leaf(max_temps[lat, long].tolist(), base_temp, start_date, day_max, pheno_event, plant, gdh[lat, long])
            else:
                spring_index_array[lat, long] = -9999.0
    spring_index_array[np.isnan(spring_index_array)] = -9999.0
    return spring_index_array


# compute spring index using daily tmin / tmax temps to create hourly temperature approximations
def spring_index(max_temps, min_temps, base_temp, leaf_out_days, pheno_event, plant, site_latitudes):
    num_lats = max_temps.shape[0]
    num_longs = max_temps.shape[1]
    day_max = max_temps.shape[2]

    spring_index_array = np.empty((num_lats, num_longs))

    for day in range(1, day_max):
        max_temps[:, :, day] = np.maximum(max_temps[:, :, day], min_temps[:, :, day - 1])
        min_temps[:, :, day] = np.minimum(min_temps[:, :, day], max_temps[:, :, day - 1])

    # calculate day lengths and rounded day lengths
    site_day_lengths = np.empty((day_max, num_lats))
    for day in range(0, day_max):
        temp_lats = np.copy(site_latitudes)
        for i, temp_lat in enumerate(temp_lats):
            if temp_lat < 40:
                temp_lats[i] = 12.14 + 3.34 * np.tan(temp_lat * np.pi / 180) * np.cos(0.0172 * solar_declination[day] - 1.95)
            else:
                temp_lats[i] = 12.25 + (1.6164 + 1.7643 * (np.tan(temp_lat * np.pi / 180)) ** 2) * np.cos(0.0172 * solar_declination[day] - 1.95)
        # temp_lats[temp_lats < 40] = 12.14 + 3.34 * np.tan(site_latitudes[site_latitudes < 40] * np.pi / 180) * np.cos(0.0172 * solar_declination[day] - 1.95)
        # temp_lats[temp_lats >= 40] = 12.25 + (1.6164 + 1.7643 * (
        # np.tan(site_latitudes[site_latitudes >= 40] * np.pi / 180)) ** 2) * np.cos(0.0172 * solar_declination[day] - 1.95)
        site_day_lengths[day, :] = temp_lats
    site_day_lengths[site_day_lengths < 1] = 1
    site_day_lengths[site_day_lengths > 23] = 23
    site_day_lengths_rounded = site_day_lengths.astype(int)

    # calculate temperature differences
    min_temps[min_temps == 0] = 0.01
    max_temps[max_temps == min_temps] += 0.01
    temperature_differences = max_temps - min_temps

    # calculate growing degree hours (parallelized across all longitudes on a latitude)
    for lat in range(0, num_lats):
        lat_gdh = np.empty((day_max, num_longs))
        for day in range(0, day_max):
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
        gdh = gdh.tolist()


        # now we have all the data structures built that could be parallelized, so now run the main six algorithm
        for long in range(0, num_longs):
            if not np.isnan(np.sum(max_temps[lat, long])):
                if pheno_event == 'leaf':
                    start_date = 0
                elif pheno_event == 'bloom':
                    start_date = leaf_out_days[lat, long]
                else:
                    print('error: pheno_event not found - ' + pheno_event)
                    return spring_index_array
                spring_index_array[lat, long] = leaf(max_temps[lat, long].tolist(), base_temp, start_date, day_max, pheno_event, plant, gdh[long])
            else:
                spring_index_array[lat, long] = -9999.0

    spring_index_array[np.isnan(spring_index_array)] = -9999.0
    return spring_index_array


def spring_index_for_point(max_temps, min_temps, base_temp, leaf_out_day, pheno_event, plant, lat):

    # calculate day lengths and rounded day lengths
    day_max = len(max_temps)
    site_day_lengths = np.empty(day_max)
    for day in range(0, day_max):
        if lat < 40:
            dll = 12.14 + 3.34 * np.tan(lat * np.pi / 180) * np.cos(0.0172 * solar_declination[day] - 1.95)
        else:
            dll = 12.25 + (1.6164 + 1.7643 * (np.tan(lat * np.pi / 180)) ** 2) * np.cos(0.0172 * solar_declination[day] - 1.95)
        site_day_lengths[day] = dll
    site_day_lengths[site_day_lengths < 1] = 1
    site_day_lengths[site_day_lengths > 23] = 23
    site_day_lengths_rounded = site_day_lengths.astype(int)

    # calculate temperature differences
    min_temps[min_temps == 0] = 0.01
    max_temps[max_temps == min_temps] += 0.01
    temperature_differences = max_temps - min_temps

    # calculate growing degree hours
    gdh = np.empty(day_max)
    for day in range(0, day_max):
        temp_diff = temperature_differences[day]
        day_length = site_day_lengths[day]
        min_temp = min_temps[day]
        daily_gdh = min_temp
        daily_gdh -= base_temp
        if daily_gdh < 0:
            daily_gdh = 0
        # calculate day time hourly temperatures
        for hour in range(1, site_day_lengths_rounded[day] + 1):
            aprox_temp_for_hour = temp_diff * np.sin(np.pi / (day_length + 4) * hour) + min_temp
            aprox_temp_for_hour -= base_temp
            if aprox_temp_for_hour < 0:
                aprox_temp_for_hour = 0
            daily_gdh += aprox_temp_for_hour
        # calculate sunset time and temperature
        ts1 = temp_diff * np.sin(np.pi / (day_length + 4) * day_length) + min_temp
        if ts1 <= 0:
            ts1 = 0.01
        # calculate night time hourly temperatures
        count = 0
        for hour in range(site_day_lengths_rounded[day] + 1, 24):
            count += 1
            aprox_temp_for_hour = ts1 - (ts1 - min_temp) / (np.log(24 - day_length)) * np.log(count)
            aprox_temp_for_hour -= base_temp
            if aprox_temp_for_hour < 0:
                aprox_temp_for_hour = 0
            daily_gdh += aprox_temp_for_hour
        gdh[day] = daily_gdh

    start_date = leaf_out_day
    spring_index_day = leaf(None, None, start_date, day_max, pheno_event, plant, gdh)
    return spring_index_day