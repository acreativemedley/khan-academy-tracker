# Test Student Creation Instructions

**Date:** October 5, 2025  
**Task:** Create Test Student with Authentication  
**Method:** Using StudentAccountCreator UI Component

---

## Test Student Details

Use the following information when filling out the StudentAccountCreator form:

### Required Information

**Student Email:** `mommy.mack@gmail.com`  
**Password:** `TestPass123!`  
**Confirm Password:** `TestPass123!`  
**Display Name:** `Test Student`  
**Parent Email:** `feltiefun@gmail.com`  
**Timezone:** `America/Chicago` (should be default)

---

## Steps to Create Test Student

### 1. Start the Development Server

Open PowerShell in the project root and run:

```powershell
cd frontend
npm run dev
```

Wait for the server to start (usually on http://localhost:5173)

### 2. Navigate to StudentAccountCreator

The component should be accessible via the application navigation or directly at the appropriate route.

### 3. Fill Out the Form

Enter the information exactly as specified above:
- ✅ Student Email: `mommy.mack@gmail.com`
- ✅ Password: `TestPass123!`
- ✅ Confirm Password: `TestPass123!`
- ✅ Display Name: `Test Student`
- ✅ Parent Email: `feltiefun@gmail.com`
- ✅ Timezone: `America/Chicago`

### 4. Click "Create Student"

The system will:
1. Create an authenticated user in Supabase Auth with the email
2. Create a student record in the students table with the auth user ID
3. Set school_days to default: `['sunday', 'monday', 'thursday', 'friday', 'saturday']`

### 5. Verify Success

You should see:
- ✅ Success message: "User and student created successfully!"
- Student data displayed showing the created record

---

## What Happens Behind the Scenes

### Database Operations

**1. Supabase Auth User Creation:**
```javascript
supabase.auth.signUp({
  email: 'mommy.mack@gmail.com',
  password: 'TestPass123!',
  options: {
    data: {
      display_name: 'Test Student'
    }
  }
})
```

**2. Students Table Insert:**
```sql
INSERT INTO students (
  id,                    -- Auth user UUID (satisfies FK constraint)
  display_name,
  student_email,
  parent_email,
  timezone,
  school_days
) VALUES (
  '<auth_user_id>',
  'Test Student',
  'mommy.mack@gmail.com',
  'feltiefun@gmail.com',
  'America/Chicago',
  ARRAY['sunday', 'monday', 'thursday', 'friday', 'saturday']
);
```

### Foreign Key Relationship

The student record's `id` field MUST match an existing `auth.users.id` - this is why we use the StudentAccountCreator component instead of directly inserting into the students table.

---

## Verification Queries

After creation, you can verify in Supabase SQL Editor:

### Check Auth User
```sql
SELECT id, email, created_at
FROM auth.users
WHERE email = 'mommy.mack@gmail.com';
```

### Check Student Record
```sql
SELECT *
FROM students
WHERE student_email = 'mommy.mack@gmail.com';
```

### Verify Foreign Key Relationship
```sql
SELECT 
  s.id,
  s.display_name,
  s.student_email,
  s.parent_email,
  s.school_days,
  au.email as auth_email,
  au.created_at as auth_created_at
FROM students s
JOIN auth.users au ON s.id = au.id
WHERE s.student_email = 'mommy.mack@gmail.com';
```

---

## Troubleshooting

### Error: "Email already in use"
If you see this error, the email is already registered in Supabase Auth.

**Solution:**
1. Go to Supabase Dashboard → Authentication → Users
2. Find and delete the user with email `mommy.mack@gmail.com`
3. Also delete from students table if record exists
4. Try creating again

### Error: "Error creating student"
This usually means the student table insert failed.

**Check:**
1. Is there an existing student with this ID?
2. Are RLS policies blocking the insert?
3. Check the browser console for detailed error message

### Error: "No user returned from authentication"
Auth signup failed or email confirmation is required.

**Check:**
1. Email is valid format
2. Password meets requirements (8+ characters)
3. Supabase email confirmation is disabled for development

---

## Next Steps After Creation

Once the test student is created:

1. ✅ Note the student ID (UUID) for future use
2. ✅ Test student can now be used for progress tracking
3. ✅ Schedule assignments can be created with this student_id
4. ✅ Vacation periods can be added for this student
5. ✅ All foreign key constraints will be satisfied

---

## Alternative: Manual Creation via SQL (If UI Fails)

If the UI component has issues, you can create manually via Supabase SQL Editor:

```sql
-- IMPORTANT: You must create the auth user FIRST through Supabase Dashboard
-- Go to: Authentication → Users → Add User
-- Email: mommy.mack@gmail.com
-- Password: TestPass123!
-- After creating auth user, copy the user ID and use it below:

INSERT INTO students (
  id,                    -- Replace with actual auth user ID
  display_name,
  student_email,
  parent_email,
  timezone,
  school_days
) VALUES (
  'PASTE_AUTH_USER_ID_HERE',
  'Test Student',
  'mommy.mack@gmail.com',
  'feltiefun@gmail.com',
  'America/Chicago',
  ARRAY['sunday', 'monday', 'thursday', 'friday', 'saturday']
);
```

---

**Status:** Ready to execute  
**Blocking:** No other tasks until student is created  
**Estimated Time:** 2-3 minutes
