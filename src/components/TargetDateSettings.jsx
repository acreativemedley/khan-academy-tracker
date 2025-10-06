import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { 
  Box, 
  Typography, 
  Button, 
  Alert, 
  CircularProgress, 
  TextField,
  Grid,
  Card,
  CardContent,
  Chip,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogContentText,
  DialogActions,
  List,
  ListItem,
  ListItemText
} from '@mui/material';
import CalendarTodayIcon from '@mui/icons-material/CalendarToday';
import WarningIcon from '@mui/icons-material/Warning';
import { supabase } from '../services/supabase';
import { createLocalDate, daysBetween, formatDateForDisplay } from '../utils/dateUtils';
import { calculateSchedule, deleteScheduleForCourse } from '../services/scheduleService';

export default function TargetDateSettings() {
  console.log('TargetDateSettings rendering...');
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [courses, setCourses] = useState([]);
  const [tempDates, setTempDates] = useState({}); // Track temporary input values for target dates
  const [tempStartDates, setTempStartDates] = useState({}); // Track temporary input values for start dates
  const [result, setResult] = useState('');
  const [error, setError] = useState(null);
  const [studentId, setStudentId] = useState(null);
  const [calculatingCourse, setCalculatingCourse] = useState(null);
  const [scheduleResult, setScheduleResult] = useState(null);
  const [confirmDialog, setConfirmDialog] = useState({ open: false, courseId: null, courseName: null });

  useEffect(() => {
    console.log('TargetDateSettings useEffect running...');
    loadStudentId();
    loadCourses();
  }, []);

  const loadStudentId = async () => {
    try {
      console.log('Loading student ID...');
      const { data: { user } } = await supabase.auth.getUser();
      console.log('User:', user);
      if (user) {
        // The student.id IS the auth user.id (FK relationship)
        // Just verify the student record exists
        const { data, error } = await supabase
          .from('students')
          .select('id')
          .eq('id', user.id)
          .single();
        
        console.log('Student query result:', { data, error });
        if (error) {
          console.warn('Student record not found, using auth user ID directly');
          // Use the auth user ID directly even if student record doesn't exist yet
          setStudentId(user.id);
        } else {
          setStudentId(data.id);
          console.log('Student ID set to:', data.id);
        }
      }
    } catch (err) {
      console.error('Error loading student ID:', err);
      setError(`Failed to load student ID: ${err.message}`);
    }
  };

  const loadCourses = async () => {
    try {
      console.log('Loading courses...');
      const { data, error } = await supabase
        .from('courses')
        .select('id, name, total_activities, target_completion_date, start_date')
        .order('name');
      
      console.log('Courses query result:', { data, error });
      if (error) throw error;
      
      setCourses(data || []);
      console.log('Courses loaded:', data?.length);
    } catch (err) {
      console.error('Error loading courses:', err);
      setError(err.message);
    }
  };

  const calculateActivitiesPerDay = (totalActivities, targetDateString) => {
    if (!targetDateString || !totalActivities) return 0;
    
    const today = new Date();
    const targetDate = createLocalDate(targetDateString);
    
    if (!targetDate) return 0;
    
    const diffDays = daysBetween(today, targetDate);
    
    // If target date is in the past, return 0
    if (diffDays <= 0) return 0;
    
    // Assuming 5 school days per week (Sunday, Monday, Thursday, Friday, Saturday)
    const schoolDaysPerWeek = 5;
    const totalWeeks = Math.ceil(diffDays / 7);
    const availableSchoolDays = totalWeeks * schoolDaysPerWeek;
    
    // Account for exam days and review days (estimate based on course structure)
    const estimatedExamDays = Math.ceil(totalActivities / 30); // Rough estimate: 1 exam per 30 activities
    const estimatedReviewDays = estimatedExamDays;
    const effectiveStudyDays = Math.max(1, availableSchoolDays - estimatedExamDays - estimatedReviewDays);
    
    return totalActivities > 0 ? (totalActivities / effectiveStudyDays).toFixed(1) : 0;
  };

  const updateCourseTargetDate = async (courseId, newTargetDate) => {
    if (!newTargetDate) {
      setResult('❌ Please select a target date');
      return;
    }

    try {
      setLoading(true);
      setResult('');
      setError(null);
      
      console.log(`Updating course ${courseId} to target date: ${newTargetDate}`);
      
      const { data, error } = await supabase
        .from('courses')
        .update({ target_completion_date: newTargetDate })
        .eq('id', courseId)
        .select('id, name, target_completion_date');
      
      if (error) {
        console.error('❌ Error updating course:', error);
        throw error;
      }
      
      console.log('✅ Successfully updated course:', data);
      
      // Update local state
      setCourses(prevCourses => 
        prevCourses.map(course => 
          course.id === courseId 
            ? { ...course, target_completion_date: newTargetDate }
            : course
        )
      );
      
      setResult(`✅ Successfully updated target date for ${data[0]?.name || 'course'}`);
      
    } catch (err) {
      console.error('Update error:', err);
      setError(`Failed to update target date: ${err.message}`);
    } finally {
      setLoading(false);
    }
  };

  const updateCourseStartDate = async (courseId, newStartDate) => {
    if (!newStartDate) {
      setResult('❌ Please select a start date');
      return;
    }

    try {
      setLoading(true);
      setResult('');
      setError(null);
      
      console.log(`Updating course ${courseId} to start date: ${newStartDate}`);
      
      const { data, error } = await supabase
        .from('courses')
        .update({ start_date: newStartDate })
        .eq('id', courseId)
        .select('id, name, start_date');
      
      if (error) {
        console.error('❌ Error updating course:', error);
        throw error;
      }
      
      console.log('✅ Successfully updated course:', data);
      
      // Update local state
      setCourses(prevCourses => 
        prevCourses.map(course => 
          course.id === courseId 
            ? { ...course, start_date: newStartDate }
            : course
        )
      );
      
      setResult(`✅ Successfully updated start date for ${data[0]?.name || 'course'}`);
      
    } catch (err) {
      console.error('Update error:', err);
      setError(`Failed to update start date: ${err.message}`);
    } finally {
      setLoading(false);
    }
  };

  const calculateDaysRemaining = (targetDate) => {
    if (!targetDate) return null;
    return daysBetween(new Date(), createLocalDate(targetDate));
  };

  const testDatabaseAccess = async () => {
    try {
      setLoading(true);
      setResult('');
      setError(null);
      
      console.log('Testing database access...');
      
      // Test 1: Can we read courses?
      const { data: readData, error: readError } = await supabase
        .from('courses')
        .select('*');
      
      console.log('Read test:', { data: readData, error: readError });
      
      if (readError) {
        throw new Error(`Read failed: ${readError.message}`);
      }
      
      // Test 2: Can we update a single course? (pick the first one)
      if (readData && readData.length > 0) {
        const testCourse = readData[0];
        console.log('Testing update on:', testCourse.name);
        console.log('Current target date:', testCourse.target_completion_date);
        
        // Try updating with a test date
        const testDate = '2026-06-15'; // Different date to verify change
        
        const { data: updateData, error: updateError } = await supabase
          .from('courses')
          .update({ target_completion_date: testDate })
          .eq('id', testCourse.id)
          .select();
        
        console.log('Update test:', { data: updateData, error: updateError });
        
        if (updateError) {
          throw new Error(`Update failed: ${updateError.message}`);
        }
        
        // Test 3: Read back to verify the change
        const { data: verifyData, error: verifyError } = await supabase
          .from('courses')
          .select('id, name, target_completion_date')
          .eq('id', testCourse.id)
          .single();
        
        console.log('Verification read:', verifyData);
        
        if (verifyError) {
          throw new Error(`Verification failed: ${verifyError.message}`);
        }
        
        const actualDate = verifyData.target_completion_date;
        const expectedDate = testDate;
        
        if (actualDate === expectedDate) {
          setResult(`✅ Database test PASSED! 
Successfully updated ${testCourse.name}
Old date: ${testCourse.target_completion_date}
New date: ${actualDate}
Update is working correctly!`);
        } else {
          setResult(`❌ Database test FAILED!
Expected: ${expectedDate}
Actual: ${actualDate}
Update did not persist to database!`);
        }
        
      } else {
        setResult('❌ No courses found in database');
      }
      
    } catch (err) {
      console.error('Database test error:', err);
      setResult(`❌ Database test failed: ${err.message}`);
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleCalculateSchedule = async (courseId, courseName, hasExistingSchedule = false) => {
    if (!studentId) {
      setError('Student ID not loaded yet. Please refresh the page.');
      return;
    }

    // If there might be an existing schedule, confirm with user
    if (hasExistingSchedule) {
      setConfirmDialog({ open: true, courseId, courseName });
      return;
    }

    await executeCalculateSchedule(courseId, courseName);
  };

  const executeCalculateSchedule = async (courseId, courseName) => {
    try {
      setCalculatingCourse(courseId);
      setScheduleResult(null);
      setError(null);
      
      console.log(`Calculating schedule for course ${courseId} (${courseName})`);
      
      const result = await calculateSchedule(courseId, studentId);
      
      console.log('Schedule calculation result:', result);
      
      if (!result.success) {
        setError(`Failed to calculate schedule: ${result.error}`);
        return;
      }
      
      setScheduleResult({
        courseId,
        courseName,
        totalActivities: result.assignmentsCreated,
        regularActivities: result.regularActivitiesScheduled,
        examActivities: result.examsScheduled,
        availableDays: result.schoolDaysUsed,
        activitiesPerDay: parseFloat(result.averageActivitiesPerDay),
        firstDate: result.startDate,
        lastDate: result.endDate,
        warnings: result.warnings || []
      });
      
    } catch (err) {
      console.error('Schedule calculation error:', err);
      setError(`Failed to calculate schedule: ${err.message}`);
    } finally {
      setCalculatingCourse(null);
      setConfirmDialog({ open: false, courseId: null, courseName: null });
    }
  };

  const handleRecalculate = async () => {
    const { courseId, courseName } = confirmDialog;
    
    try {
      setCalculatingCourse(courseId);
      
      // Delete existing schedule first
      await deleteScheduleForCourse(courseId, studentId);
      
      // Then calculate new schedule
      await executeCalculateSchedule(courseId, courseName);
      
    } catch (err) {
      console.error('Recalculation error:', err);
      setError(`Failed to recalculate schedule: ${err.message}`);
      setCalculatingCourse(null);
      setConfirmDialog({ open: false, courseId: null, courseName: null });
    }
  };

  return (
    <Box sx={{ p: 3 }}>
      <Typography variant="h4" gutterBottom>
        Target Date Settings
      </Typography>
      
      <Typography variant="body1" color="text.secondary" sx={{ mb: 3 }}>
        Set individual target completion dates for each course to calculate daily activity goals.
      </Typography>

      {error && (
        <Alert severity="error" sx={{ mb: 2 }}>
          {error}
        </Alert>
      )}

      {courses.length === 0 && !error && (
        <Box sx={{ display: 'flex', justifyContent: 'center', p: 4 }}>
          <CircularProgress />
        </Box>
      )}

      <Grid container spacing={3}>
        {courses.map((course) => (
          <Grid item xs={12} md={6} key={course.id}>
            <Card>
              <CardContent>
                <Typography variant="h6" gutterBottom>
                  {course.name}
                </Typography>
                <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                  {course.total_activities} activities
                </Typography>
                
                <TextField
                  label="Start Date"
                  type="date"
                  value={tempStartDates[course.id] !== undefined ? tempStartDates[course.id] : (course.start_date || '')}
                  onChange={(e) => {
                    setTempStartDates(prev => ({
                      ...prev,
                      [course.id]: e.target.value
                    }));
                  }}
                  onBlur={(e) => {
                    const newDate = e.target.value;
                    if (newDate !== course.start_date) {
                      updateCourseStartDate(course.id, newDate);
                    }
                    // Clear temp state after update
                    setTempStartDates(prev => {
                      const updated = { ...prev };
                      delete updated[course.id];
                      return updated;
                    });
                  }}
                  fullWidth
                  sx={{ mb: 2 }}
                  InputLabelProps={{
                    shrink: true,
                  }}
                  disabled={loading}
                />
                
                <TextField
                  label="Target Completion Date"
                  type="date"
                  value={tempDates[course.id] !== undefined ? tempDates[course.id] : (course.target_completion_date || '')}
                  onChange={(e) => {
                    setTempDates(prev => ({
                      ...prev,
                      [course.id]: e.target.value
                    }));
                  }}
                  onBlur={(e) => {
                    const newDate = e.target.value;
                    if (newDate !== course.target_completion_date) {
                      updateCourseTargetDate(course.id, newDate);
                    }
                    // Clear temp state after update
                    setTempDates(prev => {
                      const updated = { ...prev };
                      delete updated[course.id];
                      return updated;
                    });
                  }}
                  fullWidth
                  sx={{ mb: 2 }}
                  InputLabelProps={{
                    shrink: true,
                  }}
                  disabled={loading}
                />
                
                {course.target_completion_date && (
                  <Box sx={{ mb: 2 }}>
                    <Chip 
                      label={`${calculateDaysRemaining(course.target_completion_date)} days remaining`}
                      color={calculateDaysRemaining(course.target_completion_date) > 0 ? "primary" : "error"}
                      variant="outlined"
                      sx={{ mr: 1 }}
                    />
                    <Chip 
                      label={`~${calculateActivitiesPerDay(course.total_activities, course.target_completion_date)} activities/day`}
                      color="secondary"
                      variant="outlined"
                    />
                  </Box>
                )}

                {course.target_completion_date && course.start_date && studentId && (
                  <Button
                    variant="contained"
                    color="primary"
                    startIcon={calculatingCourse === course.id ? <CircularProgress size={20} /> : <CalendarTodayIcon />}
                    onClick={() => handleCalculateSchedule(course.id, course.name, true)}
                    disabled={calculatingCourse !== null}
                    fullWidth
                  >
                    {calculatingCourse === course.id ? 'Calculating...' : 'Calculate Schedule'}
                  </Button>
                )}

                {(!course.target_completion_date || !course.start_date) && (
                  <Alert severity="warning" sx={{ mt: 2 }}>
                    {!course.start_date && !course.target_completion_date 
                      ? 'Set both start and target dates to calculate schedule'
                      : !course.start_date 
                        ? 'Set a start date to calculate schedule'
                        : 'Set a target date to calculate schedule'
                    }
                  </Alert>
                )}
              </CardContent>
            </Card>
          </Grid>
        ))}
      </Grid>

      {result && (
        <Alert 
          severity={result.includes('✅') ? 'success' : 'error'} 
          sx={{ mt: 3 }}
          action={
            result.includes('✅') ? (
              <Button 
                color="inherit" 
                size="small" 
                onClick={() => navigate('/')}
              >
                View Dashboard
              </Button>
            ) : null
          }
        >
          {result}
        </Alert>
      )}

      {scheduleResult && (
        <Alert 
          severity={scheduleResult.warnings?.length > 0 ? 'warning' : 'success'} 
          sx={{ mt: 3 }}
          onClose={() => setScheduleResult(null)}
        >
          <Typography variant="h6" gutterBottom>
            ✅ Schedule Calculated: {scheduleResult.courseName}
          </Typography>
          
          <Typography variant="body2" gutterBottom>
            <strong>Total Activities:</strong> {scheduleResult.totalActivities}
          </Typography>
          <Typography variant="body2" gutterBottom>
            <strong>Regular Activities:</strong> {scheduleResult.regularActivities}
          </Typography>
          <Typography variant="body2" gutterBottom>
            <strong>Exam Activities:</strong> {scheduleResult.examActivities}
          </Typography>
          <Typography variant="body2" gutterBottom>
            <strong>School Days Available:</strong> {scheduleResult.availableDays}
          </Typography>
          <Typography variant="body2" gutterBottom>
            <strong>Daily Target:</strong> {scheduleResult.activitiesPerDay?.toFixed(2)} activities/day
          </Typography>
          <Typography variant="body2" gutterBottom>
            <strong>First Activity:</strong> {formatDateForDisplay(scheduleResult.firstDate)}
          </Typography>
          <Typography variant="body2" gutterBottom>
            <strong>Last Activity:</strong> {formatDateForDisplay(scheduleResult.lastDate)}
          </Typography>

          {scheduleResult.warnings?.length > 0 && (
            <Box sx={{ mt: 2 }}>
              <Typography variant="subtitle2" color="warning.main" sx={{ display: 'flex', alignItems: 'center', mb: 1 }}>
                <WarningIcon sx={{ mr: 1 }} /> Warnings:
              </Typography>
              <List dense>
                {scheduleResult.warnings.map((warning, index) => (
                  <ListItem key={index}>
                    <ListItemText primary={warning} />
                  </ListItem>
                ))}
              </List>
            </Box>
          )}

          <Button 
            variant="outlined" 
            size="small" 
            onClick={() => navigate(`/courses/${scheduleResult.courseId}`)}
            sx={{ mt: 2 }}
          >
            View Course Schedule
          </Button>
        </Alert>
      )}

      {/* Confirmation Dialog for Recalculation */}
      <Dialog
        open={confirmDialog.open}
        onClose={() => setConfirmDialog({ open: false, courseId: null, courseName: null })}
      >
        <DialogTitle>Recalculate Schedule?</DialogTitle>
        <DialogContent>
          <DialogContentText>
            This will delete the existing schedule for <strong>{confirmDialog.courseName}</strong> and create a new one.
          </DialogContentText>
          <DialogContentText sx={{ mt: 2 }}>
            <strong>Note:</strong> Any manual date overrides you've made will be lost. Incomplete activities will be rescheduled to new dates.
          </DialogContentText>
          <DialogContentText sx={{ mt: 2 }}>
            Are you sure you want to continue?
          </DialogContentText>
        </DialogContent>
        <DialogActions>
          <Button 
            onClick={() => setConfirmDialog({ open: false, courseId: null, courseName: null })}
            color="inherit"
          >
            Cancel
          </Button>
          <Button 
            onClick={handleRecalculate}
            color="primary"
            variant="contained"
            autoFocus
          >
            Recalculate Schedule
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
}