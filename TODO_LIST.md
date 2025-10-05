# Khan Academy Tracker - TODO List

**Created:** October 2, 2025  
**Status:** Active Development  
**Purpose:** Comprehensive task breakdown for completing the Khan Academy course tracking application

---

## Overview

This TODO list represents the remaining work to complete the Khan Academy Multi-Course Academic Planner based on the PROJECT_PLAN requirements and current implementation status. Tasks are organized by priority and dependencies.

**Total Tasks:** 20  
**Completed:** 1  
**In Progress:** 0  
**Not Started:** 19  

---

## Task Status Legend
- ✅ **COMPLETED** - Task finished and verified working
- 🔄 **IN PROGRESS** - Currently being worked on
- ⏸️ **BLOCKED** - Waiting on dependency or external input
- ❌ **NOT STARTED** - Not yet begun

---

## PHASE 1: Foundation & Data Setup

### Task 1: Create Test Student Profile ✅
**Priority:** HIGH - Immediate  
**Dependencies:** None  
**Description:** Create a test student record in the database to enable meaningful progress tracking and testing. This will allow development to proceed without full authentication while ensuring the data model works correctly for future real student implementation.

**Acceptance Criteria:**
- Test student record exists in students table
- Progress tracking can be linked to this student
- Checkbox functionality works with student association

**Status:** ✅ COMPLETED  
**Completed Date:** October 2, 2025  
**Notes:** Test student successfully created and progress tracking functionality is working. User can check off activities and progress is saved to database. Foreign key relationships verified and functional. 

---

### Task 2: Import Integrated Math 3 Units 2-13 ✅ COMPLETED  
**Priority:** HIGH - Immediate  
**Dependencies:** Task 1 (Test Student)  
**Description:** Complete the import of remaining Integrated Math 3 units from course-data/math-data-formatted.md. Currently only Unit 1 (34 activities) is imported. Need to add remaining 329 activities across Units 2-13 to database using clean import pattern established with Unit 1.

**Acceptance Criteria:**
- All 363 Math 3 activities imported to database
- Proper unit and lesson grouping maintained
- Foreign key relationships correct

**Status:** ✅ COMPLETED   
**Estimated Time:** 2-3 hours  
**Notes:** 

---

## PHASE 2: Course Data Research & Import

### Task 3: Research & Fix Chemistry Course Data ✅ COMPLETED  
**Priority:** MEDIUM - User Task  
**Dependencies:** None  
**Description:** Review and correct the High School Chemistry course data in course-data/high-school-chemistry.md. Data is incomplete/incorrect and needs verification against Khan Academy before database import can proceed.

**Acceptance Criteria:**
- Chemistry course data verified against Khan Academy
- All units, lessons, and activities documented correctly
- Activity types and exam flags accurate

**Status:** ✅ COMPLETED  
**Assigned To:** User  
**Notes:** User will handle data research

---

### Task 4: Research & Fix World History Course Data ❌
**Priority:** MEDIUM - User Task  
**Dependencies:** None  
**Description:** Review and correct the World History course data in course-data/world-history.md. Data needs verification and correction against Khan Academy before database import can proceed.

**Acceptance Criteria:**
- World History course data verified against Khan Academy
- All units, lessons, and activities documented correctly
- Activity types and exam flags accurate

**Status:** ❌ NOT STARTED  
**Assigned To:** User  
**Notes:** User will handle data research

---

### Task 5: Research & Fix Reading Course Data ✅ COMPLETED   
**Priority:** MEDIUM - User Task  
**Dependencies:** None  
**Description:** Review and correct the 10th Grade Reading and Vocabulary course data in course-data/10th-grade-reading-vocabulary.md. Data needs verification against Khan Academy before database import can proceed.

**Acceptance Criteria:**
- Reading course data verified against Khan Academy
- All units, lessons, and activities documented correctly
- Activity types and exam flags accurate

**Status:** ❌ NOT STARTED  
**Assigned To:** User  
**Notes:** User will handle data research

---

