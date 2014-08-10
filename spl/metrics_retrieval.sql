-- NOF / Number Of Files (Project)
----------------------------------------
SELECT count(*) count
FROM spl_file f
JOIN project p
  ON p.id = f.project_id
WHERE p.name = 'test'


-- NOF / Number Of Files (Release)
----------------------------------------
SELECT rt.tag revision, count(*) count
FROM spl_file_instance fi
JOIN release_timeline rt
  ON rt.id = fi.release_timeline_id
JOIN spl_file f
  ON fi.file_id = f.id
JOIN project p
  ON p.id = f.project_id
WHERE p.name = 'test'
GROUP BY rt.tag


-- LOC / Lines Of Code (SUM, Release)
----------------------------------------
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
JOIN project p
  ON p.id = f.project_id
WHERE p.name = 'test'
AND m.name = 'LOC'
GROUP BY rt.tag


-- LOC / Lines Of Code (AVG, Release)
----------------------------------------
SELECT rt.tag revision, AVG(v.value) LOC
FROM spl_variable v
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN spl_file_instance fi
  ON v.spl_file_instance_id = fi.id
JOIN release_timeline rt
  ON rt.id = fi.release_timeline_id
JOIN spl_file f
  ON fi.file_id = f.id
JOIN project p
  ON p.id = f.project_id
WHERE p.name = 'test'
AND m.name = 'LOC'
GROUP BY rt.tag


-- LOC / Lines Of Code (AVG, Project)
----------------------------------------
SELECT AVG(LOC) LOC FROM (
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
  JOIN project p
    ON p.id = f.project_id
  WHERE p.name = 'test'
  AND m.name = 'LOC'
  GROUP BY rt.tag
) AS tmp


-- LOF / Lines Of Feature Code (SUM, Release)
----------------------------------------
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
JOIN project p
  ON p.id = f.project_id
WHERE p.name = 'test'
AND m.name = 'LOF'
GROUP BY rt.tag


-- LOF / Lines Of Feature Code (AVG, Release)
----------------------------------------
SELECT rt.tag revision, AVG(v.value) LOF
FROM spl_variable v
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN spl_file_instance fi
  ON v.spl_file_instance_id = fi.id
JOIN release_timeline rt
  ON rt.id = fi.release_timeline_id
JOIN spl_file f
  ON fi.file_id = f.id
JOIN project p
  ON p.id = f.project_id
WHERE p.name = 'test'
AND m.name = 'LOF'
GROUP BY rt.tag


-- LOF / Lines Of Feature Code (AVG, Project)
----------------------------------------
SELECT AVG(LOF) LOF FROM (
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
  JOIN project p
    ON p.id = f.project_id
  WHERE p.name = 'test'
  AND m.name = 'LOF'
  GROUP BY rt.tag
) AS tmp


-- PLOF / Product LOF/LOC (Release)
----------------------------------------
SELECT rt.tag revision, (SUM(v.value) / SUM(v2.value)) PLOF
FROM spl_variable v
JOIN spl_metric m
  ON v.spl_metric_id = m.id
  AND m.name = 'LOF'
JOIN spl_file_instance fi
  ON v.spl_file_instance_id = fi.id
JOIN release_timeline rt
  ON rt.id = fi.release_timeline_id
JOIN spl_file f
  ON fi.file_id = f.id
JOIN project p
  ON p.id = f.project_id
JOIN spl_variable v2
  ON v2.spl_file_instance_id = v.spl_file_instance_id
JOIN spl_metric m2
  ON m2.id = v2.spl_metric_id
  AND m2.name = 'LOC'
WHERE p.name = 'test'
GROUP BY rt.tag


-- VP / Variation Point (Release)
----------------------------------------
SELECT rt.tag revision, SUM(v.value) VP
FROM spl_variable v
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN spl_file_instance fi
  ON v.spl_file_instance_id = fi.id
JOIN release_timeline rt
  ON rt.id = fi.release_timeline_id
JOIN spl_file f
  ON fi.file_id = f.id
JOIN project p
  ON p.id = f.project_id
WHERE p.name = 'test'
AND m.name LIKE 'GRAN%'
GROUP BY rt.tag


-- VP / Variation Point (AVG, Project)
----------------------------------------
SELECT AVG(VP) VP FROM (
  SELECT rt.tag revision, SUM(v.value) as VP
  FROM spl_variable v
  JOIN spl_metric m
    ON v.spl_metric_id = m.id
  JOIN spl_file_instance fi
    ON v.spl_file_instance_id = fi.id
  JOIN release_timeline rt
    ON rt.id = fi.release_timeline_id
  JOIN spl_file f
    ON fi.file_id = f.id
  JOIN project p
    ON p.id = f.project_id
  WHERE p.name = 'test'
  AND m.name LIKE 'GRAN%'
  GROUP BY rt.tag
) AS tmp


