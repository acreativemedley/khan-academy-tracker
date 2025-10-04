-- Unit 8: Trigonometry Import Script - FROM FORMATTED DATA
-- This script imports Unit 8 (Trigonometry) with 82 activities total
-- Based on math-data-formatted.md (the corrected, cleaned data)
-- This is the largest unit in Integrated Math 3

-- =============================================================================
-- UNIT 8: TRIGONOMETRY - COMPLETE IMPORT (82 activities)
-- 12 lessons, 4 quizzes, 1 unit test
-- =============================================================================

DO $$
DECLARE
    math_course_id UUID;
    unit_8_id UUID;
    activity_counter INTEGER := 225; -- Starting after Units 1-7 (224 activities)
BEGIN
    -- Get the Integrated Math 3 course ID
    SELECT id INTO math_course_id FROM courses WHERE name = 'Integrated Math 3';
    
    IF math_course_id IS NULL THEN
        RAISE EXCEPTION 'Integrated Math 3 course not found. Please run main import script first.';
    END IF;

    -- Get Unit 8 ID
    SELECT id INTO unit_8_id FROM units 
    WHERE course_id = math_course_id AND unit_number = 8;
    
    IF unit_8_id IS NULL THEN
        RAISE EXCEPTION 'Unit 8 not found. Please run main import script first.';
    END IF;

    RAISE NOTICE 'Found Unit 8: Trigonometry - %', unit_8_id;

    -- Delete existing activities for Unit 8 only
    DELETE FROM activities WHERE unit_id = unit_8_id;
    
    RAISE NOTICE 'Deleted existing activities for Unit 8: Trigonometry';

    -- =============================================================================
    -- UNIT 8: TRIGONOMETRY (82 activities) - COMPLETE FROM FORMATTED DATA
    -- =============================================================================
    
    -- Lesson 1: Law of sines (4 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (math_course_id, unit_8_id, 'Solving for a side with the law of sines', 'video', 'Law of sines', activity_counter),
    (math_course_id, unit_8_id, 'Solving for an angle with the law of sines', 'video', 'Law of sines', activity_counter + 1),
    (math_course_id, unit_8_id, 'Solve triangles using the law of sines', 'exercise', 'Law of sines', activity_counter + 2),
    (math_course_id, unit_8_id, 'Proof of the law of sines', 'video', 'Law of sines', activity_counter + 3);
    activity_counter := activity_counter + 4;
    
    -- Lesson 2: Law of cosines (4 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (math_course_id, unit_8_id, 'Solving for a side with the law of cosines', 'video', 'Law of cosines', activity_counter),
    (math_course_id, unit_8_id, 'Solving for an angle with the law of cosines', 'video', 'Law of cosines', activity_counter + 1),
    (math_course_id, unit_8_id, 'Solve triangles using the law of cosines', 'exercise', 'Law of cosines', activity_counter + 2),
    (math_course_id, unit_8_id, 'Proof of the law of cosines', 'video', 'Law of cosines', activity_counter + 3);
    activity_counter := activity_counter + 4;
    
    -- Lesson 3: Solving general triangles (3 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (math_course_id, unit_8_id, 'Trig word problem: stars', 'video', 'Solving general triangles', activity_counter),
    (math_course_id, unit_8_id, 'General triangle word problems', 'exercise', 'Solving general triangles', activity_counter + 1),
    (math_course_id, unit_8_id, 'Laws of sines and cosines review', 'article', 'Solving general triangles', activity_counter + 2);
    activity_counter := activity_counter + 3;
    
    -- Quiz 1: Trigonometry
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (math_course_id, unit_8_id, 'Quiz 1: Trigonometry', 'quiz', 'Quiz 1: Trigonometry', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 4: Unit circle introduction (4 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (math_course_id, unit_8_id, 'Unit circle', 'video', 'Unit circle introduction', activity_counter),
    (math_course_id, unit_8_id, 'Unit circle', 'exercise', 'Unit circle introduction', activity_counter + 1),
    (math_course_id, unit_8_id, 'The trig functions & right triangle trig ratios', 'video', 'Unit circle introduction', activity_counter + 2),
    (math_course_id, unit_8_id, 'Trig - unit circle review', 'article', 'Unit circle introduction', activity_counter + 3);
    activity_counter := activity_counter + 4;
    
    -- Lesson 5: Radians (7 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (math_course_id, unit_8_id, 'Intro to radians', 'video', 'Radians', activity_counter),
    (math_course_id, unit_8_id, 'Radians & degrees', 'video', 'Radians', activity_counter + 1),
    (math_course_id, unit_8_id, 'Degrees to radians', 'video', 'Radians', activity_counter + 2),
    (math_course_id, unit_8_id, 'Radians to degrees', 'video', 'Radians', activity_counter + 3),
    (math_course_id, unit_8_id, 'Radians & degrees', 'exercise', 'Radians', activity_counter + 4),
    (math_course_id, unit_8_id, 'Radian angles & quadrants', 'video', 'Radians', activity_counter + 5),
    (math_course_id, unit_8_id, 'Unit circle (with radians)', 'exercise', 'Radians', activity_counter + 6);
    activity_counter := activity_counter + 7;
    
    -- Lesson 6: The Pythagorean identity (4 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (math_course_id, unit_8_id, 'Proof of the Pythagorean trig identity', 'video', 'The Pythagorean identity', activity_counter),
    (math_course_id, unit_8_id, 'Using the Pythagorean trig identity', 'video', 'The Pythagorean identity', activity_counter + 1),
    (math_course_id, unit_8_id, 'Use the Pythagorean identity', 'exercise', 'The Pythagorean identity', activity_counter + 2),
    (math_course_id, unit_8_id, 'Pythagorean identity review', 'article', 'The Pythagorean identity', activity_counter + 3);
    activity_counter := activity_counter + 4;
    
    -- Lesson 7: Trigonometric values of special angles (2 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (math_course_id, unit_8_id, 'Trig values of π/4', 'video', 'Trigonometric values of special angles', activity_counter),
    (math_course_id, unit_8_id, 'Trig values of special angles', 'exercise', 'Trigonometric values of special angles', activity_counter + 1);
    activity_counter := activity_counter + 2;
    
    -- Quiz 2: Trigonometry
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (math_course_id, unit_8_id, 'Quiz 2: Trigonometry', 'quiz', 'Quiz 2: Trigonometry', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 8: Graphs of sin(x), cos(x), and tan(x) (3 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (math_course_id, unit_8_id, 'Graph of y=sin(x)', 'video', 'Graphs of sin(x), cos(x), and tan(x)', activity_counter),
    (math_course_id, unit_8_id, 'Intersection points of y=sin(x) and y=cos(x)', 'video', 'Graphs of sin(x), cos(x), and tan(x)', activity_counter + 1),
    (math_course_id, unit_8_id, 'Graph of y=tan(x)', 'video', 'Graphs of sin(x), cos(x), and tan(x)', activity_counter + 2);
    activity_counter := activity_counter + 3;
    
    -- Lesson 9: Amplitude, midline, & period (5 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (math_course_id, unit_8_id, 'Features of sinusoidal functions', 'video', 'Amplitude, midline, & period', activity_counter),
    (math_course_id, unit_8_id, 'Midline of sinusoidal functions from graph', 'exercise', 'Amplitude, midline, & period', activity_counter + 1),
    (math_course_id, unit_8_id, 'Amplitude of sinusoidal functions from graph', 'exercise', 'Amplitude, midline, & period', activity_counter + 2),
    (math_course_id, unit_8_id, 'Period of sinusoidal functions from graph', 'exercise', 'Amplitude, midline, & period', activity_counter + 3),
    (math_course_id, unit_8_id, 'Midline, amplitude, and period review', 'article', 'Amplitude, midline, & period', activity_counter + 4);
    activity_counter := activity_counter + 5;
    
    -- Lesson 10: Transforming sinusoidal graphs (6 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (math_course_id, unit_8_id, 'Amplitude & period of sinusoidal functions from equation', 'video', 'Transforming sinusoidal graphs', activity_counter),
    (math_course_id, unit_8_id, 'Transforming sinusoidal graphs: vertical stretch & horizontal reflection', 'video', 'Transforming sinusoidal graphs', activity_counter + 1),
    (math_course_id, unit_8_id, 'Transforming sinusoidal graphs: vertical & horizontal stretches', 'video', 'Transforming sinusoidal graphs', activity_counter + 2),
    (math_course_id, unit_8_id, 'Amplitude of sinusoidal functions from equation', 'exercise', 'Transforming sinusoidal graphs', activity_counter + 3),
    (math_course_id, unit_8_id, 'Midline of sinusoidal functions from equation', 'exercise', 'Transforming sinusoidal graphs', activity_counter + 4),
    (math_course_id, unit_8_id, 'Period of sinusoidal functions from equation', 'exercise', 'Transforming sinusoidal graphs', activity_counter + 5);
    activity_counter := activity_counter + 6;
    
    -- Quiz 3: Trigonometry
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (math_course_id, unit_8_id, 'Quiz 3: Trigonometry', 'quiz', 'Quiz 3: Trigonometry', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 11: Graphing sinusoidal functions (6 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (math_course_id, unit_8_id, 'Example: Graphing y=3⋅sin(½⋅x)-2', 'video', 'Graphing sinusoidal functions', activity_counter),
    (math_course_id, unit_8_id, 'Example: Graphing y=-cos(π⋅x)+1.5', 'video', 'Graphing sinusoidal functions', activity_counter + 1),
    (math_course_id, unit_8_id, 'Graph sinusoidal functions', 'exercise', 'Graphing sinusoidal functions', activity_counter + 2),
    (math_course_id, unit_8_id, 'Sinusoidal function from graph', 'video', 'Graphing sinusoidal functions', activity_counter + 3),
    (math_course_id, unit_8_id, 'Construct sinusoidal functions', 'exercise', 'Graphing sinusoidal functions', activity_counter + 4),
    (math_course_id, unit_8_id, 'Graph sinusoidal functions: phase shift', 'exercise', 'Graphing sinusoidal functions', activity_counter + 5);
    activity_counter := activity_counter + 6;
    
    -- Lesson 12: Sinusoidal models (7 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (math_course_id, unit_8_id, 'Interpreting trigonometric graphs in context', 'video', 'Sinusoidal models', activity_counter),
    (math_course_id, unit_8_id, 'Interpret trigonometric graphs in context', 'exercise', 'Sinusoidal models', activity_counter + 1),
    (math_course_id, unit_8_id, 'Trig word problem: modeling daily temperature', 'video', 'Sinusoidal models', activity_counter + 2),
    (math_course_id, unit_8_id, 'Trig word problem: modeling annual temperature', 'video', 'Sinusoidal models', activity_counter + 3),
    (math_course_id, unit_8_id, 'Model with sinusoidal functions', 'exercise', 'Sinusoidal models', activity_counter + 4),
    (math_course_id, unit_8_id, 'Trig word problem: length of day (phase shift)', 'video', 'Sinusoidal models', activity_counter + 5),
    (math_course_id, unit_8_id, 'Modeling with sinusoidal functions: phase shift', 'exercise', 'Sinusoidal models', activity_counter + 6);
    activity_counter := activity_counter + 7;
    
    -- Quiz 4: Trigonometry
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (math_course_id, unit_8_id, 'Quiz 4: Trigonometry', 'quiz', 'Quiz 4: Trigonometry', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Unit Test: Trigonometry
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (math_course_id, unit_8_id, 'Unit Test: Trigonometry', 'unit_test', 'Unit Test: Trigonometry', activity_counter);
    activity_counter := activity_counter + 1;

    RAISE NOTICE 'Unit 8 completed. Activities: 82 (Expected: 82)';
    RAISE NOTICE 'Total activities imported so far: %', activity_counter - 1;
    RAISE NOTICE 'Unit 8: Trigonometry - COMPLETE';
    
END $$;

-- =============================================================================
-- VERIFICATION QUERIES - Unit 8 Only
-- =============================================================================

-- Check that Unit 8 was created correctly
SELECT 
    u.unit_number,
    u.title,
    u.total_activities as expected_activities,
    COUNT(a.id) as actual_activities,
    CASE WHEN COUNT(a.id) = u.total_activities THEN '✓ Complete' ELSE '✗ Incomplete' END as status
FROM units u
LEFT JOIN activities a ON u.id = a.unit_id
WHERE u.course_id = (SELECT id FROM courses WHERE name = 'Integrated Math 3')
  AND u.unit_number = 8
GROUP BY u.id, u.unit_number, u.title, u.total_activities
ORDER BY u.unit_number;

-- Check activity types for Unit 8
SELECT 
    activity_type,
    COUNT(*) as count
FROM activities a
JOIN units u ON a.unit_id = u.id
WHERE u.course_id = (SELECT id FROM courses WHERE name = 'Integrated Math 3')
  AND u.unit_number = 8
GROUP BY activity_type
ORDER BY count DESC;

-- Check lesson breakdown for Unit 8
SELECT 
    lesson_name,
    COUNT(*) as activity_count,
    STRING_AGG(DISTINCT activity_type::text, ', ' ORDER BY activity_type::text) as activity_types
FROM activities a
JOIN units u ON a.unit_id = u.id
WHERE u.course_id = (SELECT id FROM courses WHERE name = 'Integrated Math 3')
  AND u.unit_number = 8
GROUP BY lesson_name
ORDER BY MIN(a.order_index);

-- Summary of Unit 8 implementation
SELECT 
    'Unit 8: Trigonometry Import Status' as status,
    COUNT(*) as total_activities_imported,
    '82 activities complete - Largest unit in Integrated Math 3' as notes
FROM activities a
JOIN units u ON a.unit_id = u.id
WHERE u.course_id = (SELECT id FROM courses WHERE name = 'Integrated Math 3')
  AND u.unit_number = 8;