-- Check if the specific user ID exists in students table
-- The debug shows user ID: 7539e054-2bda-4ab5-8466-e890ac2c621d

SELECT 
    'SPECIFIC USER CHECK' as test,
    id::text as student_id,
    display_name,
    student_email
FROM students
WHERE id = '7539e054-2bda-4ab5-8466-e890ac2c621d';

-- Check if this user exists in auth.users
SELECT 
    'AUTH USER CHECK' as test,
    id::text as auth_user_id,
    email
FROM auth.users
WHERE id = '7539e054-2bda-4ab5-8466-e890ac2c621d';

-- Check if the specific activity exists (should be yes)
SELECT 
    'ACTIVITY CHECK' as test,
    id::text as activity_id,
    activity_name
FROM activities
WHERE id = 'f58bc0aa-701f-4f70-8c34-f0372b80f66d';

-- Show all students to see what exists
SELECT 
    'ALL STUDENTS' as test,
    id::text as student_id,
    display_name,
    created_at
FROM students
ORDER BY created_at DESC;