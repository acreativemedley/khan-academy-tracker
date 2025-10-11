-- Simple Schema Documentation Query
-- Copy and paste this into Supabase SQL Editor
-- Run it and save the results to document your current database schema

-- 1. TABLES OVERVIEW
SELECT
    schemaname as schema_name,
    tablename as table_name,
    'SELECT COUNT(*) FROM ' || tablename || ';' as count_query
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;

-- 2. TABLE STRUCTURES
SELECT
    c.table_name,
    c.column_name,
    c.data_type,
    CASE WHEN c.is_nullable = 'YES' THEN 'NULL' ELSE 'NOT NULL' END as nullable,
    COALESCE(c.column_default, '') as default_value
FROM information_schema.columns c
WHERE c.table_schema = 'public'
ORDER BY c.table_name, c.ordinal_position;

-- 3. FOREIGN KEY RELATIONSHIPS
SELECT
    tc.table_name as source_table,
    kcu.column_name as source_column,
    ccu.table_name as referenced_table,
    ccu.column_name as referenced_column
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu ON tc.constraint_name = ccu.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema = 'public'
ORDER BY tc.table_name, kcu.column_name;