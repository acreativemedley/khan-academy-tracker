# TASK 1: Create Test Student - Quick Start

**Status:** Ready to Execute  
**Estimated Time:** 2-3 minutes

---

## Quick Instructions

1. **Start the development server** (if not already running):
   ```powershell
   npm run dev
   ```
   (Run from the `tracker` root directory)

2. **Open the application** in your browser:
   - URL should be displayed in terminal (typically `http://localhost:5173`)

3. **Navigate to "Test Student" page:**
   - Click the "Test Student" button in the top navigation bar
   - Or go directly to: `http://localhost:5173/test-student`

4. **Fill out the form with these exact values:**
   - **Student Email:** `mommy.mack@gmail.com`
   - **Password:** `TestPass123!`
   - **Confirm Password:** `TestPass123!`
   - **Display Name:** `Test Student`
   - **Parent Email:** `feltiefun@gmail.com`
   - **Timezone:** `America/Chicago` (default)

5. **Click "Create Student Account" button**

6. **Verify success:**
   - You should see: ✅ "User and student created successfully!"
   - Student details will be displayed

---

## What This Does

- ✅ Creates authenticated user in Supabase Auth
- ✅ Creates student profile in database
- ✅ Links student profile to auth user (satisfies FK constraint)
- ✅ Sets default school days: Sun, Mon, Thu, Fri, Sat
- ✅ Enables all future schedule and progress tracking features

---

## After Creation

Once complete, you can proceed with:
- Creating parent account (Task 2)
- Setting up vacation periods
- Calculating course schedules
- Tracking progress

The test student will have:
- **Student ID:** (UUID from auth.users)
- **Email:** mommy.mack@gmail.com
- **Name:** Test Student
- **Parent:** feltiefun@gmail.com
- **Timezone:** America/Chicago
- **School Days:** Sunday, Monday, Thursday, Friday, Saturday

---

**Ready to proceed!**
