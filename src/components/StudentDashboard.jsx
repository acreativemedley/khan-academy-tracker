import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Container,
  Grid,
  Card,
  CardContent,
  Typography,
  Box,
  LinearProgress,
  Chip,
  Alert,
  CircularProgress,
  Button,
  CardActions
} from '@mui/material';
import { supabase } from '../services/supabase';
import { createLocalDate, daysBetween, getDaysRemaining, formatDateForDisplay, formatDateForDB } from '../utils/dateUtils';

const StudentDashboard = () => {
  const navigate = useNavigate();
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [todayActivities, setTodayActivities] = useState([]);
  const [user, setUser] = useState(null);

  const calculateActivitiesPerDay = (course) => {
    if (!course.target_completion_date || !course.total_activities) return 0;
    
    const today = new Date();
    const targetDate = createLocalDate(course.target_completion_date);
    
    if (!targetDate) return 0;
    
    const diffDays = daysBetween(today, targetDate);
    
    // If target date is in the past, return 0
    if (diffDays <= 0) return 0;
    
    // Assuming 5 school days per week (Sunday, Monday, Thursday, Friday, Saturday)
    const schoolDaysPerWeek = 5;
    const totalWeeks = Math.ceil(diffDays / 7);
    const availableSchoolDays = totalWeeks * schoolDaysPerWeek;
    
    // Account for exam days and review days (estimate based on course structure)
    const estimatedExamDays = Math.ceil(course.total_activities / 30); // Rough estimate: 1 exam per 30 activities
    const estimatedReviewDays = estimatedExamDays;
    const effectiveStudyDays = Math.max(1, availableSchoolDays - estimatedExamDays - estimatedReviewDays);
    
    return course.total_activities > 0 ? (course.total_activities / effectiveStudyDays) : 0;
  };

  useEffect(() => {
    getCurrentUser();
  }, []);

  useEffect(() => {
    if (user) {
      fetchDashboardData();
    }
  }, [user]);

  const getCurrentUser = async () => {
    try {
      const { data: { user }, error } = await supabase.auth.getUser();
      if (error) throw error;
      setUser(user);
    } catch (err) {
      console.error('Error getting user:', err);
      setError('Authentication error');
      setLoading(false);
    }
  };

  const fetchDashboardData = async () => {
    try {
      setLoading(true);
      
      if (!user) {
        setError('No authenticated user');
        setLoading(false);
        return;
      }
      
      // Fetch courses with progress
      const { data: coursesData, error: coursesError } = await supabase
        .from('courses')
        .select(`
          id,
          name,
          total_activities,
          target_completion_date,
          created_at
        `);

      if (coursesError) throw coursesError;

      // For each course, calculate progress and today's activities
      const coursesWithProgress = await Promise.all(
        coursesData.map(async (course) => {
          // Get completed activities count for this student
          const { count: completedCount, error: progressError } = await supabase
            .from('progress_tracking')
            .select('*', { count: 'exact' })
            .eq('student_id', user.id)
            .eq('course_id', course.id)
            .eq('completed', true);

          if (progressError) {
            console.error('Progress error:', progressError);
          }

          // Calculate progress percentage
          const progressPercentage = course.total_activities > 0 
            ? Math.round((completedCount || 0) / course.total_activities * 100)
            : 0;

          // Get today's scheduled activities for this course
          const today = new Date();
          today.setHours(0, 0, 0, 0);
          const todayString = formatDateForDB(today);
          const { data: todayActivitiesData, error: scheduleError } = await supabase
            .from('schedule')
            .select(`
              id,
              scheduled_date,
              is_exam_day,
              is_review_day,
              activities!inner(
                id,
                activity_name,
                activity_type
              )
            `)
            .eq('course_id', course.id)
            .eq('scheduled_date', todayString);

          if (scheduleError) {
            console.error('Schedule error:', scheduleError);
          }

          return {
            ...course,
            completedActivities: completedCount || 0,
            progressPercentage,
            todayActivities: todayActivitiesData || [],
            activitiesPerDay: calculateActivitiesPerDay(course)
          };
        })
      );

      setCourses(coursesWithProgress);
      
      // Combine all today's activities
      const allTodayActivities = coursesWithProgress.flatMap(course => 
        course.todayActivities.map(activity => ({
          ...activity,
          courseName: course.name
        }))
      );
      setTodayActivities(allTodayActivities);

    } catch (err) {
      console.error('Dashboard error:', err);
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const getProgressColor = (percentage) => {
    if (percentage >= 80) return 'success';
    if (percentage >= 60) return 'info';
    if (percentage >= 40) return 'warning';
    return 'error';
  };

  const formatDaysUntilTarget = (targetDate) => {
    if (!targetDate) return 'No target date set';
    
    const daysRemaining = getDaysRemaining(targetDate);
    
    if (daysRemaining === null) return 'Invalid target date';
    if (daysRemaining < 0) return `${Math.abs(daysRemaining)} days overdue`;
    if (daysRemaining === 0) return 'Due today!';
    return `${daysRemaining} days remaining`;
  };

  if (loading) {
    return (
      <Container maxWidth="lg" sx={{ mt: 4, display: 'flex', justifyContent: 'center' }}>
        <CircularProgress />
      </Container>
    );
  }

  if (error) {
    return (
      <Container maxWidth="lg" sx={{ mt: 4 }}>
        <Alert severity="error">
          Error loading dashboard: {error}
        </Alert>
      </Container>
    );
  }

  return (
    <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
      {/* Header */}
      <Box sx={{ mb: 4 }}>
        <Typography variant="h4" component="h1" gutterBottom>
          Student Dashboard
        </Typography>
      </Box>

      {/* Today's Activities Summary */}
      <Card sx={{ mb: 4 }}>
        <CardContent>
          <Typography variant="h6" gutterBottom>
            Today's Schedule - {new Date().toLocaleDateString()}
          </Typography>
          {todayActivities.length === 0 ? (
            <Typography color="text.secondary">
              No activities scheduled for today
            </Typography>
          ) : (
            <Grid container spacing={2}>
              {todayActivities.map((activity, index) => (
                <Grid item xs={12} sm={6} md={4} key={index}>
                  <Box sx={{ p: 2, border: 1, borderColor: 'divider', borderRadius: 1 }}>
                    <Typography variant="subtitle2" color="primary">
                      {activity.courseName}
                    </Typography>
                    <Typography variant="body2">
                      {activity.activities.activity_name}
                    </Typography>
                    <Box sx={{ mt: 1 }}>
                      <Chip 
                        label={activity.activities.activity_type} 
                        size="small" 
                        variant="outlined"
                      />
                      {activity.is_exam_day && (
                        <Chip 
                          label="EXAM DAY" 
                          size="small" 
                          color="error" 
                          sx={{ ml: 1 }}
                        />
                      )}
                      {activity.is_review_day && (
                        <Chip 
                          label="REVIEW" 
                          size="small" 
                          color="warning" 
                          sx={{ ml: 1 }}
                        />
                      )}
                    </Box>
                  </Box>
                </Grid>
              ))}
            </Grid>
          )}
        </CardContent>
      </Card>

      {/* Course Progress Cards */}
      <Grid container spacing={3}>
        {courses.map((course) => (
          <Grid item xs={12} md={6} key={course.id}>
            <Card sx={{ height: '100%' }}>
              <CardContent>
                <Typography variant="h6" component="h2" gutterBottom>
                  {course.name}
                </Typography>
                
                {/* Progress Bar */}
                <Box sx={{ mb: 2 }}>
                  <Box sx={{ display: 'flex', alignItems: 'center', mb: 1 }}>
                    <Typography variant="body2" color="text.secondary" sx={{ mr: 1 }}>
                      Progress:
                    </Typography>
                    <Typography variant="body2" fontWeight="bold">
                      {course.completedActivities} / {course.total_activities} activities
                    </Typography>
                  </Box>
                  <LinearProgress
                    variant="determinate"
                    value={course.progressPercentage}
                    color={getProgressColor(course.progressPercentage)}
                    sx={{ height: 8, borderRadius: 1 }}
                  />
                  <Typography variant="body2" color="text.secondary" sx={{ mt: 0.5 }}>
                    {course.progressPercentage}% complete
                  </Typography>
                </Box>

                {/* Course Stats */}
                <Box sx={{ mb: 2 }}>
                  <Typography variant="body2" color="text.secondary">
                    Daily Target: {course.activitiesPerDay?.toFixed(1)} activities/day
                  </Typography>
                  <Typography variant="body2" color="text.secondary">
                    {formatDaysUntilTarget(course.target_completion_date)}
                  </Typography>
                </Box>

                {/* Today's Activities for this course */}
                <Box>
                  <Typography variant="subtitle2" gutterBottom>
                    Today's Activities ({course.todayActivities.length})
                  </Typography>
                  {course.todayActivities.length === 0 ? (
                    <Typography variant="body2" color="text.secondary">
                      No activities scheduled
                    </Typography>
                  ) : (
                    course.todayActivities.slice(0, 3).map((activity, index) => (
                      <Typography key={index} variant="body2" sx={{ mb: 0.5 }}>
                        • {activity.activities.activity_name}
                      </Typography>
                    ))
                  )}
                  {course.todayActivities.length > 3 && (
                    <Typography variant="body2" color="text.secondary">
                      +{course.todayActivities.length - 3} more...
                    </Typography>
                  )}
                </Box>
              </CardContent>
              <CardActions>
                <Button 
                  size="small" 
                  variant="contained"
                  onClick={() => navigate(`/courses/${course.id}`)}
                >
                  View Course
                </Button>
                <Button 
                  size="small" 
                  variant="outlined"
                  onClick={fetchDashboardData}
                >
                  Refresh
                </Button>
              </CardActions>
            </Card>
          </Grid>
        ))}
      </Grid>

      {/* Overall Progress Summary */}
      <Card sx={{ mt: 4 }}>
        <CardContent>
          <Typography variant="h6" gutterBottom>
            Overall Progress Summary
          </Typography>
          <Grid container spacing={3}>
            <Grid item xs={6} sm={3}>
              <Typography variant="h4" color="primary">
                {courses.reduce((sum, course) => sum + course.completedActivities, 0)}
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Total Completed
              </Typography>
            </Grid>
            <Grid item xs={6} sm={3}>
              <Typography variant="h4" color="primary">
                {courses.reduce((sum, course) => sum + course.total_activities, 0)}
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Total Activities
              </Typography>
            </Grid>
            <Grid item xs={6} sm={3}>
              <Typography variant="h4" color="primary">
                {courses.length > 0 ? 
                  Math.round(
                    courses.reduce((sum, course) => sum + course.progressPercentage, 0) / courses.length
                  ) : 0
                }%
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Average Progress
              </Typography>
            </Grid>
            <Grid item xs={6} sm={3}>
              <Typography variant="h4" color="primary">
                {todayActivities.length}
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Today's Tasks
              </Typography>
            </Grid>
          </Grid>
        </CardContent>
      </Card>
    </Container>
  );
};

export default StudentDashboard;