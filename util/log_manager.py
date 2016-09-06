import logging


def get_error_log():
    formatter = logging.Formatter('%(asctime)s : %(message)s')
    error_log = logging.getLogger('error_log')
    error_log.addHandler(logging.FileHandler('/usr/local/scripts/gridded_models/error.log', mode='w'))
    error_log.addHandler(logging.StreamHandler().setFormatter(formatter))
    error_log.setLevel(logging.ERROR)
    return error_log
