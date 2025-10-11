# Khan Academy Tracker - Current Database Schema

**Last Updated:** October 10, 2025
**Generated from:** Live database query results
**Status:** CURRENT ACTUAL SCHEMA

## Database Overview

The Khan Academy Tracker database contains **10 tables** with the following structure:

| Table | Purpose |
|-------|---------|
| activities | Individual learning activities, videos, exercises, and quizzes |
| courses | Khan Academy courses being tracked |
| help_requests | Student help request system |
| parent_contacts | Parent contact information for students |
| progress_tracking | Student activity completion tracking |
| schedule | Daily assignment scheduling |
| settings | Application configuration |
| students | Student profile information |
| units | Course units/chapters |
| vacation_periods | Vacation and holiday periods for schedule exclusion |

## Foreign Key Relationships

| Source Table | Source Column | Referenced Table | Referenced Column |
|-------------|---------------|------------------|-------------------|
| activities | course_id | courses | id |
| activities | unit_id | units | id |
| help_requests | activity_id | activities | id |
| help_requests | course_id | courses | id |
| help_requests | student_id | students | id |
| parent_contacts | student_id | students | id |
| progress_tracking | activity_id | activities | id |
| progress_tracking | course_id | courses | id |
| progress_tracking | student_id | students | id |
| schedule | activity_id | activities | id |
| schedule | course_id | courses | id |
| schedule | student_id | students | id |
| units | course_id | courses | id |
| vacation_periods | student_id | students | id |

## Table Structures

### 1. activities
**Purpose:** Individual learning activities, videos, exercises, and quizzes

| Column | Type | Nullable | Default | Key Info |
|--------|------|----------|---------|----------|
| id | uuid | NOT NULL | uuid_generate_v4() | PK |
| course_id | uuid | NULL | | FK → courses.id |
| unit_id | uuid | NULL | | FK → units.id |
| activity_name | character varying(255) | NOT NULL | | |
| activity_type | USER-DEFINED | NOT NULL | | |
| is_exam | boolean | NULL | false | |
| khan_academy_url | character varying(500) | NULL | | |
| order_index | integer(32,0) | NOT NULL | | |
| lesson_name | character varying(255) | NULL | | |
| created_at | timestamp with time zone | NULL | now() | |
| updated_at | timestamp with time zone | NULL | now() | |

### 2. courses
**Purpose:** Khan Academy courses being tracked

| Column | Type | Nullable | Default | Key Info |
|--------|------|----------|---------|----------|
| id | uuid | NOT NULL | uuid_generate_v4() | PK |
| name | character varying(255) | NOT NULL | | |
| description | text | NULL | | |
| khan_academy_url | character varying(500) | NULL | | |
| total_activities | integer(32,0) | NULL | 0 | |
| total_units | integer(32,0) | NULL | 0 | |
| target_completion_date | date | NULL | | |
| start_date | date | NULL | CURRENT_DATE | |
| status | USER-DEFINED | NULL | 'not_started'::course_status | |
| estimated_hours | integer(32,0) | NULL | | |
| created_at | timestamp with time zone | NULL | now() | |
| updated_at | timestamp with time zone | NULL | now() | |

### 3. help_requests
**Purpose:** Student help request system

| Column | Type | Nullable | Default | Key Info |
|--------|------|----------|---------|----------|
| id | uuid | NOT NULL | uuid_generate_v4() | PK |
| student_id | uuid | NULL | | FK → students.id |
| activity_id | uuid | NULL | | FK → activities.id |
| course_id | uuid | NULL | | FK → courses.id |
| status | USER-DEFINED | NULL | 'open'::help_status | |
| request_message | text | NULL | | |
| resolution_notes | text | NULL | | |
| requested_date | timestamp with time zone | NULL | now() | |
| resolved_date | timestamp with time zone | NULL | | |
| resolved_by | character varying(255) | NULL | | |
| created_at | timestamp with time zone | NULL | now() | |
| updated_at | timestamp with time zone | NULL | now() | |

### 4. parent_contacts
**Purpose:** Parent contact information for students

| Column | Type | Nullable | Default | Key Info |
|--------|------|----------|---------|----------|
| id | uuid | NOT NULL | uuid_generate_v4() | PK |
| student_id | uuid | NULL | | FK → students.id |
| contact_name | character varying(255) | NULL | | |
| email | character varying(255) | NULL | | |
| phone | character varying(50) | NULL | | |
| relationship | character varying(100) | NULL | | |
| is_primary | boolean | NULL | false | |
| created_at | timestamp with time zone | NULL | now() | |
| updated_at | timestamp with time zone | NULL | now() | |

