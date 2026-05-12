# Demo for Spring Development Index Raster Development
# Author: Joshua J. Hatzis
# Date: 2024-02-28

# Load libraries
import numpy as np
import rasterio as rs
import pandas as pd
import datetime as dt
import math
from rasterio.io import MemoryFile
import psycopg2
from psycopg2.extensions import AsIs
import yaml
import os.path
import datetime
from dateutil.relativedelta import relativedelta
from util.database import update_time_series


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.safe_load(ymlfile)
db = cfg["postgis"]

try:
    conn = psycopg2.connect(dbname=db["db"], port=db["port"], user=db["user"],
                        password=db["password"], host=db["host"], keepalives=1, keepalives_idle=30,
                        keepalives_interval=10, keepalives_count=5)
except:
    print('database.py failed to connect to the database: ' + db["db"])

def get_raster_from_query(query, data):
    # Load raster from postgis into a virtual memory file
    vsipath = '/vsimem/from_postgis'
    curs = conn.cursor()
    curs.execute(query, data)
    result = curs.fetchone()
    curs.close()
    
    with MemoryFile(bytes(result[0])) as memfile:
     with memfile.open() as dataset:
         data_array = dataset.read()
         return data_array
    

def get_raster_array(table_name, column_name, value):
    query = "SELECT ST_AsGDALRaster(ST_Union(rast), 'Gtiff') FROM %s WHERE %s = %s;"
    data = (AsIs(table_name), AsIs(column_name), value)
    return get_raster_from_query(query, data)

def get_climate_data(var_type, date, temp_unit):
    """
    Read climate data from GeoTIFF files on disk.

    var_type: 'tmin' or 'tmax'
    date: datetime.date object
    temp_unit: 'fahrenheit' or 'celsius' (currently unused but kept for compatibility)
    """
    # Construct the file path
    # Format: /geo-data/climate_data/prism/prism_tmin/prism_tmin_us_25m_YYYYMMDD.tif
    base_dir = f"/geo-data/climate_data/prism/prism_{var_type}"
    filename = f"prism_{var_type}_us_25m_{date.strftime('%Y%m%d')}.tif"
    filepath = os.path.join(base_dir, filename)

    if not os.path.exists(filepath):
        print(f"Warning: File not found: {filepath}")
        return None

    with rs.open(filepath) as src:
        outarray = src.read()

    # convert -9999 values to not a number so we don't have to worry about manipulating them
    outarray[outarray == -9999.0] = np.nan
    #if temp_unit == 'fahrenheit':
    #    outarray *= 1.8
    #    outarray += 32
    return outarray


def find_last_available_date(var_type):
    """Find the most recent date for which PRISM GeoTIFF data exists on disk."""
    base_dir = f"/geo-data/climate_data/prism/prism_{var_type}"
    latest = None
    if not os.path.isdir(base_dir):
        return None
    prefix = f"prism_{var_type}_us_25m_"
    for filename in os.listdir(base_dir):
        if filename.startswith(prefix) and filename.endswith(".tif"):
            date_str = filename[len(prefix):-4]
            try:
                d = datetime.datetime.strptime(date_str, "%Y%m%d").date()
                if latest is None or d > latest:
                    latest = d
            except ValueError:
                continue
    return latest


#==============================================================
# DEFINE FUNCTIONS
#
# Calculate growing degree hours for a single point
def growing_degree_hours(tmn, tmx, pp, tbase):
    # Check if value is nan
    if (np.isnan(tmn) or np.isnan(tmx) or np.isnan(pp)):
        return(np.nan)
    
    # trying to optimize
    if (tmn == 0 and tmx == 0):
        return 0
    
    # Define constants
    PI = 3.14159
    
    # Initialize numeric vector for hourly temperatures
    T_hour = []
    GDH = 0
    
    # Adjust min and max values for use with log function
    if tmn == 0:
        MN = 0.01
    else:
        MN = tmn
    
    if tmx == MN:
        MX = tmx + 0.01
    else:
        MX = tmx

    # Calculate temperature range
    DT = MX - MN

    # Calculate daylength as an integer
    IDL = math.floor(pp)
    
    # Add minimum temperature to hourly temperature list
    T_hour.append(MN)
    
    # Add temperatures for daylight hours
    hr_m = list(range(1,IDL+1))
    for i in hr_m:
        T_hour.append(DT*math.sin(PI/(pp+4)*(i))+MN)
    
    # Calculate temperature at sunset
    TS1 = DT*math.sin(PI/(pp+4)*pp)+MN
    if (TS1 <= 0):
        TS1 = 0.01
    
    # Calculate night time hourly temperatures
    hr_n = list(range(1, 24-IDL))
    for i in hr_n:
        T_hour.append(TS1-(TS1-MN)/(math.log(24-pp))*math.log(i))
        
    for i in range(0,24):
        if T_hour[i] - tbase >= 0:
            GDH += T_hour[i]-tbase
        
    return (GDH)

