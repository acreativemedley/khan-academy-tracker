import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import {
  Container,
  Card,
  CardContent,
  Typography,
  Box,
  LinearProgress,
  Grid,
  Accordion,
  AccordionSummary,
  AccordionDetails,
  Checkbox,
  FormControlLabel,
  Chip,
  Button,
  Alert,
  CircularProgress,
  List,
  ListItem,
  ListItemText,
  ListItemIcon
} from '@mui/material';
import {
  ExpandMore as ExpandMoreIcon,
  PlayCircleOutline as VideoIcon,
  Article as ArticleIcon,
  Quiz as QuizIcon,
  Assignment as ExerciseIcon,
  School as ExamIcon
} from '@mui/icons-material';
import { supabase } from '../services/supabase';
import { getTodayString, createLocalDate } from '../utils/dateUtils';

const CourseDetail = () => {
  const { courseId } = useParams();
  const [course, setCourse] = useState(null);
  const [units, setUnits] = useState([]);
  const [activities, setActivities] = useState([]);
  const [progress, setProgress] = useState({});
  const [schedule, setSchedule] = useState({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [user, setUser] = useState(null);

  const calculateActivitiesPerDay = (course) => {
    if (!course.target_completion_date) return 0;
    
    const today = new Date();
    const targetDate = new Date(course.target_completion_date);
    const diffTime = targetDate - today;
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    
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
    if (courseId && user) {
      fetchCourseData();
    }
  }, [courseId, user]);

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

  const fetchCourseData = async () => {
    try {
      setLoading(true);

      if (!user) {
        setError('No authenticated user');
        setLoading(false);
        return;
      }

      // Fetch course details
      const { data: courseData, error: courseError } = await supabase
        .from('courses')
        .select('*')
        .eq('id', courseId)
        .single();

      if (courseError) throw courseError;
      setCourse(courseData);

      // Fetch units for this course
      const { data: unitsData, error: unitsError } = await supabase
        .from('units')
        .select('*')
        .eq('course_id', courseId)
        .order('unit_number');

      if (unitsError) throw unitsError;
      setUnits(unitsData);

      // Fetch activities for this course
      const { data: activitiesData, error: activitiesError } = await supabase
        .from('activities')
        .select('*')
        .eq('course_id', courseId)
        .order('unit_id, order_index');

      if (activitiesError) throw activitiesError;
      setActivities(activitiesData);

      // Fetch progress for this course and this student
      const { data: progressData, error: progressError } = await supabase
        .from('progress_tracking')
        .select('*')
        .eq('course_id', courseId)
        .eq('student_id', user.id);

      if (progressError) throw progressError;

      // Convert progress array to object keyed by activity_id
      const progressMap = {};
      progressData.forEach(p => {
        progressMap[p.activity_id] = p;
      });
      setProgress(progressMap);

      // Fetch schedule for this course and this student
      const { data: scheduleData, error: scheduleError } = await supabase
        .from('schedule')
        .select('*')
        .eq('course_id', courseId)
        .eq('student_id', user.id);

      if (scheduleError) throw scheduleError;

      // Convert schedule array to object keyed by activity_id
      const scheduleMap = {};
      scheduleData.forEach(s => {
        scheduleMap[s.activity_id] = s;
      });
      setSchedule(scheduleMap);

    } catch (err) {
      console.error('Course detail error:', err);
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleActivityComplete = async (activity, completed) => {
    try {
      if (!user) {
        alert('Authentication required');
        return;
      }

      if (completed) {
        // Insert or update progress record with student ID
        const { error } = await supabase
          .from('progress_tracking')
          .upsert({
            student_id: user.id,
            course_id: courseId,
            activity_id: activity.id,
            completed: true,
            completion_date: new Date().toISOString()
          });

        if (error) throw error;
      } else {
        // Remove progress record for this student and activity
        const { error } = await supabase
          .from('progress_tracking')
          .delete()
          .eq('activity_id', activity.id)
          .eq('student_id', user.id);

        if (error) throw error;
      }

      // Update local progress state
      setProgress(prev => ({
        ...prev,
        [activity.id]: completed ? {
          student_id: user.id,
          course_id: courseId,
          activity_id: activity.id,
          completed: true,
          completion_date: new Date().toISOString()
        } : undefined
      }));

    } catch (err) {
      console.error('Error updating progress:', err);
      alert('Error updating progress: ' + err.message);
    }
  };

  const getActivityIcon = (activityType) => {
    switch (activityType) {
      case 'video': return <VideoIcon color="primary" />;
      case 'article': return <ArticleIcon color="info" />;
      case 'quiz': return <QuizIcon color="warning" />;
      case 'exercise': return <ExerciseIcon color="success" />;
      case 'test': return <ExamIcon color="error" />;
      default: return <ExerciseIcon />;
    }
  };

  const isActivityOverdue = (activity) => {
    const scheduleEntry = schedule[activity.id];
    if (!scheduleEntry) return false;
    
    const isCompleted = progress[activity.id]?.completed || false;
    if (isCompleted) return false; // Completed activities are not overdue
    
    const today = getTodayString();
    return scheduleEntry.scheduled_date < today;
  };

  const getUnitProgress = (unitId) => {
    const unitActivities = activities.filter(a => a.unit_id === unitId);
    const completedActivities = unitActivities.filter(a => progress[a.id]?.completed);
    return {
      total: unitActivities.length,
      completed: completedActivities.length,
      percentage: unitActivities.length > 0 ? 
        Math.round((completedActivities.length / unitActivities.length) * 100) : 0
    };
  };

  const getCourseProgress = () => {
    const completedActivities = activities.filter(a => progress[a.id]?.completed);
    return {
      total: activities.length,
      completed: completedActivities.length,
      percentage: activities.length > 0 ? 
        Math.round((completedActivities.length / activities.length) * 100) : 0
    };
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
          Error loading course: {error}
        </Alert>
      </Container>
    );
  }

  if (!course) {
    return (
      <Container maxWidth="lg" sx={{ mt: 4 }}>
        <Alert severity="warning">
          Course not found
        </Alert>
      </Container>
    );
  }

  const courseProgress = getCourseProgress();

  return (
    <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
      {/* Course Header */}
      <Card sx={{ mb: 4 }}>
        <CardContent>
          <Typography variant="h4" component="h1" gutterBottom>
            {course.name}
          </Typography>
          
          {/* Course Progress */}
          <Box sx={{ mb: 3 }}>
            <Box sx={{ display: 'flex', alignItems: 'center', mb: 1 }}>
              <Typography variant="h6" sx={{ mr: 2 }}>
                Course Progress:
              </Typography>
              <Typography variant="h6" color="primary">
                {courseProgress.completed} / {courseProgress.total} activities
              </Typography>
            </Box>
            <LinearProgress
              variant="determinate"
              value={courseProgress.percentage}
              sx={{ height: 12, borderRadius: 1, mb: 1 }}
            />
            <Typography variant="body1" color="text.secondary">
              {courseProgress.percentage}% complete
            </Typography>
          </Box>

          {/* Course Stats */}
          <Grid container spacing={3}>
            <Grid item xs={6} sm={3}>
              <Typography variant="h5" color="primary">
                {course.total_activities}
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Total Activities
              </Typography>
            </Grid>
            <Grid item xs={6} sm={3}>
              <Typography variant="h5" color="success.main">
                {courseProgress.completed}
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Completed
              </Typography>
            </Grid>
            <Grid item xs={6} sm={3}>
              <Typography variant="h5" color="info.main">
                {calculateActivitiesPerDay(course).toFixed(1)}
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Daily Target
              </Typography>
            </Grid>
            <Grid item xs={6} sm={3}>
              <Typography variant="h5" color="warning.main">
                {course.target_completion_date ? 
                  createLocalDate(course.target_completion_date).toLocaleDateString() : 'Not set'
                }
              </Typography>
              <Typography variant="body2" color="text.secondary">
                Target Date
              </Typography>
            </Grid>
          </Grid>
        </CardContent>
      </Card>

      {/* Units and Activities */}
      {units.map((unit) => {
        const unitProgress = getUnitProgress(unit.id);
        const unitActivities = activities.filter(a => a.unit_id === unit.id);

        return (
          <Accordion key={unit.id} sx={{ mb: 2 }}>
            <AccordionSummary expandIcon={<ExpandMoreIcon />}>
              <Box sx={{ width: '100%', mr: 2 }}>
                <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                  <Typography variant="h6">
                    Unit {unit.unit_number}: {unit.title}
                  </Typography>
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
                    <Typography variant="body2" color="text.secondary">
                      {unitProgress.completed} / {unitProgress.total}
                    </Typography>
                    <Typography variant="body2" color="primary" fontWeight="bold">
                      {unitProgress.percentage}%
                    </Typography>
                    {unit.has_exam && (
                      <Chip label="Has Exam" color="error" size="small" />
                    )}
                  </Box>
                </Box>
                <LinearProgress
                  variant="determinate"
                  value={unitProgress.percentage}
                  sx={{ mt: 1, height: 6, borderRadius: 1 }}
                />
              </Box>
            </AccordionSummary>
            <AccordionDetails>
              {/* Group activities by lesson */}
              {(() => {
                // Group activities by lesson_name
                const activitiesByLesson = unitActivities.reduce((acc, activity) => {
                  const lessonName = activity.lesson_name || 'Other Activities';
                  if (!acc[lessonName]) {
                    acc[lessonName] = [];
                  }
                  acc[lessonName].push(activity);
                  return acc;
                }, {});

                return Object.entries(activitiesByLesson).map(([lessonName, lessonActivities]) => (
                  <Box key={lessonName} sx={{ mb: 3 }}>
                    {/* Lesson Header */}
                    <Typography variant="subtitle1" fontWeight="bold" color="primary" sx={{ mb: 1 }}>
                      {lessonName}
                    </Typography>
                    
                    {/* Activities in this lesson */}
                    <List sx={{ pl: 2, border: '1px solid #e0e0e0', borderRadius: 1, bgcolor: '#fafafa' }}>
                      {lessonActivities.map((activity) => {
                        const isCompleted = progress[activity.id]?.completed || false;
                        const scheduleEntry = schedule[activity.id];
                        const isOverdue = isActivityOverdue(activity);
                        
                        return (
                          <ListItem 
                            key={activity.id} 
                            sx={{ 
                              pl: 0,
                              bgcolor: isOverdue ? '#ffebee' : 'transparent',
                              borderLeft: isOverdue ? '4px solid #d32f2f' : 'none',
                              mb: 0.5
                            }}
                          >
                            <ListItemIcon>
                              {getActivityIcon(activity.activity_type)}
                            </ListItemIcon>
                            <ListItemText
                              primary={
                                <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, flexWrap: 'wrap' }}>
                                  <FormControlLabel
                                    control={
                                      <Checkbox
                                        checked={isCompleted}
                                        onChange={(e) => handleActivityComplete(activity, e.target.checked)}
                                      />
                                    }
                                    label={activity.activity_name}
                                    sx={{ flexGrow: 1, minWidth: '200px' }}
                                  />
                                  {scheduleEntry && (
                                    <Chip 
                                      label={`Due: ${createLocalDate(scheduleEntry.scheduled_date).toLocaleDateString()}`}
                                      size="small" 
                                      color={isOverdue ? 'error' : 'default'}
                                      variant={isOverdue ? 'filled' : 'outlined'}
                                    />
                                  )}
                                  <Chip 
                                    label={activity.activity_type} 
                                    size="small" 
                                    variant="outlined"
                                  />
                                  {activity.is_exam && (
                                    <Chip 
                                      label="EXAM" 
                                      color="error" 
                                      size="small"
                                    />
                                  )}
                                </Box>
                              }
                              secondary={
                                isCompleted && progress[activity.id]?.completion_date ? (
                                  <Typography variant="caption" color="success.main">
                                    Completed: {createLocalDate(progress[activity.id].completion_date).toLocaleDateString()}
                                  </Typography>
                                ) : isOverdue ? (
                                  <Typography variant="caption" color="error">
                                    Overdue
                                  </Typography>
                                ) : null
                              }
                            />
                          </ListItem>
                        );
                      })}
                    </List>
                  </Box>
                ));
              })()}
            </AccordionDetails>
          </Accordion>
        );
      })}

      {/* Action Buttons */}
      <Box sx={{ mt: 4, display: 'flex', gap: 2 }}>
        <Button variant="contained" onClick={() => window.history.back()}>
          Back to Dashboard
        </Button>
        <Button variant="outlined" onClick={fetchCourseData}>
          Refresh Data
        </Button>
      </Box>
    </Container>
  );
};

export default CourseDetail;