### 5. progress_tracking
**Purpose:** Student activity completion tracking

| Column | Type | Nullable | Default | Key Info |
|--------|------|----------|---------|----------|
| id | uuid | NOT NULL | uuid_generate_v4() | PK |
| student_id | uuid | NULL | | FK → students.id |
| activity_id | uuid | NULL | | FK → activities.id |
| course_id | uuid | NULL | | FK → courses.id |
| completed | boolean | NULL | false | |
| completion_date | timestamp with time zone | NULL | | |
| needs_help | boolean | NULL | false | |
| help_requested_date | timestamp with time zone | NULL | | |
| help_resolved_date | timestamp with time zone | NULL | | |
| notes | text | NULL | | |
| created_at | timestamp with time zone | NULL | now() | |
| updated_at | timestamp with time zone | NULL | now() | |

### 6. schedule
**Purpose:** Daily assignment scheduling

| Column | Type | Nullable | Default | Key Info |
|--------|------|----------|---------|----------|
| id | uuid | NOT NULL | uuid_generate_v4() | PK |
| student_id | uuid | NULL | | FK → students.id |
| activity_id | uuid | NULL | | FK → activities.id |
| course_id | uuid | NULL | | FK → courses.id |
| scheduled_date | date | NOT NULL | | |
| is_exam_day | boolean | NULL | false | |
| is_review_day | boolean | NULL | false | |
| order_in_day | integer(32,0) | NULL | 1 | |
| manually_assigned | boolean | NULL | false | |
| created_at | timestamp with time zone | NULL | now() | |
| updated_at | timestamp with time zone | NULL | now() | |

### 7. settings
**Purpose:** Application configuration

| Column | Type | Nullable | Default | Key Info |
|--------|------|----------|---------|----------|
| id | uuid | NOT NULL | uuid_generate_v4() | PK |
| setting_name | character varying(100) | NOT NULL | | |
| setting_value | jsonb | NULL | | |
| description | text | NULL | | |
| created_at | timestamp with time zone | NULL | now() | |
| updated_at | timestamp with time zone | NULL | now() | |

### 8. students
**Purpose:** Student profile information

| Column | Type | Nullable | Default | Key Info |
|--------|------|----------|---------|----------|
| id | uuid | NOT NULL | | PK, FK → auth.users.id |
| display_name | character varying(255) | NULL | | |
| grade_level | character varying(50) | NULL | | |
| parent_email | character varying(255) | NULL | | |
| timezone | character varying(50) | NULL | 'America/Chicago'::character varying | |
| school_days | ARRAY | NULL | '{sunday,monday,thursday,friday,saturday}'::text[] | |
| created_at | timestamp with time zone | NULL | now() | |
| updated_at | timestamp with time zone | NULL | now() | |
| student_email | character varying(255) | NULL | | |

### 9. units
**Purpose:** Course units/chapters

| Column | Type | Nullable | Default | Key Info |
|--------|------|----------|---------|----------|
| id | uuid | NOT NULL | uuid_generate_v4() | PK |
| course_id | uuid | NULL | | FK → courses.id |
| unit_number | integer(32,0) | NOT NULL | | |
| title | character varying(255) | NOT NULL | | |
| description | text | NULL | | |
| total_activities | integer(32,0) | NULL | 0 | |
| has_unit_test | boolean | NULL | false | |
| order_index | integer(32,0) | NOT NULL | | |
| created_at | timestamp with time zone | NULL | now() | |
| updated_at | timestamp with time zone | NULL | now() | |

### 10. vacation_periods
**Purpose:** Vacation and holiday periods for schedule exclusion

| Column | Type | Nullable | Default | Key Info |
|--------|------|----------|---------|----------|
| id | uuid | NOT NULL | uuid_generate_v4() | PK |
| student_id | uuid | NULL | | FK → students.id |
| name | character varying(255) | NOT NULL | | |
| start_date | date | NOT NULL | | |
| end_date | date | NOT NULL | | |
| description | text | NULL | | |
| created_at | timestamp with time zone | NULL | now() | |
| updated_at | timestamp with time zone | NULL | now() | |

## Custom Types (ENUMs)

The database uses custom enumeration types:

- **activity_type** - Defines types of learning activities
- **course_status** - Tracks course completion status
- **help_status** - Manages help request states