# Calculate triangular temperature response for a single point
def triangular_temperature_response(tmin, tmax, T_min, T_opt, T_max):
    
    # Calculate mean daily temperature from min and max
    tmean = (tmin + tmax) / 2

    # Calculate the triangular temperature response from Basler (2016)
    if ((tmean >= T_min) & (tmean < T_opt)):
        return ((tmean - T_min)/(T_opt - T_min))
    elif ((tmean >= T_opt) & (tmean < T_max)):
        return (1 - ((tmean - T_opt)/(T_max - T_opt)))
    else:
        return (0)

# Calculate heat units for an array of values
def heat_units(T_min, T_max, D_len, model, pars):
    # Initialize variables
    nrow = T_min.shape[1]
    ncol = T_min.shape[2]
    nday = T_min.shape[0]
    cumchl = np.zeros((nrow, ncol))            # Cumulative chill units
    
    # Initialize parameter values
    pr_tbase = pars[1]
    pr_t0chill = pars[2]
    pr_tmin = pars[3]
    pr_topt = pars[4]
    pr_tmax = pars[5]
    pr_Creq = pars[6]
    pr_f = pars[7]

    # Create empty vectors for hourly temperature and heating units
    hu = np.empty((nday, nrow, ncol))
    hu[:] = np.nan

    # Calculate accumulated growing degree hours for day
    gdd = np.stack(np.vectorize(growing_degree_hours) \
                   (T_min, T_max, D_len, pr_tbase), \
                   axis=0)

    if (model == "TT"):
        # For thermal time model the heat units are just the growing degree
        # days or hours
        hu[:] = gdd
    elif (model == "SQ"):
        # For sequential model, a chilling requirement must first be met then
        # heat units begin accumulating

        # Set day to start accumulating chilling
        dchl = int(np.floor(pr_t0chill))

        # Use triangular temperature response to calculate chilling
        # for each day
        xchl = np.stack(np.vectorize(triangular_temperature_response) \
                        (T_min, T_max, pr_tmin, pr_topt, pr_tmax), \
                        axis=0)

        # Set the daily chill to 0 if its before the date we want to begin
        # accumulating chill
        xchl[0:(dchl+1),:,:] = 0

        # Accumulate daily chill
        cumchl = np.cumsum(xchl, axis=0)

        # Check if accumulated chill has passed the required level. If so set
        # the binary multiplier to 1 to indicate heat can begin to accumulate
        k = cumchl
        k[k < pr_Creq] = 0
        k[k >= pr_Creq] = 1

        # Calculate heat units (as growing degree days or hours) for the day,
        # will be 0 if before the chill requirement is met (k=0)
        hu[:] = gdd * k
                
    elif (model == "PTT"):
        # For photothermal time model we reduce the heat units (as growing
        # degree days or hours) by the fraction of the day that is in daylight
        hu[:] = gdd * (D_len / 24)
    elif (model == "M1"):
        # For the M1 photothermal time model we reduce the heat units (as
        # growing degree days or hours) by a daylength-based parameter.
        hu[:] = np.power(gdd * (D_len / 10), pr_f)

    return (hu)
#==============================================================

# Set path to demo directory
#root_dir = 'C:/Users/hatzis/Desktop/SDIpy_demo/'
# root_dir = '/Users/jeff/Development/SDIpy_demo/'
root_dir = '/usr/local/scripts/SDIpy_demo/'

# Read in model and model summary files as data frames
models = pd.read_csv(root_dir + 'data/operationalized_SDI_models.csv')

# Set year to model (really previous year, since we start on 10/1)
# Dynamically determine: if we're in Oct-Dec, the season starts this year;
# otherwise (Jan-Sep) the season started last year.
current_date_now = datetime.date.today()
if current_date_now.month >= 10:
    year = current_date_now.year
