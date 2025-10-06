-- Fix order_index to be sequential across entire course
-- This fixes issues where units were uploaded separately with duplicate order_index values

-- Create a function to resequence activities for a course
CREATE OR REPLACE FUNCTION resequence_course_activities(p_course_id UUID)
RETURNS void AS $$
DECLARE
  activity_record RECORD;
  new_index INTEGER := 1;
BEGIN
  -- Loop through all activities in the course ordered by unit_id and current order_index
  FOR activity_record IN 
    SELECT id 
    FROM activities 
    WHERE course_id = p_course_id
    ORDER BY unit_id, order_index
  LOOP
    -- Update each activity with the new sequential index
    UPDATE activities 
    SET order_index = new_index 
    WHERE id = activity_record.id;
    
    new_index := new_index + 1;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Apply resequencing to all courses
DO $$
DECLARE
  course_record RECORD;
BEGIN
  FOR course_record IN SELECT id, name FROM courses ORDER BY name
  LOOP
    RAISE NOTICE 'Resequencing course: %', course_record.name;
    PERFORM resequence_course_activities(course_record.id);
  END LOOP;
END $$;

-- Verify the results
SELECT 
  c.name as course_name,
  COUNT(a.id) as total_activities,
  MIN(a.order_index) as min_index,
  MAX(a.order_index) as max_index,
  COUNT(DISTINCT a.order_index) as unique_indexes
FROM courses c
LEFT JOIN activities a ON a.course_id = c.id
GROUP BY c.id, c.name
ORDER BY c.name;
