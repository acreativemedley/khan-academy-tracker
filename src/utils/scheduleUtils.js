/**
 * Schedule Utilities
 * Date calculation helper functions for the scheduling system
 * 
 * NO TIME TRACKING - This module only handles date/day calculations
 * All functions work with dates only, never with time duration or estimates
 */

/**
 * Check if a given date is a school day based on the student's school days array
 * @param {Date} date - The date to check
 * @param {string[]} schoolDaysArray - Array of lowercase day names (e.g., ['sunday', 'monday', 'thursday', 'friday', 'saturday'])
 * @returns {boolean} - True if the date is a school day
 */
export function isSchoolDay(date, schoolDaysArray) {
  if (!date || !schoolDaysArray || !Array.isArray(schoolDaysArray)) {
    return false;
  }

  const dayNames = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
  const dayOfWeek = date.getDay(); // 0 = Sunday, 1 = Monday, etc.
  const dayName = dayNames[dayOfWeek];

  return schoolDaysArray.includes(dayName.toLowerCase());
}

/**
 * Check if a given date falls within any vacation period
 * @param {Date} date - The date to check
 * @param {Array} vacationPeriods - Array of vacation period objects with start_date and end_date
 * @returns {boolean} - True if the date is within a vacation period
 */
export function isVacationDay(date, vacationPeriods) {
  if (!date || !vacationPeriods || !Array.isArray(vacationPeriods)) {
    return false;
  }

  // Normalize the date to midnight for comparison
  const checkDate = new Date(date);
  checkDate.setHours(0, 0, 0, 0);

  return vacationPeriods.some(vacation => {
    const startDate = new Date(vacation.start_date);
    startDate.setHours(0, 0, 0, 0);
    
    const endDate = new Date(vacation.end_date);
    endDate.setHours(0, 0, 0, 0);

    return checkDate >= startDate && checkDate <= endDate;
  });
}

/**
 * Get the next available school day after a given date
 * @param {Date} date - The starting date
 * @param {string[]} schoolDaysArray - Array of school day names
 * @param {Array} vacationPeriods - Array of vacation periods
 * @returns {Date} - The next available school day
 */
export function getNextSchoolDay(date, schoolDaysArray, vacationPeriods = []) {
  const nextDay = new Date(date);
  nextDay.setDate(nextDay.getDate() + 1);
  nextDay.setHours(0, 0, 0, 0);

  // Keep incrementing until we find a school day that's not a vacation day
  let attempts = 0;
  const maxAttempts = 365; // Prevent infinite loop

  while (attempts < maxAttempts) {
    if (isSchoolDay(nextDay, schoolDaysArray) && !isVacationDay(nextDay, vacationPeriods)) {
      return nextDay;
    }
    nextDay.setDate(nextDay.getDate() + 1);
    attempts++;
  }

  // If we couldn't find a school day in a year, something is wrong
  throw new Error('Could not find next school day within 365 days. Check school days configuration.');
}

/**
 * Count the number of school days between two dates (inclusive)
 * @param {Date} startDate - The start date
 * @param {Date} endDate - The end date
 * @param {string[]} schoolDaysArray - Array of school day names
 * @param {Array} vacationPeriods - Array of vacation periods
 * @returns {number} - The count of school days
 */
export function countSchoolDays(startDate, endDate, schoolDaysArray, vacationPeriods = []) {
  if (!startDate || !endDate) {
    return 0;
  }

  const start = new Date(startDate);
  start.setHours(0, 0, 0, 0);

  const end = new Date(endDate);
  end.setHours(0, 0, 0, 0);

  if (start > end) {
    return 0;
  }

  let count = 0;
  const current = new Date(start);

  while (current <= end) {
    if (isSchoolDay(current, schoolDaysArray) && !isVacationDay(current, vacationPeriods)) {
      count++;
    }
    current.setDate(current.getDate() + 1);
  }

  return count;
}

/**
 * Get an array of all school days in a date range
 * @param {Date} startDate - The start date
 * @param {Date} endDate - The end date
 * @param {string[]} schoolDaysArray - Array of school day names
 * @param {Array} vacationPeriods - Array of vacation periods
 * @returns {Date[]} - Array of school day dates
 */