else:
    year = current_date_now.year - 1

# Find the most recent date for which both tmin and tmax PRISM files exist
last_tmin_date = find_last_available_date('tmin')
last_tmax_date = find_last_available_date('tmax')
last_data_date = min(last_tmin_date, last_tmax_date)
print(f"Last available PRISM data: {last_data_date}")

# Make a list of split species models
split_spp = [] 
#split_spp = ["Acer rubrum bloom", "Liquidambar styraciflua leaf", 
#             "Prunus virginiana leaf", "Prunus virginiana bloom"]

# Create dictionary matching index names and species models
sdi_index={
    #"Very Early leaf":["Symphoricarpos albus leaf", "Lindera benzoin leaf"],
    #"Early leaf":["Forsythia spp. leaf", "Carpinus caroliniana leaf",
    #              "Prunus virginiana leaf", "Liriodendron tulipifera leaf",
    #              "Acer negundo leaf"],
    #"Middle leaf":["Liquidambar styraciflua leaf", "Acer saccharum leaf",
    #               "Prunus serotina leaf", "Cornus florida leaf",
    #               "Populus tremuloides leaf", "Acer rubrum leaf"],
    #"Late leaf":["Populus deltoides leaf", "Cercis canadensis leaf",
    #             "Quercus rubra leaf", "Fraxinus pennsylvanica leaf",
    #             "Quercus alba leaf", "Acer pensylvanicum leaf",
    #             "Fagus grandifolia leaf", "Betula alleghaniensis leaf"],
    #"Very Early bloom":["Corylus cornuta bloom", "Acer rubrum bloom",
    #                    "Lindera benzoin bloom", "Forsythia spp. bloom"],
    #"Early bloom":["Carpinus caroliniana bloom", "Acer saccharum bloom",
    #               "Acer negundo bloom", "Cercis canadensis bloom", 
    #               "Betula papyrifera bloom", "Populus deltoides bloom",
    #               "Amelanchier grandiflora-autumnbrilliance bloom"],
    #"Middle bloom":["Cornus florida bloom", "Acer circinatum bloom",
    #                "Quercus rubra bloom", "Quercus alba bloom",
    #                "Acer pensylvanicum bloom", "Prunus virginiana bloom",
    #                "Fagus grandifolia bloom"],
    "Late bloom":["Prunus serotina bloom", "Symphoricarpos albus bloom"]
}

# Get indices for beginning and ending of model year (10/1 - 9/29 or 30)
date_beg = dt.date(year, 10, 1)
date_end = date_beg + dt.timedelta(days=364)
yr1_beg = date_beg.timetuple().tm_yday
yr1_end = dt.date(year, 12, 31).timetuple().tm_yday
yr2_end = date_end.timetuple().tm_yday

# Get leap year indices
date_end_ly = dt.date(1991, 10, 1) + dt.timedelta(days=364)
ly_beg = dt.date(1992, 10, 1).timetuple().tm_yday
ly_end = dt.date(1992, 12, 31).timetuple().tm_yday
yr2_end_ly = date_end_ly.timetuple().tm_yday

# Number of days between 10/1 and 1/1
jan1_days = dt.date(year+1, 1, 1) - dt.date(year, 10, 1)

