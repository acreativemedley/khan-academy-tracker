/**
 * Date utility functions to handle timezone issues consistently
 * Prevents "off by one day" errors when working with date strings
 */

/**
 * Create a Date object from a date string (YYYY-MM-DD) in local timezone
 * This prevents timezone offset issues that cause dates to appear one day earlier
 */
export function createLocalDate(dateString) {
  if (!dateString) return null;
  
  // Split the date string and create date in local timezone
  const [year, month, day] = dateString.split('-');
  return new Date(parseInt(year), parseInt(month) - 1, parseInt(day));
}

/**
 * Format a Date object to YYYY-MM-DD string (for database storage)
 */
export function formatDateForDB(date) {
  if (!date) return null;
  
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  
  return `${year}-${month}-${day}`;
}

/**
 * Get today's date as YYYY-MM-DD string in local timezone
 */
export function getTodayString() {
  return formatDateForDB(new Date());
}

/**
 * Calculate days between two dates
 */
export function daysBetween(startDate, endDate) {
  if (!startDate || !endDate) return 0;
  
  const start = typeof startDate === 'string' ? createLocalDate(startDate) : startDate;
  const end = typeof endDate === 'string' ? createLocalDate(endDate) : endDate;
  
  const diffTime = end - start;
  return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
}

/**
 * Format a date for display (locale-aware)
 */
export function formatDateForDisplay(dateString) {
  if (!dateString) return 'No date set';
  
  const date = createLocalDate(dateString);
  return date.toLocaleDateString();
}

/**
 * Calculate days remaining until target date
 */
export function getDaysRemaining(targetDateString) {
  if (!targetDateString) return null;
  
  const today = new Date();
  const targetDate = createLocalDate(targetDateString);
  
  return daysBetween(today, targetDate);
}