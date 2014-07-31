import MySQLdb as mdb
from datetime import datetime
from logging import getLogger; log = getLogger(__name__)
from contextlib import contextmanager

from ..dbmanager import DBManager
from ..dbmanager import _log_db_error

class DBManager(DBManager):
    """This class provides an interface to the codeface sql database with spl extended schema."""

    def doExecMany(self, stmt, args=None):
        with _log_db_error(stmt, args):
            while True:
                try:
                    return self.cur.executemany(stmt, args)
                except mdb.OperationalError as dbe:
                    log.info("DBE args: " + str(dbe.args))
                    if dbe.args[0] == 1213: # Deadlock! retry...
                        log.warning("Recoverable deadlock in MySQL - retrying.")
                    else:
                        raise

