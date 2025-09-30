# Khan Academy Tracker - Database Schema

## Overview
This document contains the complete database schema for the Khan Academy multi-course tracker application. Execute these SQL statements in your Supabase SQL editor.

## Tables

### 1. Courses Table
Stores information about each Khan Academy course being tracked.

```sql
CREATE TYPE course_status AS ENUM ('not_started', 'in_progress', 'completed', 'paused');

CREATE TABLE courses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    khan_academy_url VARCHAR(500),
    total_activities INTEGER DEFAULT 0,
    total_units INTEGER DEFAULT 0,
    target_completion_date DATE,
    start_date DATE DEFAULT CURRENT_DATE,
    status course_status DEFAULT 'not_started',
    estimated_hours INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 2. Units Table
Stores course units/chapters with their metadata.

```sql
CREATE TABLE units (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
    unit_number INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    total_activities INTEGER DEFAULT 0,
    has_unit_test BOOLEAN DEFAULT FALSE,
    order_index INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(course_id, unit_number)
);
```

### 3. Activities Table
Stores individual activities (videos, exercises, articles, quizzes, tests).

```sql
CREATE TYPE activity_type AS ENUM ('video', 'article', 'exercise', 'quiz', 'unit_test');

CREATE TABLE activities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
    unit_id UUID REFERENCES units(id) ON DELETE CASCADE,
    activity_name VARCHAR(255) NOT NULL,
    activity_type activity_type NOT NULL,
    estimated_minutes INTEGER,
    is_exam BOOLEAN DEFAULT FALSE,
    khan_academy_url VARCHAR(500),
    order_index INTEGER NOT NULL,
    lesson_name VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 4. Students Table
Extends Supabase auth.users with student-specific information.

