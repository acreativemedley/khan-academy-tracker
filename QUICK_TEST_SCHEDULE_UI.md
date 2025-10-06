# Quick Test Guide: Schedule Calculation Feature

**Purpose:** Test the newly implemented schedule calculation UI  
**Estimated Time:** 10-15 minutes  
**Prerequisites:** Dev server running, logged in as test student

---

## Step-by-Step Test

### 1. Start Dev Server (if not running)

```powershell
cd C:\Users\felti\OneDrive\Documents\Coding\School2025\tracker
npm run dev
```

Server should start at: http://localhost:5174

### 2. Login as Test Student

- **Email:** mommy.mack@gmail.com
- **Password:** [the password you set during Task 1]

### 3. Navigate to Target Date Settings

- Click "Target Dates" in navigation menu
- OR go directly to: http://localhost:5174/target-dates

### 4. Verify Course Cards Display

You should see cards for:
- ✅ Math - Unit 1
- ✅ Reading
- ✅ History - Unit 1

Each card shows:
- Course name
- Total activities count
- Target date field
- Days remaining chip
- Activities/day estimate

### 5. Test Setting Target Date

**Pick any course** (recommend Math - Unit 1):

1. Click on the date field
2. Select a future date (e.g., May 30, 2026)
3. Click outside the field or press Tab
4. Verify:
   - ✅ Date saves automatically
   - ✅ "Calculate Schedule" button appears
   - ✅ Days remaining updates
   - ✅ Activities/day updates

### 6. Test Schedule Calculation

1. Click **"Calculate Schedule"** button
2. Verify confirmation dialog appears:
   - Title: "Recalculate Schedule?"
   - Warning about manual overrides
   - Cancel / Recalculate buttons

3. Click **"Recalculate Schedule"**
4. Verify:
   - ✅ Button shows "Calculating..." with spinner
   - ✅ Button is disabled during calculation

5. Wait for completion (should take 2-5 seconds)

### 7. Verify Success Alert

Success alert should display:

**Metrics to Check:**
- ✅ Total Activities: 104 (for Math Unit 1)
- ✅ Regular Activities: ~100
- ✅ Exam Activities: ~4
- ✅ School Days Available: [number based on date range]
- ✅ Daily Target: ~1-2 activities/day
- ✅ First Activity: [date close to today]
- ✅ Last Activity: [date close to target]

**Warnings (if target date is soon):**
- May show warnings about insufficient time
- May show warnings about past dates
- This is EXPECTED behavior if target date is tight

### 8. Verify Database Records

**Option A: Via Supabase Dashboard**

1. Go to: https://supabase.com
2. Open your project
3. Go to Table Editor
4. Select `schedule` table
5. Verify:
   - ✅ 104 new rows for Math Unit 1
   - ✅ Each has `scheduled_date` filled
   - ✅ Some have `is_exam_day = true`
   - ✅ All have `manually_assigned = false`
   - ✅ All have `order_in_day` values

**Option B: Via SQL Editor**

```sql
-- Count schedule records for the course
SELECT COUNT(*) 
FROM schedule 
WHERE course_id = (SELECT id FROM courses WHERE name = 'Math - Unit 1');

-- View sample records
SELECT 
  a.title,
  s.scheduled_date,
  s.is_exam_day,
  s.order_in_day
FROM schedule s
JOIN activities a ON s.activity_id = a.id
WHERE s.course_id = (SELECT id FROM courses WHERE name = 'Math - Unit 1')
ORDER BY s.scheduled_date, s.order_in_day
LIMIT 20;

-- Check for exam days
SELECT 
  scheduled_date,
  COUNT(*) as activities_count,
  BOOL_OR(is_exam_day) as has_exam
FROM schedule
WHERE course_id = (SELECT id FROM courses WHERE name = 'Math - Unit 1')
GROUP BY scheduled_date
ORDER BY scheduled_date;
```

### 9. Test "View Course Schedule" Button

1. Click **"View Course Schedule"** button in success alert
2. Verify:
   - ✅ Navigates to CourseDetail page
   - ✅ URL is `/course/[course-id]`
   - (Note: Schedule display will be added in Task 10)

### 10. Test Recalculation

1. Go back to Target Date Settings
2. Change the target date to a different date
3. Click "Calculate Schedule" again
4. Verify:
   - ✅ Confirmation dialog appears
   - ✅ Warning mentions losing manual overrides
5. Confirm recalculation
6. Verify:
   - ✅ New schedule calculated
   - ✅ Metrics updated to reflect new target date
   - ✅ Database records updated

### 11. Test Edge Cases

**Test 1: Past Target Date**
1. Set target date to yesterday
2. Calculate schedule
3. Expected: Warnings about past dates

**Test 2: Very Soon Target Date**
1. Set target date to next week
2. Calculate schedule
3. Expected: High activities/day, may warn about insufficient time

**Test 3: Multiple Courses**
1. Set target dates for all 3 courses
2. Calculate schedules for each
3. Verify each works independently

---

## Expected Behavior Summary

### ✅ Success Criteria

- [x] Button appears only when target date is set
- [x] Loading state shows during calculation
- [x] Confirmation dialog prevents accidental recalculation
- [x] Success alert shows all metrics
- [x] Warnings appear when appropriate
- [x] Database records created correctly
- [x] Navigation to course works
- [x] Multiple courses can be scheduled independently

### ❌ What Should NOT Happen

- ❌ No time estimates shown (we don't track time!)
- ❌ No errors in browser console
- ❌ No infinite loading states
- ❌ No duplicate schedule records
- ❌ No activities scheduled on vacation days (none set yet)
- ❌ No activities scheduled on non-school days (Tue/Wed)

---

## Troubleshooting

### Issue: Button doesn't appear
**Solution:** Make sure target date is set for that course

### Issue: "Student ID not loaded" error
**Solution:** Refresh the page, make sure you're logged in

### Issue: Calculation never finishes
**Solution:** 
1. Check browser console for errors
2. Check Supabase logs
3. Verify course has activities in database

### Issue: No warnings when setting past date
**Solution:** This is fine if date is far enough in future to fit all activities

### Issue: Database records not appearing
**Solution:**
1. Check RLS policies on `schedule` table
2. Verify student_id matches authenticated user
3. Check for database errors in console

---

## Browser Console Checks

Open DevTools (F12) and check Console tab:

**Expected logs:**
```
Calculating schedule for course [uuid] ([Course Name])
Schedule calculation result: { totalActivities: 104, ... }
```

**No errors should appear**

---

## What Happens Next?

After successful testing:

1. **Task 10:** CourseDetail will display these schedules
2. **Task 13:** DailyScheduleView will show today's activities
3. **Task 16:** More comprehensive testing with real data
4. **Task 8:** Add vacation periods (will exclude from schedules)

---

## Quick Visual Checklist

Before closing:
- [ ] Math Unit 1 scheduled (104 activities)
- [ ] Reading scheduled
- [ ] History Unit 1 scheduled
- [ ] All schedules show in database
- [ ] No console errors
- [ ] Success alerts displayed correctly
- [ ] Confirmation dialogs work
- [ ] Navigation works

---

**Time to Complete:** ~15 minutes  
**Difficulty:** Easy  
**Next Step:** Task 10 (Display schedules in CourseDetail)
