# Scheduling Algorithm Specification

**Date:** October 5, 2025  
**Version:** 1.0  
**Status:** Final Specification  
**Based On:** PHASE3_DESIGN_QUESTIONS.md User Responses

---

## Executive Summary

This document specifies the scheduling algorithm for the Khan Academy Multi-Course Academic Planner. The system will calculate and assign due dates for all course activities based on target completion dates, school days, vacation periods, and exam scheduling requirements.

**Key Principles:**
- **NO TIME TRACKING** - The system tracks activity completion only, not time spent
- **Bulk Assignment with Manual Recalculation** - All dates assigned upfront, recalculated on demand
- **Independent Course Scheduling** - Each course scheduled separately
- **Flexible Manual Overrides** - Individual activity dates can be manually changed
- **Vacation-Aware** - Excludes vacation days and holidays from scheduling

---

## 1. Core Algorithm Design

### 1.1 High-Level Flow

```
1. Get Course Configuration
   - Target completion date
   - Start date (individual per course)
   - Total activities count
   
2. Calculate Available School Days
   - From start date to target date
   - Exclude: Tuesdays, Wednesdays (configurable)
   - Exclude: Vacation periods
   - Exclude: Holidays
   
3. Identify Exam Activities
   - Find all activities where is_exam = true
   - Reserve dedicated days for exams
   
4. Calculate Daily Activity Distribution
   - Activities per day = (Total activities - Exams) / (Available days - Exam days)
   - Handle fractional activities (e.g., 1.25 activities/day)
   
5. Assign Due Dates
   - Distribute activities across available school days
   - Spread extra activities evenly
   - Place exams after their unit's activities
   - Store assignments in schedule table
   
6. Allow Manual Overrides
   - Individual activity dates can be changed
   - Manual changes are temporary (reset on recalculation)
```

### 1.2 Fractional Activity Distribution

**Problem:** When activities/day calculation results in a fraction (e.g., 1.25 activities/day)

**Solution:** Distribute evenly throughout the schedule

**Algorithm:**
```javascript
totalActivities = 100
availableDays = 80
activitiesPerDay = 100 / 80 = 1.25

baseActivities = Math.floor(1.25) = 1
extraActivities = 100 - (80 * 1) = 20

// Distribute 20 extra activities across 80 days
interval = Math.floor(80 / 20) = 4

// Every 4th day gets an extra activity
Day 1: 1 activity
Day 2: 1 activity
Day 3: 1 activity
Day 4: 2 activities (1 + 1 extra)
Day 5: 1 activity
...
Day 8: 2 activities
```

**Implementation:**
- Calculate base activities per day (floor)
- Calculate total extra activities needed
- Distribute extras evenly using interval calculation
- Ensure all activities are assigned

---

## 2. School Days & Calendar Logic

### 2.1 School Days Configuration

**Default School Days:**
- Sunday
- Monday
- Thursday
- Friday
- Saturday

**Non-School Days:**
- Tuesday
- Wednesday

**Configuration:**
- Stored per student in `students.school_days` array
- User can modify via settings interface
- Configurable exceptions supported

### 2.2 Date Calculation Helper Functions

**Required Functions:**

```javascript
// Check if date is a school day
isSchoolDay(date, schoolDaysArray)

// Check if date is a vacation/holiday
isVacationDay(date, vacationPeriods)

// Get next available school day
getNextSchoolDay(date, schoolDaysArray, vacationPeriods)

// Count school days between two dates
countSchoolDays(startDate, endDate, schoolDaysArray, vacationPeriods)

// Get array of all school days in range
getSchoolDaysInRange(startDate, endDate, schoolDaysArray, vacationPeriods)
```

---

## 3. Vacation & Holiday Management

### 3.1 Vacation Storage

**Database Table:** `vacation_periods` (NEW)

```sql
CREATE TABLE vacation_periods (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id UUID REFERENCES students(id),
  name VARCHAR(255) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### 3.2 Vacation Types

**Supported Input:**
- Individual dates: Single day vacation
- Date ranges: Multiple consecutive days

**Examples:**
```javascript
{
  name: "Thanksgiving Break 2025",
  start_date: "2025-11-25",  // Tuesday before Thanksgiving
  end_date: "2025-11-30"      // Sunday after Thanksgiving
}

