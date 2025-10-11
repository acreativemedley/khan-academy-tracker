import React, { useState, useEffect } from 'react';
import {
  Container,
  Card,
  CardContent,
  Typography,
  Box,
  Button,
  TextField,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  List,
  ListItem,
  ListItemText,
  ListItemSecondaryAction,
  IconButton,
  Alert,
  CircularProgress,
  Divider,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Chip
} from '@mui/material';
import {
  Add as AddIcon,
  Delete as DeleteIcon,
  BeachAccess as VacationIcon,
  Event as EventIcon,
  Refresh as RefreshIcon
} from '@mui/icons-material';
import { supabase } from '../services/supabase';
import { formatDateForDB, createLocalDate } from '../utils/dateUtils';
import { recalculateScheduleWithVacations } from '../services/scheduleService';

const VacationManager = () => {
  const [user, setUser] = useState(null);
  const [vacations, setVacations] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [openDialog, setOpenDialog] = useState(false);
  const [openRegenerateDialog, setOpenRegenerateDialog] = useState(false);
  const [regenerating, setRegenerating] = useState(false);
  const [formData, setFormData] = useState({
    name: '',
    start_date: '',
    end_date: '',
    description: ''
  });
  const [formError, setFormError] = useState('');

  useEffect(() => {
    checkUser();
  }, []);

  useEffect(() => {
    if (user) {
      fetchVacations();
    }
  }, [user]);

  const checkUser = async () => {
    try {
      const { data: { user }, error } = await supabase.auth.getUser();
      if (error) throw error;
      setUser(user);
    } catch (err) {
      console.error('Error getting user:', err);
      setError('Authentication error');
    } finally {
      setLoading(false);
    }
  };

  const fetchVacations = async () => {
    if (!user) {
      return;
    }
    try {
      setLoading(true);
      const { data, error } = await supabase
        .from('vacation_periods')
        .select('*')
        .eq('student_id', user.id)
        .order('start_date', { ascending: true });

      if (error) throw error;
      setVacations(data || []);
      setError(null);
    } catch (err) {
      console.error('Error fetching vacations:', err);
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleOpenDialog = () => {
    setFormData({
      name: '',
      start_date: '',
      end_date: '',
      description: ''
    });
    setFormError('');
    setOpenDialog(true);
  };

  const handleCloseDialog = () => {
    setOpenDialog(false);
    setFormError('');
  };

  const handleFormChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
  };

  const validateForm = () => {
    if (!formData.name.trim()) {
      setFormError('Please enter a name for this vacation period');
      return false;
    }
    if (!formData.start_date) {
      setFormError('Please select a start date');
      return false;
    }
    if (!formData.end_date) {
      setFormError('Please select an end date');
      return false;
    }
    if (formData.start_date > formData.end_date) {
      setFormError('End date must be after start date');
      return false;
    }
    return true;
  };

  const handleAddVacation = async () => {
    if (!validateForm()) return;

    try {
      if (!user) {
        setFormError('You must be logged in to add vacation periods.');
        return;
      }
      const { error } = await supabase
        .from('vacation_periods')
        .insert([{
          student_id: user.id,
          name: formData.name,
          start_date: formData.start_date,
          end_date: formData.end_date,
          description: formData.description || null
        }]);

      if (error) throw error;

      await fetchVacations();
      handleCloseDialog();
    } catch (err) {
      console.error('Error adding vacation:', err);
      setFormError(err.message);
    }
  };

  const handleDeleteVacation = async (vacationId) => {
    if (!confirm('Are you sure you want to delete this vacation period?')) {
      return;
    }

    try {
      if (!user) {
        alert('You must be logged in to delete vacation periods.');
        return;
      }
      const { error } = await supabase
        .from('vacation_periods')
        .delete()
        .eq('id', vacationId)
        .eq('student_id', user.id);

      if (error) throw error;

      await fetchVacations();
    } catch (err) {
      console.error('Error deleting vacation:', err);
      alert('Error deleting vacation: ' + err.message);
    }
  };

  const calculateDays = (startDate, endDate) => {
    const start = new Date(startDate);
    const end = new Date(endDate);
    const diffTime = Math.abs(end - start);
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1; // +1 to include both start and end
    return diffDays;
  };

  const handleRegenerateSchedule = async (includeOverdue = true) => {
    if (!user) {
      alert('You must be logged in to regenerate schedules.');
      return;
    }
    try {
      setRegenerating(true);

      // Get all courses
      const { data: courses, error: coursesError } = await supabase
        .from('courses')
        .select('id, name');

      if (coursesError) throw coursesError;

      if (!courses || courses.length === 0) {
        alert('No courses found');
        setRegenerating(false);
        return;
      }

      // Get today's date
      const today = formatDateForDB(new Date());

      // Regenerate schedule for each course with the selected mode
      let successCount = 0;
      let errorCount = 0;
      const mode = includeOverdue ? 'all' : 'future';

      for (const course of courses) {
        try {
          const result = await recalculateScheduleWithVacations(course.id, user.id, mode);
          if (result.success) {
            successCount++;
          } else {
            console.error(`Error for ${course.name}:`, result.error);
            errorCount++;
          }
        } catch (err) {
          console.error(`Error generating schedule for ${course.name}:`, err);
          errorCount++;
        }
      }

      setOpenRegenerateDialog(false);
      
      if (errorCount === 0) {
        alert(`Schedule regenerated successfully for ${successCount} course(s)!`);
      } else {
        alert(`Schedule regenerated for ${successCount} course(s). ${errorCount} course(s) had errors.`);
      }

    } catch (err) {
      console.error('Error regenerating schedule:', err);
      alert('Error regenerating schedule: ' + err.message);
    } finally {
      setRegenerating(false);
    }
  };

    if (loading) {
      return (
        <Container maxWidth="lg" sx={{ mt: 4, display: 'flex', justifyContent: 'center' }}>
          <CircularProgress />
        </Container>
      );
    }

    if (!user) {
      return (
        <Container maxWidth="lg" sx={{ mt: 4 }}>
          <Alert severity="info">
            Please log in to manage vacation periods.
          </Alert>
        </Container>
      );
    }

  if (loading) {
    return (
      <Container maxWidth="lg" sx={{ mt: 4, display: 'flex', justifyContent: 'center' }}>
        <CircularProgress />
      </Container>
    );
  }

  return (
    <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
      <Box sx={{ mb: 3 }}>
        <Typography variant="h4" component="h1" gutterBottom>
          <VacationIcon sx={{ mr: 1, verticalAlign: 'middle' }} />
          Vacation Periods
        </Typography>
        <Typography variant="body1" color="text.secondary" gutterBottom>
          Manage vacation and holiday periods. These dates will be excluded when calculating your schedule.
        </Typography>
      </Box>

      {error && (
        <Alert severity="error" sx={{ mb: 3 }}>
          {error}
        </Alert>
      )}

      <Box sx={{ mb: 3, display: 'flex', gap: 2 }}>
        <Button
          variant="contained"
          startIcon={<AddIcon />}
          onClick={handleOpenDialog}
        >
          Add Vacation Period
        </Button>
        <Button
          variant="outlined"
          startIcon={<RefreshIcon />}
          onClick={() => setOpenRegenerateDialog(true)}
          color="primary"
        >
          Recalculate Due Dates
        </Button>
      </Box>

      {vacations.length === 0 ? (
        <Card>
          <CardContent>
            <Typography variant="body1" color="text.secondary" align="center">
              No vacation periods added yet. Click "Add Vacation Period" to get started.
            </Typography>
          </CardContent>
        </Card>
      ) : (
        <Card>
          <CardContent>
            <List>
              {vacations.map((vacation, index) => {
                const days = calculateDays(vacation.start_date, vacation.end_date);
                const isThanksgiving = vacation.name === 'Thanksgiving Break';

                return (
                  <React.Fragment key={vacation.id}>
                    {index > 0 && <Divider />}
                    <ListItem>
                      <ListItemText
                        primary={
                          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, flexWrap: 'wrap' }}>
                            <Typography variant="h6" component="span">
                              {vacation.name}
                            </Typography>
                            {isThanksgiving && (
                              <Chip 
                                label="Auto-calculated" 
                                size="small" 
                                color="info"
                                variant="outlined"
                              />
                            )}
                            <Chip 
                              label={`${days} day${days !== 1 ? 's' : ''}`}
                              size="small"
                              variant="outlined"
                            />
                          </Box>
                        }
                        secondary={
                          <React.Fragment>
                            <span style={{ display: 'block', marginTop: '8px' }}>
                              {createLocalDate(vacation.start_date).toLocaleDateString('en-US', { 
                                weekday: 'short', 
                                month: 'short', 
                                day: 'numeric',
                                year: 'numeric'
                              })} 
                              {' → '}
                              {createLocalDate(vacation.end_date).toLocaleDateString('en-US', { 
                                weekday: 'short', 
                                month: 'short', 
                                day: 'numeric',
                                year: 'numeric'
                              })}
                            </span>
                            {vacation.description && (
                              <span style={{ display: 'block', marginTop: '4px' }}>
                                {vacation.description}
                              </span>
                            )}
                          </React.Fragment>
                        }
                      />
                      <ListItemSecondaryAction>
                        <IconButton
                          edge="end"
                          aria-label="delete"
                          onClick={() => handleDeleteVacation(vacation.id)}
                          color="error"
                        >
                          <DeleteIcon />
                        </IconButton>
                      </ListItemSecondaryAction>
                    </ListItem>
                  </React.Fragment>
                );
              })}
            </List>
          </CardContent>
        </Card>
      )}

      <Alert severity="info" sx={{ mt: 3 }}>
        <Typography variant="body2">
          <strong>Note:</strong> After adding or removing vacation periods, you'll need to regenerate your schedule 
          for the changes to take effect.
        </Typography>
      </Alert>

      {/* Add Vacation Dialog */}
      <Dialog open={openDialog} onClose={handleCloseDialog} maxWidth="sm" fullWidth>
        <DialogTitle>Add Vacation Period</DialogTitle>
        <DialogContent>
          {formError && (
            <Alert severity="error" sx={{ mb: 2 }}>
              {formError}
            </Alert>
          )}
          
          <TextField
            fullWidth
            label="Name"
            name="name"
            value={formData.name}
            onChange={handleFormChange}
            margin="normal"
            placeholder="e.g., Spring Break, Winter Holiday"
            required
          />

          <Box sx={{ display: 'flex', gap: 2, mt: 2 }}>
            <TextField
              fullWidth
              label="Start Date"
              name="start_date"
              type="date"
              value={formData.start_date}
              onChange={handleFormChange}
              InputLabelProps={{ shrink: true }}
              required
            />

            <TextField
              fullWidth
              label="End Date"
              name="end_date"
              type="date"
              value={formData.end_date}
              onChange={handleFormChange}
              InputLabelProps={{ shrink: true }}
              required
            />
          </Box>

          <TextField
            fullWidth
            label="Description (Optional)"
            name="description"
            value={formData.description}
            onChange={handleFormChange}
            margin="normal"
            multiline
            rows={2}
            placeholder="Add any notes about this vacation period"
          />

          {formData.start_date && formData.end_date && formData.start_date <= formData.end_date && (
            <Alert severity="info" sx={{ mt: 2 }}>
              This vacation period is {calculateDays(formData.start_date, formData.end_date)} day
              {calculateDays(formData.start_date, formData.end_date) !== 1 ? 's' : ''} long.
            </Alert>
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDialog}>Cancel</Button>
          <Button onClick={handleAddVacation} variant="contained">
            Add Vacation
          </Button>
        </DialogActions>
      </Dialog>

      {/* Regenerate Schedule Confirmation Dialog */}
      <Dialog open={openRegenerateDialog} onClose={() => setOpenRegenerateDialog(false)} maxWidth="sm" fullWidth>
        <DialogTitle>Recalculate Due Dates?</DialogTitle>
        <DialogContent>
          <Alert severity="info" sx={{ mb: 2 }}>
            Choose how to recalculate your schedule:
          </Alert>
          <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
            <strong>Recalculate All:</strong> Reschedules all incomplete activities starting today. Nothing will be overdue. 
            Takes into account vacation days and previously overdue items.
          </Typography>
          <Typography variant="body2" color="text.secondary">
            <strong>Recalculate Future Activities:</strong> Keeps overdue assignments as-is. Only recalculates activities 
            due today and beyond, accounting for vacation days.
          </Typography>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setOpenRegenerateDialog(false)} disabled={regenerating}>
            Cancel
          </Button>
          <Button 
            onClick={() => handleRegenerateSchedule(false)} 
            variant="outlined" 
            color="primary"
            disabled={regenerating}
            startIcon={regenerating ? <CircularProgress size={20} /> : <RefreshIcon />}
          >
            Recalculate Future Activities
          </Button>
          <Button 
            onClick={() => handleRegenerateSchedule(true)} 
            variant="contained" 
            color="primary"
            disabled={regenerating}
            startIcon={regenerating ? <CircularProgress size={20} /> : <RefreshIcon />}
          >
            Recalculate All
          </Button>
        </DialogActions>
      </Dialog>
    </Container>
  );
};

export default VacationManager;
