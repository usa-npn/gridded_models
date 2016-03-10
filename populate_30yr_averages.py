from util.gdd import *
from six.spring_index_util import *
import time
import logging


def main():
    # logging.basicConfig(filename='D:\Python Projects\gridded_models\populate_30yr_averages.log',
    logging.basicConfig(filename='/usr/local/scripts/gridded_models/populate_30yr_averages.log',
                        level=logging.INFO,
                        format='%(asctime)s %(message)s',
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    t0 = time.time()

    logging.info(' ')
    logging.info('*****************************************************************************')
    logging.info('****************beginning script populate_30yr_averages.py*******************')
    logging.info('*****************************************************************************')

    # calculate doy spring index prism raster averaged over 3 species
    # this function was written to fix averaging error over 3 species bloom
    # without having to rerun the spring index over each year
    populate_yearly_six_prism_species_averages('bloom')


    # populate 30 year average for each day of year's spring index based on prism data
    # populate_six_30yr_average('average', 'leaf')
    populate_six_30yr_average('average', 'bloom')
    #
    # populate 30 year average for each day of year's agdd based on prism data
    # base = 32
    # import_average_agdd(1981, 2011, base)
    # base = 50
    # import_average_agdd(1981, 2011, base)

    t1 = time.time()
    logging.info('*****************************************************************************')
    logging.info('**************populate_30yr_averages.py finished in %s seconds***************', t1-t0)
    logging.info('*****************************************************************************')


if __name__ == "__main__":
    main()