-- Migration: Create vacation_periods table
-- Date: October 5, 2025
-- Purpose: Store vacation and holiday periods for schedule calculation exclusion

-- Create vacation_periods table
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

-- Add helpful comment
COMMENT ON TABLE vacation_periods IS 'Stores vacation and holiday periods that are excluded from schedule calculations';
COMMENT ON COLUMN vacation_periods.student_id IS 'Foreign key to students table - vacations are student-specific';
COMMENT ON COLUMN vacation_periods.start_date IS 'First day of vacation period (inclusive)';
COMMENT ON COLUMN vacation_periods.end_date IS 'Last day of vacation period (inclusive)';

-- Verify table was created
SELECT 
  table_name,
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_name = 'vacation_periods'
ORDER BY ordinal_position;
