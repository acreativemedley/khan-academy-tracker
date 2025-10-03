-- Create Test Student Profile with Proper Authentication
-- Task #1: Enable meaningful progress tracking during development
-- NOTE: Timezone is US Central (America/Chicago)
-- REQUIRES: User must be created via Supabase Auth first

-- This script assumes you have already created a user via Supabase Auth
-- Replace 'YOUR_USER_ID_HERE' with the actual UUID from auth.users

-- Insert test student record linked to authenticated user
INSERT INTO students (
    id, -- Must match existing auth.users.id due to foreign key constraint
    display_name,
    student_email,
    parent_email,
    timezone,
    school_days
) VALUES (
    'YOUR_USER_ID_HERE', -- Replace with actual auth user ID
    'Test Student',
    'student@example.com',
    'parent@example.com',
    'America/Chicago',
    ARRAY['sunday', 'monday', 'thursday', 'friday', 'saturday']
) 
ON CONFLICT DO NOTHING;

-- Verify the student was created
SELECT 
    id,
    display_name,
    student_email,
    parent_email,
    timezone,
    school_days,
    created_at
FROM students 
WHERE display_name = 'Test Student';

-- Show student count
SELECT COUNT(*) as total_students FROM students;

-- Show auth users for reference
SELECT id, email, created_at FROM auth.users WHERE email = 'student@example.com';