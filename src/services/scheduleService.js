/**
 * Schedule Service
 * Core scheduling algorithm and related functions
 * 
 * NO TIME TRACKING - This module only handles activity distribution by date
 * No time estimates, no duration tracking, only completion-based scheduling
 */

import { supabase } from './supabase.js';
import { createLocalDate, formatDateForDB } from '../utils/dateUtils.js';
import {
  getSchoolDaysInRange,
  getNextSchoolDay,
  countSchoolDays,
  isPastDate
} from '../utils/scheduleUtils.js';

/**
 * Calculate and assign due dates for all activities in a course
 * 
 * @param {string} courseId - UUID of the course
 * @param {string} studentId - UUID of the student
 * @param {object} options - Configuration options
 * @param {boolean} options.forceRecalculate - If true, delete existing schedule and recalculate
 * @returns {Promise<object>} - Result object with assignments and warnings
 */
export async function calculateSchedule(courseId, studentId, options = {}) {
  const { forceRecalculate = false } = options;

  try {
    // Step 1: Get course data
    const { data: course, error: courseError } = await supabase
      .from('courses')
      .select('*')
      .eq('id', courseId)
      .single();

    if (courseError) throw courseError;
    if (!course) throw new Error('Course not found');

    // Validate course has target date
    if (!course.target_completion_date) {
      throw new Error('Course must have a target completion date');
    }

    // Step 2: Get student data (for school days configuration)
    const { data: student, error: studentError } = await supabase
      .from('students')
      .select('*')
      .eq('id', studentId)
      .single();

    if (studentError) throw studentError;
    if (!student) throw new Error('Student not found');

    // Step 3: Get all activities for the course with unit info for proper ordering
    // We need unit_number to ensure Unit 1 → Unit 2 → Unit 3 order (not UUID order)
    const { data: activities, error: activitiesError } = await supabase
      .from('activities')
      .select(`
        *,
        unit:units!inner(unit_number)
      `)
      .eq('course_id', courseId);

    if (activitiesError) throw activitiesError;
    if (!activities || activities.length === 0) {
      throw new Error('No activities found for this course');
    }

    // Sort activities by unit_number, then order_index (in JavaScript since Supabase ordering is complex)
    activities.sort((a, b) => {
      if (a.unit.unit_number !== b.unit.unit_number) {
        return a.unit.unit_number - b.unit.unit_number;
      }
      return a.order_index - b.order_index;
    });

    // Step 4: Get vacation periods for the student
    const { data: vacations, error: vacationsError } = await supabase
      .from('vacation_periods')
      .select('*')
      .eq('student_id', studentId);

    if (vacationsError) throw vacationsError;

    // Step 5: Calculate date range - USE createLocalDate to avoid timezone issues
    const startDate = course.start_date ? createLocalDate(course.start_date) : new Date();
    if (startDate && !course.start_date) {
      // If using today, normalize to midnight
      startDate.setHours(0, 0, 0, 0);
    }
    const targetDate = createLocalDate(course.target_completion_date);

    // Validate dates
    if (targetDate <= startDate) {
      throw new Error('Target completion date must be after start date');
    }

    // Step 6: Get available school days
    const availableDays = getSchoolDaysInRange(
      startDate,
      targetDate,
      student.school_days || ['sunday', 'monday', 'thursday', 'friday', 'saturday'],
      vacations || []
    );

    if (availableDays.length === 0) {
      throw new Error('No available school days between start and target date');
    }

    // Step 7: Separate exams from regular activities
    const exams = activities.filter(a => a.is_exam);
    const regularActivities = activities.filter(a => !a.is_exam);
    const scheduledExamIds = new Set(); // Track which exams we've scheduled

    // Step 8: Calculate distribution with buffer days
    // Add 5 buffer days to account for:
    // - Unit boundaries (can't split units across days)
    // - Exam days taking full days
    // - Review/catch-up time at the end
    const examDaysNeeded = exams.length;
    const bufferDays = 5;
    const effectiveDays = Math.max(1, availableDays.length - examDaysNeeded - bufferDays);

    if (effectiveDays <= 0) {
      throw new Error('Not enough school days to schedule all activities and exams. Try extending the target completion date.');
    }

    const activitiesPerDay = regularActivities.length / effectiveDays;
    const baseActivities = Math.floor(activitiesPerDay);
    const extraActivities = regularActivities.length - (effectiveDays * baseActivities);

    // Calculate interval for distributing extra activities evenly
    const extraInterval = extraActivities > 0 ? Math.floor(effectiveDays / extraActivities) : 0;

    // Step 9: Delete existing schedule if force recalculate
    if (forceRecalculate) {
      const { error: deleteError } = await supabase
        .from('schedule')
        .delete()
        .eq('course_id', courseId)
        .eq('student_id', studentId);

      if (deleteError) throw deleteError;
    }

    // Step 10: Create assignments
    const assignments = [];
    let activityIndex = 0;
    let extraAssigned = 0;
    let dayIndex = 0;
    let warnings = [];
    let pastDateCount = 0;

    while (activityIndex < regularActivities.length && dayIndex < availableDays.length) {
      const currentDate = availableDays[dayIndex];

      // Calculate how many activities for this day
      let activitiesForDay = baseActivities;

      // Add extra activity if we're at the right interval
      if (extraActivities > 0 && extraAssigned < extraActivities) {
        if (extraInterval > 0 && dayIndex % extraInterval === 0) {
          activitiesForDay++;
          extraAssigned++;
        }
      }

      // Check if we're about to finish a unit - if so, only schedule up to the end of that unit
      if (activityIndex < regularActivities.length) {
        const currentActivity = regularActivities[activityIndex];
        const remainingInCurrentUnit = regularActivities.slice(activityIndex).filter(a => 
          a.unit_id === currentActivity.unit_id
        ).length;
        
        // If there are fewer activities remaining in this unit than we planned to schedule today,
        // only schedule up to the end of the unit (leaving room for the exam)
        if (remainingInCurrentUnit < activitiesForDay) {
          activitiesForDay = remainingInCurrentUnit;
        }
      }

      // Assign activities for this day
      for (let i = 0; i < activitiesForDay && activityIndex < regularActivities.length; i++) {
        const activity = regularActivities[activityIndex];
        
        // Check if THIS ACTIVITY is being scheduled in the past
        if (isPastDate(currentDate)) {
          pastDateCount++;
        }
        
        assignments.push({
          student_id: studentId,
          activity_id: activity.id,
          course_id: courseId,
          scheduled_date: formatDateForDB(currentDate),
          is_exam_day: false,
          is_review_day: false,
          order_in_day: i + 1,
          manually_assigned: false
        });

        activityIndex++;
      }

      // After assigning regular activities, check if we need to schedule an exam
      // We want to schedule an exam after we've completed all activities in a unit
      let examScheduled = false;
      if (activityIndex > 0 && activityIndex <= regularActivities.length) {
        const lastScheduledActivity = regularActivities[activityIndex - 1];
        const exam = findExamForActivity(exams, regularActivities, lastScheduledActivity, activityIndex, scheduledExamIds);

        if (exam) {
          // Mark this exam as scheduled
          scheduledExamIds.add(exam.id);

          dayIndex++; // Move to next day for exam
          if (dayIndex < availableDays.length) {
            const examDate = availableDays[dayIndex];
            
            if (isPastDate(examDate)) {
              pastDateCount++;
            }

            assignments.push({
              student_id: studentId,
              activity_id: exam.id,
              course_id: courseId,
              scheduled_date: formatDateForDB(examDate),
              is_exam_day: true,
              is_review_day: false,
              order_in_day: 1,
              manually_assigned: false
            });
            
            examScheduled = true;
          }
        }
      }

      // Only increment dayIndex if we didn't schedule an exam
      // (exam scheduling already incremented it)
      if (!examScheduled) {
        dayIndex++;
      } else {
        dayIndex++; // Move past the exam day for next iteration
      }
    }

    // Step 11: Check if we scheduled all activities
    if (activityIndex < regularActivities.length) {
      warnings.push(`Not all activities could be scheduled. ${regularActivities.length - activityIndex} activities remain.`);
    }

    // Check for exams not scheduled
    const unscheduledExams = exams.filter(e => !scheduledExamIds.has(e.id));
    if (unscheduledExams.length > 0) {
      warnings.push(`${unscheduledExams.length} exam(s) could not be scheduled.`);
    }

    // Add past date warning
    if (pastDateCount > 0) {
      warnings.push(`⚠️ ${pastDateCount} activities are scheduled for past dates. These will show as overdue until marked complete.`);
    }

    // Step 12: Insert assignments into database
    if (assignments.length > 0) {
      const { error: insertError } = await supabase
        .from('schedule')
        .insert(assignments);

      if (insertError) throw insertError;
    }

    // Step 13: Return results
    return {
      success: true,
      assignmentsCreated: assignments.length,
      startDate: formatDateForDB(startDate),
      endDate: formatDateForDB(availableDays[availableDays.length - 1]),
      regularActivitiesScheduled: activityIndex,
      examsScheduled: scheduledExamIds.length,
      averageActivitiesPerDay: activitiesPerDay.toFixed(2),
      schoolDaysUsed: dayIndex,
      warnings: warnings
    };

  } catch (error) {
    console.error('Schedule calculation error:', error);
    return {
      success: false,
      error: error.message,
      assignmentsCreated: 0
    };
  }
}