# Open PRISM raster files
# tmin1_file = root_dir + 'data/PRISM/tmin_15km/PRISM_tmin_15km_' + '1991' + '.tif'
# tmin1_rast = rs.open(tmin1_file)
# tmin2_file = root_dir + 'data/PRISM/tmin_15km/PRISM_tmin_15km_' + str(year+1) + '.tif'
# tmin2_rast = rs.open(tmin2_file)
#tmax1_file = root_dir + 'data/PRISM/tmax_15km/PRISM_tmax_15km_' + '1991' + '.tif'
#tmax1_rast = rs.open(tmax1_file)
# tmax2_file = root_dir + 'data/PRISM/tmax_15km/PRISM_tmax_15km_' + str(year+1) + '.tif'
# tmax2_rast = rs.open(tmax2_file)
pp_file = '/geo-vault/gridded_models/spring_index/late_bloom_input_files/daylength_4km/PRISM_daylength_4km.tif'
# pp_file = root_dir + 'data/PRISM/daylength_4km/NCEP_daylength.tif'
pp_rast = rs.open(pp_file)
lat_file = '/geo-vault/gridded_models/spring_index/late_bloom_input_files/lat_4km/PRISM_lat_4km.tif'
# lat_file = root_dir + 'data/PRISM/lat_4km/NCEP_lat.tif'
lat_rast = rs.open(lat_file)
elev_file = '/geo-vault/gridded_models/spring_index/late_bloom_input_files/elev_4km/PRISM_elev_4km.tif'
# elev_file = root_dir + 'data/PRISM/elev_4km/NCEP_elev.tif'
elev_rast = rs.open(elev_file)
mat_file = '/geo-vault/gridded_models/spring_index/late_bloom_input_files/tmean_30yr_avg_4km/PRISM_tmean_30yr_avg_4km.tif'
#gdalwarp -of ENVI -srcnodata 9999 -dstnodata -9999 -t_srs EPSG:4269 -ts 2606 1228 -te -125.0208333 24.0625000 -66.4791667 49.9375000 PRISM_tmean_30yr_avg_15km.tif NCEP_tmean_30yr_avg.tif
# mat_file = root_dir + 'data/PRISM/tmean_30yr_avg_15km/NCEP_tmean_30yr_avg.tif'
mat_rast = rs.open(mat_file)

# Extract raster dimensions
nrow = 621#tmin1_rast.shape[0]
ncol = 1405#tmin1_rast.shape[1]
nday = 365#len(tmin1_rast.indexes)

# Save tmin, tmax, and dl to arrays and extract only the model year using
# the indices
# tmin_yr1 = tmin1_rast.read()
# tmin_yr2 = tmin2_rast.read()
# tmin_y1 = tmin_yr1[0:365,0:300,0:300]
# tmin_y1 = tmin_yr1[0:365,:,:]
# tmin_y2 = tmin_yr2[0:yr2_end,:,:]
# tmax_yr1 = tmax1_rast.read()
# tmax_yr2 = tmax2_rast.read()
# tmax_y1 = tmax_yr1[0:365,:,:]
# tmax_y2 = tmax_yr2[0:yr2_end,:,:]
dl_arr = pp_rast.read()
dl_y1 = dl_arr[ly_beg-1:ly_end,:,:]
dl_y2 = dl_arr[0:yr2_end_ly,:,:]

tminstack = np.array([])
start_date = datetime.date(year, 10, 1)
end_date = last_data_date
delta = datetime.timedelta(days=1)
count = 0
while start_date <= end_date:
    count += 1
    day = start_date
    tmin = get_climate_data('tmin', day, 'fahrenheit')
    if tminstack.size == 0:
        tminstack = tmin
    else:
        tminstack = np.vstack((tminstack, tmin))
    print(start_date.strftime("%Y-%m-%d"))
    start_date += delta
print("end tmin")

tminstack = np.vstack((tminstack, np.zeros((365-count,nrow, ncol))))

tmaxstack = np.array([])
start_date = datetime.date(year, 10, 1)
end_date = last_data_date
delta = datetime.timedelta(days=1)
while start_date <= end_date:
    day = start_date
    tmax = get_climate_data('tmax', day, 'fahrenheit')
    if tmaxstack.size == 0:
        tmaxstack = tmax
    else:
        tmaxstack = np.vstack((tmaxstack, tmax))
    print(start_date.strftime("%Y-%m-%d"))
    start_date += delta
print("end tmax")

tmaxstack = np.vstack((tmaxstack, np.zeros((365-count,nrow, ncol))))

# Save PRISM climate data for model year to a dictonary
# prism = {'tmin': np.concatenate((tmin_y1, tmin_y2)), 
#          'tmax': np.concatenate((tmax_y1, tmax_y2)),
#          'dl': np.concatenate((dl_y1, dl_y2)),
#          'MAT': mat_rast.read(),
#          'ELEV': elev_rast.read(),
#          'LAT': lat_rast.read()}
prism = {'tmin': tminstack,#tmin_y1, 
         'tmax': tmaxstack, #tmax_y1,
         'dl': np.concatenate((dl_y1, dl_y2)),
         'MAT': mat_rast.read(),
         'ELEV': elev_rast.read(),
         'LAT': lat_rast.read()}

