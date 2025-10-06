# Debugging Target Date Settings Page

## Issue
Target Date Settings page only loads the navbar, not the main content.

## Debugging Steps

### Step 1: Check Browser Console
1. Open browser to http://localhost:5174
2. Press F12 to open DevTools
3. Click Console tab
4. Navigate to Settings/Target Dates page
5. Look for these console messages:
   - "TargetDateSettings rendering..."
   - "TargetDateSettings useEffect running..."
   - "Loading student ID..."
   - "Loading courses..."

### Step 2: Check for Errors
Look for any red error messages in console, particularly:
- Import errors (scheduleService, scheduleUtils)
- Database connection errors
- Authentication errors
- Rendering errors

### Step 3: Check Network Tab
1. Click Network tab in DevTools
2. Reload the page
3. Look for failed requests (red status codes)
4. Check if Supabase API calls are succeeding

### Step 4: Check React DevTools (if installed)
1. Look for TargetDateSettings component in component tree
2. Check its state values
3. See if it's actually mounted

## Possible Causes

### 1. Import Error
- scheduleService.js might have syntax error
- Path to scheduleService might be wrong
- Missing dependencies in scheduleUtils

### 2. Data Loading Error
- Student ID not loading (auth issue)
- Courses not loading (database/RLS issue)
- Component renders but data fetch fails

### 3. Rendering Error
- JSX syntax error
- Missing closing tags
- Conditional rendering hiding content

### 4. Route Issue
- Wrong route path
- Route not matching
- AuthWrapper blocking render

## Quick Fixes to Try

### Fix 1: Temporarily Simplify Component
Comment out schedule service imports to test if that's the issue.

### Fix 2: Check Authentication
Make sure you're logged in as test student (mommy.mack@gmail.com or mommymack@gmail.com).

### Fix 3: Check Database
Verify courses table has data:
```sql
SELECT * FROM courses;
```

### Fix 4: Hard Refresh
Clear browser cache and hard refresh (Ctrl+Shift+R).

## What I've Added

Added console.log statements to help debug:
- Component render
- useEffect execution  
- Student ID loading
- Course loading
- Error handling

Also added:
- Loading spinner when courses.length === 0
- Better error messages
- Null safety on data

## Next Steps

**Please provide the console output** and I can pinpoint the exact issue.