/**
 * Find the exam that should be scheduled after a given activity
 * Exams are placed after all regular activities in their unit have been scheduled
 * 
 * @param {Array} exams - Array of exam activities
 * @param {Array} regularActivities - Non-exam activities in order
 * @param {object} lastScheduledActivity - The last activity we just scheduled
 * @param {number} currentIndex - Current index in regularActivities array
 * @param {Set} scheduledExamIds - Set of exam IDs already scheduled
 * @returns {object|null} - Exam activity or null
 */
function findExamForActivity(exams, regularActivities, lastScheduledActivity, currentIndex, scheduledExamIds) {
  if (!lastScheduledActivity || exams.length === 0) {
    return null;
  }

  // Find an exam in the same unit as the last scheduled activity
  for (const exam of exams) {
    // Skip if already scheduled
    if (scheduledExamIds.has(exam.id)) {
      continue;
    }

    if (exam.unit_id !== lastScheduledActivity.unit_id) {
      continue; // Wrong unit
    }

    // Check if there are any more activities in this unit that haven't been scheduled yet
    const remainingActivitiesInUnit = regularActivities.slice(currentIndex).filter(a => 
      a.unit_id === lastScheduledActivity.unit_id
    );

    // If no more activities in this unit, schedule the exam
    if (remainingActivitiesInUnit.length === 0) {
      return exam;
    }
  }

  return null;
}

