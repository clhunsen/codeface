from logging import getLogger; log = getLogger(__name__)

from .dbmanager import DBManager
import csv_parser as cp 

class DatabaseImporter(object):
  """This class provides import functionality for CSV formatted analysis data of the cppstats tool (http://fosd.net/cppstats)."""

  SCOPE_FILE_INSTANCE = 'ScopeFileInstance'
  SCOPE_RELEASE = 'ScopeRelease'
  SCOPE_PROJECT = 'ScopeProject'

  def __init__(self, conf):
    self.conf = conf
    self.cppStats = conf["spl"]["cppstats"]
    self.db = DBManager(conf)

  def import_file_level_data(self):
    for revision in self.get_revisions():
      path = self.get_path_file_level(revision)
      log.info("Reading file-level data from %s" % path)
      data = cp.read_data_per_file(path)
      for line in data:
        key_value_pairs = line.items()
        file_instance_id = self.get_file_instance_id(key_value_pairs, revision)
        for key, value in key_value_pairs:
          log.debug("Got %s: %s" % (key, value))
          self.handle_file_level_metric(key, value, file_instance_id)

  def import_revision_level_data(self):
    for revision in self.get_revisions():


  def get_revisions(self):
    self.conf["revisions"]

  def handle_file_level_metric(self, key, value, file_instance_id):
    if key != 'FILENAME':
      metricId = self.get_metric_id(key, self.SCOPE_FILE_INSTANCE)
      create_query = 'INSERT INTO spl_variable (spl_metric_id, value, spl_file_instance_id) VALUES (%s, %s, %s)'
      self.db.doExecCommit(create_query, (metricId, value, file_instance_id))
      variableId = self.db.cur.lastrowid
      return variableId
    else:
      return None

  def get_metric_id(self, key, scope):
    metric_id = None
    query = 'SELECT id FROM spl_metric WHERE name = %s AND scope = %s'
    self.db.doExec(query, (key, scope))
    if self.db.cur.rowcount == 0:
      create_query = "INSERT INTO spl_metric (scope, name) VALUES (%s, %s)"
      self.db.doExecCommit(create_query, (scope, key))
      metric_id = self.db.cur.lastrowid
    else:
      metric_id = self.db.doFetchAll()[0][0]
    return metric_id

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
    file_instance_id = None
    fileId = self.lookup_file_id(filename)
    releaseTimelineId = self.lookup_release_timeline_id(revision)
    queryFileInstance = 'SELECT id FROM spl_file_instance WHERE file_id = %s AND release_timeline_id = %s'
    self.db.doExec(queryFileInstance, (fileId, releaseTimelineId))
    if self.db.cur.rowcount == 0:
      create_query = 'INSERT INTO spl_file_instance (file_id, release_timeline_id) VALUES (%s, %s)'
      self.db.doExecCommit(create_query, (fileId, releaseTimelineId))
      file_instance_id = self.db.cur.lastrowid
    else:
      file_instance_id = self.db.doFetchAll()[0][0]
    return file_instance_id

  def lookup_commit_id(self, release):
    """Lookup the commit that created a release and return its ID"""
    return 1

  def get_path_file_level(self, revision):
    perfileFilename = self.cppStats["perfile"]
    path = self.get_path(revision, perfileFilename)
    return path

  def get_path_revision_level(self, revision):
    perRevisionFilename = self.cppStats["perrevision"]
    path = self.get_path(revision, perRevisionFilename)
    return path

  def get_path(self, revision, filename):
    path = self.cppStats["basePath"]
    revisionPattern = self.cppStats["revisionPattern"]
    return "%s/%s/%s" % (path, (revisionPattern % revision), filename)

  def get_project_id(self, name):
    self.db.doExec("SELECT id FROM project WHERE name=%s;", name)
    pid = self.db.doFetchAll()[0][0]
    log.debug("Using project %s with ID %s" % (name, pid))
    return pid

  def lookup_release_timeline_id(self, revision):
    projectId = self.get_project_id(self.conf["project"])
    self.db.doExec("SELECT id FROM release_timeline WHERE projectId = %s AND type = 'release' AND tag = %s", (projectId, revision))
    rtid = self.db.doFetchAll()[0][0]
    log.debug("release_timeline lookup returned %s for (projectId:%s, revision:%s)" % (rtid, projectId, revision))
    return rtid
