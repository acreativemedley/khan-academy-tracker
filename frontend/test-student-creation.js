// Test script to create student profile
// Run this with: node test-student-creation.js

import { createClient } from '@supabase/supabase-js'
import dotenv from 'dotenv'

// Load environment variables
dotenv.config({ path: '.env.local' })

const supabaseUrl = process.env.VITE_SUPABASE_URL
const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseAnonKey) {
  console.error('❌ Missing Supabase environment variables')
  console.log('VITE_SUPABASE_URL:', supabaseUrl ? 'Set' : 'Missing')
  console.log('VITE_SUPABASE_ANON_KEY:', supabaseAnonKey ? 'Set' : 'Missing')
  process.exit(1)
}

const supabase = createClient(supabaseUrl, supabaseAnonKey)

async function testStudentCreation() {
  console.log('🧪 Testing student creation...\n')

  // 1. Verify table access
  console.log('1. Checking students table access...')
  try {
    const { data: existingStudents, error: fetchError } = await supabase
      .from('students')
      .select('id, display_name, grade_level, created_at')
      .limit(5)

    if (fetchError) {
      console.error('❌ Error accessing students table:', fetchError.message)
      return false
    }

    console.log('✅ Students table accessible')
    console.log(`   Found ${existingStudents.length} existing students`)
    if (existingStudents.length > 0) {
      existingStudents.forEach(student => {
        console.log(`   - ${student.display_name} (${student.grade_level})`)
      })
    }
  } catch (err) {
    console.error('❌ Unexpected error accessing table:', err.message)
    return false
  }

  // 2. Check if test student already exists
  console.log('\n2. Checking for existing test student...')
  try {
    const { data: testStudent, error: checkError } = await supabase
      .from('students')
      .select('*')
      .eq('display_name', 'Test Student')
      .maybeSingle()

    if (checkError) {
      console.error('❌ Error checking for test student:', checkError.message)
      return false
    }

    if (testStudent) {
      console.log('ℹ️  Test student already exists:')
      console.log(`   ID: ${testStudent.id}`)
      console.log(`   Name: ${testStudent.display_name}`)
      console.log(`   Grade: ${testStudent.grade_level}`)
      console.log(`   Created: ${testStudent.created_at}`)
      return true
    } else {
      console.log('ℹ️  No test student found, will create new one')
    }
  } catch (err) {
    console.error('❌ Unexpected error checking for test student:', err.message)
    return false
  }

  // 3. Create test student
  console.log('\n3. Creating test student...')
  try {
    const { data: newStudent, error: createError } = await supabase
      .from('students')
      .insert([
        {
          display_name: 'Test Student',
          grade_level: '10th Grade',
          parent_email: 'parent@example.com',
          timezone: 'America/New_York',
          school_days: ['sunday', 'monday', 'thursday', 'friday', 'saturday']
          // NO TIME TRACKING - this system tracks activity completion only
        }
      ])
      .select()
      .single()

    if (createError) {
      console.error('❌ Error creating test student:', createError.message)
      return false
    }

    console.log('✅ Test student created successfully!')
    console.log(`   ID: ${newStudent.id}`)
    console.log(`   Name: ${newStudent.display_name}`)
    console.log(`   Grade: ${newStudent.grade_level}`)
    console.log(`   Email: ${newStudent.parent_email}`)
    console.log(`   School Days: ${newStudent.school_days.join(', ')}`)
    console.log(`   Created: ${newStudent.created_at}`)

    return true
  } catch (err) {
    console.error('❌ Unexpected error creating student:', err.message)
    return false
  }
}

// Run the test
testStudentCreation()
  .then(success => {
    if (success) {
      console.log('\n🎉 Student creation test completed successfully!')
    } else {
      console.log('\n💥 Student creation test failed!')
      process.exit(1)
    }
  })
  .catch(err => {
    console.error('💥 Fatal error:', err.message)
    process.exit(1)
  })