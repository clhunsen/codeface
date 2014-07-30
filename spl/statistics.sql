-- releases
-------------------------------------
SELECT count(*) count
FROM release_timeline rt
JOIN project p
    ON p.id = rt.projectId
WHERE rt.type = 'release'
AND p.name = 'test'


-- spl_file
-------------------------------------
SELECT count(*) count
FROM spl_file f
JOIN project p
    ON p.id = f.project_id
WHERE p.name = 'test'


-- spl_file_instance
-------------------------------------
SELECT count(*) count
FROM spl_file f
JOIN project p
    ON p.id = f.project_id
JOIN spl_file_instance fi
    ON fi.file_id = f.id
WHERE p.name = 'test'


-- spl_variable
-------------------------------------
SELECT SUM(count) count FROM (
    SELECT count(*) count
    FROM spl_file f
    JOIN project p
        ON p.id = f.project_id
    JOIN spl_file_instance fi
        ON fi.file_id = f.id
    JOIN spl_variable v
        ON v.spl_file_instance_id = fi.id
    WHERE p.name = 'test'
    UNION
    SELECT count(*) count
    FROM project p
    JOIN release_timeline rt
        ON rt.projectId = p.id AND rt.type = 'release'
    JOIN spl_variable v
        ON v.release_timeline_id = rt.id
    WHERE p.name = 'test'
    UNION
    SELECT count(*) count
    FROM project p
    JOIN spl_variable v
        ON v.project_id = p.id
    WHERE p.name = 'test'
) AS tmp

