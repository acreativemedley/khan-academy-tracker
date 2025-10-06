import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  'https://ynwhqyzrrpkckekymvfj.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlud2hxeXpycnBrY2tla3ltdmZqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc0OTc1NjcsImV4cCI6MjA1MzA3MzU2N30.5P8vAhU4x_mq_DXp41Vs7BmD4sOy9c8BhUt0hcMHPnE'
);

async function listCourses() {
  const { data: courses, error } = await supabase
    .from('courses')
    .select('id, name, total_activities')
    .order('name');
  
  if (error) {
    console.error('Error:', error);
    return;
  }

  console.log('\n=== All Courses ===\n');
  courses.forEach(c => {
    console.log(`${c.name} (${c.total_activities} activities)`);
    console.log(`  ID: ${c.id}\n`);
  });
}

listCourses().catch(console.error);