/**
 * Get schedule for a specific course and student
 * 
 * @param {string} courseId - UUID of the course
 * @param {string} studentId - UUID of the student
 * @returns {Promise<Array>} - Array of scheduled activities
 */
export async function getScheduleForCourse(courseId, studentId) {
  try {
    const { data, error } = await supabase
      .from('schedule')
      .select(`
        *,
        activity:activities(*)
      `)
      .eq('course_id', courseId)
      .eq('student_id', studentId)
      .order('scheduled_date', { ascending: true })
      .order('order_in_day', { ascending: true });

    if (error) throw error;
    return data || [];

  } catch (error) {
    console.error('Error fetching schedule:', error);
    return [];
  }
}

/**
 * Get today's scheduled activities for a student (all courses)
 * 
 * @param {string} studentId - UUID of the student
 * @returns {Promise<Array>} - Array of today's scheduled activities
 */
export async function getTodaySchedule(studentId) {
  try {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const todayString = formatDateForDB(today);

    const { data, error } = await supabase
      .from('schedule')
      .select(`
        *,
        activity:activities(*),
        course:courses(name)
      `)
      .eq('student_id', studentId)
      .eq('scheduled_date', todayString)
      .order('course_id')
      .order('order_in_day', { ascending: true });

    if (error) throw error;
    return data || [];

  } catch (error) {
    console.error('Error fetching today\'s schedule:', error);
    return [];
  }
}

