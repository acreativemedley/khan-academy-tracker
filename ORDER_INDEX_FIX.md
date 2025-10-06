# Order Index Sequencing Fix

## Problem

When units were uploaded separately to the database, each unit's activities started with `order_index = 1`. This caused:
- Duplicate `order_index` values across different units in the same course
- Incorrect activity sequencing in schedule calculation
- Exams not being scheduled properly (because the algorithm couldn't find the right position)

**Example of the problem:**
```
Unit 1: activities with order_index 1-50
Unit 2: activities with order_index 1-60  ❌ DUPLICATES!
Unit 3: activities with order_index 1-45  ❌ DUPLICATES!
```

## Solution

### 1. Database Migration to Resequence Activities

Run the SQL migration in `migrations/fix-order-index-sequencing.sql` to:
- Create a resequencing function
- Apply it to ALL courses
- Make `order_index` sequential across the entire course (not per unit)

**After migration:**
```
Unit 1: activities with order_index 1-50
Unit 2: activities with order_index 51-110  ✅ Sequential!
Unit 3: activities with order_index 111-155 ✅ Sequential!
```

### 2. Code Fix for Ordering

Updated `scheduleService.js` to order by `unit_id` THEN `order_index`:

```javascript
.order('unit_id', { ascending: true })
.order('order_index', { ascending: true })
```

This ensures:
- Even if `order_index` values have duplicates or gaps, units are processed in order
- Activities within each unit are ordered correctly
- Schedule flows Unit 1 → Unit 2 → Unit 3 as intended

## How to Apply the Fix

1. **Open Supabase Dashboard** → SQL Editor
2. **Paste the migration** from `migrations/fix-order-index-sequencing.sql`
3. **Run the query**
4. **Verify** - The query will show results like:
   ```
   course_name              | total_activities | min_index | max_index | unique_indexes
   ------------------------ | ---------------- | --------- | --------- | --------------
   High School Chemistry    | 208              | 1         | 208       | 208
   World History Unit 3-6   | 150              | 1         | 150       | 150
   ```
   - `unique_indexes` should equal `total_activities` (no duplicates)
   - `max_index` should equal `total_activities` (sequential from 1)

5. **Recalculate schedules** for affected courses using the UI

## Affected Courses

Courses that had units uploaded separately:
- World History (Units 3-6)
- Any other multi-unit courses uploaded unit-by-unit

## Prevention

The code fix in `scheduleService.js` adds a layer of protection:
- Always orders by `unit_id` first
- Even if future data has `order_index` issues, units will still be processed sequentially

## Testing

After applying the fix:
1. Navigate to Target Dates settings
2. Recalculate schedule for World History
3. Verify:
   - All unit exams are scheduled
   - Activities appear in correct unit order
   - No "X exams could not be scheduled" warnings (or reduced count)

## Files Modified

- `src/services/scheduleService.js` - Added `unit_id` to ordering
- `migrations/fix-order-index-sequencing.sql` - Database migration to fix existing data
