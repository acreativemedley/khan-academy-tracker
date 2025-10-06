-- Clear all existing schedules since order_index values changed
-- This ensures schedules are recalculated with the corrected sequencing

-- Delete all schedule entries
DELETE FROM schedule;

-- Verify deletion
SELECT 
  c.name as course_name,
  COUNT(s.id) as scheduled_activities
FROM courses c
LEFT JOIN schedule s ON s.course_id = c.id
GROUP BY c.id, c.name
ORDER BY c.name;

-- Should show 0 scheduled_activities for all courses
