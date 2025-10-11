import React, { useState, useEffect } from 'react';
import {
  Box,
  Card,
  CardContent,
  Typography,
  Button,
  Alert,
  CircularProgress,
  Grid,
  Chip,
  List,
  ListItem,
  ListItemText,
  Divider,
  Paper
} from '@mui/material';
import { supabase } from '../services/supabase';
import { getCurrentLocalTimestamp } from '../utils/dateUtils';

const TestStudentProfile = () => {
  const [loading, setLoading] = useState(false);
  const [testResults, setTestResults] = useState({});
  const [studentProfile, setStudentProfile] = useState(null);
  const [courses, setCourses] = useState([]);
  const [activities, setActivities] = useState([]);
  const [progressRecords, setProgressRecords] = useState([]);
  const [error, setError] = useState(null);

  // Test 1: Get authenticated user and create/verify student profile
  const testStudentProfile = async () => {
    try {
      setLoading(true);
      setError(null);

      // Get current authenticated user
      const { data: { user }, error: authError } = await supabase.auth.getUser();
      
      if (authError || !user) {
        throw new Error('No authenticated user found. Please create an account first.');
      }

      console.log('✅ Authenticated user found:', user.id);

      // Check if student profile already exists
      const { data: existingStudent, error: fetchError } = await supabase
        .from('students')
        .select('*')
        .eq('id', user.id)
        .single();

      if (fetchError && fetchError.code !== 'PGRST116') {
        throw new Error(`Error checking student profile: ${fetchError.message}`);
      }

      if (existingStudent) {
        console.log('✅ Student profile already exists:', existingStudent);
        setStudentProfile(existingStudent);
        setTestResults(prev => ({ 
          ...prev, 
          studentProfile: { 
            status: 'success', 
            message: 'Student profile found', 
            data: existingStudent 
          } 
        }));
      } else {
        // Create student profile using the authenticated user ID
        const newStudent = {
          id: user.id,
          display_name: user.user_metadata?.display_name || user.email?.split('@')[0] || 'Test Student',
          student_email: user.email,
          grade_level: '10th Grade',
          parent_email: user.email,
          timezone: 'America/Chicago',
          school_days: ['sunday', 'monday', 'thursday', 'friday', 'saturday']
          // Removed daily_goal_minutes - this system is activity-based, not time-based
        };

        const { data: createdStudent, error: createError } = await supabase
          .from('students')
          .insert([newStudent])
          .select()
          .single();

        if (createError) {
          throw new Error(`Error creating student profile: ${createError.message}`);
        }

        console.log('✅ Student profile created:', createdStudent);
        setStudentProfile(createdStudent);
        setTestResults(prev => ({ 
          ...prev, 
          studentProfile: { 
            status: 'success', 
            message: 'Student profile created successfully', 
            data: createdStudent 
          } 
        }));
      }

    } catch (err) {
      console.error('❌ Student profile test failed:', err);
      setTestResults(prev => ({ 
        ...prev, 
        studentProfile: { 
          status: 'error', 
          message: err.message 
        } 
      }));
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  // Test 2: Fetch courses from database
  const testCourseData = async () => {
    try {
      setLoading(true);

      const { data: coursesData, error: coursesError } = await supabase
        .from('courses')
        .select('*')
        .order('name');

      if (coursesError) {
        throw new Error(`Error fetching courses: ${coursesError.message}`);
      }

      console.log('✅ Courses fetched:', coursesData);
      setCourses(coursesData);
      setTestResults(prev => ({ 
        ...prev, 
        courseData: { 
          status: 'success', 
          message: `Found ${coursesData.length} courses`, 
          data: coursesData 
        } 
      }));

    } catch (err) {
      console.error('❌ Course data test failed:', err);
      setTestResults(prev => ({ 
        ...prev, 
        courseData: { 
          status: 'error', 
          message: err.message 
        } 
      }));
    } finally {
      setLoading(false);
    }
  };

  // Test 3: Fetch activities from database (especially Math Unit 1)
  const testActivityData = async () => {
    try {
      setLoading(true);

      const { data: activitiesData, error: activitiesError } = await supabase
        .from('activities')
        .select(`
          *,
          courses (name),
          units (title, unit_number)
        `)
        .order('order_index');

      if (activitiesError) {
        throw new Error(`Error fetching activities: ${activitiesError.message}`);
      }

      console.log('✅ Activities fetched:', activitiesData);
      setActivities(activitiesData);
      
      const mathUnit1Activities = activitiesData.filter(
        activity => activity.courses?.name?.includes('Math') && 
                   activity.units?.unit_number === 1
      );

      setTestResults(prev => ({ 
        ...prev, 
        activityData: { 
          status: 'success', 
          message: `Found ${activitiesData.length} total activities, ${mathUnit1Activities.length} in Math Unit 1`, 
          data: { total: activitiesData.length, mathUnit1: mathUnit1Activities.length }
        } 
      }));

    } catch (err) {
      console.error('❌ Activity data test failed:', err);
      setTestResults(prev => ({ 
        ...prev, 
        activityData: { 
          status: 'error', 
          message: err.message 
        } 
      }));
    } finally {
      setLoading(false);
    }
  };

  // Test 4: Test progress tracking functionality
  const testProgressTracking = async () => {
    try {
      setLoading(true);

      // Get current authenticated user directly
      const { data: { user }, error: authError } = await supabase.auth.getUser();
      
      if (authError || !user) {
        throw new Error('No authenticated user found for progress tracking test');
      }

      // Get student profile directly
      const { data: currentStudent, error: studentError } = await supabase
        .from('students')
        .select('*')
        .eq('id', user.id)
        .single();

      if (studentError) {
        throw new Error(`Error fetching student for progress test: ${studentError.message}`);
      }

      // Get activities directly
      const { data: currentActivities, error: activitiesError } = await supabase
        .from('activities')
        .select(`
          *,
          courses (name),
          units (title, unit_number)
        `)
        .order('order_index');

      if (activitiesError) {
        throw new Error(`Error fetching activities for progress test: ${activitiesError.message}`);
      }

      // Get first Math Unit 1 activity for testing
      const mathActivity = currentActivities.find(
        activity => activity.courses?.name?.includes('Math') && 
                   activity.units?.unit_number === 1
      );

      if (!mathActivity) {
        throw new Error('No Math Unit 1 activities found for testing');
      }

      // Check existing progress
      const { data: existingProgress, error: fetchProgressError } = await supabase
        .from('progress_tracking')
        .select('*')
        .eq('student_id', currentStudent.id)
        .eq('activity_id', mathActivity.id);

      if (fetchProgressError) {
        throw new Error(`Error checking progress: ${fetchProgressError.message}`);
      }

      if (existingProgress.length > 0) {
        console.log('✅ Progress tracking data exists:', existingProgress);
        setProgressRecords(existingProgress);
        setTestResults(prev => ({ 
          ...prev, 
          progressTracking: { 
            status: 'success', 
            message: `Found ${existingProgress.length} progress records`, 
            data: existingProgress 
          } 
        }));
      } else {
        // Create a test progress record
        const testProgress = {
          student_id: currentStudent.id,
          activity_id: mathActivity.id,
          course_id: mathActivity.course_id,
          completed: true,
          completion_date: getCurrentLocalTimestamp(),
          notes: 'Test progress record created by TestStudentProfile component'
        };

        const { data: createdProgress, error: createProgressError } = await supabase
          .from('progress_tracking')
          .insert([testProgress])
          .select()
          .single();

        if (createProgressError) {
          throw new Error(`Error creating progress record: ${createProgressError.message}`);
        }

        console.log('✅ Test progress record created:', createdProgress);
        setProgressRecords([createdProgress]);
        setTestResults(prev => ({ 
          ...prev, 
          progressTracking: { 
            status: 'success', 
            message: 'Test progress record created successfully', 
            data: createdProgress 
          } 
        }));
      }

    } catch (err) {
      console.error('❌ Progress tracking test failed:', err);
      setTestResults(prev => ({ 
        ...prev, 
        progressTracking: { 
          status: 'error', 
          message: err.message 
        } 
      }));
    } finally {
      setLoading(false);
    }
  };

  // Run all tests
  const runAllTests = async () => {
    setTestResults({});
    setError(null);
    
    await testStudentProfile();
    await testCourseData();
    await testActivityData();
    await testProgressTracking();
  };

  const getStatusIcon = (status) => {
    switch (status) {
      case 'success': return '✅';
      case 'error': return '❌';
      default: return '⏳';
    }
  };

  const getStatusColor = (status) => {
    switch (status) {
      case 'success': return 'success';
      case 'error': return 'error';
      default: return 'info';
    }
  };

  return (
    <Box sx={{ p: 3 }}>
      <Typography variant="h4" gutterBottom>
        Test Student Profile & Data Connection
      </Typography>
      
      <Typography variant="body1" sx={{ mb: 3 }}>
        This test verifies that the authentication system, student profile creation, 
        and data connection are all working properly with the existing database.
      </Typography>

      <Button 
        variant="contained" 
        onClick={runAllTests}
        disabled={loading}
        sx={{ mb: 3 }}
      >
        {loading ? <CircularProgress size={24} /> : 'Run All Tests'}
      </Button>

      {error && (
        <Alert severity="error" sx={{ mb: 3 }}>
          {error}
        </Alert>
      )}

      <Grid container spacing={3}>
        {/* Test Results Summary */}
        <Grid item xs={12}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Test Results Summary
              </Typography>
              <List>
                {Object.entries(testResults).map(([testName, result]) => (
                  <ListItem key={testName}>
                    <ListItemText
                      primary={
                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                          <Typography component="span">
                            {getStatusIcon(result.status)} {testName.replace(/([A-Z])/g, ' $1').replace(/^./, str => str.toUpperCase())}
                          </Typography>
                          <Chip 
                            label={result.status} 
                            color={getStatusColor(result.status)}
                            size="small"
                          />
                        </Box>
                      }
                      secondary={result.message}
                    />
                  </ListItem>
                ))}
              </List>
            </CardContent>
          </Card>
        </Grid>

        {/* Student Profile Details */}
        {studentProfile && (
          <Grid item xs={12} md={6}>
            <Card>
              <CardContent>
                <Typography variant="h6" gutterBottom>
                  Student Profile Details
                </Typography>
                <Typography><strong>ID:</strong> {studentProfile.id}</Typography>
                <Typography><strong>Name:</strong> {studentProfile.display_name}</Typography>
                <Typography><strong>Email:</strong> {studentProfile.student_email}</Typography>
                <Typography><strong>Grade:</strong> {studentProfile.grade_level}</Typography>
                <Typography><strong>Timezone:</strong> {studentProfile.timezone}</Typography>
                <Typography><strong>School Days:</strong> {studentProfile.school_days?.join(', ')}</Typography>
              </CardContent>
            </Card>
          </Grid>
        )}

        {/* Course Data Summary */}
        {courses.length > 0 && (
          <Grid item xs={12} md={6}>
            <Card>
              <CardContent>
                <Typography variant="h6" gutterBottom>
                  Available Courses ({courses.length})
                </Typography>
                {courses.map((course) => (
                  <Paper key={course.id} elevation={1} sx={{ p: 2, mb: 1 }}>
                    <Typography variant="subtitle2">{course.name}</Typography>
                    <Typography variant="body2" color="text.secondary">
                      Activities: {course.total_activities} | Units: {course.total_units}
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                      Status: {course.status}
                    </Typography>
                  </Paper>
                ))}
              </CardContent>
            </Card>
          </Grid>
        )}

        {/* Activity Data Summary */}
        {activities.length > 0 && (
          <Grid item xs={12}>
            <Card>
              <CardContent>
                <Typography variant="h6" gutterBottom>
                  Activity Data Summary
                </Typography>
                <Typography variant="body1" sx={{ mb: 2 }}>
                  Total Activities: {activities.length}
                </Typography>
                
                {/* Math Unit 1 Activities */}
                {activities.filter(a => a.courses?.name?.includes('Math') && a.units?.unit_number === 1).length > 0 && (
                  <Box sx={{ mb: 2 }}>
                    <Typography variant="subtitle1" gutterBottom>
                      Math Unit 1 Activities ({activities.filter(a => a.courses?.name?.includes('Math') && a.units?.unit_number === 1).length})
                    </Typography>
                    <List dense>
                      {activities
                        .filter(a => a.courses?.name?.includes('Math') && a.units?.unit_number === 1)
                        .slice(0, 5)
                        .map((activity) => (
                          <ListItem key={activity.id}>
                            <ListItemText
                              primary={activity.activity_name}
                              secondary={`${activity.activity_type} | ${activity.lesson_name}`}
                            />
                          </ListItem>
                        ))}
                      {activities.filter(a => a.courses?.name?.includes('Math') && a.units?.unit_number === 1).length > 5 && (
                        <Typography variant="body2" color="text.secondary" sx={{ pl: 2 }}>
                          ... and {activities.filter(a => a.courses?.name?.includes('Math') && a.units?.unit_number === 1).length - 5} more
                        </Typography>
                      )}
                    </List>
                  </Box>
                )}
              </CardContent>
            </Card>
          </Grid>
        )}

        {/* Progress Tracking Results */}
        {progressRecords.length > 0 && (
          <Grid item xs={12}>
            <Card>
              <CardContent>
                <Typography variant="h6" gutterBottom>
                  Progress Tracking Test Results
                </Typography>
                {progressRecords.map((progress) => (
                  <Paper key={progress.id} elevation={1} sx={{ p: 2, mb: 1 }}>
                    <Typography><strong>Activity ID:</strong> {progress.activity_id}</Typography>
                    <Typography><strong>Completed:</strong> {progress.completed ? 'Yes' : 'No'}</Typography>
                    <Typography><strong>Completion Date:</strong> {progress.completion_date ? new Date(progress.completion_date).toLocaleDateString() : 'N/A'}</Typography>
                    <Typography><strong>Notes:</strong> {progress.notes || 'None'}</Typography>
                  </Paper>
                ))}
              </CardContent>
            </Card>
          </Grid>
        )}
      </Grid>
    </Box>
  );
};

export default TestStudentProfile;