# This driver is similar in spirit to the original fortran to matlab port verifier
# It plots an overlay of the leaf and bloom indexes for six test stations to make sure
# that the output of this python spring index code is the same as the output of the matlab spring index code

import matplotlib.pyplot as plt
import numpy as np
from six_not_optimized.calc_si import calc_si


print("reading in station long/lat information from csv...")
station_latitudes = np.genfromtxt('test_data\\lat.csv', delimiter=",")
print("reading in temperature matixes from csv...")
temperature_min = np.genfromtxt('test_data\\tmin.csv', delimiter=",")
temperature_max = np.genfromtxt('test_data\\tmax.csv', delimiter=",")

print("reshaping temperature matixes...")
temperature_min = np.reshape(temperature_min, (201, 6, 366))
temperature_max = np.reshape(temperature_max, (201, 6, 366))

print("calculating spring index...")
results = calc_si(temperature_min, temperature_max, station_latitudes)

print("reading in matlab spring index results...")
station_1 = np.genfromtxt('matlab_results\\station_1.csv', delimiter=",")
station_2 = np.genfromtxt('matlab_results\\station_2.csv', delimiter=",")
station_3 = np.genfromtxt('matlab_results\\station_3.csv', delimiter=",")
station_4 = np.genfromtxt('matlab_results\\station_4.csv', delimiter=",")
station_5 = np.genfromtxt('matlab_results\\station_5.csv', delimiter=",")
station_6 = np.genfromtxt('matlab_results\\station_6.csv', delimiter=",")

station_1_bloom = np.genfromtxt('matlab_results\\station_1_bloom.csv', delimiter=",")
station_2_bloom = np.genfromtxt('matlab_results\\station_2_bloom.csv', delimiter=",")
station_3_bloom = np.genfromtxt('matlab_results\\station_3_bloom.csv', delimiter=",")
station_4_bloom = np.genfromtxt('matlab_results\\station_4_bloom.csv', delimiter=",")
station_5_bloom = np.genfromtxt('matlab_results\\station_5_bloom.csv', delimiter=",")
station_6_bloom = np.genfromtxt('matlab_results\\station_6_bloom.csv', delimiter=",")

print("plotting results...")
f, axarr = plt.subplots(6, sharex=True)
axarr[0].plot(station_1, label="station 1 leaf matlab")
axarr[0].plot(station_1_bloom, label="station 1 bloom matlab")
axarr[0].set_title('Station 1')
# axarr[0].legend(bbox_to_anchor=(0., 1.02, 1., .102), loc=3, ncol=2, mode="expand", borderaxespad=0.)
axarr[1].plot(station_2, label="station 2 leaf matlab")
axarr[1].plot(station_2_bloom, label="station 2 bloom matlab")
axarr[1].set_title('Station 2')
axarr[2].plot(station_3, label="station 3 leaf matlab")
axarr[2].plot(station_3_bloom, label="station 3 bloom matlab")
axarr[2].set_title('Station 3')
axarr[3].plot(station_4, label="station 4 leaf matlab")
axarr[3].plot(station_4_bloom, label="station 4 bloom matlab")
axarr[3].set_title('Station 4')
axarr[4].plot(station_5, label="station 5 leaf matlab")
axarr[4].plot(station_5_bloom, label="station 5 bloom matlab")
axarr[4].set_title('Station 5')
axarr[5].plot(station_6, label="station 6 leaf matlab")
axarr[5].plot(station_6_bloom, label="station 6 bloom matlab")
axarr[5].set_title('Station 6')

for station in range(0, 6):
    average_si_leaf = (results[station, :, 0, 0] + results[station, :, 1, 0] + results[station, :, 2, 0]) / 3
    average_si_bloom = (results[station, :, 0, 1] + results[station, :, 1, 1] + results[station, :, 2, 1]) / 3
    # can also graph unaveraged individual results like so:
    # axarr[station].plot(results[station, :, 0, 0])
    # axarr[station].plot(results[station, :, 1, 0])
    # axarr[station].plot(results[station, :, 2, 0])
    axarr[station].plot(average_si_leaf, label="station 1 leaf python")
    axarr[station].plot(average_si_bloom, label="station 1 bloom python")
    if station == 0:
        axarr[0].legend(bbox_to_anchor=(0., 1.02, 1., .102), loc=3, ncol=2, mode="expand", borderaxespad=0.)

plt.show()
