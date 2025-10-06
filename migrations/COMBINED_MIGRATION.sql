-- Combined Database Migration Script
-- Date: October 5, 2025
-- Tasks: 3 & 4 - Create vacation_periods table and add manually_assigned column
-- Instructions: Run this entire script in Supabase SQL Editor

-- ============================================================================
-- TASK 3: Create vacation_periods Table
-- ============================================================================

CREATE TABLE IF NOT EXISTS vacation_periods (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id UUID REFERENCES students(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_vacation_periods_student ON vacation_periods(student_id);
CREATE INDEX IF NOT EXISTS idx_vacation_periods_dates ON vacation_periods(start_date, end_date);

-- Add comments
COMMENT ON TABLE vacation_periods IS 'Stores vacation and holiday periods that are excluded from schedule calculations';
COMMENT ON COLUMN vacation_periods.student_id IS 'Foreign key to students table - vacations are student-specific';
COMMENT ON COLUMN vacation_periods.start_date IS 'First day of vacation period (inclusive)';
COMMENT ON COLUMN vacation_periods.end_date IS 'Last day of vacation period (inclusive)';

-- ============================================================================
-- TASK 4: Add manually_assigned Column to schedule Table
-- ============================================================================

ALTER TABLE schedule 
ADD COLUMN IF NOT EXISTS manually_assigned BOOLEAN DEFAULT FALSE;

-- Add comment
COMMENT ON COLUMN schedule.manually_assigned IS 'TRUE if due date was manually set by user, FALSE if auto-calculated. Manual dates are temporary and reset on recalculation.';

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Verify vacation_periods table structure
SELECT 
  'vacation_periods' as table_name,
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_name = 'vacation_periods'
ORDER BY ordinal_position;

-- Verify schedule.manually_assigned column
SELECT 
  'schedule' as table_name,
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_name = 'schedule' 
  AND column_name = 'manually_assigned';

-- Check indexes
SELECT 
  tablename,
  indexname,
  indexdef
FROM pg_indexes
WHERE tablename IN ('vacation_periods', 'schedule')
ORDER BY tablename, indexname;

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================

DO $$
BEGIN
  RAISE NOTICE '✅ Migration completed successfully!';
  RAISE NOTICE '✅ vacation_periods table created with indexes';
  RAISE NOTICE '✅ schedule.manually_assigned column added';
  RAISE NOTICE '';
  RAISE NOTICE '📋 Next Steps:';
  RAISE NOTICE '  - Task 5: Create date calculation utility functions';
  RAISE NOTICE '  - Task 6: Implement core schedule calculation algorithm';
END $$;
