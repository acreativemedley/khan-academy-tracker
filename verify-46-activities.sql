-- Verify what 46 activities the frontend is seeing
-- Check all activities for course ID: ccf09880-1891-4739-be39-692b7cefc0f1

SELECT 
    'ALL COURSE ACTIVITIES' as source,
    COUNT(*) as total_activities
FROM activities 
WHERE course_id = 'ccf09880-1891-4739-be39-692b7cefc0f1';

-- Show breakdown by unit
SELECT 
    u.unit_number,
    u.title as unit_title,
    COUNT(a.id) as activity_count
FROM activities a
JOIN units u ON a.unit_id = u.id
WHERE a.course_id = 'ccf09880-1891-4739-be39-692b7cefc0f1'
GROUP BY u.unit_number, u.title
ORDER BY u.unit_number;

-- Show all activities to see what the frontend is fetching
SELECT 
    a.id::text as activity_id,
    a.activity_name,
    a.activity_type,
    a.order_index,
    u.unit_number,
    u.title as unit_title
FROM activities a
JOIN units u ON a.unit_id = u.id
WHERE a.course_id = 'ccf09880-1891-4739-be39-692b7cefc0f1'
ORDER BY u.unit_number, a.order_index;