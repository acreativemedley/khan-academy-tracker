-- fix-is_exam.sql
-- Ensures only unit tests have is_exam = TRUE and all other activity types have is_exam = FALSE

BEGIN;

-- Set is_exam = TRUE only for activities where activity_type = 'unit_test'
UPDATE activities
SET is_exam = TRUE
WHERE activity_type = 'unit_test';

-- Set is_exam = FALSE for everything else (safety)
UPDATE activities
SET is_exam = FALSE
WHERE activity_type IS DISTINCT FROM 'unit_test' AND (is_exam IS NULL OR is_exam = TRUE);

COMMIT;

-- Notes:
-- Run this script after you run the imports and after ensuring the enum type activity_type exists in the DB.
-- If you prefer to only set TRUE (and leave others unchanged), remove the second UPDATE.