# Loop through each model (including both models for split ones) and create rasters of DOY values
for m in range(0, models.shape[0]):
    # Subset to current model
    ar_leaf = models.iloc[m]
    
    # Get model information
    model = ar_leaf["pr_model"]
    reg2_var = ar_leaf["reg2_type"]
    spl_var = ar_leaf["group_type"]
    pars = ar_leaf.loc["t0":"F_crit"]

    # Calculate heat accumulation for current year
    hu = heat_units(prism['tmin'], prism['tmax'], prism['dl'], model, pars)

    # Set all values prior to the begin accumulation date (t0) to 0 and calculate
    # cumulative heat accumulation
    hu[0:int(pars['t0']),:,:] = 0
    cumhu = np.cumsum(hu, axis=0)
    cumhu = cumhu[pars['t0']:,:,:]

    # Create an array of NaNs to store values for chat and event day
    chat = np.empty((cumhu.shape[0], nrow, ncol))
    chat[:] = np.nan
    doy = np.empty((nrow, ncol))
    doy[:] = np.nan
    
    # Calculate chat for each day
    for d in range(1, cumhu.shape[0]+1):
        chat[d-1,:,:] =  cumhu[d-1,:,:]* ar_leaf['beta'] + ar_leaf['alpha']*d
    
    # Loop through each grid cell and calculate event day
    for j in range(0, nrow):
        for i in range(0,ncol):
            # Extract all daily chat values for grid cell for year
            cc = chat[:,j, i]
            
            # If all values of chat are NaN grid cell is empty so set event day to NaN
            if (np.all(np.isnan(cc))):
                    doy[j,i] = np.nan
            # Otherwise calculate event day
            else:
                if (str(reg2_var) == 'nan'):
                    reg2_diff = 0.
                else:
                    # If model uses a secondary regression calculate the difference using 
                    # the delta and gamma coefficients 
                    if (reg2_var != ""):
                        reg2_diff = prism[reg2_var][0,j,i] * ar_leaf['delta'] + ar_leaf['gamma']
                    else:
                        reg2_diff = 0.
                    
                # Calculate the event day as the day when chat reaches or exceeds 1000 and
                # convert the day to days since Jan 1
                doy[j,i] = float(np.argwhere(np.diff(cc >= 1000, prepend=False))) + pars['t0'] - jan1_days.days - reg2_diff + 1
                
    # Register GDAL format drivers and configuration options with a
    # context manager.
    with rs.Env():

        # Write an array as a raster band to a new 8-bit file. For
        # the new file's profile, we start with the profile of the source
        src = elev_rast
        profile = src.profile

        # And then change the band count to 1, set the
        # dtype to uint8, and specify LZW compression.
        profile.update(
            dtype=rs.float32,
            count=1,
            compress='lzw')

        # Set file name based on model species and write the doy array as a raster image to a GeoTIFF file
        if (str(ar_leaf['group']) == 'nan'):
            fpath=root_dir + "output/spp/" + \
                ar_leaf["latin_name"] + \
                ' ' + \
                ar_leaf['event'] + \
                ' ' + \
                str(year+1) + \
                '.tif'
        else:
            fpath=root_dir + "output/spp/" + \
                ar_leaf["latin_name"] + \
                ' ' + \
                ar_leaf['event'] + \
                ' ' + \
                str(ar_leaf['group']) + \
                ' ' + \
                str(year+1) + \
                '.tif'
            
        with rs.open(fpath, 'w', **profile) as dst:
            dst.write(doy.astype(rs.float32), 1)

# Go through each split model and combine the maps
for s in range(0, len(split_spp)):
    # Read in the models
    ge40N_file = root_dir + "output/spp/" + split_spp[s] + " lat2_ge40N " + str(year + 1) +".tif"
    ge40N_rast = rs.open(ge40N_file)
    lt40N_file = root_dir + "output/spp/" + split_spp[s] + " lat2_lt40N " + str(year + 1) +".tif"
    lt40N_rast = rs.open(lt40N_file)

    # Create an empty array for storage
    doy = np.empty((nrow, ncol))
    doy[:] = np.nan
    
    # Loop through each element
    for j in range(0, nrow):
        for i in range(0, ncol):
            # Save the value based on whether latitude is north or south of 40N
            if (prism["LAT"][0,j,i] >= 40):
                doy[j,i] = ge40N_rast.read()[0,j,i]
            else:
                doy[j,i] = lt40N_rast.read()[0,j,i]
            
    # Register GDAL format drivers and configuration options with a
    # context manager.
    with rs.Env():

        # Write an array as a raster band to a new 8-bit file. For
        # the new file's profile, we start with the profile of the source
        src = elev_rast
        profile = src.profile

        # And then change the band count to 1, set the
        # dtype to uint8, and specify LZW compression.
        profile.update(
            dtype=rs.float32,
            count=1,
            compress='lzw')

        # Set file name based on model species and write the doy array as a raster image to a GeoTIFF file
        fpath=root_dir + "output/spp/" + split_spp[s] + ' ' + str(year + 1) + ".tif"
            
        with rs.open(fpath, 'w', **profile) as dst:
            dst.write(doy.astype(rs.float32), 1)

