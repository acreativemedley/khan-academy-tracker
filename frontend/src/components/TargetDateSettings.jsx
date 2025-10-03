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
  Chip
} from '@mui/material';
import { supabase } from '../services/supabase';
import { createLocalDate, daysBetween, formatDateForDisplay } from '../utils/dateUtils';

export default function TargetDateSettings() {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [courses, setCourses] = useState([]);
  const [tempDates, setTempDates] = useState({}); // Track temporary input values
  const [result, setResult] = useState('');
  const [error, setError] = useState(null);

  useEffect(() => {
    loadCourses();
  }, []);

  const loadCourses = async () => {
    try {
      const { data, error } = await supabase
        .from('courses')
        .select('id, name, total_activities, target_completion_date')
        .order('name');
      
      if (error) throw error;
      
      setCourses(data);
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
    </Box>
  );
}