-- Debug Activity ID Issue - Enhanced Check
-- Run this to see exactly what's in the database vs. what the UI might be showing

-- 1. Show ALL Unit 1 activities with their exact IDs and details
SELECT 
    'DATABASE ACTIVITIES' as source,
    a.id::text as activity_id,
    a.activity_name,
    a.activity_type,
    a.order_index,
    a.lesson_name,
    u.title as unit_title,
    u.unit_number,
    a.created_at,
    a.updated_at
FROM activities a
JOIN courses c ON a.course_id = c.id
JOIN units u ON a.unit_id = u.id
WHERE c.name = 'Integrated Math 3'
AND u.unit_number = 1
ORDER BY a.order_index;

-- 2. Check if there are any activities without proper unit_id
SELECT 
    'ACTIVITIES WITH NULL UNIT' as issue,
    a.id::text as activity_id,
    a.activity_name,
    a.unit_id,
    c.name as course_name
FROM activities a
JOIN courses c ON a.course_id = c.id
WHERE c.name = 'Integrated Math 3'
AND a.unit_id IS NULL;

-- 3. Check progress_tracking records that might be causing issues
SELECT 
    'PROGRESS_TRACKING RECORDS' as source,
    pt.id::text as progress_id,
    pt.activity_id::text as referenced_activity_id,
    pt.student_id::text as student_id,
    pt.completed,
    CASE 
        WHEN a.id IS NOT NULL THEN 'VALID'
        ELSE 'INVALID - Activity Not Found'
    END as validity_status
FROM progress_tracking pt
LEFT JOIN activities a ON pt.activity_id = a.id
WHERE pt.activity_id IS NOT NULL;

-- 4. Show exact UUID format to check for data type issues
SELECT 
    'UUID FORMAT CHECK' as test,
    a.id,
    pg_typeof(a.id) as id_data_type,
    LENGTH(a.id::text) as uuid_length,
    a.activity_name
FROM activities a
JOIN courses c ON a.course_id = c.id
WHERE c.name = 'Integrated Math 3'
LIMIT 3;

-- 5. Check if there are multiple courses with similar names
SELECT 
    'COURSE NAME CHECK' as test,
    id::text as course_id,
    name,
    created_at
FROM courses 
WHERE name ILIKE '%math%'
ORDER BY created_at;