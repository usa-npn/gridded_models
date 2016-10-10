import logging
import yaml
import os.path

with open(os.path.abspath(os.path.join(os.path.dirname(__file__), os.path.pardir, 'config.yml')), 'r') as ymlfile:
    cfg = yaml.load(ymlfile)
log_path = cfg["log_path"]

def get_error_log():
    formatter = logging.Formatter('%(asctime)s : %(message)s')
    error_log = logging.getLogger('error_log')
    error_log.addHandler(logging.FileHandler(log_path + 'error.log', mode='w'))
    error_log.addHandler(logging.StreamHandler().setFormatter(formatter))
    error_log.setLevel(logging.ERROR)
    return error_log