{
  name: "Christmas Break 2025-2026",
  start_date: "2025-12-23",
  end_date: "2026-01-02"
}
```

### 3.3 Vacation Impact Options

**When vacation is added, user chooses:**

**Option A: Push Back Assignments**
- All future assignments shift by vacation days
- Target completion date extends
- Activities per day remains same

**Option B: Maintain Target Date**
- Increase activities per day for remaining days
- Target completion date stays same
- Recalculate distribution

**Implementation:**
- Present choice to user when adding vacation
- Apply selected strategy during recalculation

### 3.4 Holiday Calculation

**Thanksgiving:**
- Calculate 4th Thursday in November
- Break = Tuesday before through Sunday after
- Formula: `getNthWeekdayOfMonth(November, Thursday, 4)`

**Pre-configured Holidays:**
- Configurable per school year in vacation_periods table
- Can be generated automatically or manually created

---

## 4. Exam Scheduling

### 4.1 Exam Identification

**Criteria:**
- Activity record has `is_exam = true`
- Typically one per unit (unit tests)

### 4.2 Exam Day Rules

**Single Course Rule:**
- When exam is scheduled, it is the ONLY activity for that course on that day
- Other courses CAN have regular activities on the same day

**Scheduling Logic:**
```javascript
1. Sort activities by order_index
2. Identify exam activities
3. For each exam:
   - Find all activities in same unit before the exam
   - Calculate last day those activities are due
   - Schedule exam on next available school day after unit activities
4. Ensure exam has dedicated day (no other activities from same course)
```

### 4.3 Exam Override

**Auto-Assignment:**
- System automatically assigns exam days based on unit completion

**Manual Override:**
- User can manually change exam date
- System maintains "exam day only" rule for that course
- Manual changes are temporary (reset on recalculation unless flagged)

---

## 5. Schedule Assignment Algorithm

### 5.1 Main Scheduling Function

**Inputs:**
- `course_id`: UUID of course
- `student_id`: UUID of student
- `force_recalculate`: Boolean (default false)

**Process:**

```javascript
async function calculateSchedule(courseId, studentId, forceRecalculate = false) {
  
  // 1. Get course data
  const course = await getCourse(courseId);
  const activities = await getActivities(courseId); // sorted by order_index
  const student = await getStudent(studentId);
  const vacations = await getVacationPeriods(studentId);
  
  // 2. Calculate date range
  const startDate = course.start_date || new Date();
  const targetDate = new Date(course.target_completion_date);
  
  // 3. Get available school days
  const availableDays = getSchoolDaysInRange(
    startDate,
    targetDate,
    student.school_days,
    vacations
  );
  
  // 4. Separate exams from regular activities
  const exams = activities.filter(a => a.is_exam);
  const regularActivities = activities.filter(a => !a.is_exam);
  
  // 5. Calculate daily distribution
  const examDaysNeeded = exams.length;
  const effectiveDays = availableDays.length - examDaysNeeded;
  const activitiesPerDay = regularActivities.length / effectiveDays;
  const baseActivities = Math.floor(activitiesPerDay);
  const extraActivities = regularActivities.length - (effectiveDays * baseActivities);
  
  // 6. Distribute activities
  const assignments = [];
  let activityIndex = 0;
  let extraAssigned = 0;
  const extraInterval = Math.floor(effectiveDays / extraActivities);
  
  for (let dayIndex = 0; dayIndex < availableDays.length; dayIndex++) {
    const currentDate = availableDays[dayIndex];
    let activitiesForDay = baseActivities;
    
    // Add extra activity if needed
    if (extraActivities > 0 && dayIndex % extraInterval === 0 && extraAssigned < extraActivities) {
      activitiesForDay++;
      extraAssigned++;
    }
    
    // Assign activities for this day
    for (let i = 0; i < activitiesForDay && activityIndex < regularActivities.length; i++) {
      assignments.push({
        activity_id: regularActivities[activityIndex].id,
        scheduled_date: currentDate,
        is_exam_day: false
      });
      activityIndex++;
    }
    
    // Check if an exam should be scheduled after this batch
    const exam = shouldScheduleExam(regularActivities, activityIndex, exams);
    if (exam) {
      dayIndex++; // Use next day for exam
      if (dayIndex < availableDays.length) {
        assignments.push({
          activity_id: exam.id,
          scheduled_date: availableDays[dayIndex],
          is_exam_day: true
        });
      }
    }
  }
  
  // 7. Save to database
  await saveSchedule(courseId, studentId, assignments, forceRecalculate);
  
  return assignments;
}
```

### 5.2 Schedule Storage

**Table:** `schedule`

**Record Structure:**
```javascript
{
  id: UUID,
  student_id: UUID,
  activity_id: UUID,
  course_id: UUID,
  scheduled_date: DATE,
  is_exam_day: BOOLEAN,
  is_review_day: BOOLEAN (for future use),
  order_in_day: INTEGER,
  manually_assigned: BOOLEAN (new field),
  created_at: TIMESTAMP,
  updated_at: TIMESTAMP
}
```

**New Field:**
- `manually_assigned`: Tracks if date was manually changed by user

---

## 6. Manual Override System

### 6.1 Individual Activity Date Change

**User Action:**
- Click on activity in CourseDetail view
- Change due date to different date
- Save change

**Backend Logic:**
```javascript
async function overrideActivityDate(activityId, newDate, studentId) {
  // Update schedule record
  await supabase
    .from('schedule')
    .update({
      scheduled_date: newDate,
      manually_assigned: true,
      updated_at: new Date()
    })
    .match({
      activity_id: activityId,
      student_id: studentId
    });
}
```

### 6.2 Recalculation Behavior

**Manual Override Treatment:**
- Overrides are NOT preserved on recalculation
- `manually_assigned` flag is reset to false
- User is warned before recalculation: "X activities have manual dates that will be reset"

**Recalculation Trigger:**
- User clicks "Recalculate Schedule" button
- Target date changes (optional auto-recalculate with confirmation)
- Vacation days added/removed (optional auto-recalculate with confirmation)

---

## 7. Start Date Handling

### 7.1 Individual Course Start Dates

**Configuration:**
- Each course has its own `start_date` field
- Can be different for each course
- Defaults to current date if not set

**Use Cases:**
```javascript
// Course 1: Started in September
course1.start_date = "2025-09-01"

