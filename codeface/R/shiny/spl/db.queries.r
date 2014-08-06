spl.db.count.files <- function(pid) {
  dbGetQuery(conf$con, sprintf('SELECT COUNT(*) FROM spl_file f WHERE f.project_id = %d', strtoi(pid)))
}

spl.db.count.files.instances <- function(pid) {
  dbGetQuery(conf$con, sprintf('SELECT COUNT(*) FROM spl_file_instance fi
                              JOIN spl_file f ON f.id = fi.file_id
                              WHERE f.project_id = %d', strtoi(pid)))
}

spl.db.count.files.instances.r <- function(pid, rid) {
  dbGetQuery(conf$con, sprintf('SELECT COUNT(*) FROM spl_file_instance fi
                              JOIN spl_file f ON f.id = fi.file_id
                              WHERE f.project_id = %d
                              AND fi.release_timeline_id = %d', strtoi(pid), strtoi(rid)))
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

spl.db.count.variables.file.r <- function(pid, rid) {
  dbGetQuery(conf$con, sprintf('SELECT COUNT(*) FROM spl_variable v
                                JOIN spl_file_instance fi ON fi.id = v.spl_file_instance_id
                                JOIN spl_file f ON f.id = fi.file_id
                                WHERE f.project_id = %d
                                AND fi.release_timeline_id = %d', strtoi(pid), strtoi(rid)))
}

spl.db.count.variables.release.r <- function(pid, rid) {
  dbGetQuery(conf$con, sprintf('SELECT COUNT(*) FROM spl_variable v
                                JOIN release_timeline rt ON rt.id = v.release_timeline_id
                                WHERE rt.projectId = %d
                                AND rt.id = %d', strtoi(pid), strtoi(rid)))
}

spl.db.count.releases <- function(pid) {
  dbGetQuery(conf$con, sprintf("SELECT COUNT(*) FROM release_timeline rt
                                WHERE rt.projectId = %d
                                AND rt.type = 'release'", strtoi(pid)))
}

spl.db.hasdata <- function(pid) {
  spl.db.count.files.instances(pid) > 0
}

spl.db.release.get <- function(pid, rid) {
  dbGetQuery(conf$con, sprintf("SELECT *
    FROM release_timeline rt
    WHERE rt.projectId = %1$d
    AND rt.id = %2$d", strtoi(pid), strtoi(rid)))
}

spl.db.project.loc <- function(pid) {
  query <- sprintf("SELECT MAX(LOC) max, MIN(LOC) min, AVG(LOC) avg FROM (
SELECT rt.tag revision, SUM(v.value) LOC
FROM spl_variable v
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN spl_file_instance fi
  ON v.spl_file_instance_id = fi.id
JOIN release_timeline rt
  ON rt.id = fi.release_timeline_id
JOIN spl_file f
  ON fi.file_id = f.id
WHERE f.project_id = %1$d
AND m.name = 'LOC'
GROUP BY rt.tag
) as tmp", strtoi(pid))
  dbGetQuery(conf$con, query)
}

spl.db.project.lof <- function(pid) {
  query <- sprintf("SELECT MAX(LOF) max, MIN(LOF) min, AVG(LOF) avg FROM (
SELECT rt.tag revision, SUM(v.value) LOF
FROM spl_variable v
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN spl_file_instance fi
  ON v.spl_file_instance_id = fi.id
JOIN release_timeline rt
  ON rt.id = fi.release_timeline_id
JOIN spl_file f
  ON fi.file_id = f.id
WHERE f.project_id = %1$d
AND m.name = 'LOF'
GROUP BY rt.tag
) as tmp", strtoi(pid))
  dbGetQuery(conf$con, query)
}

spl.db.project.nofc <- function(pid) {
  query <- sprintf("SELECT MAX(NOFC) max, MIN(NOFC) min, AVG(NOFC) avg FROM (
SELECT rt.tag revision, SUM(v.value) NOFC
FROM spl_variable v
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN spl_file_instance fi
  ON v.spl_file_instance_id = fi.id
JOIN release_timeline rt
  ON rt.id = fi.release_timeline_id
JOIN spl_file f
  ON fi.file_id = f.id
WHERE f.project_id = %1$d
AND m.name = 'NOFC'
GROUP BY rt.tag
) as tmp", strtoi(pid))
  dbGetQuery(conf$con, query)
}

spl.db.release.metrics <- function(pid) {
  query <- sprintf("SELECT * FROM (
SELECT f.project_id pid, rt.id rid, rt.tag revision, m.name, SUM(v.value) sum
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
      AND f.project_id = %1$d
    GROUP BY rt.tag, m.name
UNION
SELECT f.project_id pid, rt.id rid, rt.tag revision, m.name, AVG(v.value) sum
    FROM spl_variable v
    JOIN spl_metric m
      ON m.id = v.spl_metric_id
      AND m.scope = 'ScopeFileInstance'
      AND m.name IN ('ANDAVG')
    JOIN spl_file_instance fi
      ON fi.id = v.spl_file_instance_id
    JOIN release_timeline rt
      ON rt.id = fi.release_timeline_id
    JOIN spl_file f
      ON f.id = fi.file_id
      AND f.project_id = %1$d
    GROUP BY rt.tag, m.name
UNION
SELECT rt.projectId pid, rt.id rid, rt.tag revision, m.name, v.value sum
    FROM spl_variable v
    JOIN spl_metric m
      ON m.id = v.spl_metric_id
      AND m.scope = 'ScopeRelease'
      AND m.name IN ('SDEGMEAN', 'TDEGMEAN', 'NOFPFCMEAN')
    JOIN release_timeline rt
      ON rt.id = v.release_timeline_id
      AND rt.projectId = %1$d
    GROUP BY rt.tag, m.name
) as TMP
ORDER BY INET_ATON(SUBSTRING_INDEX(CONCAT(revision, '.0.0.0'), '.', 4))", strtoi(pid))
  dbGetQuery(conf$con, query)
}

spl.db.release.metrics.r <- function(pid, rid) {
  query <- sprintf("SELECT * FROM (
SELECT rt.tag revision, m.name, SUM(v.value) sum
    FROM spl_variable v
    JOIN spl_metric m
      ON m.id = v.spl_metric_id
      AND m.scope = 'ScopeFileInstance'
      AND m.name IN ('LOC', 'NOFC', 'LOF')
    JOIN spl_file_instance fi
      ON fi.id = v.spl_file_instance_id
    JOIN release_timeline rt
      ON rt.id = fi.release_timeline_id
      AND rt.id = %2$d
    JOIN spl_file f
      ON f.id = fi.file_id
      AND f.project_id = %1$d
    GROUP BY rt.tag, m.name
UNION
SELECT rt.tag revision, m.name, AVG(v.value) sum
    FROM spl_variable v
    JOIN spl_metric m
      ON m.id = v.spl_metric_id
      AND m.scope = 'ScopeFileInstance'
      AND m.name IN ('ANDAVG')
    JOIN spl_file_instance fi
      ON fi.id = v.spl_file_instance_id
    JOIN release_timeline rt
      ON rt.id = fi.release_timeline_id
      AND rt.id = %2$d
    JOIN spl_file f
      ON f.id = fi.file_id
      AND f.project_id = %1$d
    GROUP BY rt.tag, m.name
UNION
SELECT rt.tag revision, m.name, v.value sum
    FROM spl_variable v
    JOIN spl_metric m
      ON m.id = v.spl_metric_id
      AND m.scope = 'ScopeRelease'
      AND m.name IN ('SDEGMEAN', 'TDEGMEAN', 'NOFPFCMEAN')
    JOIN release_timeline rt
      ON rt.id = v.release_timeline_id
      AND rt.projectId = %1$d
      AND rt.id = %2$d
    GROUP BY rt.tag, m.name
) as TMP
ORDER BY INET_ATON(SUBSTRING_INDEX(CONCAT(revision, '.0.0.0'), '.', 4))", strtoi(pid), strtoi(rid))
  dbGetQuery(conf$con, query)
}

spl.db.avg.type <- function(pid) {
  query <- sprintf("SELECT m.name, AVG(v.value) value
FROM spl_variable v
JOIN release_timeline rt
  ON rt.id = v.release_timeline_id
JOIN spl_metric m
  ON v.spl_metric_id = m.id
WHERE m.name IN('HOHE', 'HET', 'HOM')
AND rt.projectId = %1$d
AND m.scope = 'ScopeRelease'
GROUP BY name", strtoi(pid))
  dbGetQuery(conf$con, query)
}

spl.db.avg.gran <- function(pid) {
  query <- sprintf("SELECT name, AVG(sum) value FROM (
SELECT rt.tag revision, m.name, SUM(v.value) sum
    FROM spl_variable v
    JOIN spl_metric m
      ON m.id = v.spl_metric_id
      AND m.scope = 'ScopeFileInstance'
      AND m.name like 'GRAN%%'
    JOIN spl_file_instance fi
      ON fi.id = v.spl_file_instance_id
    JOIN release_timeline rt
      ON rt.id = fi.release_timeline_id
    JOIN spl_file f
      ON f.id = fi.file_id
      AND f.project_id = %1$d
    GROUP BY rt.tag, m.name
) AS tmp
GROUP BY name", strtoi(pid))
  dbGetQuery(conf$con, query)
}

spl.db.releases.het <- function(pid) {
  query <- sprintf("SELECT rt.tag revision, v.value value
FROM spl_variable v
JOIN release_timeline rt
  ON rt.id = v.release_timeline_id
JOIN spl_metric m
  ON v.spl_metric_id = m.id
WHERE m.name = 'HET'
AND rt.projectId = %1$d
AND m.scope = 'ScopeRelease'
ORDER BY INET_ATON(SUBSTRING_INDEX(CONCAT(revision, '.0.0.0'), '.', 4))", strtoi(pid))
  dbGetQuery(conf$con, query)
}

spl.db.releases.hom <- function(pid) {
  query <- sprintf("SELECT rt.tag revision, v.value value
FROM spl_variable v
JOIN release_timeline rt
  ON rt.id = v.release_timeline_id
JOIN spl_metric m
  ON v.spl_metric_id = m.id
WHERE m.name = 'HOM'
AND rt.projectId = %1$d
AND m.scope = 'ScopeRelease'
ORDER BY INET_ATON(SUBSTRING_INDEX(CONCAT(revision, '.0.0.0'), '.', 4))", strtoi(pid))
  dbGetQuery(conf$con, query)
}

spl.db.releases.hohe <- function(pid) {
  query <- sprintf("SELECT rt.tag revision, v.value value
FROM spl_variable v
JOIN release_timeline rt
  ON rt.id = v.release_timeline_id
JOIN spl_metric m
  ON v.spl_metric_id = m.id
WHERE m.name = 'HOHE'
AND rt.projectId = %1$d
AND m.scope = 'ScopeRelease'
ORDER BY INET_ATON(SUBSTRING_INDEX(CONCAT(revision, '.0.0.0'), '.', 4))", strtoi(pid))
  dbGetQuery(conf$con, query)
}

spl.db.files.and.avg <- function(pid, rtid) {
  query <- sprintf("SELECT f.path path, v.value value
FROM spl_variable v
JOIN spl_file_instance fi
  ON fi.id = v.spl_file_instance_id
JOIN spl_metric m
  ON m.id = v.spl_metric_id
JOIN spl_file f
  ON f.id = fi.file_id
WHERE f.project_id = %1$d
AND fi.release_timeline_id = %2$d
AND m.name = 'ANDAVG'
AND v.value > 0
ORDER BY f.path", strtoi(pid), strtoi(rtid))
  dbGetQuery(conf$con, query)
}

spl.db.finstance.get <- function(pid, fid) {
  query <- sprintf("SELECT fi.id id, f.path, rt.tag as revision
FROM spl_file_instance fi
JOIN spl_file f ON f.id = fi.file_id
JOIN release_timeline rt ON rt.id = fi.release_timeline_id
WHERE fi.id = %2$d
AND f.project_id = %1$d", strtoi(pid), strtoi(fid))
  dbGetQuery(conf$con, query)
}

spl.db.finstance.metrics <- function(pid, fid) {
  query <- sprintf("SELECT m.name, v.value
FROM spl_variable v
JOIN spl_metric m ON m.id = v.spl_metric_id
JOIN spl_file_instance fi ON fi.id = v.spl_file_instance_id
JOIN spl_file f ON f.id = fi.file_id
JOIN release_timeline rt ON rt.id = fi.release_timeline_id
WHERE fi.id = %2$d
AND f.project_id = %1$d", strtoi(pid), strtoi(fid))
  dbGetQuery(conf$con, query)
}

spl.db.finstance.metrics.max <- function(pid) {
  query <- sprintf("SELECT m.name, MAX(v.value) value
FROM spl_variable v
JOIN spl_metric m ON m.id = v.spl_metric_id
JOIN spl_file_instance fi ON fi.id = v.spl_file_instance_id
JOIN spl_file f ON f.id = fi.file_id
WHERE f.project_id = %1$d
GROUP BY m.name", strtoi(pid))
  dbGetQuery(conf$con, query)
}