## Data Status Summary

### Active Tables (containing data):
- **courses**: 4 courses loaded
- **activities**: 114 activities loaded
- **units**: 7 units loaded
- **progress_tracking**: 1 progress record

### Empty Tables (no data):
- **students**: No student profiles created
- **schedule**: No scheduled assignments
- **settings**: No application settings configured
- **help_requests**: No help requests logged
- **parent_contacts**: No parent contacts added
- **vacation_periods**: No vacation periods defined

## Notes

1. **Foreign Key Relationships**: All FK relationships are properly defined between tables
2. **UUID Primary Keys**: All tables use UUID primary keys with auto-generation
3. **Timestamp Tracking**: All tables include created_at and updated_at timestamps
4. **Default Values**: Appropriate defaults are set for boolean and date fields
5. **Nullable Fields**: Most foreign key fields are nullable, allowing flexible data entry

---

*This documentation reflects the actual current state of the database as of October 10, 2025. It serves as the definitive reference for the live system structure.*

## Table Structures

### 1. activities
**Purpose:** Individual learning activities, videos, exercises, and quizzes
**Rows:** ~114 records

| Column | Type | Nullable | Default | Key Info |
|--------|------|----------|---------|----------|
| id | uuid | NOT NULL | uuid_generate_v4() | PK |
| course_id | uuid | NULL | | FK → courses.id |
| unit_id | uuid | NULL | | FK → units.id |
| activity_name | character varying(255) | NOT NULL | | |
| activity_type | USER-DEFINED | NOT NULL | | |
| is_exam | boolean | NULL | false | |
| khan_academy_url | character varying(500) | NULL | | |
| order_index | integer(32,0) | NOT NULL | | |
| lesson_name | character varying(255) | NULL | | |
| created_at | timestamp with time zone | NULL | now() | |
| updated_at | timestamp with time zone | NULL | now() | |

### 2. courses
**Purpose:** Khan Academy courses being tracked
**Rows:** ~4 records

| Column | Type | Nullable | Default | Key Info |
|--------|------|----------|---------|----------|
| id | uuid | NOT NULL | uuid_generate_v4() | PK |
| name | character varying(255) | NOT NULL | | |
| description | text | NULL | | |
| khan_academy_url | character varying(500) | NULL | | |
| total_activities | integer(32,0) | NULL | 0 | |
| total_units | integer(32,0) | NULL | 0 | |
| target_completion_date | date | NULL | | |
| start_date | date | NULL | CURRENT_DATE | |
| status | USER-DEFINED | NULL | 'not_started'::course_status | |
| estimated_hours | integer(32,0) | NULL | | |
| created_at | timestamp with time zone | NULL | now() | |
| updated_at | timestamp with time zone | NULL | now() | |

### 3. help_requests
**Purpose:** Student help request and resolution tracking
**Rows:** ~0 records (empty)

| Column | Type | Nullable | Default | Key Info |
|--------|------|----------|---------|----------|
| id | uuid | NOT NULL | uuid_generate_v4() | PK |
| student_id | uuid | NULL | | FK → students.id |
| activity_id | uuid | NULL | | FK → activities.id |
| course_id | uuid | NULL | | FK → courses.id |
| status | USER-DEFINED | NULL | 'open'::help_status | |
| request_message | text | NULL | | |
| resolution_notes | text | NULL | | |
| requested_date | timestamp with time zone | NULL | now() | |
| resolved_date | timestamp with time zone | NULL | | |
| resolved_by | character varying(255) | NULL | | |
| created_at | timestamp with time zone | NULL | now() | |
| updated_at | timestamp with time zone | NULL | now() | |

### 4. progress_tracking
**Purpose:** Student activity completion tracking
**Rows:** ~1 record

| Column | Type | Nullable | Default | Key Info |
|--------|------|----------|---------|----------|
| id | uuid | NOT NULL | uuid_generate_v4() | PK |
| student_id | uuid | NULL | | FK → students.id |
| activity_id | uuid | NULL | | FK → activities.id |
| course_id | uuid | NULL | | FK → courses.id |
| completed | boolean | NULL | false | |
| completion_date | timestamp with time zone | NULL | | |
| needs_help | boolean | NULL | false | |
| help_requested_date | timestamp with time zone | NULL | | |
| help_resolved_date | timestamp with time zone | NULL | | |
| notes | text | NULL | | |
| created_at | timestamp with time zone | NULL | now() | |
| updated_at | timestamp with time zone | NULL | now() | |

