-- Migration: Add manually_assigned column to schedule table
-- Date: October 5, 2025
-- Purpose: Track which activity due dates were manually overridden by user

-- Add manually_assigned column to schedule table
ALTER TABLE schedule 
ADD COLUMN IF NOT EXISTS manually_assigned BOOLEAN DEFAULT FALSE;

-- Add helpful comment
COMMENT ON COLUMN schedule.manually_assigned IS 'TRUE if due date was manually set by user, FALSE if auto-calculated. Manual dates are temporary and reset on recalculation.';

-- Verify column was added
SELECT 
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_name = 'schedule' 
  AND column_name = 'manually_assigned';
