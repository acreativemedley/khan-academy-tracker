# Month View Update - Course Grouping & Overdue Prioritization

## Overview

Updated the month view to match the week view organization, providing consistent course-focused grouping across all views.

## Changes Made

### 1. **Modified `groupedData()` Function** (Lines 258-289)

**Before:**
- Month view grouped activities by date
- Week and today views grouped by course
- Inconsistent user experience across views

**After:**
- **All views now group by course name** (today, week, and month)
- Activities within each course are automatically sorted with:
  1. **Overdue activities first** (uncompleted activities with dates before today)
  2. **Then sorted by date** (ascending - earlier dates first)

**Code Logic:**
```javascript
// Sort items within each course group: overdue first, then by date
grouped[courseName].sort((a, b) => {
  const aOverdue = !progress[a.activity_id]?.completed && isOverdue(a.scheduled_date);
  const bOverdue = !progress[b.activity_id]?.completed && isOverdue(b.scheduled_date);
  
  // Overdue items first
  if (aOverdue !== bOverdue) {
    return aOverdue ? -1 : 1;  // True (-1) comes before False (1)
  }
  
  // Then sort by date
  return a.scheduled_date.localeCompare(b.scheduled_date);
});
```

### 2. **Updated Card Header Display** (Line 387)

**Before:**
```javascript
{view === 'week' ? key : view === 'today' ? key : createLocalDate(key).toLocaleDateString(...)}
```

**After:**
```javascript
{key}  // Always displays the course name
```

Now the header consistently shows the course name for all views.

### 3. **Updated Due Date Chip Display** (Lines 419-427)

**Before:**
```javascript
{view === 'week' && (
  <Chip label={...due date...} />
)}
```

**After:**
```javascript
{(view === 'week' || view === 'month') && (
  <Chip 
    label={createLocalDate(item.scheduled_date).toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}
    size="small"
    variant="outlined"
    color={isOverdue(item.scheduled_date) ? "error" : "default"}
  />
)}
```

Month view now displays due date chips, just like week view.

### 4. **Course Name Chip Behavior** (Lines 428-434)

**Before:**
```javascript
{view !== 'today' && view !== 'week' && (
  <Chip label={item.course.name} />  // Showed course name in month view
)}
```

**After:**
```javascript
{view !== 'today' && view !== 'week' && (
  <Chip label={item.course.name} />  // Still visible in other contexts
)}
```

This condition now only applies when needed (essentially disabled since we're grouping by course).

## User Experience Impact

### Month View Now Shows:
✅ **Course headers** - all activities grouped by course name  
✅ **Overdue activities at top** - within each course group, overdue tasks appear first  
✅ **Due date chips** - each activity shows its due date  
✅ **Visual indicators** - red chips for overdue dates, standard outline for future dates  
✅ **Consistent organization** - matches week view structure  

### Example Layout:
```
📚 Integrated Math 3
  ⚠️ [OVERDUE] Quadratic Equations Review     Oct 10  (red chip)
  ⚠️ [OVERDUE] Chapter 5 Practice Problems   Oct 12  (red chip)
  □ Polynomial Division Practice              Oct 18
  □ Systems of Equations Project              Oct 25

📚 US History
  ⚠️ [OVERDUE] Civil War Essay                Oct 8   (red chip)
  □ Reconstruction Timeline                   Oct 20
```

## Timezone Safety

All date comparisons use:
- `isOverdue(scheduledDate)` - compares against local today string
- `createLocalDate()` - preserves user's local timezone
- No UTC conversions - dates remain in student's timezone

## Testing Checklist

After deployment, verify:
- [ ] Month view displays course names as headers
- [ ] Overdue activities appear at top of each course group
- [ ] Due date chips show correctly in month view
- [ ] Red chips appear for overdue dates
- [ ] Dates don't shift or change
- [ ] Scrolling through months works correctly
- [ ] Course sorting is consistent across views
- [ ] Completed activities don't count as overdue

## Deployment Steps

1. Run `npm run build` to rebuild the app
2. Run the deploy script:
   ```powershell
   .\deploy\deploy.ps1 -RemoteUser dh_k773dx -RemoteHost vps30327.dreamhostps.com -RemotePath /home/dh_k773dx/matthew.makealltheprojects.com -KeyPath $env:USERPROFILE\.ssh\id_ed25519
   ```
3. Wait 1-2 minutes
4. Refresh the app in your browser (Ctrl+F5 to clear cache)
5. Navigate to Month view to see the changes

## File Modified
- `src/components/DailyScheduleView.jsx` (3 major changes in `groupedData()` and rendering logic)