-- NOFC / Numer Of Feature Constants (Release)
----------------------------------------
SELECT rt.tag revision, v.value NOFC
FROM spl_variable v
JOIN release_timeline rt
  ON rt.id = v.release_timeline_id
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN project p
  ON p.id = rt.projectId
WHERE m.name = 'NOFC'
AND p.name = 'test'
AND m.scope = 'ScopeRelease'


-- NOFC / Numer Of Feature Constants (AVG, Project)
----------------------------------------
SELECT AVG(NOFC) NOFC FROM (
  SELECT rt.tag revision, v.value NOFC
  FROM spl_variable v
  JOIN release_timeline rt
    ON rt.id = v.release_timeline_id
  JOIN spl_metric m
    ON v.spl_metric_id = m.id
  JOIN project p
    ON p.id = rt.projectId
  WHERE m.name = 'NOFC'
  AND p.name = 'test'
  AND m.scope = 'ScopeRelease'
) AS tmp


-- NOFC / Numer Of Feature Constants (STDEV, Project)
----------------------------------------
SELECT STDDEV_POP(NOFC) NOFC FROM (
  SELECT rt.tag revision, v.value NOFC
  FROM spl_variable v
  JOIN release_timeline rt
    ON rt.id = v.release_timeline_id
  JOIN spl_metric m
    ON v.spl_metric_id = m.id
  JOIN project p
    ON p.id = rt.projectId
  WHERE m.name = 'NOFC'
  AND p.name = 'test'
  AND m.scope = 'ScopeRelease'
) AS tmp


-- SDEGMEAN / Scattering Degree (MEAN, Release)
----------------------------------------
SELECT rt.tag revision, v.value SDEGMEAN
FROM spl_variable v
JOIN release_timeline rt
  ON rt.id = v.release_timeline_id
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN project p
  ON p.id = rt.projectId
WHERE m.name = 'SDEGMEAN'
AND p.name = 'test'
AND m.scope = 'ScopeRelease'


-- SDEGSTD / SDEG Std.Dev. (Release)
----------------------------------------
SELECT rt.tag revision, v.value SDEGSTD
FROM spl_variable v
JOIN release_timeline rt
  ON rt.id = v.release_timeline_id
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN project p
  ON p.id = rt.projectId
WHERE m.name = 'SDEGSTD'
AND p.name = 'test'
AND m.scope = 'ScopeRelease'


-- NOFPFCMEAN / Number Of Files Per Feature Constant [source code scattering] (Release)
----------------------------------------
SELECT rt.tag revision, v.value NOFPFCMEAN
FROM spl_variable v
JOIN release_timeline rt
  ON rt.id = v.release_timeline_id
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN project p
  ON p.id = rt.projectId
WHERE m.name = 'NOFPFCMEAN'
AND p.name = 'test'
AND m.scope = 'ScopeRelease'


-- NOFPFCSTD / NOFPFC Std.Dev. (Release)
----------------------------------------
SELECT rt.tag revision, v.value NOFPFCSTD
FROM spl_variable v
JOIN release_timeline rt
  ON rt.id = v.release_timeline_id
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN project p
  ON p.id = rt.projectId
WHERE m.name = 'NOFPFCSTD'
AND p.name = 'test'
AND m.scope = 'ScopeRelease'


-- TDEGMEAN / Tangling Degree 
----------------------------------------
SELECT rt.tag revision, v.value TDEGMEAN
FROM spl_variable v
JOIN release_timeline rt
  ON rt.id = v.release_timeline_id
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN project p
  ON p.id = rt.projectId
WHERE m.name = 'TDEGMEAN'
AND p.name = 'test'
AND m.scope = 'ScopeRelease'


-- TDEGSTD / TDEG Std.Dev. (Release)
----------------------------------------
SELECT rt.tag revision, v.value TDEGSTD
FROM spl_variable v
JOIN release_timeline rt
  ON rt.id = v.release_timeline_id
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN project p
  ON p.id = rt.projectId
WHERE m.name = 'TDEGSTD'
AND p.name = 'test'
AND m.scope = 'ScopeRelease'


-- NOFC / Numer Of Feature Constants (AVG, File)
----------------------------------------
SELECT rt.tag revision, AVG(v.value) NOFC
FROM spl_variable v
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN spl_file_instance fi
  ON v.spl_file_instance_id = fi.id
