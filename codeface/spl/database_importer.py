from logging import getLogger; log = getLogger(__name__)

from .dbmanager import DBManager
import csv_parser as cp 

class DatabaseImporter(object):
  """This class provides import functionality for CSV formatted analysis data of the cppstats tool (http://fosd.net/cppstats)."""

  def __init__(self, conf):
    self.conf = conf
    self.cppStats = conf["spl"]["cppstats"]
    self.db = DBManager(conf)

  def import_file_level_data(self):
    for revision in self.conf["revisions"]:
      path = self.get_path_file_level(revision)
      log.info("Reading file-level data from %s" % path)
      data = cp.read_data_per_file(path)
      for line in data:
        key_value_pairs = line.items()
        file_instance_id = self.get_file_instance_id(key_value_pairs, revision)
        query = 'INSERT INTO spl_statistics_file (file_instance_id, variable, value) VALUES (###FID###, %s, %s)'.replace('###FID###', file_instance_id)
        #self.db.doExecMany(query, key_value_pairs)

  def get_file_instance_id(self, key_value_pairs, revision):
    """Looks for a 'FILENAME' key in the given key-value-pair-list. Performs a lookup for a file_instance with that name in the given revision and returns its ID"""
    filename = ''
    for key, value in key_value_pairs:
      if key == 'FILENAME':
        filename = value
        break
    if not filename:
      raise RuntimeError("data is missing a FILENAME attribute")

    log.debug("Lookup spl_file_instance.id for %s", filename)
    file_instance_id = self.lookup_file_instance_id(filename, revision)
    return str(file_instance_id)

  def lookup_file_id(self, filename):
    """Returns the ID of a file specified by 'filename'. If no instance is found, it is created"""
    file_id = None
    projectId = self.get_project_id(self.conf["project"])
    queryFile = 'SELECT id FROM spl_file WHERE path = %s and project_id = %s'
    self.db.doExec(queryFile, (filename, projectId))
    if self.db.cur.rowcount == 0:
      create_query = "INSERT INTO spl_file (path, project_id) VALUES (%s, %s)"
      self.db.doExecCommit(create_query, (filename, projectId))
      file_id = self.db.cur.lastrowid
    else:
      file_id = self.db.doFetchAll()[0][0]
    
    return file_id

  def lookup_file_instance_id(self, filename, revision):
    """Returns the ID of a file_instance specified by 'filename' and 'revision'. If no instance is found, it is created"""
    self.lookup_file_id(filename)
    return "1"

  def lookup_commit_id(self, release):
    """Lookup the commit that created a release and return its ID"""
    return 1

  def get_path_file_level(self, revision):
    path = self.cppStats["basePath"]
    revisionPattern = self.cppStats["revisionPattern"]
    return path + "/" + (revisionPattern % revision) + '/perfile.csv'

  def get_project_id(self, name):
    self.db.doExec("SELECT id FROM project WHERE name=%s;", name)
    pid = self.db.doFetchAll()[0][0]
    log.debug("Using project %s with ID %s" % (name, pid))
    return pid