/**
 * Get schedule for a date range
 * 
 * @param {string} studentId - UUID of the student
 * @param {Date} startDate - Start date
 * @param {Date} endDate - End date
 * @returns {Promise<Array>} - Array of scheduled activities
 */
export async function getScheduleForDateRange(studentId, startDate, endDate) {
  try {
    const startString = formatDateForDB(typeof startDate === 'string' ? createLocalDate(startDate) : startDate);
    const endString = formatDateForDB(typeof endDate === 'string' ? createLocalDate(endDate) : endDate);

    const { data, error } = await supabase
      .from('schedule')
      .select(`
        *,
        activity:activities(*),
        course:courses(name)
      `)
      .eq('student_id', studentId)
      .gte('scheduled_date', startString)
      .lte('scheduled_date', endString)
      .order('scheduled_date', { ascending: true })
      .order('course_id')
      .order('order_in_day', { ascending: true });

    if (error) throw error;
    return data || [];

  } catch (error) {
    console.error('Error fetching schedule for date range:', error);
    return [];
  }
}

/**
 * Override a specific activity's due date
 * 
 * @param {string} activityId - UUID of the activity
 * @param {string} studentId - UUID of the student
 * @param {Date} newDate - New due date
 * @returns {Promise<boolean>} - Success status
 */
export async function overrideActivityDate(activityId, studentId, newDate) {
  try {
    const dateString = formatDateForDB(typeof newDate === 'string' ? createLocalDate(newDate) : newDate);

    const { error } = await supabase
      .from('schedule')
      .update({
        scheduled_date: dateString,
        manually_assigned: true,
        updated_at: new Date().toISOString()
      })
      .eq('activity_id', activityId)
      .eq('student_id', studentId);

    if (error) throw error;
    return true;

  } catch (error) {
    console.error('Error overriding activity date:', error);
    return false;
  }
}

/**
 * Delete schedule for a course (used before recalculation)
 * 
 * @param {string} courseId - UUID of the course
 * @param {string} studentId - UUID of the student
 * @returns {Promise<boolean>} - Success status
 */
export async function deleteScheduleForCourse(courseId, studentId) {
  try {
    const { error } = await supabase
      .from('schedule')
      .delete()
      .eq('course_id', courseId)
      .eq('student_id', studentId);

    if (error) throw error;
    return true;

  } catch (error) {
    console.error('Error deleting schedule:', error);
    return false;
  }
}

/**
 * Recalculate schedule with vacation day support
 * 
 * @param {string} courseId - UUID of the course
 * @param {string} studentId - UUID of the student
 * @param {string} mode - 'all' or 'future'
 *   'all': Reschedule all incomplete activities starting today (nothing overdue)
 *   'future': Keep overdue assignments, only recalculate from today forward
 * @returns {Promise<object>} - Result object with assignments and warnings
 */
