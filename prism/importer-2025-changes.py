#!/usr/bin/env python3
"""
PRISM Climate Data Downloader

Downloads daily precipitation, minimum temperature, and maximum temperature data 
from the PRISM Climate Group at Oregon State University for the continental US (CONUS) 
at 4km resolution from January 1st of the current year through the current date.

Data Source: https://prism.oregonstate.edu/
Data Format: Cloud Optimized GeoTIFF (COG) - new format as of March 2025
Resolution: 4km (25m designation in new naming convention)
Region: Continental US (CONUS)

Variables Downloaded:
- ppt: Precipitation
- tmin: Minimum Temperature  
- tmax: Maximum Temperature

Author: Jeff Switzer
Date: August 2025
"""

import os
import sys
import requests
import logging
from datetime import datetime, date, timedelta
from pathlib import Path
import time
import zipfile

# Configuration
BASE_URL = "https://services.nacse.org/prism/data/get/us/4km"  # PRISM web service base URL
USER_AGENT = "Python PRISM Downloader 1.0"
BASE_DOWNNLOAD_DIR = Path("/geo-data/climate_data/prism")  # Base directory for downloaded data

# Variables to download with their corresponding output directories
VARIABLES = {
    'ppt': 'prism_ppt'
    # 'tmin': 'prism_tmin', 
    # 'tmax': 'prism_tmax'
}

def setup_logger():
    """Configure logging with both file and console output."""
    # Create logs directory if it doesn't exist
    log_dir = Path("logs")
    log_dir.mkdir(exist_ok=True)
    
    # Create timestamp for log filename
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    log_file = log_dir / f"prism_download_{timestamp}.log"
    
    # Configure logging
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(log_file, encoding='utf-8'),
            logging.StreamHandler(sys.stdout)
        ]
    )
    
    logger = logging.getLogger(__name__)
    logger.info(f"Log file created: {log_file}")
    return logger

def create_output_directories(logger):
    """Create the output directories for each variable if they don't exist."""
    for var, output_dir in VARIABLES.items():
        full_output_dir = BASE_DOWNNLOAD_DIR.joinpath(output_dir)
        Path(full_output_dir).mkdir(exist_ok=True)
        logger.info(f"Output directory for {var.upper()}: {os.path.abspath(full_output_dir)}")

def get_date_range(logger):
    """Get the date range from January 1st of current year to current date."""
    current_year = datetime.now().year
    start_date = date(current_year, 1, 1)
    end_date = date.today()
    
    logger.info(f"Date range: {start_date} to {end_date}")
    return start_date, end_date

def generate_date_list(start_date, end_date):
    """Generate a list of dates between start_date and end_date."""
    dates = []
    current_date = start_date
    while current_date <= end_date:
        dates.append(current_date)
        current_date += timedelta(days=1)
    return dates

def download_prism_data_webservice(target_date, variable, logger):
    """
    Download PRISM data for a specific date and variable using web services.
    Downloads zip file and extracts contents to the output directory.
    """
    date_str = target_date.strftime("%Y%m%d")
    output_dir = BASE_DOWNNLOAD_DIR.joinpath(VARIABLES[variable])
    
    # Web service URL format (this is an example - actual API may differ)
    url = f"{BASE_URL}/{variable}/{date_str}"
    
    # PRISM zip filename format
    output_filename = f"prism_{variable}_us_4km_{date_str}.zip"
    output_path = os.path.join(output_dir, output_filename)
    
    # Check if the extracted .tif file already exists (skip download if so)
    # note that even thogh the zip file is named with 4km, the extracted file uses 25m 
    tif_filename = f"prism_{variable}_us_25m_{date_str}.tif"
    tif_path = os.path.join(output_dir, tif_filename)
    if os.path.exists(tif_path):
        logger.info(f"✓ {tif_filename} already exists, skipping")
        return True
    
    try:
        logger.info(f"Downloading {variable.upper()} via web service for {date_str} from {url}")
        
        headers = {
            'User-Agent': USER_AGENT
        }
        
        response = requests.get(url, headers=headers, timeout=60)
        response.raise_for_status()
        
        # Save the zip file
        with open(output_path, 'wb') as f:
            f.write(response.content)
        
        logger.info(f"✓ Successfully downloaded {output_filename}")
        
        # Extract the zip file
        try:
            logger.info(f"Extracting {output_filename}...")
            with zipfile.ZipFile(output_path, 'r') as zip_ref:
                zip_ref.extractall(output_dir)
            logger.info(f"✓ Successfully extracted {output_filename}")
            
            # Remove the zip file after successful extraction
            os.remove(output_path)
            logger.info(f"✓ Removed zip file {output_filename}")
            
            return True
            
        except zipfile.BadZipFile as e:
            logger.error(f"Failed to extract {output_filename}: Invalid zip file - {e}")
            # Delete the corrupted zip file
            if os.path.exists(output_path):
                os.remove(output_path)
                logger.info(f"Deleted corrupted zip file {output_filename}")
            return False
            
        except Exception as e:
            logger.error(f"Failed to extract {output_filename}: {e}")
            # Delete the zip file on extraction failure
            if os.path.exists(output_path):
                os.remove(output_path)
                logger.info(f"Deleted zip file {output_filename} due to extraction failure")
            return False
        
    except requests.exceptions.RequestException as e:
        logger.error(f"Failed to download {variable.upper()} via web service for {date_str}: {e}")
        return False

