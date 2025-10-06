import React, { useState, useEffect } from 'react';
import {
  Container,
  Card,
  CardContent,
  Typography,
  Box,
  Checkbox,
  FormControlLabel,
  ToggleButtonGroup,
  ToggleButton,
  Alert,
  CircularProgress,
  List,
  ListItem,
  ListItemText,
  ListItemIcon,
  Chip,
  IconButton,
  Divider
} from '@mui/material';
import {
  Today as TodayIcon,
  DateRange as WeekIcon,
  CalendarMonth as MonthIcon,
  PlayCircleOutline as VideoIcon,
  Article as ArticleIcon,
  Quiz as QuizIcon,
  Assignment as ExerciseIcon,
  School as ExamIcon,
  NavigateBefore as PrevIcon,
  NavigateNext as NextIcon
} from '@mui/icons-material';
import { supabase } from '../services/supabase';
import { getTodayString, createLocalDate, formatDateForDB } from '../utils/dateUtils';

const DailyScheduleView = () => {
  const [view, setView] = useState('today'); // 'today', 'week', 'month'
  const [currentDate, setCurrentDate] = useState(new Date());
  const [scheduleData, setScheduleData] = useState([]);
  const [progress, setProgress] = useState({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [user, setUser] = useState(null);

  useEffect(() => {
    getCurrentUser();
  }, []);

  useEffect(() => {
    if (user) {
      fetchScheduleData();
    }
  }, [user, view, currentDate]);

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

  const fetchScheduleData = async () => {
    try {
      setLoading(true);

      // Calculate date range based on view
      const { startDate, endDate } = getDateRange();

      // Fetch scheduled activities for the date range
      const { data: scheduleItems, error: scheduleError } = await supabase
        .from('schedule')
        .select(`
          *,
          activity:activities(*),
          course:courses(name)
        `)
        .eq('student_id', user.id)
        .gte('scheduled_date', startDate)
        .lte('scheduled_date', endDate)
        .order('scheduled_date', { ascending: true })
        .order('order_in_day', { ascending: true });

      if (scheduleError) throw scheduleError;

      // Fetch progress for these activities
      const activityIds = scheduleItems.map(s => s.activity_id);
      const { data: progressData, error: progressError } = await supabase
        .from('progress_tracking')
        .select('*')
        .eq('student_id', user.id)
        .in('activity_id', activityIds);

      if (progressError) throw progressError;

      // Convert progress to map
      const progressMap = {};
      progressData.forEach(p => {
        progressMap[p.activity_id] = p;
      });

      setScheduleData(scheduleItems || []);
      setProgress(progressMap);
      setError(null);

    } catch (err) {
      console.error('Error fetching schedule:', err);
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const getDateRange = () => {
    const date = new Date(currentDate);
    date.setHours(0, 0, 0, 0);

    if (view === 'today') {
      return {
        startDate: formatDateForDB(date),
        endDate: formatDateForDB(date)
      };
    } else if (view === 'week') {
      // Get start of week (Sunday)
      const startOfWeek = new Date(date);
      startOfWeek.setDate(date.getDate() - date.getDay());
      
      // Get end of week (Saturday)
      const endOfWeek = new Date(startOfWeek);
      endOfWeek.setDate(startOfWeek.getDate() + 6);

      return {
        startDate: formatDateForDB(startOfWeek),
        endDate: formatDateForDB(endOfWeek)
      };
    } else { // month
      const startOfMonth = new Date(date.getFullYear(), date.getMonth(), 1);
      const endOfMonth = new Date(date.getFullYear(), date.getMonth() + 1, 0);

      return {
        startDate: formatDateForDB(startOfMonth),
        endDate: formatDateForDB(endOfMonth)
      };
    }
  };

  const handleViewChange = (event, newView) => {
    if (newView !== null) {
      setView(newView);
    }
  };

  const navigateDate = (direction) => {
    const newDate = new Date(currentDate);
    
    if (view === 'today') {
      newDate.setDate(newDate.getDate() + direction);
    } else if (view === 'week') {
      newDate.setDate(newDate.getDate() + (direction * 7));
    } else { // month
      newDate.setMonth(newDate.getMonth() + direction);
    }

    setCurrentDate(newDate);
  };

  const handleActivityComplete = async (activity, completed) => {
    try {
      if (completed) {
        // Mark as complete
        const { error } = await supabase
          .from('progress_tracking')
          .upsert({
            student_id: user.id,
            course_id: activity.course_id,
            activity_id: activity.activity_id,
            completed: true,
            completion_date: new Date().toISOString()
          });

        if (error) throw error;
      } else {
        // Mark as incomplete
        const { error } = await supabase
          .from('progress_tracking')
          .delete()
          .eq('activity_id', activity.activity_id)
          .eq('student_id', user.id);

        if (error) throw error;
      }

      // Update local progress state
      setProgress(prev => ({
        ...prev,
        [activity.activity_id]: completed ? {
          student_id: user.id,
          course_id: activity.course_id,
          activity_id: activity.activity_id,
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

  const getDateLabel = () => {
    const date = new Date(currentDate);
    
    if (view === 'today') {
      const today = getTodayString();
      const currentDateStr = formatDateForDB(date);
      
      if (currentDateStr === today) {
        return 'Today';
      } else {
        return date.toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric' });
      }
    } else if (view === 'week') {
      const startOfWeek = new Date(date);
      startOfWeek.setDate(date.getDate() - date.getDay());
      const endOfWeek = new Date(startOfWeek);
      endOfWeek.setDate(startOfWeek.getDate() + 6);
      
      return `${startOfWeek.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })} - ${endOfWeek.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}`;
    } else {
      return date.toLocaleDateString('en-US', { month: 'long', year: 'numeric' });
    }
  };

  // Group schedule data by date or course
  const groupedData = () => {
    if (view === 'today') {
      // Group by course
      const grouped = {};
      scheduleData.forEach(item => {
        const courseName = item.course.name;
        if (!grouped[courseName]) {
          grouped[courseName] = [];
        }
        grouped[courseName].push(item);
      });
      return grouped;
    } else {
      // Group by date
      const grouped = {};
      scheduleData.forEach(item => {
        const date = item.scheduled_date;
        if (!grouped[date]) {
          grouped[date] = [];
        }
        grouped[date].push(item);
      });
      return grouped;
    }
  };

  const isOverdue = (scheduledDate) => {
    const today = getTodayString();
    return scheduledDate < today;
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
          Error loading schedule: {error}
        </Alert>
      </Container>
    );
  }

  const grouped = groupedData();
  const totalActivities = scheduleData.length;
  const completedActivities = scheduleData.filter(s => progress[s.activity_id]?.completed).length;

  return (
    <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
      {/* Header */}
      <Box sx={{ mb: 3 }}>
        <Typography variant="h4" component="h1" gutterBottom>
          My Schedule
        </Typography>

        {/* View Toggle */}
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
          <ToggleButtonGroup
            value={view}
            exclusive
            onChange={handleViewChange}
            aria-label="schedule view"
          >
            <ToggleButton value="today" aria-label="today">
              <TodayIcon sx={{ mr: 1 }} />
              Today
            </ToggleButton>
            <ToggleButton value="week" aria-label="week">
              <WeekIcon sx={{ mr: 1 }} />
              Week
            </ToggleButton>
            <ToggleButton value="month" aria-label="month">
              <MonthIcon sx={{ mr: 1 }} />
              Month
            </ToggleButton>
          </ToggleButtonGroup>

          {/* Date Navigation */}
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
            <IconButton onClick={() => navigateDate(-1)} aria-label="previous">
              <PrevIcon />
            </IconButton>
            <Typography variant="h6">
              {getDateLabel()}
            </Typography>
            <IconButton onClick={() => navigateDate(1)} aria-label="next">
              <NextIcon />
            </IconButton>
          </Box>
        </Box>

        {/* Summary */}
        {totalActivities > 0 && (
          <Alert severity="info" sx={{ mb: 2 }}>
            {completedActivities} of {totalActivities} activities completed
            {completedActivities === totalActivities && " 🎉"}
          </Alert>
        )}
      </Box>

      {/* Schedule Content */}
      {totalActivities === 0 ? (
        <Card>
          <CardContent>
            <Typography variant="body1" color="text.secondary" align="center">
              No activities scheduled for this {view === 'today' ? 'day' : view === 'week' ? 'week' : 'month'}.
            </Typography>
          </CardContent>
        </Card>
      ) : (
        Object.entries(grouped).map(([key, items]) => (
          <Card key={key} sx={{ mb: 2 }}>
            <CardContent>
              <Typography variant="h6" gutterBottom color="primary">
                {view === 'today' ? key : createLocalDate(key).toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric' })}
              </Typography>
              
              <List>
                {items.map((item, index) => {
                  const isCompleted = progress[item.activity_id]?.completed || false;
                  const activityOverdue = !isCompleted && isOverdue(item.scheduled_date);

                  return (
                    <React.Fragment key={item.id}>
                      {index > 0 && <Divider />}
                      <ListItem
                        sx={{
                          bgcolor: activityOverdue ? '#ffebee' : 'transparent',
                          borderLeft: activityOverdue ? '4px solid #d32f2f' : 'none'
                        }}
                      >
                        <ListItemIcon>
                          {getActivityIcon(item.activity.activity_type)}
                        </ListItemIcon>
                        <ListItemText
                          primary={
                            <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, flexWrap: 'wrap' }}>
                              <FormControlLabel
                                control={
                                  <Checkbox
                                    checked={isCompleted}
                                    onChange={(e) => handleActivityComplete(item, e.target.checked)}
                                  />
                                }
                                label={item.activity.activity_name}
                                sx={{ flexGrow: 1, minWidth: '200px' }}
                              />
                              {view !== 'today' && (
                                <Chip 
                                  label={item.course.name}
                                  size="small"
                                  variant="outlined"
                                />
                              )}
                              {item.activity.is_exam && (
                                <Chip 
                                  label="EXAM" 
                                  color="error" 
                                  size="small"
                                />
                              )}
                              {activityOverdue && (
                                <Chip 
                                  label="OVERDUE" 
                                  color="error" 
                                  size="small"
                                  variant="filled"
                                />
                              )}
                            </Box>
                          }
                          secondary={
                            isCompleted && progress[item.activity_id]?.completion_date ? (
                              <Typography variant="caption" color="success.main">
                                ✓ Completed: {createLocalDate(progress[item.activity_id].completion_date).toLocaleDateString()}
                              </Typography>
                            ) : null
                          }
                        />
                      </ListItem>
                    </React.Fragment>
                  );
                })}
              </List>
            </CardContent>
          </Card>
        ))
      )}
    </Container>
  );
};

export default DailyScheduleView;
