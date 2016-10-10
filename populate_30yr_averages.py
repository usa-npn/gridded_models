from util.gdd import *
from six.spring_index_util import *
import time
import logging
import yaml
import os.path
from util.log_manager import get_error_log


with open(os.path.abspath(os.path.join(os.path.dirname(__file__), 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]


# This script is used to generate historic 30year average spring index and agdd maps. It is not ran nightly.
# Before running this script populate_prism.py must be ran for the years you want to average over.
# Before running this script populate_six.py must be ran for the years you want to average over.
def main():
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('****************beginning script populate_30yr_averages.py*******************')
    logging.info('*****************************************************************************')

    # calculate doy spring index prism raster averaged over 3 species
    # this function was written to fix averaging error over 3 species bloom
    # without having to rerun the spring index over each year
    # populate_yearly_six_prism_species_averages('bloom')


    # populate 30 year average for each day of year's spring index based on prism data
    populate_six_30yr_average('average', 'leaf')
    populate_six_30yr_average('average', 'bloom')


    # populate 30 year average for each day of year's agdd based on prism data
    base = 32
    import_average_agdd(1981, 2011, base)
    base = 50
    import_average_agdd(1981, 2011, base)

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('**************populate_30yr_averages.py finished in %s seconds***************', t1-t0)
    logging.info('*****************************************************************************')


if __name__ == "__main__":
    logging.basicConfig(filename=log_path + 'populate_30yr_averages.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    error_log = get_error_log()

    try:
        main()
    except (SystemExit, KeyboardInterrupt):
        raise
    except:
        error_log.error('populate_30yr_averages.py failed to finish: ', exc_info=True)