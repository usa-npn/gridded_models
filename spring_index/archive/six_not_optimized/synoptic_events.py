# Function to calculate number and value of "synoptic events" used
# in SI calculation.
#
# Usage:
#  [dde2, dd57, syn_flag]=synval(gdh_previous_seven_days, gdh, pheno_event)
#
# Inputs:
#  gdh_previous_seven_days.........GDH during previous 7 days
#  gdh.............................GDH at current time
#  pheno_event.....................Event of interest ('leaf' or 'bloom')
import numpy as np

def synoptic_events(gdh_previous_seven_days, gdh, pheno_event):
    limit = 0
    if pheno_event == 'leaf':
        limit = 637
    elif pheno_event == 'bloom':
        limit = 2001
    else:
        print('error: invalid pheno_event')
    if gdh + gdh_previous_seven_days[0] + gdh_previous_seven_days[1] >= limit:
        syn_flag = 1
    else:
        syn_flag = 0

    # calculate last two week degree day accumulation
    dde2 = gdh + gdh_previous_seven_days[0] + gdh_previous_seven_days[1]
    dd57 = np.sum(gdh_previous_seven_days[4:7]) #gdh_previous_seven_days[4] + gdh_previous_seven_days[5] + gdh_previous_seven_days[6]

    return [dde2, dd57, syn_flag]