def main():
    """Main function to orchestrate the download process."""
    # Setup logging first
    logger = setup_logger()
    
    logger.info("PRISM Climate Data Downloader")
    logger.info("=" * 50)
    logger.info("Target resolution: 4km")
    logger.info("Target region: Continental US (CONUS)")
    logger.info("Output format: GeoTIFF")
    logger.info(f"Variables to download: {', '.join([v.upper() for v in VARIABLES.keys()])}")
    
    # Create output directories
    create_output_directories(logger)
    
    # Get date range
    start_date, end_date = get_date_range(logger)
    
    # Generate list of dates to download
    dates_to_download = generate_date_list(start_date, end_date)
    total_dates = len(dates_to_download)
    total_files = total_dates * len(VARIABLES)
    
    logger.info(f"Total dates to process: {total_dates}")
    logger.info(f"Total files to download: {total_files}")
    
    # Download data for each date and variable
    successful_downloads = 0
    failed_downloads = []
    
    file_counter = 0
    for i, target_date in enumerate(dates_to_download, 1):
        logger.info(f"[Date {i}/{total_dates}] Processing {target_date}...")
        
        # Download each variable for this date
        for variable in VARIABLES.keys():
            file_counter += 1
            logger.info(f"  [{file_counter}/{total_files}] Downloading {variable.upper()} for {target_date}...")
            
            success = download_prism_data_webservice(target_date, variable, logger)
            
            if success:
                successful_downloads += 1
                logger.debug(f"Successfully processed {variable.upper()} for {target_date}")
            else:
                failed_downloads.append((target_date, variable))
                logger.warning(f"Failed to download {variable.upper()} for {target_date}")
            
            # Add a small delay between variable downloads
            time.sleep(0.2)
        
        # Add a slightly longer delay between dates to be respectful to the server
        time.sleep(0.5)
    
    # Summary
    logger.info("=" * 50)
    logger.info("DOWNLOAD SUMMARY")
    logger.info("=" * 50)
    logger.info(f"Total files processed: {total_files}")
    logger.info(f"Successful downloads: {successful_downloads}")
    logger.info(f"Failed downloads: {len(failed_downloads)}")
    
    # Summary by variable
    for variable, output_dir in VARIABLES.items():
        var_successful = successful_downloads - len([f for f in failed_downloads if f[1] != variable])
        var_failed = len([f for f in failed_downloads if f[1] == variable])
        logger.info(f"  {variable.upper()}: {var_successful} successful, {var_failed} failed")
    
    if failed_downloads:
        logger.warning("Failed downloads:")
        for failed_date, failed_var in failed_downloads:
            logger.warning(f"  - {failed_date} ({failed_var.upper()})")
        logger.info("Note: Some failures may be due to data not being available yet")
        logger.info("for recent dates, or server temporary issues.")
    
    # Show output directories
    logger.info("Downloaded files are saved in:")
    for variable, output_dir in VARIABLES.items():
        logger.info(f"  {variable.upper()}: {os.path.abspath(output_dir)}")
    
    # Additional notes
    logger.info("IMPORTANT NOTES:")
    logger.info("- Using new PRISM COG format (March 2025)")
    logger.info("- Files use new naming convention: prism_{var}_us_4km_YYYYMMDD.tif")
    logger.info("- Recent dates may not be available immediately")
    logger.info("- Data may be preliminary and subject to updates")
    logger.info("- Please cite PRISM Climate Group when using this data")
    
    return successful_downloads, failed_downloads

if __name__ == "__main__":
    try:
        successful, failed = main()
        
        # Get logger for final messages
        logger = logging.getLogger(__name__)
        
        # Exit with appropriate code
        if len(failed) == 0:
            logger.info("🎉 All downloads completed successfully!")
            sys.exit(0)
        elif successful > 0:
            logger.warning(f"⚠️ Partial success: {successful} files downloaded, {len(failed)} failed")
            sys.exit(1)
        else:
            logger.error("❌ All downloads failed")
            sys.exit(2)
            
    except KeyboardInterrupt:
        logger = logging.getLogger(__name__)
        logger.info("⏹️ Download interrupted by user")
        sys.exit(130)
    except Exception as e:
        logger = logging.getLogger(__name__)
        logger.error(f"❌ Unexpected error: {e}")
        sys.exit(1)