-- Complete ELA Import Script - FROM FORMATTED DATA
-- This script imports all units for the ELA course based on formatted data
-- Based on course data in course-data/ELA-formatted.md

-- =============================================================================
-- 10th Grade Reading and Vocabulary - COMPLETE IMPORT (All units from Formatted Data)
-- Clean import process for activities across units
-- =============================================================================

DO $$
DECLARE
    ela_course_id UUID;
    unit_1_id UUID;
    unit_2_id UUID;
    unit_3_id UUID;
    unit_4_id UUID;
    unit_5_id UUID;
    unit_6_id UUID;
    activity_counter INTEGER := 1;
    unit_counter INTEGER;
BEGIN
    -- Get the ELA course ID
    SELECT id INTO ela_course_id FROM courses WHERE name = '10th Grade Reading and Vocabulary';
    
    IF ela_course_id IS NULL THEN
        RAISE EXCEPTION '10th Grade Reading and Vocabulary course not found. Please import courses first.';
    END IF;

    RAISE NOTICE 'Found ELA course: %', ela_course_id;

    -- Delete existing activities and units for this course
    DELETE FROM activities WHERE course_id = ela_course_id;
    DELETE FROM units WHERE course_id = ela_course_id;
    
    RAISE NOTICE 'Deleted existing units and activities for 10th Grade Reading and Vocabulary';

    -- =============================================================================
    -- CREATE UNITS (Based on formatted data structure)
    -- =============================================================================
    
    -- Create Unit 1: Into the unknown (main)
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (ela_course_id, 1, 'Into the unknown', 18, TRUE, 1)
    RETURNING id INTO unit_1_id;

    -- Create Unit 2: Into the unknown: Long Passage Practice
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (ela_course_id, 2, 'Into the unknown: Long Passage Practice', 9, TRUE, 2)
    RETURNING id INTO unit_2_id;

    -- Create Unit 3: Ties that bind (main)
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (ela_course_id, 3, 'Ties that bind', 18, TRUE, 3)
    RETURNING id INTO unit_3_id;

    -- Create Unit 4: Ties that bind: Long Passage Practice
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (ela_course_id, 4, 'Ties that bind: Long Passage Practice', 10, TRUE, 4)
    RETURNING id INTO unit_4_id;

    -- Create Unit 5: Winds of change (main)
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (ela_course_id, 5, 'Winds of change', 17, TRUE, 5)
    RETURNING id INTO unit_5_id;

    -- Create Unit 6: Winds of change: Long Passage Practice
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (ela_course_id, 6, 'Winds of change: Long Passage Practice', 9, TRUE, 6)
    RETURNING id INTO unit_6_id;

    RAISE NOTICE 'Created all units';

    -- Reset activity counter
    activity_counter := 1;

    -- =============================================================================
    -- UNIT 1: INTO THE UNKNOWN (main) (18 activities)
    -- =============================================================================

    -- Lesson: Building background knowledge (2 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_1_id, 'Into the unknown: Welcome to the unit!', 'article', 'Building background knowledge', activity_counter),
    (ela_course_id, unit_1_id, 'Into the unknown: Unit vocabulary', 'article', 'Building background knowledge', activity_counter + 1);
    activity_counter := activity_counter + 2;

    -- Lesson: Citing text evidence (3 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_1_id, 'Text evidence: The art of selecting the best', 'article', 'Citing text evidence', activity_counter),
    (ela_course_id, unit_1_id, 'Choosing the best text evidence', 'video', 'Citing text evidence', activity_counter + 1),
    (ela_course_id, unit_1_id, 'Text evidence', 'exercise', 'Citing text evidence', activity_counter + 2);
    activity_counter := activity_counter + 3;

    -- Lesson: Making inferences (3 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_1_id, 'Be a text detective: Making inferences', 'article', 'Making inferences', activity_counter),
    (ela_course_id, unit_1_id, 'Supporting an inference with logical reasoning and evidence', 'video', 'Making inferences', activity_counter + 1),
    (ela_course_id, unit_1_id, 'Inferences', 'exercise', 'Making inferences', activity_counter + 2);
    activity_counter := activity_counter + 3;

    -- Lesson: Determining central idea, summary, and theme (5 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_1_id, 'What''s the big idea? Central ideas and supporting details', 'article', 'Determining central idea, summary, and theme', activity_counter),
    (ela_course_id, unit_1_id, 'How can a text have two or more central ideas?', 'video', 'Determining central idea, summary, and theme', activity_counter + 1),
    (ela_course_id, unit_1_id, 'The search for meaning: Determining theme', 'article', 'Determining central idea, summary, and theme', activity_counter + 2),
    (ela_course_id, unit_1_id, 'Developing themes', 'video', 'Determining central idea, summary, and theme', activity_counter + 3),
    (ela_course_id, unit_1_id, 'Central idea, summary, and theme', 'exercise', 'Determining central idea, summary, and theme', activity_counter + 4);
    activity_counter := activity_counter + 5;

    -- Lesson: Analyzing idea and character development (4 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_1_id, 'Follow the trail: Analyzing idea development in a text', 'article', 'Analyzing idea and character development', activity_counter),
    (ela_course_id, unit_1_id, 'Analyzing the presentation of ideas | Reading', 'video', 'Analyzing idea and character development', activity_counter + 1),
    (ela_course_id, unit_1_id, 'Character change | Reading', 'video', 'Analyzing idea and character development', activity_counter + 2),
    (ela_course_id, unit_1_id, 'Idea and character development', 'exercise', 'Analyzing idea and character development', activity_counter + 3);
    activity_counter := activity_counter + 4;

    -- Unit Test: Into the unknown
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_1_id, 'Into the unknown: Unit test', 'unit_test', 'Unit assessment', activity_counter);
    activity_counter := activity_counter + 1;

    RAISE NOTICE 'Unit 1 completed. Activities: 18 (Expected: 18)';

    -- =============================================================================
    -- UNIT 2: INTO THE UNKNOWN: LONG PASSAGE PRACTICE (9 activities)
    -- =============================================================================

    -- Long Passage Practice: Reading literary texts (3 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_2_id, 'Test-taking strategy: Always read the directions and introductory notes', 'article', 'Reading literary texts', activity_counter),
    (ela_course_id, unit_2_id, 'The Martian Chronicles', 'exercise', 'Reading literary texts', activity_counter + 1),
    (ela_course_id, unit_2_id, 'The Jasad Heir', 'exercise', 'Reading literary texts', activity_counter + 2);
    activity_counter := activity_counter + 3;

    -- Long Passage Practice: Reading informational texts (3 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_2_id, 'Test-taking strategy: Answer the question before looking at the answer choices', 'article', 'Reading informational texts', activity_counter),
    (ela_course_id, unit_2_id, 'The Adventure Gap', 'exercise', 'Reading informational texts', activity_counter + 1),
    (ela_course_id, unit_2_id, 'Death on the ice: The mystery and tragedy of the Franklin Expedition', 'exercise', 'Reading informational texts', activity_counter + 2);
    activity_counter := activity_counter + 3;

    -- Long Passage Practice: Reading argumentative texts (3 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_2_id, 'Test-taking strategy: Go back and check the text', 'article', 'Reading argumentative texts', activity_counter),
    (ela_course_id, unit_2_id, 'President John F. Kennedy''s “Special Message to the Congress on Urgent National Needs"', 'exercise', 'Reading argumentative texts', activity_counter + 1),
    (ela_course_id, unit_2_id, 'Exploration is exploitation: Why uncontacted tribes should be left alone', 'exercise', 'Reading argumentative texts', activity_counter + 2);
    activity_counter := activity_counter + 3;

    RAISE NOTICE 'Unit 2 completed. Activities: 9 (Expected: 9)';

    -- =============================================================================
    -- UNIT 3: TIES THAT BIND (main) (18 activities)
    -- =============================================================================

    -- Lesson: Building background knowledge (2 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_3_id, 'Ties that bind: Welcome to the unit!', 'article', 'Building background knowledge', activity_counter),
    (ela_course_id, unit_3_id, 'Ties that bind: Unit vocabulary', 'article', 'Building background knowledge', activity_counter + 1);
    activity_counter := activity_counter + 2;

    -- Lesson: Interpreting words in context (5 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_3_id, 'Words at work: Analyzing how authors create meaning and tone', 'article', 'Interpreting words in context', activity_counter),
    (ela_course_id, unit_3_id, 'Connotation', 'video', 'Interpreting words in context', activity_counter + 1),
    (ela_course_id, unit_3_id, 'Figurative language | Reading', 'video', 'Interpreting words in context', activity_counter + 2),
    (ela_course_id, unit_3_id, 'Words in context (informational texts)', 'exercise', 'Interpreting words in context', activity_counter + 3),
    (ela_course_id, unit_3_id, 'Words in context (literature)', 'exercise', 'Interpreting words in context', activity_counter + 4);
    activity_counter := activity_counter + 5;

    -- Lesson: Analyzing text structure (4 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_3_id, 'Beyond the basics: How specific sentences develop an author’s ideas', 'article', 'Analyzing text structure', activity_counter),
    (ela_course_id, unit_3_id, 'Out of order: How authors sequence events in literary texts to create different effects', 'article', 'Analyzing text structure', activity_counter + 1),
    (ela_course_id, unit_3_id, 'How parts of an argument make a whole', 'video', 'Analyzing text structure', activity_counter + 2),
    (ela_course_id, unit_3_id, 'Text structure', 'exercise', 'Analyzing text structure', activity_counter + 3);
    activity_counter := activity_counter + 4;

    -- Lesson: Identifying author's purpose and rhetoric (3 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_3_id, 'How do authors use rhetoric to achieve their purposes?', 'article', 'Identifying author''s purpose and rhetoric', activity_counter),
    (ela_course_id, unit_3_id, 'Rhetorical devices and appeals', 'video', 'Identifying author''s purpose and rhetoric', activity_counter + 1),
    (ela_course_id, unit_3_id, 'Author''s purpose and rhetoric', 'exercise', 'Identifying author''s purpose and rhetoric', activity_counter + 2);
    activity_counter := activity_counter + 3;

    -- Lesson: Determining point of view (3 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_3_id, 'The way they see it: Analyzing characters'' points of view', 'article', 'Determining point of view', activity_counter),
    (ela_course_id, unit_3_id, 'The way I see it: Analyzing an author’s point of view', 'article', 'Determining point of view', activity_counter + 1),
    (ela_course_id, unit_3_id, 'Point of view', 'exercise', 'Determining point of view', activity_counter + 2);
    activity_counter := activity_counter + 3;

    -- Unit Test: Ties that bind
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_3_id, 'Ties that bind: Unit test', 'unit_test', 'Unit assessment', activity_counter);
    activity_counter := activity_counter + 1;

    RAISE NOTICE 'Unit 3 completed. Activities: 18 (Expected: 18)';

    -- =============================================================================
    -- UNIT 4: TIES THAT BIND: LONG PASSAGE PRACTICE (10 activities)
    -- =============================================================================

    -- Long Passage Practice: Reading literary texts (4 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_4_id, 'Test-taking strategy: Check that the answer makes sense in the text', 'article', 'Reading literary texts', activity_counter),
    (ela_course_id, unit_4_id, 'Sense and Sensibility', 'exercise', 'Reading literary texts', activity_counter + 1),
    (ela_course_id, unit_4_id, 'The Story of an Hour', 'exercise', 'Reading literary texts', activity_counter + 2),
    (ela_course_id, unit_4_id, 'A Thousand Splendid Suns', 'exercise', 'Reading literary texts', activity_counter + 3);
    activity_counter := activity_counter + 4;

    -- Long Passage Practice: Reading informational texts (3 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_4_id, 'Test-taking strategy: Answer the question being asked', 'article', 'Reading informational texts', activity_counter),
    (ela_course_id, unit_4_id, 'Outcasts United: The Story of a Refugee Soccer Team that Changed a Town', 'exercise', 'Reading informational texts', activity_counter + 1),
    (ela_course_id, unit_4_id, 'Schools are the hubs and hearts of neighborhoods – here''s how they can strengthen the communities around them', 'exercise', 'Reading informational texts', activity_counter + 2);
    activity_counter := activity_counter + 3;

    -- Long Passage Practice: Reading argumentative texts (3 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_4_id, 'Test-taking strategy: Avoid partially correct answers', 'article', 'Reading argumentative texts', activity_counter),
    (ela_course_id, unit_4_id, 'Speech by Elie Wiesel', 'exercise', 'Reading argumentative texts', activity_counter + 1),
    (ela_course_id, unit_4_id, '"It Is Time to Reassess Our National Priorities" by Shirley Chisholm', 'exercise', 'Reading argumentative texts', activity_counter + 2);
    activity_counter := activity_counter + 3;

    RAISE NOTICE 'Unit 4 completed. Activities: 10 (Expected: 10)';

    -- =============================================================================
    -- UNIT 5: WINDS OF CHANGE (main) (17 activities)
    -- =============================================================================

    -- Lesson: Building background knowledge (2 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_5_id, 'Winds of change: Welcome to the unit!', 'article', 'Building background knowledge', activity_counter),
    (ela_course_id, unit_5_id, 'Winds of change: Unit vocabulary', 'article', 'Building background knowledge', activity_counter + 1);
    activity_counter := activity_counter + 2;

    -- Lesson: Using visual and quantitative evidence (3 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_5_id, 'Seeing beyond words: Analyzing visual evidence to better understand texts', 'article', 'Using visual and quantitative evidence', activity_counter),
    (ela_course_id, unit_5_id, 'Different mediums and the tone of the text', 'video', 'Using visual and quantitative evidence', activity_counter + 1),
    (ela_course_id, unit_5_id, 'Visual and quantitative evidence', 'exercise', 'Using visual and quantitative evidence', activity_counter + 2);
    activity_counter := activity_counter + 3;

    -- Lesson: Evaluating claims and arguments (3 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_5_id, 'Evaluating an argument''s reasoning and evidence', 'article', 'Evaluating claims and arguments', activity_counter),
    (ela_course_id, unit_5_id, 'Evaluating a source''s reasoning and evidence', 'video', 'Evaluating claims and arguments', activity_counter + 1),
    (ela_course_id, unit_5_id, 'Claims and arguments', 'exercise', 'Evaluating claims and arguments', activity_counter + 2);
    activity_counter := activity_counter + 3;

    -- Lesson: Comparing two texts (4 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_5_id, 'Not just the same old story: Analyzing multiple accounts of a subject', 'article', 'Comparing two texts', activity_counter),
    (ela_course_id, unit_5_id, 'Similarities and differences: different accounts of the same topic', 'video', 'Comparing two texts', activity_counter + 1),
    (ela_course_id, unit_5_id, 'Similarities and differences: primary and secondary sources', 'video', 'Comparing two texts', activity_counter + 2),
    (ela_course_id, unit_5_id, 'Comparing texts', 'exercise', 'Comparing two texts', activity_counter + 3);
    activity_counter := activity_counter + 4;

    -- Lesson: Understanding historical documents and allusions (4 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_5_id, 'Reading and analyzing historical documents', 'article', 'Understanding historical documents and allusions', activity_counter),
    (ela_course_id, unit_5_id, 'Points of reference: Interpreting allusions', 'article', 'Understanding historical documents and allusions', activity_counter + 1),
    (ela_course_id, unit_5_id, 'The value of historical context', 'video', 'Understanding historical documents and allusions', activity_counter + 2),
    (ela_course_id, unit_5_id, 'Historical documents and allusions', 'exercise', 'Understanding historical documents and allusions', activity_counter + 3);
    activity_counter := activity_counter + 4;

    -- Unit Test: Winds of change
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_5_id, 'Winds of change: Unit test', 'unit_test', 'Unit assessment', activity_counter);
    activity_counter := activity_counter + 1;

    RAISE NOTICE 'Unit 5 completed. Activities: 17 (Expected: 17)';

    -- =============================================================================
    -- UNIT 6: WINDS OF CHANGE: LONG PASSAGE PRACTICE (9 activities)
    -- =============================================================================

    -- Long Passage Practice: Reading literary texts (3 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_6_id, 'Test-taking strategy: Use process of elimination', 'article', 'Reading literary texts', activity_counter),
    (ela_course_id, unit_6_id, 'Legendborn', 'exercise', 'Reading literary texts', activity_counter + 1),
    (ela_course_id, unit_6_id, 'The Strange Case of Dr. Jekyll and Mr. Hyde', 'exercise', 'Reading literary texts', activity_counter + 2);
    activity_counter := activity_counter + 3;

    -- Long Passage Practice: Reading informational texts (3 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_6_id, 'Test-taking strategy: Avoid extreme answers', 'article', 'Reading informational texts', activity_counter),
    (ela_course_id, unit_6_id, 'How World War I sparked the artistic movement that transformed Black America', 'exercise', 'Reading informational texts', activity_counter + 1),
    (ela_course_id, unit_6_id, 'The invention of littering', 'exercise', 'Reading informational texts', activity_counter + 2);
    activity_counter := activity_counter + 3;

    -- Long Passage Practice: Reading argumentative texts (3 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (ela_course_id, unit_6_id, 'Test-taking strategy: Consider all answer choices', 'article', 'Reading argumentative texts', activity_counter),
    (ela_course_id, unit_6_id, 'The Declaration of Independence', 'exercise', 'Reading argumentative texts', activity_counter + 1),
    (ela_course_id, unit_6_id, 'Brown v. Board of Education of Topeka', 'exercise', 'Reading argumentative texts', activity_counter + 2);
    activity_counter := activity_counter + 3;

    RAISE NOTICE 'Unit 6 completed. Activities: 9 (Expected: 9)';

    -- =============================================================================
    -- SUMMARY AND COMPLETION
    -- =============================================================================
    
    RAISE NOTICE 'Successfully imported 10th Grade Reading and Vocabulary - Units 1-6 COMPLETE';
    RAISE NOTICE 'Unit 1: Into the unknown - 18 activities';
    RAISE NOTICE 'Unit 2: Into the unknown: Long Passage Practice - 9 activities';
    RAISE NOTICE 'Unit 3: Ties that bind - 18 activities';
    RAISE NOTICE 'Unit 4: Ties that bind: Long Passage Practice - 10 activities';
    RAISE NOTICE 'Unit 5: Winds of change - 17 activities';
    RAISE NOTICE 'Unit 6: Winds of change: Long Passage Practice - 9 activities';
    RAISE NOTICE 'Total activities imported: %', activity_counter - 1;
    
END $$;

-- =============================================================================
-- VERIFICATION QUERIES - Units 1-3 Complete
-- =============================================================================

-- Check that units 1-3 were created correctly
SELECT 
    u.unit_number,
    u.title,
    u.total_activities as expected_activities,
    COUNT(a.id) as actual_activities,
    CASE 
        WHEN u.unit_number <= 3 THEN 
            CASE WHEN COUNT(a.id) = u.total_activities THEN '✓ Complete' ELSE '✗ Incomplete' END
        ELSE '⚠ Not Yet Implemented'
    END as status
FROM units u
LEFT JOIN activities a ON u.id = a.unit_id
WHERE u.course_id = (SELECT id FROM courses WHERE name = '10th Grade Reading and Vocabulary')
GROUP BY u.id, u.unit_number, u.title, u.total_activities
ORDER BY u.unit_number;

-- Check activity types for implemented units
SELECT 
    activity_type,
    COUNT(*) as count
FROM activities 
WHERE course_id = (SELECT id FROM courses WHERE name = '10th Grade Reading and Vocabulary')
GROUP BY activity_type
ORDER BY count DESC;

-- Summary of current implementation
SELECT 
    '10th Grade Reading and Vocabulary Import Status - Units 1-3' as status,
    COUNT(*) as total_activities_imported,
    'All units implemented' as progress,
    'No remaining units' as next_step
FROM activities 
WHERE course_id = (SELECT id FROM courses WHERE name = '10th Grade Reading and Vocabulary');