export function getSchoolDaysInRange(startDate, endDate, schoolDaysArray, vacationPeriods = []) {
  if (!startDate || !endDate) {
    return [];
  }

  const start = new Date(startDate);
  start.setHours(0, 0, 0, 0);

  const end = new Date(endDate);
  end.setHours(0, 0, 0, 0);

  if (start > end) {
    return [];
  }

  const schoolDays = [];
  const current = new Date(start);

  while (current <= end) {
    if (isSchoolDay(current, schoolDaysArray) && !isVacationDay(current, vacationPeriods)) {
      schoolDays.push(new Date(current));
    }
    current.setDate(current.getDate() + 1);
  }

  return schoolDays;
}

/**
 * Calculate Thanksgiving date for a given year
 * Thanksgiving is the 4th Thursday in November
 * @param {number} year - The year (e.g., 2025)
 * @returns {Date} - The Thanksgiving date
 */
export function getThanksgivingDate(year) {
  // Start with November 1st of the given year
  const november = new Date(year, 10, 1); // Month 10 = November (0-indexed)
  
  // Find the first Thursday
  let thursday = 1;
  while (new Date(year, 10, thursday).getDay() !== 4) {
    thursday++;
  }
  
  // Add 3 weeks to get the 4th Thursday
  const thanksgivingDate = new Date(year, 10, thursday + 21);
  return thanksgivingDate;
}

/**
 * Calculate Thanksgiving week vacation period
 * Starts Tuesday before Thanksgiving, ends Sunday after
 * @param {number} year - The year (e.g., 2025)
 * @returns {Object} - Vacation period object with start_date and end_date
 */
export function getThanksgivingVacation(year) {
  const thanksgiving = getThanksgivingDate(year);
  
  // Tuesday before Thanksgiving (2 days before)
  const startDate = new Date(thanksgiving);
  startDate.setDate(thanksgiving.getDate() - 2);
  
  // Sunday after Thanksgiving (3 days after)
  const endDate = new Date(thanksgiving);
  endDate.setDate(thanksgiving.getDate() + 3);
  
  return {
    name: `Thanksgiving Break ${year}`,
    start_date: startDate.toISOString().split('T')[0], // Format as YYYY-MM-DD
    end_date: endDate.toISOString().split('T')[0],
    description: `Thanksgiving week vacation (${startDate.toDateString()} - ${endDate.toDateString()})`
  };
}

/**
 * Format a date for display (e.g., "Monday, Oct 5, 2025")
 * @param {Date} date - The date to format
 * @returns {string} - Formatted date string
 */
export function formatDateForDisplay(date) {
  if (!date) return '';
  
  const options = { 
    weekday: 'long', 
    year: 'numeric', 
    month: 'short', 
    day: 'numeric' 
  };
  
  return new Date(date).toLocaleDateString('en-US', options);
}

/**
 * Check if a date is in the past (before today)
 * @param {Date} date - The date to check
 * @returns {boolean} - True if date is before today
 */
export function isPastDate(date) {
  if (!date) return false;
  
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  
  const checkDate = new Date(date);
  checkDate.setHours(0, 0, 0, 0);
  
  return checkDate < today;
}

/**
 * Check if two dates are the same day
 * @param {Date} date1 - First date
 * @param {Date} date2 - Second date
 * @returns {boolean} - True if dates are the same day
 */
export function isSameDay(date1, date2) {
  if (!date1 || !date2) return false;
  
  const d1 = new Date(date1);
  const d2 = new Date(date2);
  
  return d1.getFullYear() === d2.getFullYear() &&
         d1.getMonth() === d2.getMonth() &&
         d1.getDate() === d2.getDate();
}

/**
 * Get the day of week name for a date
 * @param {Date} date - The date
 * @returns {string} - Day name (e.g., "monday")
 */
export function getDayName(date) {
  const dayNames = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
  return dayNames[new Date(date).getDay()];
}
