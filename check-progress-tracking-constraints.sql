-- Check all constraints on progress_tracking table
-- This will show us exactly what the progress_tracking_activity_id_fkey constraint is checking

-- 1. Show all foreign key constraints on progress_tracking table
SELECT 
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
  AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
  AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
AND tc.table_name = 'progress_tracking';

-- 2. Show detailed constraint information
SELECT 
    conname as constraint_name,
    contype as constraint_type,
    confrelid::regclass as foreign_table,
    a.attname as column_name,
    af.attname as foreign_column
FROM pg_constraint c
JOIN pg_attribute a ON a.attnum = ANY(c.conkey) AND a.attrelid = c.conrelid
JOIN pg_attribute af ON af.attnum = ANY(c.confkey) AND af.attrelid = c.confrelid
WHERE c.conrelid = 'progress_tracking'::regclass
AND c.contype = 'f'
ORDER BY c.conname;

-- 3. Show table structure to see all columns and their constraints
\d progress_tracking;

-- 4. Specifically check the activity_id foreign key constraint
SELECT 
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name,
    'This is the constraint that is failing' as note
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
  AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
  AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY' 
AND tc.table_name = 'progress_tracking'
AND tc.constraint_name = 'progress_tracking_activity_id_fkey';