### 5. schedule
**Purpose:** Daily assignment scheduling
**Rows:** ~0 records (empty)

| Column | Type | Nullable | Default | Key Info |
|--------|------|----------|---------|----------|
| id | uuid | NOT NULL | uuid_generate_v4() | PK |
| student_id | uuid | NULL | | FK → students.id |
| activity_id | uuid | NULL | | FK → activities.id |
| course_id | uuid | NULL | | FK → courses.id |
| scheduled_date | date | NOT NULL | | |
| is_exam_day | boolean | NULL | false | |
| is_review_day | boolean | NULL | false | |
| order_in_day | integer(32,0) | NULL | 1 | |
| created_at | timestamp with time zone | NULL | now() | |
| updated_at | timestamp with time zone | NULL | now() | |

### 6. settings
**Purpose:** Application configuration and settings
**Rows:** ~0 records (empty)

| Column | Type | Nullable | Default | Key Info |
|--------|------|----------|---------|----------|
| id | uuid | NOT NULL | uuid_generate_v4() | PK |
| setting_name | character varying(100) | NOT NULL | | |
| setting_value | jsonb | NULL | | |
| description | text | NULL | | |
| created_at | timestamp with time zone | NULL | now() | |
| updated_at | timestamp with time zone | NULL | now() | |

### 7. students
**Purpose:** Student profile and preference information
**Rows:** ~0 records (empty)
**⚠️ AUTHENTICATION REQUIRED:** This table has a foreign key constraint to `auth.users.id`. Students cannot be created without first creating aa
n authenticated user via Supabase Auth.                                                                                                        
| Column | Type | Nullable | Default | Key Info |
|--------|------|----------|---------|----------|
| id | uuid | NOT NULL | | PK, FK → auth.users.id |
| display_name | character varying(255) | NULL | | |
| grade_level | character varying(50) | NULL | | |
| parent_email | character varying(255) | NULL | | |
| timezone | character varying(50) | NULL | 'America/Chicago'::character varying |
| school_days | ARRAY | NULL | '{sunday,monday,thursday,friday,saturday}'::text[] |
| created_at | timestamp with time zone | NULL | now() | |
| updated_at | timestamp with time zone | NULL | now() | |
| student_email | character varying(255) | NULL | | |

**Constraints:**
- `students_id_fkey`: Foreign key constraint requiring `students.id` to exist in `auth.users.id`
- `students_pkey`: Primary key on `id` column

**Development Notes:**
- Use `StudentAccountCreator` component to create properly authenticated students
- Cannot insert students directly without corresponding auth user

### 8. units
**Purpose:** Course units and chapters
**Rows:** ~7 records

| Column | Type | Nullable | Default | Key Info |
|--------|------|----------|---------|----------|
| id | uuid | NOT NULL | uuid_generate_v4() | PK |
| course_id | uuid | NULL | | FK → courses.id |
| unit_number | integer(32,0) | NOT NULL | | |
| title | character varying(255) | NOT NULL | | |
| description | text | NULL | | |
| total_activities | integer(32,0) | NULL | 0 | |
| has_unit_test | boolean | NULL | false | |
| order_index | integer(32,0) | NOT NULL | | |
| created_at | timestamp with time zone | NULL | now() | |
| updated_at | timestamp with time zone | NULL | now() | |

## Custom Types (ENUMs)

The database uses custom enumeration types:

- **activity_type** - Defines types of learning activities
- **course_status** - Tracks course completion status
- **help_status** - Manages help request states

## Data Status Summary

### Active Tables (containing data):
- **courses**: 4 courses loaded
- **activities**: 114 activities loaded
- **units**: 7 units loaded
- **progress_tracking**: 1 progress record

### Empty Tables (no data):
- **students**: No student profiles created
- **schedule**: No scheduled assignments
- **settings**: No application settings configured
- **help_requests**: No help requests logged

## Notes

1. **Foreign Key Relationships**: All FK relationships are properly defined between tables
2. **UUID Primary Keys**: All tables use UUID primary keys with auto-generation
3. **Timestamp Tracking**: All tables include created_at and updated_at timestamps
4. **Default Values**: Appropriate defaults are set for boolean and date fields
5. **Nullable Fields**: Most foreign key fields are nullable, allowing flexible data entry

---

*This documentation reflects the actual current state of the database as of October 2, 2025. It serves as the definitive reference for the live
 system structure.*