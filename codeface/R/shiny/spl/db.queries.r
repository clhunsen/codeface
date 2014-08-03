spl.db.count.files <- function(pid) {
  dbGetQuery(conf$con, sprintf('SELECT COUNT(*) FROM spl_file f WHERE f.project_id = %d', strtoi(pid)))
}

spl.db.count.files.instances <- function(pid) {
  dbGetQuery(conf$con, sprintf('SELECT COUNT(*) FROM spl_file_instance fi
                              JOIN spl_file f ON f.id = fi.file_id
                              WHERE f.project_id = %d', strtoi(pid)))
}

spl.db.count.variables.file <- function(pid) {
  dbGetQuery(conf$con, sprintf('SELECT COUNT(*) FROM spl_variable v
                                JOIN spl_file_instance fi ON fi.id = v.spl_file_instance_id
                                JOIN spl_file f ON f.id = fi.file_id
                                WHERE f.project_id = %d', strtoi(pid)))
}

spl.db.count.variables.release <- function(pid) {
  dbGetQuery(conf$con, sprintf('SELECT COUNT(*) FROM spl_variable v
                                JOIN release_timeline rt ON rt.id = v.release_timeline_id
                                WHERE rt.projectId = %d', strtoi(pid)))
}

spl.db.count.releases <- function(pid) {
  dbGetQuery(conf$con, sprintf("SELECT COUNT(*) FROM release_timeline rt
                                WHERE rt.projectId = %d
                                AND rt.type = 'release'", strtoi(pid)))
}

spl.db.release.metrics <- function(pid) {
  query <- sprintf("SELECT rt.tag revision, m.name, SUM(v.value) sum
    FROM spl_variable v
    JOIN spl_metric m
      ON m.id = v.spl_metric_id
      AND m.scope = 'ScopeFileInstance'
      AND m.name IN ('LOC', 'NOFC', 'LOF')
    JOIN spl_file_instance fi
      ON fi.id = v.spl_file_instance_id
    JOIN release_timeline rt
      ON rt.id = fi.release_timeline_id
    JOIN spl_file f
      ON f.id = fi.file_id
      AND f.project_id = %d 
    GROUP BY rt.tag, m.name
    ORDER BY INET_ATON(SUBSTRING_INDEX(CONCAT(revision, '.0.0.0'), '.', 4))", pid) 
  dbGetQuery(conf$con, query)
}
