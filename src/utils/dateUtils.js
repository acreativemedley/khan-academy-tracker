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
 * Format a date string or Date object for display (M/D/YYYY)
 */
export function formatDateForDisplay(date) {
  if (!date) return '';
  
  const dateObj = typeof date === 'string' ? createLocalDate(date) : date;
  if (!dateObj) return '';
  
  const month = dateObj.getMonth() + 1;
  const day = dateObj.getDate();
  const year = dateObj.getFullYear();
  
  return `${month}/${day}/${year}`;
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
 * Get current timestamp as ISO string in local timezone
 * This ensures timestamps represent the actual local time when stored
 */
export function getCurrentLocalTimestamp() {
  const now = new Date();
  // Create timestamp string that represents current local time
  // Format: YYYY-MM-DDTHH:mm:ss.sss (no Z suffix for local time)
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');
  const hours = String(now.getHours()).padStart(2, '0');
  const minutes = String(now.getMinutes()).padStart(2, '0');
  const seconds = String(now.getSeconds()).padStart(2, '0');
  const milliseconds = String(now.getMilliseconds()).padStart(3, '0');
  
  return `${year}-${month}-${day}T${hours}:${minutes}:${seconds}.${milliseconds}`;
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