```sql
CREATE TABLE students (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    display_name VARCHAR(255),
    grade_level VARCHAR(50),
    parent_email VARCHAR(255),
    timezone VARCHAR(50) DEFAULT 'America/New_York',
    school_days TEXT[] DEFAULT '{sunday,monday,thursday,friday,saturday}',
    daily_goal_minutes INTEGER DEFAULT 60,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 5. Student Course Enrollments Table
Links students to courses they're tracking.

```sql
CREATE TABLE student_course_enrollments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID REFERENCES students(id) ON DELETE CASCADE,
    course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
    enrolled_date DATE DEFAULT CURRENT_DATE,
    target_completion_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(student_id, course_id)
);
```

### 6. Progress Tracking Table
Tracks completion status of activities for each student.

```sql
CREATE TABLE progress_tracking (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID REFERENCES students(id) ON DELETE CASCADE,
    activity_id UUID REFERENCES activities(id) ON DELETE CASCADE,
    course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
    completed BOOLEAN DEFAULT FALSE,
    completion_date TIMESTAMP WITH TIME ZONE,
    time_spent_minutes INTEGER,
    needs_help BOOLEAN DEFAULT FALSE,
    help_requested_date TIMESTAMP WITH TIME ZONE,
    help_resolved_date TIMESTAMP WITH TIME ZONE,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(student_id, activity_id)
);
```

### 7. Schedule Table
Stores the generated daily schedule for each student.

```sql
CREATE TABLE schedule (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID REFERENCES students(id) ON DELETE CASCADE,
    activity_id UUID REFERENCES activities(id) ON DELETE CASCADE,
    course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
    scheduled_date DATE NOT NULL,
    is_exam_day BOOLEAN DEFAULT FALSE,
    is_review_day BOOLEAN DEFAULT FALSE,
    order_in_day INTEGER DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 8. Settings Table
Global application settings and configuration.

```sql
CREATE TABLE settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    setting_name VARCHAR(100) UNIQUE NOT NULL,
    setting_value JSONB,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 9. Help Requests Table
Tracks student help requests for detailed management.

```sql
CREATE TYPE help_status AS ENUM ('open', 'in_progress', 'resolved', 'closed');

CREATE TABLE help_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID REFERENCES students(id) ON DELETE CASCADE,
    activity_id UUID REFERENCES activities(id) ON DELETE CASCADE,
    course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
    status help_status DEFAULT 'open',
    request_message TEXT,
    resolution_notes TEXT,
    requested_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    resolved_date TIMESTAMP WITH TIME ZONE,
    resolved_by VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## Indexes for Performance

```sql
-- Progress tracking indexes
CREATE INDEX idx_progress_student_course ON progress_tracking(student_id, course_id);
CREATE INDEX idx_progress_completion ON progress_tracking(completed, completion_date);
CREATE INDEX idx_progress_needs_help ON progress_tracking(needs_help) WHERE needs_help = TRUE;

-- Schedule indexes
CREATE INDEX idx_schedule_student_date ON schedule(student_id, scheduled_date);
CREATE INDEX idx_schedule_date ON schedule(scheduled_date);
CREATE INDEX idx_schedule_exam_days ON schedule(is_exam_day) WHERE is_exam_day = TRUE;

-- Activity indexes
CREATE INDEX idx_activities_course_unit ON activities(course_id, unit_id);
CREATE INDEX idx_activities_type ON activities(activity_type);
CREATE INDEX idx_activities_exam ON activities(is_exam) WHERE is_exam = TRUE;

-- Help requests indexes
CREATE INDEX idx_help_requests_student ON help_requests(student_id);
CREATE INDEX idx_help_requests_status ON help_requests(status);
CREATE INDEX idx_help_requests_date ON help_requests(requested_date);
```

## Row Level Security (RLS) Policies

```sql
-- Enable RLS on all tables
ALTER TABLE students ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_course_enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE progress_tracking ENABLE ROW LEVEL SECURITY;
ALTER TABLE schedule ENABLE ROW LEVEL SECURITY;
ALTER TABLE help_requests ENABLE ROW LEVEL SECURITY;

-- Students can only access their own data
CREATE POLICY "Students can view own data" ON students
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Students can update own data" ON students
    FOR UPDATE USING (auth.uid() = id);

-- Progress tracking policies
CREATE POLICY "Students can view own progress" ON progress_tracking
    FOR SELECT USING (auth.uid() = student_id);

CREATE POLICY "Students can update own progress" ON progress_tracking
    FOR ALL USING (auth.uid() = student_id);

-- Schedule policies
CREATE POLICY "Students can view own schedule" ON schedule
    FOR SELECT USING (auth.uid() = student_id);

-- Help requests policies
CREATE POLICY "Students can manage own help requests" ON help_requests
    FOR ALL USING (auth.uid() = student_id);

-- Course data is public (read-only for students)
CREATE POLICY "Anyone can view courses" ON courses FOR SELECT TO authenticated USING (true);
CREATE POLICY "Anyone can view units" ON units FOR SELECT TO authenticated USING (true);
CREATE POLICY "Anyone can view activities" ON activities FOR SELECT TO authenticated USING (true);
```

## Initial Data Setup

### Default Settings
```sql
INSERT INTO settings (setting_name, setting_value, description) VALUES
('default_school_days', '["sunday", "monday", "thursday", "friday", "saturday"]', 'Default school days for new students'),
('default_daily_goal_minutes', '60', 'Default daily study goal in minutes'),
('holidays', '[
    {"name": "Thanksgiving Break", "start_date": "2025-11-27", "end_date": "2025-11-30"},
    {"name": "Christmas Break", "start_date": "2025-12-23", "end_date": "2026-01-03"},
    {"name": "Spring Break", "start_date": "2026-03-15", "end_date": "2026-03-22"}
]', 'Holiday periods when no activities are scheduled');
```

## Functions and Triggers

### Auto-update timestamps
```sql
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Add triggers to all tables with updated_at
CREATE TRIGGER update_courses_updated_at BEFORE UPDATE ON courses
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_units_updated_at BEFORE UPDATE ON units
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_activities_updated_at BEFORE UPDATE ON activities
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_students_updated_at BEFORE UPDATE ON students
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_progress_updated_at BEFORE UPDATE ON progress_tracking
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_schedule_updated_at BEFORE UPDATE ON schedule
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_help_requests_updated_at BEFORE UPDATE ON help_requests
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

## Notes for Implementation

1. **Course Data Import**: You'll need to import the course data from the markdown files we created
2. **Authentication**: Supabase Auth is already configured - students will sign up/login through the app
3. **Schedule Generation**: The schedule table will be populated by the scheduling algorithm
4. **Progress Tracking**: As students complete activities, the progress_tracking table is updated
5. **Help System**: Students can flag activities for help, tracked in help_requests table

## Next Steps After Database Setup

1. Create your Supabase project at https://supabase.com
2. Execute the SQL statements above in the Supabase SQL editor
3. Update your .env file with the Supabase URL and anon key
4. Import the course data from our markdown files
5. Test the database connection from the React app