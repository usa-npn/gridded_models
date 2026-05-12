from datetime import date, timedelta
import requests
from util.database import update_time_series
from util.database import table_exists
import subprocess
import os.path

def set_srs(tif_file):
    temp_file = str.replace(tif_file, ".tif", "_warpme.tif")
    os.rename(tif_file, temp_file)
    warp_command = "gdalwarp -t_srs EPSG:4269 {source_file} {dest_file}"\
        .format(source_file=temp_file, dest_file=tif_file)
    ps = subprocess.Popen(warp_command, stdout=subprocess.PIPE, shell=True)
    ps.wait()
    os.remove(temp_file)

def process_japanese_beetle_data(start_date, end_date):
    """
    Process Japanese beetle data for a date range.
    
    Args:
        start_date (date): Start date for processing
        end_date (date): End date for processing (inclusive)
    """
    current_date = start_date
    
    while current_date <= end_date:
        current_year = current_date.year
        
        # Generate URLs for the current year
        japanese_beetle_adult_url = f'https://uspest.org/CAPS/JPB_cohorts/Misc_output/Earliest_PEMp0Excl1_{current_year}1231.tif'
        japanese_beetle_egg_url = f'https://uspest.org/CAPS/JPB_cohorts/Misc_output/Avg_PEMe1Excl1_{current_year}1231.tif'
        
        print(f"Processing data for {current_date.strftime('%Y-%m-%d')}")
        
        # Process adult beetle data
        filename = f'/geo-data/gridded_models/japanese_beetle/japanese_beetle_adult/japanese_beetle_adult_{current_date.strftime("%Y%m%d")}.tif'
        try:
            with open(filename, 'wb') as out_file:
                content = requests.get(japanese_beetle_adult_url, stream=True).content
                out_file.write(content)
                time_series_table = 'japanese_beetle_adult'
                tif_name = f'japanese_beetle_adult_{current_date.strftime("%Y%m%d")}.tif'
                if table_exists(time_series_table):
                    update_time_series(time_series_table, tif_name, current_date)
            set_srs(filename)
        except Exception as e:
            print(f"Error processing adult beetle data for {current_date}: {e}")
        
        # Process egg hatch data
        filename = f'/geo-data/gridded_models/japanese_beetle/japanese_beetle_egg_hatch/japanese_beetle_egg_hatch_{current_date.strftime("%Y%m%d")}.tif'
        try:
            with open(filename, 'wb') as out_file:
                content = requests.get(japanese_beetle_egg_url, stream=True).content
                out_file.write(content)
                time_series_table = 'japanese_beetle_egg_hatch'
                tif_name = f'japanese_beetle_egg_hatch_{current_date.strftime("%Y%m%d")}.tif'
                if table_exists(time_series_table):
                    update_time_series(time_series_table, tif_name, current_date)
            set_srs(filename)
        except Exception as e:
            print(f"Error processing egg hatch data for {current_date}: {e}")
        
        # Move to next date
        current_date += timedelta(days=1)

# Example usage:
if __name__ == "__main__":
    # Define your date range here
    start_date = date(2025, 6, 7)  # Change to your desired start date
    end_date = date(2025, 6, 22)  # Change to your desired end date
    
    # Or use today as end date and go back N days:
    # today = date.today()
    # start_date = today - timedelta(days=30)  # Last 30 days
    # end_date = today
    
    process_japanese_beetle_data(start_date, end_date)
