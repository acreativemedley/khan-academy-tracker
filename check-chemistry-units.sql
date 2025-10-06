-- Check Chemistry course unit ordering and activity distribution
SELECT 
  u.unit_number,
  u.unit_name,
  COUNT(a.id) as activity_count,
  MIN(a.order_index) as first_order_index,
  MAX(a.order_index) as last_order_index,
  STRING_AGG(CASE WHEN a.is_exam THEN a.activity_name END, ', ') as exams
FROM courses c
JOIN units u ON u.course_id = c.id
LEFT JOIN activities a ON a.unit_id = u.id
WHERE c.name = 'High School Chemistry'
GROUP BY u.unit_number, u.unit_name, u.id
ORDER BY u.unit_number;
