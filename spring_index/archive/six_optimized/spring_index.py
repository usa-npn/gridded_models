import numpy as np

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


def leaf(site_max_temps, base_temp, start_date, day_max, pheno_event, plant, gdh, daystop):
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
        print('error: invalid pheno_event')

    for day in range(0, day_max):
        # if day == daystop:
        #         return agdh
        if error is True:
            return out_date + 1

        if site_max_temps[day] >= base_temp:
            # calculate the growing degree hours value and synoptic info
            growing_degree_hours = gdh[day]
            # set all lag values to day 1 first time through
            if day == 0 and pheno_event == 'leaf':
                lag[0] = growing_degree_hours
                lag[1] = growing_degree_hours

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
                    elif plant == 'arnold_red':
                        mdsum1 = (4.266 * mds0) + (20.899 * synop) + (0.000 * dde2) + (0.248 * dd57)
                    elif plant == 'zabelli':
                        mdsum1 = (2.802 * mds0) + (21.433 * synop) + (0.266 * dde2) + (0.000 * dd57)
                    else:
                        print('error: plant not found')
                elif pheno_event == 'bloom':
                    if plant == 'lilac':
                        mdsum1 = (-23.934 * mds0) + (0.116 * agdh)
                    elif plant == 'arnold_red':
                        mdsum1 = (-24.825 * mds0) + (0.127 * agdh)
                    elif plant == 'zabelli':
                        mdsum1 = (-11.368 * mds0) + (0.096 * agdh)
                    else:
                        print('error: plant not found')
                else:
                    print('error: pheno_event not found')
            else:
                mdsum1 = 1

            if mdsum1 >= 999.5 and error is False:
                error = True
                if pheno_event == 'leaf':
                    if plant == 'lilac':
                        out_date = day
                    elif plant == 'arnold_red':
                        out_date = day + 1
                    elif plant == 'zabelli':
                        out_date = day
                    else:
                        print('error: plant not found')
                elif pheno_event == 'bloom':
                    out_date = day
                else:
                    print('error: pheno_event not found')

            # lag = np.roll(lag, 1)
            lag[1:7] = lag[0:6]
            lag[0] = growing_degree_hours
    if error is False:
        return np.nan
    return round(out_date + 1)


def spring_index(max_temps, min_temps, base_temp, start_date, pheno_event, plant, upper_left_y, ydim, daystop):
    num_lats = 621
    num_longs = 1405
    day_max = 240

    spring_index_array = np.empty((num_lats, num_longs))

    for day in range(1, day_max):
        max_temps[:, :, day] = np.maximum(max_temps[:, :, day], min_temps[:, :, day - 1])
        min_temps[:, :, day] = np.minimum(min_temps[:, :, day], max_temps[:, :, day - 1])

    # calculate latitudes
    site_latitudes = np.arange(num_lats, dtype=float)
    site_latitudes *= -ydim
    site_latitudes += upper_left_y

    # calculate day lengths and rounded day lengths
    site_day_lengths = np.empty((day_max, num_lats))
    for day in range(0, day_max):
        temp_lats = np.copy(site_latitudes)
        temp_lats[temp_lats < 40] = 12.14 + 3.34 * np.tan(site_latitudes[site_latitudes < 40] * np.pi / 180) * np.cos(0.0172 * solar_declination[day] - 1.95)
        temp_lats[temp_lats >= 40] = 12.25 + (1.6164 + 1.7643 * (
        np.tan(site_latitudes[site_latitudes >= 40] * np.pi / 180)) ** 2) * np.cos(0.0172 * solar_declination[day] - 1.95)
        site_day_lengths[day, :] = temp_lats
    site_day_lengths[site_day_lengths < 1] = 1
    site_day_lengths[site_day_lengths > 23] = 23
    site_day_lengths_rounded = site_day_lengths.astype(int)

    # calculate temperature differences
    min_temps[min_temps == 0] = 0.01
    max_temps[np.logical_and(max_temps == min_temps, max_temps != -9999)] += 0.01
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
            if np.nanmin(max_temps[lat, long]) != -9999.0 and np.nanmin(max_temps[lat, long]) != -9999.0:
                spring_index_array[lat, long] = leaf(max_temps[lat, long].tolist(), base_temp, start_date, day_max, pheno_event, plant, gdh[long], daystop)
            else:
                spring_index_array[lat, long] = -9999.0

    return spring_index_array
