import { supabase } from '../services/supabase'

// Utility function to create test student
export async function createTestStudent() {
  try {
    // Insert test student record
    const { data, error } = await supabase
      .from('students')
      .insert([
        {
          display_name: 'Test Student',
          student_email: 'student@example.com',
          parent_email: 'parent@example.com',
          timezone: 'America/Chicago',
          school_days: ['sunday', 'monday', 'thursday', 'friday', 'saturday']
        }
      ])
      .select()

    if (error) {
      console.error('Error creating test student:', error)
      return { success: false, error: error.message }
    }

    console.log('Test student created successfully:', data)
    return { success: true, data }
  } catch (err) {
    console.error('Unexpected error:', err)
    return { success: false, error: err.message }
  }
}

// Utility function to get test student
export async function getTestStudent() {
  try {
    const { data, error } = await supabase
      .from('students')
      .select('*')
      .eq('display_name', 'Test Student')
      .single()

    if (error && error.code !== 'PGRST116') { // PGRST116 = no rows returned
      console.error('Error fetching test student:', error)
      return { success: false, error: error.message }
    }

    return { success: true, data }
  } catch (err) {
    console.error('Unexpected error:', err)
    return { success: false, error: err.message }
  }
}

// Utility function to verify students table
export async function verifyStudentsTable() {
  try {
    const { data, error } = await supabase
      .from('students')
      .select('id, display_name, grade_level, created_at')
      .limit(5)

    if (error) {
      console.error('Error accessing students table:', error)
      return { success: false, error: error.message }
    }

    console.log('Students table accessible. Current records:', data)
    return { success: true, data }
  } catch (err) {
    console.error('Unexpected error:', err)
    return { success: false, error: err.message }
  }
}