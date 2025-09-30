import { useEffect, useState } from 'react'
import { supabase } from '../services/supabase'
import { Box, Typography, Alert, Button, CircularProgress } from '@mui/material'

export default function DatabaseTest() {
  const [connectionStatus, setConnectionStatus] = useState('testing')
  const [error, setError] = useState(null)
  const [courseCount, setCourseCount] = useState(0)

  const testConnection = async () => {
    try {
      setConnectionStatus('testing')
      setError(null)
      
      // Test basic connection by selecting all courses
      const { data, error, count } = await supabase
        .from('courses')
        .select('*', { count: 'exact' })
      
      if (error) {
        throw error
      }
      
      setCourseCount(count || data?.length || 0)
      setConnectionStatus('success')
    } catch (err) {
      console.error('Database connection error:', err)
      setError(err.message)
      setConnectionStatus('error')
    }
  }

  useEffect(() => {
    testConnection()
  }, [])

  const getStatusColor = () => {
    switch (connectionStatus) {
      case 'testing': return 'info'
      case 'success': return 'success'
      case 'error': return 'error'
      default: return 'info'
    }
  }

  const getStatusMessage = () => {
    switch (connectionStatus) {
      case 'testing': return 'Testing database connection...'
      case 'success': return `✅ Database connected successfully! Found ${courseCount} courses.`
      case 'error': return `❌ Database connection failed: ${error}`
      default: return 'Unknown status'
    }
  }

  return (
    <Box sx={{ mt: 4, p: 3, border: 1, borderColor: 'grey.300', borderRadius: 2 }}>
      <Typography variant="h6" gutterBottom>
        Database Connection Test
      </Typography>
      
      <Alert severity={getStatusColor()} sx={{ mb: 2 }}>
        {connectionStatus === 'testing' && (
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <CircularProgress size={16} />
            {getStatusMessage()}
          </Box>
        )}
        {connectionStatus !== 'testing' && getStatusMessage()}
      </Alert>

      {connectionStatus === 'error' && (
        <Button 
          variant="outlined" 
          onClick={testConnection}
          sx={{ mt: 1 }}
        >
          Retry Connection
        </Button>
      )}

      <Typography variant="body2" color="text.secondary" sx={{ mt: 2 }}>
        Supabase URL: {import.meta.env.VITE_SUPABASE_URL}
      </Typography>
    </Box>
  )
}