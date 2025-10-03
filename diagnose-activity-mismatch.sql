-- Diagnostic Query: Check Activity ID Mismatch Issue
-- User reports foreign key constraint error when checking off Unit 1 activities
-- Investigate potential caching or ID mismatch issues

-- 1. Check what activities currently exist in the database
SELECT 
    a.id as activity_id,
    a.activity_name,
    a.activity_type,
    a.order_index,
    a.lesson_name,
    c.name as course_name,
    u.title as unit_title,
    u.unit_number
FROM activities a
JOIN courses c ON a.course_id = c.id
LEFT JOIN units u ON a.unit_id = u.id
WHERE c.name = 'Integrated Math 3'
AND u.unit_number = 1
ORDER BY a.order_index;

-- 2. Check if there are any orphaned progress_tracking records
SELECT 
    pt.id as progress_id,
    pt.activity_id,
    pt.student_id,
    pt.completed,
    'ORPHANED - Activity not found' as status
FROM progress_tracking pt
LEFT JOIN activities a ON pt.activity_id = a.id
WHERE a.id IS NULL;

-- 3. Check the exact structure of activities table 
\d activities;

-- 4. Check if there are any duplicate activities with different IDs
SELECT 
    activity_name,
    lesson_name,
    COUNT(*) as duplicate_count,
    string_agg(id::text, ', ') as activity_ids
FROM activities 
WHERE course_id = (SELECT id FROM courses WHERE name = 'Integrated Math 3')
GROUP BY activity_name, lesson_name
HAVING COUNT(*) > 1;

-- 5. Check recent changes to activities table (if updated_at is being used)
SELECT 
    id,
    activity_name,
    created_at,
    updated_at,
    'Recently updated' as status
FROM activities 
WHERE course_id = (SELECT id FROM courses WHERE name = 'Integrated Math 3')
AND updated_at > NOW() - INTERVAL '1 hour'
ORDER BY updated_at DESC;

-- 6. Check exact count and total for Unit 1
SELECT 
    COUNT(*) as actual_unit1_activities,
    'Expected: 34' as expected_count
FROM activities a
JOIN units u ON a.unit_id = u.id
WHERE u.unit_number = 1 
AND a.course_id = (SELECT id FROM courses WHERE name = 'Integrated Math 3');