export async function recalculateScheduleWithVacations(courseId, studentId, mode = 'all') {
  try {
    // Step 1: Get course data
    const { data: course, error: courseError } = await supabase
      .from('courses')
      .select('*')
      .eq('id', courseId)
      .single();

    if (courseError) throw courseError;
    if (!course) throw new Error('Course not found');
    if (!course.target_completion_date) {
      throw new Error('Course must have a target completion date');
    }

    // Step 2: Get student data
    const { data: student, error: studentError } = await supabase
      .from('students')
      .select('*')
      .eq('id', studentId)
      .single();

    if (studentError) throw studentError;
    if (!student) throw new Error('Student not found');

    // Step 3: Get all activities with unit info
    const { data: allActivities, error: activitiesError } = await supabase
      .from('activities')
      .select(`
        *,
        unit:units!inner(unit_number)
      `)
      .eq('course_id', courseId);

    if (activitiesError) throw activitiesError;
    if (!allActivities || allActivities.length === 0) {
      throw new Error('No activities found for this course');
    }

    // Sort activities properly
    allActivities.sort((a, b) => {
      if (a.unit.unit_number !== b.unit.unit_number) {
        return a.unit.unit_number - b.unit.unit_number;
      }
      return a.order_index - b.order_index;
    });

    // Step 4: Get completed activities
    const { data: completedActivities, error: progressError } = await supabase
      .from('progress_tracking')
      .select('activity_id')
      .eq('student_id', studentId)
      .eq('course_id', courseId)
      .eq('completed', true);

    if (progressError) throw progressError;

    const completedIds = new Set((completedActivities || []).map(p => p.activity_id));

    // Step 5: Determine which activities to schedule based on mode
    let activitiesToSchedule;
    let startDate;
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const todayString = formatDateForDB(today);

    if (mode === 'all') {
      // Recalculate All: Schedule only incomplete activities starting today
      activitiesToSchedule = allActivities.filter(a => !completedIds.has(a.id));
      startDate = today;

      // Delete ALL existing schedules for this course
      const { error: deleteError } = await supabase
        .from('schedule')
        .delete()
        .eq('course_id', courseId)
        .eq('student_id', studentId);

      if (deleteError) throw deleteError;

    } else {
      // Recalculate Future: Find last activity scheduled for yesterday or earlier
      const yesterday = new Date(today);
      yesterday.setDate(yesterday.getDate() - 1);
      const yesterdayString = formatDateForDB(yesterday);

      // Get all existing schedule entries
      const { data: existingSchedule, error: scheduleError } = await supabase
        .from('schedule')
        .select('activity_id, scheduled_date')
        .eq('course_id', courseId)
        .eq('student_id', studentId)
        .order('scheduled_date', { ascending: false });

      if (scheduleError) throw scheduleError;

      // Find the last activity scheduled for yesterday or earlier
      const pastScheduledActivities = (existingSchedule || [])
        .filter(s => s.scheduled_date <= yesterdayString);

      let lastPastActivityIndex = -1;
      if (pastScheduledActivities.length > 0) {
        const lastPastActivityId = pastScheduledActivities[0].activity_id;
        lastPastActivityIndex = allActivities.findIndex(a => a.id === lastPastActivityId);
      }

      // Schedule all activities after the last past activity (including completed ones)
      activitiesToSchedule = allActivities.slice(lastPastActivityIndex + 1);
      startDate = today;

      // Delete only future schedules (>= today)
      const { error: deleteError } = await supabase
        .from('schedule')
        .delete()
        .eq('course_id', courseId)
        .eq('student_id', studentId)
        .gte('scheduled_date', todayString);

      if (deleteError) throw deleteError;
    }

    if (activitiesToSchedule.length === 0) {
      return {
        success: true,
        assignmentsCreated: 0,
        message: 'No activities to schedule',
        warnings: []
      };
    }

    // Step 6: Get vacation periods
    const { data: vacations, error: vacationsError } = await supabase
      .from('vacation_periods')
      .select('*')
      .eq('student_id', studentId);

    if (vacationsError) throw vacationsError;

    // Step 7: Calculate date range and available days
    const targetDate = createLocalDate(course.target_completion_date);

    if (targetDate <= startDate) {
      throw new Error('Target completion date must be after start date');
    }

    const availableDays = getSchoolDaysInRange(
      startDate,
      targetDate,
      student.school_days || ['sunday', 'monday', 'thursday', 'friday', 'saturday'],
      vacations || []
    );

    if (availableDays.length === 0) {
      throw new Error('No available school days between start and target date');
    }

    // Step 8: Separate exams from regular activities
    const exams = activitiesToSchedule.filter(a => a.is_exam);
    const regularActivities = activitiesToSchedule.filter(a => !a.is_exam);
    const scheduledExamIds = new Set();

    // Step 9: Calculate distribution
    const examDaysNeeded = exams.length;
    const bufferDays = 5;
    const effectiveDays = Math.max(1, availableDays.length - examDaysNeeded - bufferDays);

    if (effectiveDays <= 0) {
      throw new Error('Not enough school days to schedule all activities and exams. Try extending the target completion date.');
    }

    const activitiesPerDay = regularActivities.length / effectiveDays;
    const baseActivities = Math.floor(activitiesPerDay);
    const extraActivities = regularActivities.length - (effectiveDays * baseActivities);
    const extraInterval = extraActivities > 0 ? Math.floor(effectiveDays / extraActivities) : 0;

    // Step 10: Create assignments
    const assignments = [];
    let activityIndex = 0;
    let extraAssigned = 0;
    let dayIndex = 0;
    let warnings = [];

    while (activityIndex < regularActivities.length && dayIndex < availableDays.length) {
      const currentDate = availableDays[dayIndex];

      let activitiesForDay = baseActivities;
      if (extraActivities > 0 && extraAssigned < extraActivities) {
        if (extraInterval > 0 && dayIndex % extraInterval === 0) {
          activitiesForDay++;
          extraAssigned++;
        }
      }

      if (activityIndex < regularActivities.length) {
        const currentActivity = regularActivities[activityIndex];
        const remainingInCurrentUnit = regularActivities.slice(activityIndex).filter(a => 
          a.unit_id === currentActivity.unit_id
        ).length;
        
        if (remainingInCurrentUnit < activitiesForDay) {
          activitiesForDay = remainingInCurrentUnit;
        }
      }

      for (let i = 0; i < activitiesForDay && activityIndex < regularActivities.length; i++) {
        const activity = regularActivities[activityIndex];
        
        assignments.push({
          student_id: studentId,
          activity_id: activity.id,
          course_id: courseId,
          scheduled_date: formatDateForDB(currentDate),
          is_exam_day: false,
          is_review_day: false,
          order_in_day: i + 1,
          manually_assigned: false
        });

        activityIndex++;
      }

      let examScheduled = false;
      if (activityIndex > 0 && activityIndex <= regularActivities.length) {
        const lastScheduledActivity = regularActivities[activityIndex - 1];
        const exam = findExamForActivity(exams, regularActivities, lastScheduledActivity, activityIndex, scheduledExamIds);

        if (exam) {
          scheduledExamIds.add(exam.id);
          dayIndex++;
          if (dayIndex < availableDays.length) {
            const examDate = availableDays[dayIndex];
            
            assignments.push({
              student_id: studentId,
              activity_id: exam.id,
              course_id: courseId,
              scheduled_date: formatDateForDB(examDate),
              is_exam_day: true,
              is_review_day: false,
              order_in_day: 1,
              manually_assigned: false
            });
            
            examScheduled = true;
          }
        }
      }

      if (!examScheduled) {
        dayIndex++;
      } else {
        dayIndex++;
      }
    }

    if (activityIndex < regularActivities.length) {
      warnings.push(`Not all activities could be scheduled. ${regularActivities.length - activityIndex} activities remain.`);
    }

    const unscheduledExams = exams.filter(e => !scheduledExamIds.has(e.id));
    if (unscheduledExams.length > 0) {
      warnings.push(`${unscheduledExams.length} exam(s) could not be scheduled.`);
    }

    // Step 11: Insert new assignments
    if (assignments.length > 0) {
      const { error: insertError } = await supabase
        .from('schedule')
        .insert(assignments);

      if (insertError) throw insertError;
    }

    return {
      success: true,
      assignmentsCreated: assignments.length,
      startDate: formatDateForDB(startDate),
      endDate: formatDateForDB(availableDays[availableDays.length - 1]),
      regularActivitiesScheduled: activityIndex,
      examsScheduled: scheduledExamIds.length,
      averageActivitiesPerDay: activitiesPerDay.toFixed(2),
      schoolDaysUsed: dayIndex,
      mode: mode,
      warnings: warnings
    };

  } catch (error) {
    console.error('Schedule recalculation error:', error);
    return {
      success: false,
      error: error.message,
      assignmentsCreated: 0
    };
  }
}