### Task 6: Import Chemistry Course to Database ✅ COMPLETED   
**Priority:** MEDIUM  
**Dependencies:** Task 3 (Chemistry Data Research)  
**Description:** Import corrected High School Chemistry course data to database once data research (#3) is complete. Follow clean import pattern established with Math Unit 1.

**Acceptance Criteria:**
- Chemistry course fully imported to database
- Proper unit and lesson structure maintained
- Activity types and relationships correct

**Status:** ❌ NOT STARTED  
**Estimated Time:** 1-2 hours  
**Notes:** 

---

### Task 7: Import World History Course to Database ❌
**Priority:** MEDIUM  
**Dependencies:** Task 4 (World History Data Research)  
**Description:** Import corrected World History course data to database once data research (#4) is complete. Follow clean import pattern established with Math Unit 1.

**Acceptance Criteria:**
- World History course fully imported to database
- Proper unit and lesson structure maintained
- Activity types and relationships correct

**Status:** ❌ NOT STARTED  
**Estimated Time:** 1-2 hours  
**Notes:** 

---

### Task 8: Import Reading Course to Database ❌
**Priority:** MEDIUM  
**Dependencies:** Task 5 (Reading Data Research)  
**Description:** Import corrected 10th Grade Reading course data to database once data research (#5) is complete. Follow clean import pattern established with Math Unit 1.

**Acceptance Criteria:**
- Reading course fully imported to database
- Proper unit and lesson structure maintained
- Activity types and relationships correct

**Status:** ❌ NOT STARTED  
**Estimated Time:** 1-2 hours  
**Notes:** 

---

## PHASE 3: Scheduling System Design & Implementation

### Task 9: Design Schedule Calculation Algorithm ❌
**Priority:** HIGH - Critical  
**Dependencies:** Task 2 (Full Math Data)  
**Description:** Design and specify the scheduling algorithm that will: 1) Calculate due dates for all activities based on target completion dates, 2) Handle fractional daily targets (e.g. 1.3 activities/day), 3) Respect exam days as sole activities, 4) Account for school days only (Sun, Mon, Thu, Fri, Sat), 5) Handle vacation days and holidays, 6) Support bulk assignment with manual override capability.

**Acceptance Criteria:**
- Complete algorithm specification document
- Decision on remainder activity distribution
- Exam day scheduling logic defined
- Vacation day handling approach specified
- Manual override system requirements defined

**Status:** ❌ NOT STARTED  
**Estimated Time:** 2-3 hours (discussion + documentation)  
**Notes:** Requires user input and collaboration

---

