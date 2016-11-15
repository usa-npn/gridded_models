# Calculate growing degree hours. 
# Usage:
#   total_gdh_for_day = get_growing_degree_hours(site_max_temp, site_min_temp, day_length, base_temp)
# 
# Input:
#  site_max_temp........Maximum value
#  site_min_temp........Minimum values
#  day_length....Length of day
#  base_temp.....Base temperature (values above this threshold count
#            towards growing degree hours).
# Output
#  total_gdh_for_day....Growing degree hours
import numpy as np


def get_growing_degree_hours(site_max_temp, site_min_temp, day_length, base_temp):
    gdh = np.zeros(24)
    if site_min_temp == 0:
        site_min_temp = 0.01
    if site_max_temp == site_min_temp:
        site_max_temp += 0.01
    dt = site_max_temp - site_min_temp

    day_length_rounded = int(np.floor(day_length))

    # calculate day time hourly temperatures
    gdh[0] = site_min_temp
    for hour in range(1, day_length_rounded+1):
        gdh[hour] = dt * np.sin(np.pi/(day_length+4)*(hour)) + site_min_temp

    # calculate sunset time and temperature
    ts1 = dt*np.sin(np.pi/(day_length+4)*day_length) + site_min_temp
    if ts1 <= 0:
        ts1 = 0.01

    # calculate night time hourly temperatures
    count = 0
    for hour in range(day_length_rounded + 1, 24):
        count += 1
        gdh[hour] = ts1-(ts1-site_min_temp)/(np.log(24-day_length))*np.log(count)

    # add up the growing degree hours
    total_gdh_for_day = 0
    for hour in range(0, 24):
        if gdh[hour] - base_temp > 0:
            total_gdh_for_day += (gdh[hour] - base_temp)
    return total_gdh_for_day
