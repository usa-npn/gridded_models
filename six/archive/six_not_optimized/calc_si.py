# Main SI-PYTHON driver function for calculating first leaf, first bloom, and least freeze.
#     
# Usage:    
#  [LF,BL,LSTFR,LFpred,BLpred]=calc_si(t_min, t_max, latitude)
# 
# Input:
#  t_min..........2D or 3D array of Tmin values (nyrs x 366 x nstns)
#  t_max..........2D or 3D array of Tmax values (nyrs x 366 x nstns)
#  latitude.......1D vector of latitudes for all stations (1 x nstns)
# 
# Output:
#  LFMTX............Matrix of leaf out dates (nyrs x 4 x nstns)
#                   (Ordered as [mean plant1 plant2 plant3])
#  BLMTX............Matrix of bloom index dates (nyrs x 4 x nstns)
#                   (Ordered as [mean plant1 plant2 plant3])
#
# TODO: port these
#  LSTFRZMTX........Matrix of last freeze dates (nyrs x 4 x nstns)
#  LFpredMTX........Matrix of average leaf components (nyears x 5 x nstns)
#  BLpredMTX........Matrix of average blooming components (nyears x 5 x nstns)


import numpy as np
from leaf import leaf
from six_not_optimized.daylength import get_day_lengths


def calc_si(t_min: np.ndarray, t_max: np.ndarray, latitude: np.ndarray):

    num_years, num_sites, num_days = t_min.shape

    # leaf_matrix = np.empty((num_years, num_sites, 4))
    # bloom_matrix = np.empty((num_years, num_sites, 4))

    # num_predictors = 5
    # leaf_predictors = np.empty((num_years, num_sites, num_predictors))
    # bloom_predictors = np.empty((num_years, num_sites, num_predictors))
    # last_freeze_for_sites = np.empty((num_years, num_sites))

    base_temp = 31
    day_stop = 240
    # freeze_temp = 28

    si_out = np.empty((num_sites, num_years, 3, 2))

    for site in range(0, num_sites):
        # calculate daylength for the station via its latitude
        day_lengths = get_day_lengths(day_stop, latitude[site])

        for year in range(0, num_years):
            # grab array of first 240 days of min and max tmps at the site
            site_min_temps_for_year = np.squeeze(t_min[year, site, :])
            site_max_temps_for_year = np.squeeze(t_max[year, site, :])
            site_min_temps = site_min_temps_for_year[:day_stop]
            site_max_temps = site_max_temps_for_year[:day_stop]

            flagm = False

            # look at each 30 day chunk of the first 240 days
            # and compute monthly averages for minTemp and maxTemp
            # these averages are used to overwrite outlier temps in the input matrix
            for month in range(0, day_stop, 30):
                min_temp_zeros_found, min_temp_count, min_temp_monthly_sum, min_temp_average = 0, 0, 0, 0
                max_temp_zeros_found, max_temp_count, max_temp_monthly_sum, max_temp_average = 0, 0, 0, 0

                for dayOfYear in range(month, month+30):
                    if np.isfinite(site_max_temps[dayOfYear]) or (site_max_temps[dayOfYear] > -99 and site_max_temps[dayOfYear] < 125):
                        if site_max_temps[dayOfYear] == 0:
                            max_temp_zeros_found += 1
                        max_temp_count += 1
                        max_temp_monthly_sum += site_max_temps[dayOfYear]

                for dayOfYear in range(month, month+30):
                    if np.isfinite(site_min_temps[dayOfYear]) or (site_min_temps[dayOfYear] > -99 and site_min_temps[dayOfYear] < 125):
                        if site_min_temps[dayOfYear] == 0:
                            min_temp_zeros_found += 1
                        min_temp_count += 1
                        min_temp_monthly_sum += site_min_temps[dayOfYear]

                if min_temp_zeros_found > 10 or max_temp_zeros_found > 10 or min_temp_count < 20 or max_temp_count < 20:
                    flagm = True

                if flagm is False:
                    min_temp_average = min_temp_monthly_sum / min_temp_count
                    max_temp_average = max_temp_monthly_sum / max_temp_count

                    # overwrite outlier temps with monthly average
                    for dayOfYear in range(month, month+30):
                        if(np.isnan(site_min_temps[dayOfYear])
                           or site_min_temps[dayOfYear] > 125 or site_min_temps[dayOfYear] < -99):
                            site_min_temps[dayOfYear] = min_temp_average

                        if(np.isnan(site_max_temps[dayOfYear])
                           or site_max_temps[dayOfYear] > 125 or site_max_temps[dayOfYear] < -99):
                            site_max_temps[dayOfYear] = max_temp_average
            if flagm is True:
                si_out[site, year, 0, 0] = np.nan
                si_out[site, year, 0, 1] = np.nan
                si_out[site, year, 1, 0] = np.nan
                si_out[site, year, 1, 1] = np.nan
                si_out[site, year, 2, 0] = np.nan
                si_out[site, year, 2, 1] = np.nan
            else:
                # calculate last freeze date at the station
                # last_freeze_day = 0
                # for day in range(day_stop, 0):
                #     if site_min_temps[day] < freeze_temp:
                #         last_freeze_day = day
                #         break
                # for each plant
                # calculate leaf, bloom, and sindex dates for the site durring the year

                plants = ['lilac', 'arnold_red', 'zabelli']
                pheno_events = ['leaf', 'bloom']
                plant_index = 0
                for plant in plants:
                    pheno_event_index = 0
                    for pheno_event in pheno_events:
                        if pheno_event == 'leaf':
                            start_date = 0
                        else:
                            start_date = spring-1
                        spring = leaf(site_max_temps, site_min_temps, day_lengths, base_temp, start_date, pheno_event, plant)
                        si_out[site, year, plant_index, pheno_event_index] = spring
                        pheno_event_index += 1
                    plant_index += 1
    return si_out