### Task 10: Implement Schedule Calculation Engine ❌
**Priority:** HIGH - Critical  
**Dependencies:** Task 9 (Algorithm Design)  
**Description:** Build the core scheduling engine based on algorithm design (#9). This should calculate and assign due dates to all activities across all courses, handling school days, exam days, vacation days, and fractional daily distributions.

**Acceptance Criteria:**
- Schedule calculation function implemented
- Due dates assigned to all activities
- School day filtering working
- Exam day isolation working
- Vacation day exclusion working

**Status:** ❌ NOT STARTED  
**Estimated Time:** 4-6 hours  
**Notes:** 

---

### Task 11: Create Vacation Days Management System ❌
**Priority:** HIGH - Top 3 User Priority  
**Dependencies:** Task 10 (Schedule Engine)  
**Description:** Build UI and backend functionality to allow setting vacation days that will be excluded from schedule calculations. This should integrate with the schedule calculation engine (#10) and allow date range specification.

**Acceptance Criteria:**
- Vacation days can be added/removed via UI
- Date range selection working
- Schedule recalculation when vacation days change
- Visual indication of vacation days

**Status:** ❌ NOT STARTED  
**Estimated Time:** 2-3 hours  
**Notes:** 

---

### Task 12: Add Due Dates to CourseDetail View ❌
**Priority:** HIGH - Critical  
**Dependencies:** Task 10 (Schedule Engine)  
**Description:** Update CourseDetail component to display calculated due dates for each activity. Currently shows task list without dates. Should show assigned dates from schedule calculation engine.

**Acceptance Criteria:**
- Due dates displayed for each activity
- Visual indicators for overdue/upcoming activities
- Clear date formatting
- Integration with schedule calculations

**Status:** ❌ NOT STARTED  
**Estimated Time:** 1-2 hours  
**Notes:** 

---

## PHASE 4: Student Integration & Progress Tracking

### Task 13: Connect Progress Tracking to Test Student ❌
**Priority:** MEDIUM  
**Dependencies:** Task 1 (Test Student), Task 10 (Schedule Engine)  
**Description:** Link the existing checkbox functionality to the test student profile so that completion tracking is properly associated with a student record rather than anonymous updates.

**Acceptance Criteria:**
- Checkbox updates linked to test student
- Progress tracking working correctly
- Completion dates recorded properly
- Progress calculations accurate

**Status:** ❌ NOT STARTED  
**Estimated Time:** 1-2 hours  
**Notes:** 

---

### Task 14: Build Daily Schedule View ❌
**Priority:** HIGH - Missing Core Feature  
**Dependencies:** Task 10 (Schedule Engine), Task 13 (Student Progress)  
**Description:** Create a daily schedule/calendar view that shows today's assigned activities across all courses. This is a key missing component mentioned in user requirements.

**Acceptance Criteria:**
- Daily view showing today's activities
- Activities grouped by course
- Completion checkboxes functional
- Navigation to previous/next days

**Status:** ❌ NOT STARTED  
**Estimated Time:** 3-4 hours  
**Notes:** 

---

### Task 15: Implement Manual Date Override System ❌
**Priority:** MEDIUM  
**Dependencies:** Task 10 (Schedule Engine), Task 12 (Due Dates in CourseDetail)  
**Description:** Build UI functionality to allow manual override of automatically assigned due dates while maintaining schedule integrity and showing impact of changes.

**Acceptance Criteria:**
- Individual activity dates can be manually changed
- System shows impact of date changes
- Schedule integrity maintained
- Override indicators visible

**Status:** ❌ NOT STARTED  
**Estimated Time:** 2-3 hours  
**Notes:** 

---

### Task 16: Add Schedule Recalculation Triggers ❌
**Priority:** MEDIUM  
**Dependencies:** Task 10 (Schedule Engine), Task 11 (Vacation Days)  
**Description:** Implement manual recalculation functionality that allows users to regenerate schedules when target dates change, vacation days are added, or other schedule parameters are modified.

**Acceptance Criteria:**
- Manual recalculation button/trigger
- Automatic recalculation when target dates change
- Recalculation when vacation days change
- User confirmation for major schedule changes

**Status:** ❌ NOT STARTED  
**Estimated Time:** 2-3 hours  
**Notes:** 

---

### Task 17: Update StudentDashboard Functionality ❌
**Priority:** MEDIUM  
**Dependencies:** Task 10 (Schedule Engine), Task 13 (Student Progress), Task 14 (Daily View)  
**Description:** Enhance StudentDashboard to be fully functional with schedule calculations, showing today's tasks, progress indicators, and schedule adherence status.

**Acceptance Criteria:**
- Today's tasks displayed prominently
- Progress indicators working
- Schedule adherence status (ahead/behind)
- Quick completion actions available

**Status:** ❌ NOT STARTED  
**Estimated Time:** 2-3 hours  
**Notes:** 

---

## PHASE 5: Authentication & Polish

### Task 18: Implement Student Authentication System ❌
**Priority:** LOW - Future Enhancement  
**Dependencies:** All core functionality complete  
**Description:** Build proper authentication system to replace test student approach. This includes login/signup, user roles, and RLS policy updates to support multi-user access.

**Acceptance Criteria:**
- Student login/signup working
- User sessions maintained
- RLS policies updated for multi-user
- Profile management functional

**Status:** ❌ NOT STARTED  
**Estimated Time:** 4-6 hours  
**Notes:** Can be deferred until core functionality complete

---

### Task 19: Resolve Ongoing RLS Issues ❌
**Priority:** ONGOING - As Needed  
**Dependencies:** Varies by specific issue  
**Description:** Systematic review and fix of Row Level Security policies that may be blocking database operations. This is an ongoing issue that needs comprehensive resolution.

**Acceptance Criteria:**
- All database operations working correctly
- RLS policies properly configured
- No permission errors in application
- Security maintained appropriately

**Status:** ❌ NOT STARTED  
**Estimated Time:** Variable - as issues arise  
**Notes:** Address when specific issues encountered

---

### Task 20: Update ProgressCharts for Full Database ❌
**Priority:** LOW - Polish  
**Dependencies:** All course data imported (Tasks 2, 6-8)  
**Description:** Rework ProgressCharts component once full database is populated with all course data. Currently low priority but needed for complete functionality.

**Acceptance Criteria:**
- Charts display data from all courses
- Visual improvements implemented
- Performance optimized for full dataset
- Additional chart types as needed

**Status:** ❌ NOT STARTED  
**Estimated Time:** 2-3 hours  
**Notes:** Low priority, can be done last

---

## Next Session Planning

### Immediate Actions (Next Session):
1. **Start with Task 1** - Create Test Student Profile
2. **Continue with Task 2** - Import Math Units 2-13
3. **Begin Task 9** - Design Schedule Algorithm (requires user collaboration)

### Dependencies to Track:
- Tasks 3-5 (Data Research) - User responsibility
- Task 9 completion blocks Tasks 10-17
- Task 10 completion unlocks most UI features

### Critical Path:
Task 1 → Task 2 → Task 9 → Task 10 → Tasks 11-17

---

## Revision History

| Date | Changes | Notes |
|------|---------|-------|
| Oct 2, 2025 | Initial TODO list created | Based on implementation status review |

---

**Last Updated:** October 2, 2025