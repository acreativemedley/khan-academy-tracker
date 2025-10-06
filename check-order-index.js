import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  'https://ynwhqyzrrpkckekymvfj.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlud2hxeXpycnBrY2tla3ltdmZqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc0OTc1NjcsImV4cCI6MjA1MzA3MzU2N30.5P8vAhU4x_mq_DXp41Vs7BmD4sOy9c8BhUt0hcMHPnE'
);

async function checkOrderIndex() {
  // Get World History course
  const { data: courses } = await supabase
    .from('courses')
    .select('id, name')
    .ilike('name', '%world%history%');
  
  if (!courses || courses.length === 0) {
    console.log('No World History course found');
    return;
  }

  const course = courses[0];
  console.log(`\n=== ${course.name} ===`);
  console.log(`Course ID: ${course.id}\n`);

  // Get units
  const { data: units } = await supabase
    .from('units')
    .select('id, unit_number, unit_name')
    .eq('course_id', course.id)
    .order('unit_number');

  console.log('Units:');
  units.forEach(u => console.log(`  Unit ${u.unit_number}: ${u.unit_name}`));

  // Get activities grouped by unit
  const { data: activities } = await supabase
    .from('activities')
    .select('id, activity_name, order_index, unit_id, is_exam')
    .eq('course_id', course.id)
    .order('unit_id')
    .order('order_index');

  console.log('\n=== Order Index by Unit ===');
  let currentUnitId = null;
  
  activities.forEach(a => {
    if (a.unit_id !== currentUnitId) {
      currentUnitId = a.unit_id;
      const unit = units.find(u => u.id === a.unit_id);
      console.log(`\n--- Unit ${unit?.unit_number || '?'}: ${unit?.unit_name || 'Unknown'} ---`);
    }
    const examMark = a.is_exam ? ' [EXAM]' : '';
    console.log(`  ${a.order_index}: ${a.activity_name}${examMark}`);
  });

  // Check for duplicate order_index values
  const orderIndexes = activities.map(a => a.order_index);
  const duplicates = orderIndexes.filter((item, index) => orderIndexes.indexOf(item) !== index);
  
  if (duplicates.length > 0) {
    console.log('\n⚠️  DUPLICATE ORDER_INDEX VALUES FOUND:');
    console.log(duplicates);
  } else {
    console.log('\n✅ No duplicate order_index values');
  }

  // Check if order_index is sequential
  const sorted = [...orderIndexes].sort((a, b) => a - b);
  const isSequential = sorted.every((val, idx) => idx === 0 || val === sorted[idx - 1] + 1);
  
  if (!isSequential) {
    console.log('⚠️  ORDER_INDEX VALUES ARE NOT SEQUENTIAL (gaps or duplicates)');
    console.log('   First 20 values:', sorted.slice(0, 20));
  } else {
    console.log('✅ Order_index values are sequential');
  }
}

checkOrderIndex().catch(console.error);
