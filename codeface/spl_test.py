'''
Local testing of codeface spl modules

Provides

'''
import argparse
import unittest
import os
from pkg_resources import resource_filename

from glob import glob

from .logger import set_log_level, start_logfile, log
from .configuration import Configuration
from .util import execute_command
from spl.dbmanager import DBManager
import spl.csv_parser as splcsv


def run(argv):
  print 'run'
  #splcsv.read_data_per_project('/home/sniechzial/03_Uni/Masterarbeit/data/cppstats_analysis_data/apache/plot_apache_data.csv')
  #splcsv.read_data_per_release('/home/sniechzial/03_Uni/Masterarbeit/data/cppstats_analysis_data/apache/httpd-2.4.6/merged.csv')
  #splcsv.read_data_per_file('/home/sniechzial/03_Uni/Masterarbeit/data/cppstats_analysis_data/apache/httpd-2.4.6/perfile.csv')

def main():
  import sys
  return run(sys.argv)

if __name__ == "__main__":
  import sys
  run(sys.argv)