# Loop through each index and create map
for key in sdi_index.keys():
    # Get list of species models for current index
    vals = sdi_index[key]
    
    # Create accumulation matrix
    ind_mat = np.zeros((nrow, ncol))
    
    # Loop through all models in the index and accumulate them
    for v in range(0, len(vals)):
        # Read model raster
        rast_file = root_dir + "output/spp/" + vals[v] + ' ' + str(year + 1) + ".tif"
        spp_mat = rs.open(rast_file).read()
        
        # For accumulation replace NaNs with -1
        spp_mat[np.isnan(spp_mat)] = -1
        
        # Accumulate matrices
        ind_mat = np.add(ind_mat, spp_mat[0,:,:])
        
    # Convert negative values back to NaNs
    ind_mat[ind_mat < 0] = np.nan
    
    # Calculate average value for index
    ind_mat = ind_mat / len(vals)
    
    # Register GDAL format drivers and configuration options with a
    # context manager.
    with rs.Env():

        # Write an array as a raster band to a new 8-bit file. For
        # the new file's profile, we start with the profile of the source
        src = lat_rast
        profile = src.profile

        # And then change the band count to 1, set the
        # dtype to uint8, and specify LZW compression.
        profile.update(
            dtype=rs.float32,
            count=1,
            compress='lzw')

        # Write one raster per day from Jan 1 through the last available data date.
        # Each day's raster masks out cells where the model event DOY is later than
        # the output date (those cells have no climate data yet).
        output_dir = "/geo-data/gridded_models/spring_index/six_late_bloom_prism"
        os.makedirs(output_dir, exist_ok=True)

        anomaly_output_dir = "/geo-data/gridded_models/spring_index_anomaly/six_late_bloom_anomaly_prism"
        os.makedirs(anomaly_output_dir, exist_ok=True)

        avg_file = '/geo-vault/gridded_models/spring_index/late_bloom_input_files/late-bloom-30yr-avg.tif'
        with rs.open(avg_file) as avg_rast:
            avg_mat = avg_rast.read(1).astype(np.float32)
            avg_mat[avg_mat == avg_rast.nodata] = np.nan

        output_start = datetime.date(year + 1, 1, 1)
        current_output_date = output_start
        while current_output_date <= last_data_date:
            current_doy = current_output_date.timetuple().tm_yday
            daily_ind_mat = ind_mat.copy()
            # Mask cells where the event fires after the current output date
            daily_ind_mat[daily_ind_mat > current_doy] = np.nan

            date_str_out = current_output_date.strftime("%Y%m%d")
            fpath = f"{output_dir}/late_bloom_prism_{date_str_out}.tif"
            with rs.open(fpath, 'w', **profile) as dst:
                dst.write(daily_ind_mat.astype(rs.float32), 1)
            print(f"Written: {fpath}")
            update_time_series("six_late_bloom_prism", f"late_bloom_prism_{date_str_out}.tif", current_output_date)

            anomaly_mat = daily_ind_mat - avg_mat
            anomaly_fpath = f"{anomaly_output_dir}/six_bloom_anomaly_{date_str_out}.tif"
            with rs.open(anomaly_fpath, 'w', **profile) as dst:
                dst.write(anomaly_mat.astype(rs.float32), 1)
            print(f"Written: {anomaly_fpath}")
            update_time_series("six_late_bloom_anomaly_prism", f"six_bloom_anomaly_{date_str_out}.tif", current_output_date)

            current_output_date += datetime.timedelta(days=1)
