from logging import getLogger; log = getLogger(__name__)

from .dbmanager import DBManager
import csv_parser as cp 

class DatabaseImporter(object):
  """This class provides import functionality for CSV formatted analysis data of the cppstats tool (http://fosd.net/cppstats)."""

  def __init__(self, conf):
    self.conf = conf
    self.db = DBManager(conf)

  def import_file_level_data(self):
    path = self.get_path_file_level()
    data = cp.read_data_per_file(path)
    for line in data:
      key_value_pairs = line.items()
      file_instance_id = self.get_file_instance_id(key_value_pairs)
      query = 'INSERT INTO spl_statistics_file (file_instance_id, variable, value) VALUES (###FID###, %s, %s)'.replace('###FID###', file_instance_id)
      #self.db.doExecMany(query, key_value_pairs)

  def get_file_instance_id(self, key_value_pairs):
    """Looks for a 'FILENAME' key in the given key-value-pair-list. Performs a lookup for a file_instance with that name in the given release and returns its ID"""
    filename = ''
    for key, value in key_value_pairs:
      if key == 'FILENAME':
        filename = value
        break
    file_instance_id = self.lookup_file_instance_id(filename, 'release')
    return str(file_instance_id)
   
  def lookup_file_instance_id(self, filename, release):
    """Returns the ID of a file_instance specified by 'filename' and 'release'. If no instance is found, it is created"""
    query = 'SELECT id FROM file_instance WHERE path = %s and commit_id = %s'
    commit_id = self.lookup_commit_id(release)
    self.db.doExec(query, (filename, commit_id))
    if self.db.cur.rowcount == 0:
      create_query = "INSERT INTO file_instance (path, commit_id) VALUES ('%s', %s)"
      self.db.doExecCommit(create_query, (filename, commit_id))
      file_instance_id = self.db.cur.lastrowid
    else:
      file_instance_id = self.db.doFetchAll()[0][0]
    
    return file_instance_id

  def lookup_commit_id(self, release):
    """Lookup the commit that created a release and return its ID"""
    return 1

  def get_path_file_level(self):
    path = self.conf["spl"]["cppstats"]["basePath"]
    return path + '/httpd-2.4.6/perfile.csv'