// Course 2: Starting today
course2.start_date = "2025-10-05"

// Course 3: Will start in November
course3.start_date = "2025-11-01"
```

### 7.2 Past Date Assignment

**Behavior:**
- System allows assigning activities to past dates
- Useful for mid-year setup
- Shows warning when past dates are assigned

**Warning Logic:**
```javascript
if (scheduledDate < new Date()) {
  showWarning(
    `Warning: ${pastDateCount} activities are scheduled for past dates. 
    These will show as overdue until marked complete.`
  );
}
```

---

## 8. Progress Tracking Integration

### 8.1 Completion Status

**Tables:**
- `schedule`: What's due and when
- `progress_tracking`: What's been completed

**Relationship:**
```javascript
// An activity is:
// - Scheduled (has due date in schedule table)
// - Not Started (no record in progress_tracking, or completed = false)
// - In Progress (in progress_tracking, completed = false, notes exist)
// - Completed (in progress_tracking, completed = true, completion_date set)
```

### 8.2 Overdue Detection

**Logic:**
```javascript
function isOverdue(scheduledDate, completed) {
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  
  const dueDate = new Date(scheduledDate);
  dueDate.setHours(0, 0, 0, 0);
  
  return !completed && dueDate < today;
}
```

### 8.3 Schedule Adherence

**Metrics:**
- On track: Completed activities match or exceed scheduled completion
- Ahead: Completed more than scheduled
- Behind: Completed less than scheduled

**Calculation:**
```javascript
function getScheduleAdherence(courseId, studentId) {
  const today = new Date();
  
  // Count activities scheduled through today
  const scheduledCount = countScheduledActivities(courseId, studentId, today);
  
  // Count activities completed
  const completedCount = countCompletedActivities(courseId, studentId);
  
  if (completedCount >= scheduledCount) {
    return { status: 'on-track' or 'ahead', difference: completedCount - scheduledCount };
  } else {
    return { status: 'behind', difference: scheduledCount - completedCount };
  }
}
```

---

## 9. Database Schema Updates

### 9.1 New Table: vacation_periods

```sql
CREATE TABLE vacation_periods (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id UUID REFERENCES students(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_vacation_periods_student ON vacation_periods(student_id);
CREATE INDEX idx_vacation_periods_dates ON vacation_periods(start_date, end_date);
```

### 9.2 Modified Table: schedule

**Add new column:**
```sql
ALTER TABLE schedule 
ADD COLUMN manually_assigned BOOLEAN DEFAULT FALSE;
```

### 9.3 Modified Table: students

**Update school_days to be configurable:**
```sql
-- Already exists as TEXT[] type
-- Default: '{sunday,monday,thursday,friday,saturday}'
-- Can be updated via UI
```

---

## 10. API Functions

### 10.1 Schedule Calculation

```javascript
// Calculate schedule for a course
POST /api/schedule/calculate
Body: {
  course_id: UUID,
  student_id: UUID,
  force_recalculate: BOOLEAN
}
Response: {
  success: BOOLEAN,
  assignments_created: INTEGER,
  start_date: DATE,
  end_date: DATE,
  warnings: []
}
```

### 10.2 Vacation Management

```javascript
// Add vacation period
POST /api/vacations
Body: {
  student_id: UUID,
  name: STRING,
  start_date: DATE,
  end_date: DATE,
  impact_strategy: 'push_back' | 'maintain_target'
}

// Get all vacations
GET /api/vacations/:student_id

// Delete vacation
DELETE /api/vacations/:vacation_id
```

### 10.3 Manual Overrides

```javascript
// Override activity date
PUT /api/schedule/override
Body: {
  activity_id: UUID,
  student_id: UUID,
  new_date: DATE
}
```

---

## 11. User Interface Requirements

### 11.1 TargetDateSettings Component

**Enhancements:**
- Add "Calculate Schedule" button per course
- Show warnings if past dates will be assigned
- Display calculation results (X activities scheduled over Y days)

### 11.2 Vacation Management UI

**New Component:** `VacationManager`

**Features:**
- List all vacation periods
- Add new vacation (date range picker)
- Delete vacation
- Choose impact strategy when adding
- Auto-calculate Thanksgiving based on year

### 11.3 CourseDetail Component

**Updates:**
- Display due date for each activity
- Show overdue status (red highlight)
- Allow clicking to change due date
- Show "manually assigned" indicator
- Filter by: All, Overdue, Upcoming, Completed

### 11.4 Daily Schedule View

**New Component:** `DailyScheduleView`

**Features:**
- Show today's activities by default
- Toggle between: Today | Week | Month
- Group by course
- Checkboxes to mark complete
- Visual indicators:
  1. Course name/color (most important)
  2. Unit/lesson context
  3. Activity type (video/exercise/exam)
  4. Due date
  5. Completion status
  6. Overdue indicator
  7. Link to Khan Academy
- Navigation: Previous/Next day buttons

### 11.5 Recalculation Confirmation

**Warning Dialog:**
```
Recalculate Schedule?

This will reset all schedules for [Course Name].

- 5 activities have manual date overrides that will be lost
- 12 activities are currently overdue
- New schedule will assign [X] activities across [Y] days

Continue?  [Cancel] [Recalculate]
```

---

## 12. Implementation Phases

### Phase 3A: Core Scheduling Engine
1. Create vacation_periods table
2. Add manually_assigned column to schedule
3. Implement date calculation helper functions
4. Build main schedule calculation algorithm
5. Create schedule calculation API endpoint

### Phase 3B: Vacation Management
1. Create VacationManager component
2. Add vacation CRUD operations
3. Integrate vacation exclusion into scheduling
4. Add Thanksgiving auto-calculation
5. Implement impact strategy selection

### Phase 3C: UI Integration
1. Add due dates to CourseDetail component
2. Implement manual date override functionality
3. Add recalculation button to TargetDateSettings
4. Show overdue indicators
5. Add schedule adherence metrics

### Phase 3D: Daily Schedule View
1. Create DailyScheduleView component
2. Implement view toggles (today/week/month)
3. Add activity grouping by course
4. Implement completion checkboxes
5. Add navigation controls

---

## 13. Testing Strategy

### 13.1 Unit Tests

**Date Calculations:**
- Test school day identification
- Test vacation day exclusion
- Test date range calculations
- Test Thanksgiving calculation

**Activity Distribution:**
- Test even distribution of extras
- Test exam day reservation
- Test various fractional scenarios

### 13.2 Integration Tests

**End-to-End Scheduling:**
- Create course with 100 activities
- Set target date 90 days out
- Add vacation period
- Calculate schedule
- Verify all activities assigned
- Verify no assignments on vacation days
- Verify exam days have only exams

### 13.3 Edge Cases

- Course with 0 activities
- Target date in past
- Target date = start date
- All days are vacation days
- Single activity course
- Course with only exams

---

## 14. Success Criteria

**Phase 3 is complete when:**

✅ All activities have due dates assigned  
✅ Vacation days are excluded from scheduling  
✅ Exam activities are scheduled as sole course activity  
✅ Extra activities distributed evenly  
✅ Manual date overrides work correctly  
✅ Recalculation preserves incomplete activities  
✅ CourseDetail shows due dates  
✅ Daily Schedule View displays today's tasks  
✅ Overdue activities are highlighted  
✅ No time tracking features exist anywhere  

---

**Document Version:** 1.0  
**Last Updated:** October 5, 2025  
**Approved By:** User  
**Ready for Implementation:** ✅ YES
