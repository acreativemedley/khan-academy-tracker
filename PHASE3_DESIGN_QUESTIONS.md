# Phase 3: Scheduling System Design Questions

**Date:** October 5, 2025  
**Purpose:** Gather requirements for scheduling algorithm design and implementation  
**Status:** AWAITING USER RESPONSES

---

## Overview

Before implementing the scheduling system (Phase 3 tasks), I need to understand exactly how you want the system to work. Please answer these questions with as much detail as possible. Your answers will determine how the schedule calculation engine is designed and implemented.

**What happens after you answer:**
- I will design the scheduling algorithm based on your specifications
- Create technical documentation of the algorithm
- Implement the schedule calculation engine
- Build the vacation days management system
- Add due dates to the CourseDetail view
- Create the daily schedule view

---

## SECTION 1: Schedule Calculation Fundamentals

### Question 1.1: Handling Fractional Activities Per Day

When calculating daily assignments, the math often results in fractional activities per day.

**Example:** If you need to complete 50 activities in 40 school days, that's 1.25 activities/day.

**How should the system handle this?**

- [ x] **Option A:** Distribute evenly - Some days get 1 activity, some days get 2 activities (smart distribution)
- [ ] **Option B:** Always round up - Every day gets 2 activities (will finish early)
- [ ] **Option C:** Always round down - Most days get 1 activity (won't finish on time with this math)
- [ ] **Option D:** Something else (please explain below)

**Your Answer:**
Option A



**If you chose Option A (Distribute evenly), additional question:**

### Question 1.2: How to Distribute Extra Activities

When distributing the "extra" activities throughout the schedule:

- [ ] **Option A:** Spread evenly throughout the schedule
- [ ] **Option B:** Cluster at the beginning (front-load the work)
- [ ] **Option C:** Cluster at the end (ramp up before completion)
- [ ] **Option D:** Let me manually assign which days get extra activities
- [ ] **Option E:** Other (please explain below)

**Your Answer:**
Spread evenly throughout the schedule - BUT also give the option to reschedule any assignment to another day



---

## SECTION 2: Exam Day Handling

### Question 2.1: Exam Day Scheduling Logic

When an activity is marked as `is_exam: true` (unit test), you want it to be the ONLY activity for **that course** on that day.

**How should the system assign exam days?**

- [ ] **Option A:** Automatically find the next available school day after completing the previous unit's activities
- [ ] **Option B:** Allow me to manually set exam days for each exam
- [ ] **Option C:** Auto-assign initially, but allow me to manually override specific exam dates
- [ ] **Option D:** Other (please explain below)

**Your Answer:**
C




### Question 2.2: Multi-Course Exam Day Behavior

**Scenario:** Monday is scheduled as an exam day for Chemistry.

**Can that same Monday ALSO have regular activities scheduled for Math, History, and Reading?**

- [ ] **Option A:** Yes - Exam day only means no OTHER Chemistry activities that day. Other courses can still have activities.
- [ ] **Option B:** No - Exam days should be completely exam-only across ALL courses (no regular activities for any course)
- [ ] **Option C:** Set a limit - Maximum of 1 exam + 2-3 regular activities from other courses
- [ ] **Option D:** Other (please explain below)

**Your Answer:**
A



---

## SECTION 3: Vacation Days System

### Question 3.1: Specifying Vacation Days

**How do you want to specify vacation days in the system?**

- [ ] **Option A:** Individual dates only (e.g., "December 25, 2025")
- [ ] **Option B:** Date ranges only (e.g., "December 20-26, 2025")
- [ ] **Option C:** Both individual dates and date ranges
- [ ] **Option D:** Other (please explain below)

**Your Answer:**
C



### Question 3.2: Vacation Day Impact on Schedule

**When vacation days are added, how should the schedule adjust?**

**Example:** You add a 5-day vacation. There are 100 remaining activities due in 50 school days (2 per day).

- [ ] **Option A:** Push all future assignments back by 5 days (new completion date is 5 days later, still 2 per day)
- [ ] **Option B:** Increase the daily activities for remaining days to still hit original target date (now 2.22 activities per day)
- [ ] **Option C:** Let me choose when I add the vacation period
- [ ] **Option D:** Other (please explain below)

**Your Answer:**
C



### Question 3.3: Pre-Set Vacation Periods

**What are your typical vacation periods for the 2025-2026 school year?**

Please provide specific date ranges: All dates are formatted US style mm/dd/yy

**Thanksgiving Break:**
- Start Date: ________________
- End Date: ________________
Thanksgiving is the 4th Thursday in November, Break should start the Tuesday before (last lessons on Monday), and end on Sunday (resume lessons on Monday)
**Christmas Break:**
- Start Date: _____12/23/25___________
- End Date: __________1/2/26______

**New Year (if separate from Christmas):**
- Start Date: _____Combined with Christmas___________
- End Date: ________________

**Spring Break (if applicable):**
- Start Date: ___not applicable_____________
- End Date: ________________

**Other Breaks/Holidays:**
- Name: ________________ | Start: ________________ | End: ________________
- Name: ________________ | Start: ________________ | End: ________________

**Should these be:**
- [ ] Hard-coded in the system (same every year)
- [ ] Stored in database as configurable settings
- [ ] Configurable per school year

**Your Answer:**


configurable per school year

---

## SECTION 4: Schedule Distribution Strategy

### Question 4.1: Multi-Course Scheduling Approach

**Should the schedule calculation consider all courses together or each course independently?**

**Example Scenario:** You have 4 courses, all due May 30, 2026. Each needs 2 activities/day.

**Option A (Independent):** Each course gets scheduled separately
- Monday: Math (2) + Chemistry (2) + History (2) + Reading (2) = **8 total activities**
- Some days might be very heavy, others very light

**Option B (Balanced):** System tries to balance total daily workload
- Monday: Math (2) + Chemistry (1) = **3 total activities**
- Tuesday: OFF (not a school day)
- Wednesday: OFF (not a school day)
- Thursday: History (2) + Reading (1) = **3 total activities**
- System distributes to keep daily totals more consistent

**Which approach do you prefer?**

- [ ] **Option A:** Independent scheduling per course (simpler, may vary daily workload)
- [ ] **Option B:** Balanced cross-course scheduling (more complex, consistent daily workload)
- [ ] **Option C:** Independent but warn me if any day exceeds X total activities
- [ ] **Option D:** Other (please explain below)

**Your Answer:**

Lets start with A, with the possibility of adding balancing later


### Question 4.2: Maximum Daily Activity Limit

**Is there a maximum number of total activities you want assigned on any single day?**

- [ ] **Option A:** No limit - schedule as needed
- [ ] **Option B:** Yes - Maximum of _______ activities per day (please specify number)
- [ ] **Option C:** Flexible maximum based on activity type (e.g., max 3 exercises + 2 videos per day)
- [ ] **Option D:** Other (please explain below)

**Your Answer:**

A


---

## SECTION 5: Assignment Timing & Recalculation

### Question 5.1: When to Calculate Due Dates

**When should the system calculate and assign due dates to activities?**

**Option A (Bulk Assignment):** 
- Calculate and assign due dates for ALL activities immediately when target date is set
- Pro: Student sees entire schedule upfront
- Con: Lots of date changes if target date or vacation days change

**Option B (Progressive Assignment):**
- Only assign dates for the next unit or next 2 weeks
- Recalculate and assign more as student progresses
- Pro: More flexible, adapts to actual progress
- Con: Student can't see far ahead

**Option C (Hybrid):**
- Assign all dates initially (so student can plan)
- Automatically recalculate remaining (not completed) assignments when things change
- Pro: Best of both worlds
- Con: More complex logic

**Which approach do you prefer?**

- [ ] **Option A:** Bulk assignment upfront
- [ ] **Option B:** Progressive assignment as student advances
- [ ] **Option C:** Hybrid (assign all, recalculate remaining)
- [ ] **Option D:** Other (please explain below)

**Your Answer:**

C - I want to assign all assignments up front, but have the option to recalculate. I do not want recalculation to happen automatically, but I do want to be able to re-calculate if we are progressing faster or slower than anticipated or if we work through or add a break


### Question 5.2: Handling Student Behind/Ahead of Schedule

**If the student falls behind schedule (or gets ahead), what should happen?**

**Scenario:** Activity was due Monday, but it's now Friday and still not complete.

- [ ] **Option A:** Keep original due dates - Show as overdue (red), let student catch up
- [ ] **Option B:** Automatically recalculate all remaining assignments to redistribute work over remaining time
- [ ] **Option C:** Show as overdue but don't auto-recalculate - I'll manually trigger recalculation when needed
- [ ] **Option D:** Other (please explain below)

**Your Answer:**

C


---

## SECTION 6: Manual Override Capabilities

### Question 6.1: What Can Be Manually Overridden?

**What level of manual control do you want over the schedule?**

- [ ] **Option A:** Change individual activity due dates only
- [ ] **Option B:** Move entire units to different date ranges
- [ ] **Option C:** Both individual activities AND entire units
- [ ] **Option D:** Also manually set daily activity limits per date
- [ ] **Option E:** Other (please explain below)

**Your Answer:**

Lest start with A


### Question 6.2: Behavior After Manual Override

**When you manually change a due date for an activity, what should happen on next recalculation?**

**Example:** You manually move "Activity 15" from March 5 to March 10.

- [ ] **Option A:** Lock that date - Never change Activity 15's date on recalculation
- [ ] **Option B:** Use as a "pin point" - Keep Activity 15 on March 10, recalculate activities before/after around it
- [ ] **Option C:** Treat as temporary - Next recalculation can change it
- [ ] **Option D:** Ask me each time before changing manually-set dates
- [ ] **Option E:** Other (please explain below)

**Your Answer:**

C


---

## SECTION 7: Start Date Handling

### Question 7.1: Course Start Dates

**Should each course have its own start date, or do all courses start together?**

**Example Scenarios:**

**Option A (Same Start Date):** 
- All 4 courses start September 1, 2025

**Option B (Individual Start Dates):**
- Math starts September 1, 2025
- Chemistry starts September 15, 2025 (after finishing another course)
- History starts September 1, 2025
- Reading starts October 1, 2025

**Which approach?**

- [ ] **Option A:** All courses start on the same date
- [ ] **Option B:** Each course can have its own individual start date
- [ ] **Option C:** Other (please explain below)

**Your Answer:**
B



### Question 7.2: Past Date Handling

**You're setting up the system now (October 5, 2025). Should the system:**

- [ ] **Option A:** Use "today" as earliest possible assignment date (all assignments start October 5 or later)
- [ ] **Option B:** Allow assigning activities to past dates if I'm setting up mid-year (can assign to September dates)
- [ ] **Option C:** Ask me when I set up each course
- [ ] **Option D:** Other (please explain below)

**Your Answer:**
B - allow assigning activities to past dates, but alert me if I do it



---

## SECTION 8: Authentication & Student Creation

### Question 8.1: Student Profile Creation Priority

**This application is for one student, but you want proper authentication. How should I proceed?**

- [ ] **Option A:** Create full authentication system first, then create the real student profile (most proper, takes longer)
- [ ] **Option B:** Create a "Test Student" profile for development now, migrate to real student later (faster development)
- [ ] **Option C:** Create the real student profile NOW using proper authentication (balanced approach)

**Your Answer:**

B
Also create a parent account for feltiefun@gmail.com - the parent account and student account will have different "powers" eventually


### Question 8.2: Student Information (if Option C chosen above)

**If creating real student now, please provide:**

**Student Email:** _________  _______________________

**Student Display Name:** ________________________

**Grade Level:** ________________________________

**Parent Email (if different):** _______________________________

**Preferred Password (for development - can change later):** _________________________



---

## SECTION 9: Display & User Interface Preferences

### Question 9.1: Daily Schedule View Content

**For the Daily Schedule View (the main student interface), what should be displayed?**

- [ ] **Option A:** Just today's activities
- [ ] **Option B:** Today + next 7 days
- [ ] **Option C:** Today + current week (Sunday-Saturday)
- [ ] **Option D:** Configurable view (can switch between today/week/month)
- [ ] **Option E:** Other (please explain below)

**Your Answer:**

D


### Question 9.2: Activity Grouping in Daily View

**How should activities be organized/grouped in the daily view?**

- [ ] **Option A:** Grouped by course (all Math activities together, then Chemistry, etc.)
- [ ] **Option B:** Grouped by activity type (all videos together, all exercises together)
- [ ] **Option C:** Suggested order to complete (based on dependencies or difficulty)
- [ ] **Option D:** Let student choose grouping preference
- [ ] **Option E:** Other (please explain below)

**Your Answer:**

A


### Question 9.3: Priority Visual Indicators

**What visual information is most important to show for each activity?**

Rank these from 1 (most important) to 8 (least important):

- [ ] _4__ Due date
- [ ] _1__ Course name/color
- [ ] _3__ Activity type (video/exercise/exam)
- [ ] ___ Estimated time (if tracked)
- [ ] _5__ Completion status (checkbox)
- [ ] _6__ Whether it's overdue
- [ ] _2__ Unit/lesson context
- [ ] _7__ Link to Khan Academy

**Your Answer:**
Estimated time should NOT be tracked, EVER. There should be NO time tracking anywhere in the system



---

## SECTION 10: Additional Considerations

### Question 10.1: Review Days

**Your original requirements mentioned "review days." How should these work?**

- [ ] **Option A:** System automatically schedules review days before exams (X days of review before each unit test)
- [ ] **Option B:** I manually mark certain days as "review days" (no new content, just review)
- [ ] **Option C:** No separate review days - student reviews as needed
- [ ] **Option D:** Other (please explain below)

**Your Answer:**
C



### Question 10.2: School Year Boundaries

**What are your school year start and end dates?**

**2025-2026 School Year:**
- Start Date: ________________________________
- End Date: ________________________________

Each course will have its start and end dates set manually so there is no need for this
**Should the system prevent scheduling beyond the school year end date?**

- [ ] Yes - Hard stop at end of school year
- [ ] No - Can extend into summer if needed
- [ ] Warn me but allow it

**Your Answer:**
No



### Question 10.3: Tuesday/Wednesday (Non-School Days)

**Your requirements state Tuesday and Wednesday are non-school days.**

**Is this EVERY Tuesday and Wednesday, or are there exceptions?**

- [ ] **Option A:** Every Tuesday and Wednesday are non-school days (no exceptions)
- [ ] **Option B:** Most Tuesdays/Wednesdays are off, but there are some exceptions
- [ ] **Option C:** This might change - make it configurable

**Your Answer:**
C



**If Option B, please list exception dates (Tuesdays/Wednesdays that ARE school days):**

________________________________

________________________________

________________________________


---

## SECTION 11: Open Questions & Comments

**Is there anything else about the scheduling system that I should know?**

**Any specific concerns, requirements, or features you want to make sure are included?**

**Your Comments:**

I think you covered everything extremely well, please make sure you note that there are to be no time estimates, no time tracking, I realize this is unusual for an App of this type, but it is what meets my needs


---

## Next Steps

**Once you've answered these questions:**

1. I will review your answers
2. Create a detailed scheduling algorithm specification document
3. Review the specification with you before implementation
4. Implement the scheduling system according to your exact requirements
5. Test with your actual course data
6. Iterate based on your feedback

**Please fill out as many questions as you can. If you're unsure about any question, we can discuss it together before I start implementation.**

---

**Last Updated:** October 5, 2025  
**Status:** Awaiting User Responses