JOIN release_timeline rt
  ON rt.id = fi.release_timeline_id
JOIN spl_file f
  ON fi.file_id = f.id
JOIN project p
  ON p.id = f.project_id
WHERE p.name = 'test'
AND m.name = 'NOFC'
AND v.value > 0 -- if NOFC is zero, no FC is existent -> sort out this data!  
GROUP BY rt.tag


-- NOFC / Numer Of Feature Constants (STDEV, File)
----------------------------------------
SELECT rt.tag revision, STDDEV_POP(v.value) NOFC
FROM spl_variable v
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN spl_file_instance fi
  ON v.spl_file_instance_id = fi.id
JOIN release_timeline rt
  ON rt.id = fi.release_timeline_id
JOIN spl_file f
  ON fi.file_id = f.id
JOIN project p
  ON p.id = f.project_id
WHERE p.name = 'test'
AND m.name = 'NOFC'
AND v.value > 0 -- if NOFC is zero, no FC is existent -> sort out this data!  
GROUP BY rt.tag


-- NDMAX / Max Nesting Depth (MAX, File)
----------------------------------------
SELECT rt.tag revision, MAX(v.value) NDMAX
FROM spl_variable v
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN spl_file_instance fi
  ON v.spl_file_instance_id = fi.id
JOIN release_timeline rt
  ON rt.id = fi.release_timeline_id
JOIN spl_file f
  ON fi.file_id = f.id
JOIN project p
  ON p.id = f.project_id
WHERE p.name = 'test'
AND m.name = 'NDMAX'
GROUP BY rt.tag

-- AND / Average Nesting Depth (AVG, File)
----------------------------------------
SELECT rt.tag revision, AVG(v.value) ANDAVG
FROM spl_variable v
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN spl_file_instance fi
  ON v.spl_file_instance_id = fi.id
JOIN release_timeline rt
  ON rt.id = fi.release_timeline_id
JOIN spl_file f
  ON fi.file_id = f.id
JOIN project p
  ON p.id = f.project_id
WHERE p.name = 'test'
AND m.name = 'ANDAVG'
AND v.value > 0 -- if ANDAVG is zero, no nesting is existent -> sort out this data!  
GROUP BY rt.tag


-- ANDSTDEV / Average Nesting Depth Std.Dev. (AVG, File)
----------------------------------------
SELECT rt.tag revision, AVG(v.value) ANDSTDEV
FROM spl_variable v
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN spl_file_instance fi
  ON v.spl_file_instance_id = fi.id
JOIN release_timeline rt
  ON rt.id = fi.release_timeline_id
JOIN spl_file f
  ON fi.file_id = f.id
JOIN project p
  ON p.id = f.project_id
WHERE p.name = 'test'
AND m.name = 'ANDSTDEV'
AND v.value > 0
GROUP BY rt.tag


-- HET
----------------------------------------
SELECT rt.tag revision, v.value HET
FROM spl_variable v
JOIN release_timeline rt
  ON rt.id = v.release_timeline_id
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN project p
  ON p.id = rt.projectId
WHERE m.name = 'HET'
AND p.name = 'test'
AND m.scope = 'ScopeRelease'


-- HOHE
----------------------------------------
SELECT rt.tag revision, v.value HOHE
FROM spl_variable v
JOIN release_timeline rt
  ON rt.id = v.release_timeline_id
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN project p
  ON p.id = rt.projectId
WHERE m.name = 'HOHE'
AND p.name = 'test'
AND m.scope = 'ScopeRelease'


-- HOM
----------------------------------------
SELECT rt.tag revision, v.value HOM
FROM spl_variable v
JOIN release_timeline rt
  ON rt.id = v.release_timeline_id
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN project p
  ON p.id = rt.projectId
WHERE m.name = 'HOM'
AND p.name = 'test'
AND m.scope = 'ScopeRelease'

-- GRANBL, ...
----------------------------------------
SELECT rt.tag revision, SUM(v.value) GRANBL
FROM spl_variable v
JOIN spl_metric m
  ON v.spl_metric_id = m.id
JOIN spl_file_instance fi
  ON v.spl_file_instance_id = fi.id
JOIN release_timeline rt
  ON rt.id = fi.release_timeline_id
JOIN spl_file f
  ON fi.file_id = f.id
JOIN project p
  ON p.id = f.project_id
WHERE p.name = 'test'
AND m.name = 'GRANBL'
GROUP BY rt.tag

-- ordering by version number
---------------------------------------
ORDER BY INET_ATON(SUBSTRING_INDEX(CONCAT(revision, '.0.0.0'), '.', 4))
