-- Check current state of activities table
-- This will show us what happened to the activities data

-- Count total activities
SELECT COUNT(*) as total_activities FROM activities;

-- Count activities by course
SELECT 
    c.name as course_name,
    COUNT(a.id) as activity_count
FROM courses c
LEFT JOIN activities a ON c.id = a.course_id
GROUP BY c.id, c.name
ORDER BY activity_count DESC;

-- Check if any activities exist at all
SELECT 
    a.id,
    a.activity_name,
    a.activity_type,
    c.name as course_name,
    u.unit_name
FROM activities a
JOIN courses c ON a.course_id = c.id
LEFT JOIN units u ON a.unit_id = u.id
LIMIT 10;

-- Check progress_tracking table
SELECT COUNT(*) as total_progress_records FROM progress_tracking;

-- Check if progress_tracking has orphaned records
SELECT 
    COUNT(pt.id) as orphaned_progress_records
FROM progress_tracking pt
LEFT JOIN activities a ON pt.activity_id = a.id
WHERE a.id IS NULL;