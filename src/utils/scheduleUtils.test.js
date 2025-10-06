/**
 * Tests for Schedule Utilities
 * Run these tests to verify date calculation functions work correctly
 */

import {
  isSchoolDay,
  isVacationDay,
  getNextSchoolDay,
  countSchoolDays,
  getSchoolDaysInRange,
  getThanksgivingDate,
  getThanksgivingVacation,
  formatDateForDisplay,
  isPastDate,
  isSameDay,
  getDayName
} from './scheduleUtils.js';

// Test data
const schoolDays = ['sunday', 'monday', 'thursday', 'friday', 'saturday'];
const vacationPeriods = [
  {
    name: 'Christmas Break 2025',
    start_date: '2025-12-23',
    end_date: '2026-01-02'
  }
];

console.log('🧪 Testing Schedule Utilities\n');

// Test 1: isSchoolDay
console.log('📅 Test 1: isSchoolDay');
const monday = new Date('2025-10-06'); // Monday
const tuesday = new Date('2025-10-07'); // Tuesday
console.log(`  Monday (school day): ${isSchoolDay(monday, schoolDays)}`); // Should be true
console.log(`  Tuesday (not school day): ${isSchoolDay(tuesday, schoolDays)}`); // Should be false
console.log('');

// Test 2: isVacationDay
console.log('📅 Test 2: isVacationDay');
const christmasDay = new Date('2025-12-25');
const regularDay = new Date('2025-10-15');
console.log(`  Christmas Day (vacation): ${isVacationDay(christmasDay, vacationPeriods)}`); // Should be true
console.log(`  Regular day (not vacation): ${isVacationDay(regularDay, vacationPeriods)}`); // Should be false
console.log('');

// Test 3: getNextSchoolDay
console.log('📅 Test 3: getNextSchoolDay');
const startDay = new Date('2025-10-06'); // Monday
const nextDay = getNextSchoolDay(startDay, schoolDays, vacationPeriods);
console.log(`  Next school day after Monday: ${formatDateForDisplay(nextDay)}`); // Should be Thursday
console.log('');

// Test 4: countSchoolDays
console.log('📅 Test 4: countSchoolDays');
const rangeStart = new Date('2025-10-05'); // Sunday
const rangeEnd = new Date('2025-10-11'); // Saturday
const count = countSchoolDays(rangeStart, rangeEnd, schoolDays, vacationPeriods);
console.log(`  School days from Oct 5-11, 2025: ${count}`); // Should be 5 (Sun, Mon, Thu, Fri, Sat)
console.log('');

// Test 5: getSchoolDaysInRange
console.log('📅 Test 5: getSchoolDaysInRange');
const schoolDaysArray = getSchoolDaysInRange(rangeStart, rangeEnd, schoolDays, vacationPeriods);
console.log(`  School days in range:`);
schoolDaysArray.forEach(date => {
  console.log(`    - ${formatDateForDisplay(date)}`);
});
console.log('');

// Test 6: getThanksgivingDate
console.log('📅 Test 6: getThanksgivingDate');
const thanksgiving2025 = getThanksgivingDate(2025);
console.log(`  Thanksgiving 2025: ${formatDateForDisplay(thanksgiving2025)}`); // Should be Nov 27, 2025
console.log('');

// Test 7: getThanksgivingVacation
console.log('📅 Test 7: getThanksgivingVacation');
const thanksgivingVacation = getThanksgivingVacation(2025);
console.log(`  Thanksgiving Vacation 2025:`);
console.log(`    Name: ${thanksgivingVacation.name}`);
console.log(`    Start: ${thanksgivingVacation.start_date}`); // Should be Nov 25 (Tuesday)
console.log(`    End: ${thanksgivingVacation.end_date}`); // Should be Nov 30 (Sunday)
console.log('');

// Test 8: isPastDate
console.log('📅 Test 8: isPastDate');
const pastDate = new Date('2025-01-01');
const futureDate = new Date('2026-01-01');
console.log(`  Jan 1, 2025 is past: ${isPastDate(pastDate)}`); // Should be true
console.log(`  Jan 1, 2026 is past: ${isPastDate(futureDate)}`); // Should be false
console.log('');

// Test 9: isSameDay
console.log('📅 Test 9: isSameDay');
const date1 = new Date('2025-10-05T10:30:00');
const date2 = new Date('2025-10-05T15:45:00');
const date3 = new Date('2025-10-06T10:30:00');
console.log(`  Same day (different times): ${isSameDay(date1, date2)}`); // Should be true
console.log(`  Different days: ${isSameDay(date1, date3)}`); // Should be false
console.log('');

// Test 10: getDayName
console.log('📅 Test 10: getDayName');
const testDate = new Date('2025-10-05'); // Sunday
console.log(`  Oct 5, 2025 is: ${getDayName(testDate)}`); // Should be 'sunday'
console.log('');

// Test 11: Vacation period exclusion in countSchoolDays
console.log('📅 Test 11: Vacation exclusion in counting');
const christmasStart = new Date('2025-12-20'); // Before break
const christmasEnd = new Date('2026-01-05'); // After break
const daysWithVacation = countSchoolDays(christmasStart, christmasEnd, schoolDays, vacationPeriods);
const daysWithoutVacation = countSchoolDays(christmasStart, christmasEnd, schoolDays, []);
console.log(`  School days (with Christmas vacation excluded): ${daysWithVacation}`);
console.log(`  School days (without vacation exclusion): ${daysWithoutVacation}`);
console.log(`  Days excluded by vacation: ${daysWithoutVacation - daysWithVacation}`);
console.log('');

console.log('✅ All tests completed!');
console.log('');
console.log('📋 To run these tests:');
console.log('  1. Open browser console on the app');
console.log('  2. Import and run the test functions');
console.log('  3. Or create a dedicated test page');
