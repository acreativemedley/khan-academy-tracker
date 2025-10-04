import React, { useState, useEffect } from 'react'
import { 
  Box, 
  Typography, 
  Button, 
  CircularProgress, 
  Alert,
  TextField,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  FormHelperText,
  Paper,
  Grid
} from '@mui/material'

export default function TestStudentCreator() {
  const [loading, setLoading] = useState(false)
  const [status, setStatus] = useState('')
  const [studentData, setStudentData] = useState(null)
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    confirmPassword: '',
    displayName: '',
    parentEmail: '',
    timezone: 'America/Chicago'
  })
  const [errors, setErrors] = useState({})

  useEffect(() => {
    console.log('TestStudentCreator mounted')
    setStatus('✅ Ready to create student account')
  }, [])

  const validateForm = () => {
    const newErrors = {}
    
    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!formData.email || !emailRegex.test(formData.email)) {
      newErrors.email = 'Please enter a valid email address'
    }
    
    // Password validation
    if (!formData.password || formData.password.length < 8) {
      newErrors.password = 'Password must be at least 8 characters long'
    }
    
    // Confirm password
    if (formData.password !== formData.confirmPassword) {
      newErrors.confirmPassword = 'Passwords do not match'
    }
    
    // Display name
    if (!formData.displayName || formData.displayName.trim().length < 2) {
      newErrors.displayName = 'Please enter a valid display name (at least 2 characters)'
    }
    
    // Parent email
    if (!formData.parentEmail || !emailRegex.test(formData.parentEmail)) {
      newErrors.parentEmail = 'Please enter a valid parent email address'
    }
    
    setErrors(newErrors)
    return Object.keys(newErrors).length === 0
  }

  const handleInputChange = (field) => (event) => {
    setFormData(prev => ({
      ...prev,
      [field]: event.target.value
    }))
    
    // Clear error when user starts typing
    if (errors[field]) {
      setErrors(prev => ({
        ...prev,
        [field]: ''
      }))
    }
  }

  const handleCreateStudent = async () => {
    if (!validateForm()) {
      setStatus('❌ Please fix the form errors below')
      return
    }

    setLoading(true)
    setStatus('Creating authenticated user and student...')
    
    try {
      const { supabase } = await import('../services/supabase')
      
      // Step 1: Create an authenticated user via Supabase Auth
      console.log('Creating authenticated user...')
      const { data: authData, error: authError } = await supabase.auth.signUp({
        email: formData.email,
        password: formData.password,
        options: {
          data: {
            display_name: formData.displayName
          }
        }
      })

      if (authError) {
        console.error('Auth creation error:', authError)
        setStatus(`❌ Error creating user: ${authError.message}`)
        return
      }

      if (!authData.user) {
        setStatus('❌ No user returned from authentication')
        return
      }

      console.log('User created successfully:', authData.user)
      const userId = authData.user.id

      // Step 2: Create the student record using the auth user ID
      const { data, error } = await supabase
        .from('students')
        .insert([
          {
            id: userId, // Use the auth user ID to satisfy foreign key
            display_name: formData.displayName,
            student_email: formData.email,
            parent_email: formData.parentEmail,
            timezone: formData.timezone,
            school_days: ['sunday', 'monday', 'thursday', 'friday', 'saturday']
          }
        ])
        .select()
        .single()

      if (error) {
        setStatus(`❌ Error creating student: ${error.message}`)
        console.error('Student creation error:', error)
        
        // Clean up auth user if student creation fails
        await supabase.auth.admin.deleteUser(userId)
      } else {
        setStatus('✅ User and student created successfully!')
        setStudentData(data)
        console.log('Student created:', data)
        
        // Clear form
        setFormData({
          email: '',
          password: '',
          confirmPassword: '',
          displayName: '',
          parentEmail: '',
          timezone: 'America/Chicago'
        })
      }
    } catch (err) {
      console.error('Unexpected error:', err)
      setStatus(`❌ Unexpected error: ${err.message}`)
    } finally {
      setLoading(false)
    }
  }

  return (
    <Box sx={{ maxWidth: 600, mx: 'auto', p: 3 }}>
      <Typography variant="h4" component="h1" gutterBottom>
        Create Student Account
      </Typography>
      
      <Typography variant="body2" color="text.secondary" sx={{ mb: 3 }}>
        Create a real student account with proper authentication
      </Typography>

      <Paper sx={{ p: 3, mb: 3 }}>
        <Grid container spacing={3}>
          <Grid item xs={12}>
            <TextField
              fullWidth
              label="Student Email"
              type="email"
              value={formData.email}
              onChange={handleInputChange('email')}
              error={!!errors.email}
              helperText={errors.email}
              disabled={loading}
            />
          </Grid>
          
          <Grid item xs={12} sm={6}>
            <TextField
              fullWidth
              label="Password"
              type="password"
              value={formData.password}
              onChange={handleInputChange('password')}
              error={!!errors.password}
              helperText={errors.password}
              disabled={loading}
            />
          </Grid>
          
          <Grid item xs={12} sm={6}>
            <TextField
              fullWidth
              label="Confirm Password"
              type="password"
              value={formData.confirmPassword}
              onChange={handleInputChange('confirmPassword')}
              error={!!errors.confirmPassword}
              helperText={errors.confirmPassword}
              disabled={loading}
            />
          </Grid>
          
          <Grid item xs={12}>
            <TextField
              fullWidth
              label="Display Name"
              value={formData.displayName}
              onChange={handleInputChange('displayName')}
              error={!!errors.displayName}
              helperText={errors.displayName}
              disabled={loading}
            />
          </Grid>
          
          <Grid item xs={12}>
            <TextField
              fullWidth
              label="Parent Email"
              type="email"
              value={formData.parentEmail}
              onChange={handleInputChange('parentEmail')}
              error={!!errors.parentEmail}
              helperText={errors.parentEmail}
              disabled={loading}
            />
          </Grid>
          
          <Grid item xs={12}>
            <FormControl fullWidth>
              <InputLabel>Timezone</InputLabel>
              <Select
                value={formData.timezone}
                onChange={handleInputChange('timezone')}
                label="Timezone"
                disabled={loading}
              >
                <MenuItem value="America/Chicago">US Central (America/Chicago)</MenuItem>
                <MenuItem value="America/New_York">US Eastern (America/New_York)</MenuItem>
                <MenuItem value="America/Denver">US Mountain (America/Denver)</MenuItem>
                <MenuItem value="America/Los_Angeles">US Pacific (America/Los_Angeles)</MenuItem>
              </Select>
            </FormControl>
          </Grid>
        </Grid>

        <Box sx={{ mt: 3 }}>
          <Button
            variant="contained"
            onClick={handleCreateStudent}
            disabled={loading}
            fullWidth
            size="large"
          >
            {loading ? <CircularProgress size={24} /> : 'Create Student Account'}
          </Button>
        </Box>
      </Paper>

      {status && (
        <Alert 
          severity={status.includes('✅') ? 'success' : status.includes('❌') ? 'error' : 'info'}
          sx={{ mb: 2 }}
        >
          {status}
        </Alert>
      )}

      {studentData && (
        <Paper sx={{ p: 2 }}>
          <Typography variant="h6" gutterBottom>Student Created Successfully</Typography>
          <Typography variant="body2">ID: {studentData.id}</Typography>
          <Typography variant="body2">Name: {studentData.display_name}</Typography>
          <Typography variant="body2">Email: {studentData.student_email}</Typography>
          <Typography variant="body2">Timezone: {studentData.timezone}</Typography>
        </Paper>
      )}
    </Box>
  )
}