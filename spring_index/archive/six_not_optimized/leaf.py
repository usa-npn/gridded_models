# Function called by calc_si to do most of the heavy living in
# actually calculating spring indices.
#
#Usage:
# out_date = leaf(site_max_temps, site_min_temps, day_lengths, base_temp, start_date, pheno_event, plant)
#
# Inputs:
#
#  site_max_temps.....Vector of max temps for a single year/site
#  site_min_temps.....Vector of min temps for a single year/site
#  day_lengths........Daylength vector for all days corresponding to t_min/t_max
#  base_temp.........."Base" temperature from which GDH are calculated
#  start_date.........Date of "reference" event:
#       January 1 when first leaf is being calculated
#       Leaf date when first bloom is being calculated
#  pheno_event........Phenological event to be modeled - 'leaf' for "first leaf", 'bloom' for "first bloom."
#
#  plant..............Plant species being modeled - lilac, arnold red, or zabelli)
#
# Outputs:
#  out_date.......Day of year (integer) for a given year/site/plant/event
# TODO: Port the following output
#  Xpred.........State of each of the four predictor values at the
#                time the modeled phenological event occurs.

import numpy as np
from six_not_optimized.growing_degree_hours import get_growing_degree_hours
from six_not_optimized.synoptic_events import synoptic_events

leaf_predictors = np.array([[3.306, 13.878, 0.201, 0.153],
                            [4.266, 20.899, 0.000, 0.248],
                            [2.802, 21.433, 0.266, 0.000]])

bloom_predictors = np.array([[-23.934, 0.116],
                            [-24.825, 0.127],
                            [-11.368, 0.096]])


def leaf(site_max_temps, site_min_temps, day_lengths, base_temp, start_date, pheno_event, plant):

    day_max = 240
    error = False
    lag = np.zeros(7)
    synop, agdh, mdsum1 = 0, 0, 0
    out_date = 0
    # day=start_date-1
    for day in range(0, day_max):
        if error is True:
            return out_date + 1
        # check for max-min lag errors
        # if day == day_max:
        #     if error is False:
        #         out_date = np.nan
        #     break
        if day > 0:
            if site_max_temps[day] < site_min_temps[day-1]:
                site_max_temps[day] = site_min_temps[day-1]
            if site_min_temps[day] > site_max_temps[day-1]:
                site_min_temps[day] = site_max_temps[day-1]

        if site_max_temps[day] >= base_temp:
            # calculate the growing degree hours value and synoptic info
            growing_degree_hours = get_growing_degree_hours(site_max_temps[day], site_min_temps[day], day_lengths[day], base_temp)
            # set all lag values to day 1 first time through
            if day == 0 and pheno_event == 'leaf':
                lag[0] = growing_degree_hours
                lag[1] = growing_degree_hours

            [dde2, dd57, syn_flag] = synoptic_events(lag, growing_degree_hours, pheno_event)

            if day >= start_date:
                agdh += growing_degree_hours
                if syn_flag == 1:
                    synop += 1

            # set agdh and synop accumulations
            if day >= start_date:
                mds0 = day - start_date
                if pheno_event == 'leaf':
                    if plant == 'lilac':
                        mdsum1 = (leaf_predictors[0, 0]*mds0)+(leaf_predictors[0, 1]*synop)+(leaf_predictors[0, 2]*dde2)+(leaf_predictors[0, 3]*dd57)
                    elif plant == 'arnold_red':
                        mdsum1 = (leaf_predictors[1, 0]*mds0)+(leaf_predictors[1, 1]*synop)+(leaf_predictors[1, 2]*dde2)+(leaf_predictors[1, 3]*dd57)
                    elif plant == 'zabelli':
                        mdsum1 = (leaf_predictors[2, 0]*mds0)+(leaf_predictors[2, 1]*synop)+(leaf_predictors[2, 2]*dde2)+(leaf_predictors[2, 3]*dd57)
                    else:
                        print('error: plant not found')
                elif pheno_event == 'bloom':
                    if plant == 'lilac':
                        mdsum1 = (bloom_predictors[0, 0]*mds0)+(bloom_predictors[0, 1]*agdh)
                    elif plant == 'arnold_red':
                        mdsum1 = (bloom_predictors[1, 0]*mds0)+(bloom_predictors[1, 1]*agdh)
                    elif plant == 'zabelli':
                        mdsum1 = (bloom_predictors[2, 0]*mds0)+(bloom_predictors[2, 1]*agdh)
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

            lag[1:7] = lag[0:6]
            lag[0] = growing_degree_hours
    if error is False:
        return np.nan
    return round(out_date+1)
