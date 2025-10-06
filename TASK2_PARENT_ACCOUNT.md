# TASK 2: Create Parent Account - Instructions

**Status:** In Progress  
**Estimated Time:** 2-3 minutes

---

## Parent Account Details

Use the following information to create the parent account:

### Required Information

**Email:** `feltiefun@gmail.com`  
**Password:** `ParentPass123!` (or your preferred password)  
**Display Name:** `Parent Account`  
**Parent Email:** `feltiefun@gmail.com` (same as student email field)  
**Timezone:** `America/Chicago` (default)

---

## Steps to Create Parent Account

### Option 1: Use StudentAccountCreator UI (Simple)

1. **Navigate to Test Student page:**
   - Go to http://localhost:5174/test-student
   - Or click "Test Student" in navigation

2. **Fill out the form:**
   - **Student Email:** `feltiefun@gmail.com`
   - **Password:** `ParentPass123!`
   - **Confirm Password:** `ParentPass123!`
   - **Display Name:** `Parent Account`
   - **Parent Email:** `feltiefun@gmail.com`
   - **Timezone:** `America/Chicago`

3. **Click "Create Student Account"**

4. **Verify email** when you receive the confirmation

**Note:** This creates the parent as a "student" in the database, but we can modify the record or roles later to distinguish parent vs student accounts.

---

### Option 2: Use Supabase Dashboard (For Auth Only)

If you only need the parent to have authentication (not a student profile):

1. **Go to Supabase Dashboard**
   - Navigate to Authentication → Users
   - Click "Add User"

2. **Fill in details:**
   - Email: `feltiefun@gmail.com`
   - Password: `ParentPass123!` (or auto-generate)
   - Email Confirm: ✓ (checked)

3. **Save**

**Note:** This creates an auth user but NOT a student profile. Good for parent-only access.

---

## Recommended Approach

**Use Option 2 (Supabase Dashboard)** for the parent account because:
- ✅ Parent doesn't need a student profile
- ✅ Cleaner separation between student and parent
- ✅ Parent can still authenticate and access admin features
- ✅ Future role-based access control will distinguish by auth user metadata

---

## After Creation

### Update User Metadata (Optional) DONE

To mark this user as a "parent" role:

```sql
-- In Supabase SQL Editor
UPDATE auth.users
SET raw_user_meta_data = raw_user_meta_data || '{"role": "parent"}'::jsonb
WHERE email = 'feltiefun@gmail.com';
```

This allows future features to check:
```javascript
const { data: { user } } = await supabase.auth.getUser()
if (user.user_metadata.role === 'parent') {
  // Show parent/admin features
}
```

---

## Verification Confirmed

After creating the parent account:

### Check Auth User Exists
```sql
SELECT id, email, email_confirmed_at, created_at
FROM auth.users
WHERE email = 'feltiefun@gmail.com';
```

### Check User Metadata (if added)
```sql
SELECT email, raw_user_meta_data
FROM auth.users
WHERE email = 'feltiefun@gmail.com';
```

---

## Future Role-Based Access

### Parent Capabilities (To Be Implemented)
- ✅ View all student progress
- ✅ Modify course settings
- ✅ Set target dates
- ✅ Manage vacation periods
- ✅ Recalculate schedules
- ✅ Override due dates

### Student Capabilities (To Be Implemented)
- ✅ View assigned activities
- ✅ Mark activities complete
- ✅ See progress charts
- ✅ View daily schedule
- ❌ Cannot modify settings
- ❌ Cannot change target dates

---

## What This Enables

Once parent account is created:
- ✅ Two separate authenticated users (student + parent)
- ✅ Both can log in to the application
- ✅ Future AuthWrapper can check roles
- ✅ Parent can manage the student's schedule
- ✅ Student can track their own progress

---

**Recommended Action:** Create parent account via Supabase Dashboard (Option 2)

**Next Task After Completion:** Task 3 - Create vacation_periods Database Table
