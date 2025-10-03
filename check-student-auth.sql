-- Check if test student exists and get their ID
-- This might be the source of the foreign key constraint error

SELECT 
    'STUDENTS CHECK' as test,
    id::text as student_id,
    display_name,
    student_email,
    created_at
FROM students
ORDER BY created_at DESC;

-- Check if there are any auth users
SELECT 
    'AUTH USERS CHECK' as test,
    id::text as auth_user_id,
    email,
    created_at
FROM auth.users
ORDER BY created_at DESC
LIMIT 5;

-- Check for any existing progress_tracking records
SELECT 
    'EXISTING PROGRESS' as test,
    COUNT(*) as total_progress_records
FROM progress_tracking;

-- Check if progress_tracking has the right foreign key constraints
SELECT 
    constraint_name,
    table_name,
    column_name,
    foreign_table_name,
    foreign_column_name
FROM information_schema.key_column_usage kcu
JOIN information_schema.referential_constraints rc ON kcu.constraint_name = rc.constraint_name
WHERE kcu.table_name = 'progress_tracking';