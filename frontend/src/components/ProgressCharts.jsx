import React, { useState, useEffect } from 'react';
import {
  Container,
  Card,
  CardContent,
  Typography,
  Box,
  Grid,
  Select,
  MenuItem,
  FormControl,
  InputLabel,
  Alert,
  CircularProgress
} from '@mui/material';
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
  BarChart,
  Bar,
  PieChart,
  Pie,
  Cell
} from 'recharts';
import { supabase } from '../services/supabase';

const ProgressCharts = () => {
  const [courses, setCourses] = useState([]);
  const [selectedCourse, setSelectedCourse] = useState('all');
  const [progressData, setProgressData] = useState([]);
  const [courseComparisonData, setCourseComparisonData] = useState([]);
  const [dailyProgressData, setDailyProgressData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

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
    fetchChartsData();
  }, []);

  useEffect(() => {
    if (courses.length > 0) {
      generateChartData();
    }
  }, [courses, selectedCourse]);

  const fetchChartsData = async () => {
    try {
      setLoading(true);

      // Fetch courses
      const { data: coursesData, error: coursesError } = await supabase
        .from('courses')
        .select('*')
        .order('name');

      if (coursesError) throw coursesError;

      // For each course, get progress data
      const coursesWithProgress = await Promise.all(
        coursesData.map(async (course) => {
          // Get total activities
          const { count: totalActivities, error: totalError } = await supabase
            .from('activities')
            .select('*', { count: 'exact' })
            .eq('course_id', course.id);

          if (totalError) throw totalError;

          // Get completed activities
          const { count: completedActivities, error: completedError } = await supabase
            .from('progress_tracking')
            .select('*', { count: 'exact' })
            .eq('course_id', course.id)
            .eq('completed', true);

          if (completedError) throw completedError;

          // Get progress by date for this course
          const { data: progressByDate, error: progressError } = await supabase
            .from('progress_tracking')
            .select('completion_date, activity_id')
            .eq('course_id', course.id)
            .eq('completed', true)
            .order('completion_date');

          if (progressError) throw progressError;

          return {
            ...course,
            totalActivities: totalActivities || 0,
            completedActivities: completedActivities || 0,
            progressPercentage: totalActivities > 0 ? 
              Math.round((completedActivities || 0) / totalActivities * 100) : 0,
            progressByDate: progressByDate || [],
            activitiesPerDay: calculateActivitiesPerDay({
              ...course,
              total_activities: totalActivities || 0
            })
          };
        })
      );

      setCourses(coursesWithProgress);

    } catch (err) {
      console.error('Charts data error:', err);
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const generateChartData = () => {
    // Course comparison data
    const comparisonData = courses.map(course => ({
      name: course.name.split(' ').slice(-2).join(' '), // Shortened name
      completed: course.completedActivities,
      total: course.totalActivities,
      percentage: course.progressPercentage,
      dailyTarget: course.activitiesPerDay || 0
    }));
    setCourseComparisonData(comparisonData);

    // Daily progress data
    if (selectedCourse === 'all') {
      // Aggregate all courses
      const allProgressDates = courses.flatMap(course => 
        course.progressByDate.map(p => ({
          ...p,
          courseName: course.name
        }))
      );

      // Group by date
      const dateGroups = {};
      allProgressDates.forEach(item => {
        const date = item.completion_date?.split('T')[0];
        if (!date) return;
        
        if (!dateGroups[date]) {
          dateGroups[date] = { date, completedActivities: 0 };
        }
        dateGroups[date].completedActivities += 1;
      });

      const sortedDates = Object.values(dateGroups).sort((a, b) => 
        new Date(a.date) - new Date(b.date)
      );

      // Calculate cumulative progress
      let cumulative = 0;
      const dailyData = sortedDates.map(day => {
        cumulative += day.completedActivities;
        return {
          date: new Date(day.date).toLocaleDateString(),
          completedActivities: day.completedActivities,
          cumulativeActivities: cumulative
        };
      });

      setDailyProgressData(dailyData);
    } else {
      // Single course data
      const selectedCourseData = courses.find(c => c.id === selectedCourse);
      if (selectedCourseData) {
        const progressDates = selectedCourseData.progressByDate;
        
        // Group by date
        const dateGroups = {};
        progressDates.forEach(item => {
          const date = item.completion_date?.split('T')[0];
          if (!date) return;
          
          if (!dateGroups[date]) {
            dateGroups[date] = { date, completedActivities: 0 };
          }
          dateGroups[date].completedActivities += 1;
        });

        const sortedDates = Object.values(dateGroups).sort((a, b) => 
          new Date(a.date) - new Date(b.date)
        );

        // Calculate cumulative progress
        let cumulative = 0;
        const dailyData = sortedDates.map(day => {
          cumulative += day.completedActivities;
          return {
            date: new Date(day.date).toLocaleDateString(),
            completedActivities: day.completedActivities,
            cumulativeActivities: cumulative
          };
        });

        setDailyProgressData(dailyData);
      }
    }
  };

  const COLORS = ['#0088FE', '#00C49F', '#FFBB28', '#FF8042', '#8884D8'];

  const pieChartData = courses.map((course, index) => ({
    name: course.name.split(' ').slice(-2).join(' '),
    value: course.completedActivities,
    total: course.totalActivities,
    color: COLORS[index % COLORS.length]
  }));

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
          Error loading charts: {error}
        </Alert>
      </Container>
    );
  }

  return (
    <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
      {/* Header */}
      <Box sx={{ mb: 4 }}>
        <Typography variant="h4" component="h1" gutterBottom>
          Progress Analytics
        </Typography>
        <Typography variant="h6" color="text.secondary">
          Track your learning progress across all courses
        </Typography>
      </Box>

      {/* Course Selection */}
      <Card sx={{ mb: 4 }}>
        <CardContent>
          <FormControl sx={{ minWidth: 200 }}>
            <InputLabel>Select Course</InputLabel>
            <Select
              value={selectedCourse}
              label="Select Course"
              onChange={(e) => setSelectedCourse(e.target.value)}
            >
              <MenuItem value="all">All Courses</MenuItem>
              {courses.map((course) => (
                <MenuItem key={course.id} value={course.id}>
                  {course.name}
                </MenuItem>
              ))}
            </Select>
          </FormControl>
        </CardContent>
      </Card>

      {/* Charts Grid */}
      <Grid container spacing={3}>
        {/* Course Comparison Bar Chart */}
        <Grid item xs={12} lg={8}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Course Progress Comparison
              </Typography>
              <ResponsiveContainer width="100%" height={300}>
                <BarChart data={courseComparisonData}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="name" />
                  <YAxis />
                  <Tooltip />
                  <Legend />
                  <Bar dataKey="completed" fill="#8884d8" name="Completed" />
                  <Bar dataKey="total" fill="#82ca9d" name="Total Activities" />
                </BarChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>
        </Grid>

        {/* Progress Distribution Pie Chart */}
        <Grid item xs={12} lg={4}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Completed Activities Distribution
              </Typography>
              <ResponsiveContainer width="100%" height={300}>
                <PieChart>
                  <Pie
                    data={pieChartData}
                    cx="50%"
                    cy="50%"
                    labelLine={false}
                    label={({ name, value }) => `${name}: ${value}`}
                    outerRadius={80}
                    fill="#8884d8"
                    dataKey="value"
                  >
                    {pieChartData.map((entry, index) => (
                      <Cell key={`cell-${index}`} fill={entry.color} />
                    ))}
                  </Pie>
                  <Tooltip />
                </PieChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>
        </Grid>

        {/* Daily Progress Line Chart */}
        <Grid item xs={12}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Daily Progress Tracking
                {selectedCourse !== 'all' && (
                  <Typography component="span" color="text.secondary" sx={{ ml: 1 }}>
                    - {courses.find(c => c.id === selectedCourse)?.name}
                  </Typography>
                )}
              </Typography>
              <ResponsiveContainer width="100%" height={400}>
                <LineChart data={dailyProgressData}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis dataKey="date" />
                  <YAxis yAxisId="left" />
                  <YAxis yAxisId="right" orientation="right" />
                  <Tooltip />
                  <Legend />
                  <Bar 
                    yAxisId="left" 
                    dataKey="completedActivities" 
                    fill="#8884d8" 
                    name="Daily Activities"
                  />
                  <Line 
                    yAxisId="right" 
                    type="monotone" 
                    dataKey="cumulativeActivities" 
                    stroke="#82ca9d" 
                    strokeWidth={3}
                    name="Cumulative Progress"
                  />
                </LineChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>
        </Grid>

        {/* Progress Summary Cards */}
        <Grid item xs={12}>
          <Card>
            <CardContent>
              <Typography variant="h6" gutterBottom>
                Progress Summary
              </Typography>
              <Grid container spacing={3}>
                {courses.map((course) => (
                  <Grid item xs={12} sm={6} md={3} key={course.id}>
                    <Box sx={{ textAlign: 'center', p: 2, border: 1, borderColor: 'divider', borderRadius: 1 }}>
                      <Typography variant="h4" color="primary">
                        {course.progressPercentage}%
                      </Typography>
                      <Typography variant="body2" color="text.secondary" gutterBottom>
                        {course.name.split(' ').slice(-2).join(' ')}
                      </Typography>
                      <Typography variant="caption" display="block">
                        {course.completedActivities} / {course.totalActivities} activities
                      </Typography>
                      <Typography variant="caption" display="block" color="text.secondary">
                        Target: {course.activitiesPerDay?.toFixed(1)}/day
                      </Typography>
                    </Box>
                  </Grid>
                ))}
              </Grid>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Container>
  );
};

export default ProgressCharts;