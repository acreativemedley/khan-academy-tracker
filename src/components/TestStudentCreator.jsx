import React, { useState, useEffect } from 'react'
import { Button, Box, Typography, Paper, Alert } from '@mui/material'

function TestStudentCreator() {
  const [status, setStatus] = useState('Component loading...')
  const [studentData, setStudentData] = useState(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    console.log('TestStudentCreator mounted')
    setStatus('Component ready - testing basic functionality')
    
    // Test if supabase is available
    import('../services/supabase').then(({ supabase }) => {
      console.log('Supabase imported successfully:', supabase)
      setStatus('✅ Component ready - Supabase connection available')
    }).catch(err => {
      console.error('Error importing supabase:', err)
      setStatus('❌ Error: Cannot import Supabase')
    })
  }, [])

  const handleTestBasic = async () => {
    setLoading(true)
    setStatus('Testing basic database access and checking schema...')
    
    try {
      const { supabase } = await import('../services/supabase')
      
      // Check students table structure and constraints
      const { data: tableInfo, error: schemaError } = await supabase
        .rpc('exec', { 
          query: `
            SELECT column_name, data_type, is_nullable, column_default
            FROM information_schema.columns 
            WHERE table_name = 'students' 
            ORDER BY ordinal_position;
          `
        })
      
      if (schemaError) {
        console.log('Schema check failed, trying simple count...')
        // Simple table check as fallback
        const { data, error } = await supabase
          .from('students')
          .select('count')
          .limit(1)
        
        if (error) {
          setStatus(`❌ Database Error: ${error.message}`)
        } else {
          setStatus('✅ Database access working! (Schema details unavailable)')
        }
      } else {
        console.log('Students table schema:', tableInfo)
        setStatus('✅ Database access working! Check console for schema details.')
      }
    } catch (err) {
      setStatus(`❌ Error: ${err.message}`)
    }
    
    setLoading(false)
  }

  const handleCreateStudent = async () => {
    setLoading(true)
    setStatus('Creating authenticated user and student...')
    
    try {
      const { supabase } = await import('../services/supabase')
      
      // Step 1: Create an authenticated user via Supabase Auth
      console.log('Creating authenticated user...')
      const { data: authData, error: authError } = await supabase.auth.signUp({
        email: 'student@example.com',
        password: 'testpassword123',
        options: {
          data: {
            display_name: 'Test Student'
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
            display_name: 'Test Student',
            student_email: 'student@example.com',
            parent_email: 'parent@example.com',
            timezone: 'America/Chicago',
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
        setStatus('✅ Test user and student created successfully!')
        setStudentData(data)
        console.log('Student created:', data)
      }
    } catch (err) {
      setStatus(`❌ Unexpected error: ${err.message}`)
      console.error('Unexpected error:', err)
    }
    
    setLoading(false)
  }

  const handleCheckStudent = async () => {
    setLoading(true)
    setStatus('Checking for test student...')
    
    try {
      const { supabase } = await import('../services/supabase')
      
      const { data, error } = await supabase
        .from('students')
        .select('*')
        .eq('display_name', 'Test Student')
        .maybeSingle()

      if (error) {
        setStatus(`❌ Error checking student: ${error.message}`)
      } else if (data) {
        setStatus('✅ Test student found!')
        setStudentData(data)
      } else {
        setStatus('⚠️ No test student found')
        setStudentData(null)
      }
    } catch (err) {
      setStatus(`❌ Error: ${err.message}`)
    }
    
    setLoading(false)
  }

  return (
    <Paper sx={{ p: 3, m: 2 }}>
      <Typography variant="h5" gutterBottom>
        Test Student Management
      </Typography>
      
      <Box sx={{ mb: 2 }}>
        <Button 
          variant="outlined" 
          onClick={handleTestBasic}
          disabled={loading}
          sx={{ mr: 1, mb: 1 }}
        >
          Test Database Access
        </Button>
        
        <Button 
          variant="contained" 
          onClick={handleCheckStudent}
          disabled={loading}
          sx={{ mr: 1, mb: 1 }}
        >
          Check for Test Student
        </Button>
        
        <Button 
          variant="contained" 
          color="primary"
          onClick={handleCreateStudent}
          disabled={loading}
          sx={{ mr: 1, mb: 1 }}
        >
          Create Test Student
        </Button>
      </Box>

      {status && (
        <Alert severity={status.includes('✅') ? 'success' : status.includes('❌') ? 'error' : 'info'}>
          {status}
        </Alert>
      )}

      {studentData && (
        <Box sx={{ mt: 2, p: 2, backgroundColor: '#f5f5f5', borderRadius: 1 }}>
          <Typography variant="h6">Student Data:</Typography>
          <pre style={{ fontSize: '0.9em', whiteSpace: 'pre-wrap' }}>
            {JSON.stringify(studentData, null, 2)}
          </pre>
        </Box>
      )}
    </Paper>
  )
}

export default TestStudentCreator