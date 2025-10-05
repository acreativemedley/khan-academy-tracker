-- SQL Import Script for Unit 1: Beginnings - 600 BCE
-- This script imports all lessons and activities for Unit 1 of the World History course

DO $$
DECLARE
    world_history_course_id UUID;
    unit_id UUID;
    activity_counter INTEGER := 1;
BEGIN
    -- Get the World History course ID
    SELECT id INTO world_history_course_id FROM courses WHERE name = 'World History';

    IF world_history_course_id IS NULL THEN
        RAISE EXCEPTION 'World History course not found. Please import courses first.';
    END IF;

    RAISE NOTICE 'Found World History course: %', world_history_course_id;

    -- Delete existing activities and units for this course
    DELETE FROM activities WHERE course_id = world_history_course_id;
    DELETE FROM units WHERE course_id = world_history_course_id;

    RAISE NOTICE 'Deleted existing units and activities for World History';

    -- =============================================================================
    -- Unit: Beginnings - 600 BCE
    -- =============================================================================

    -- Create Unit: Beginnings - 600 BCE
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (world_history_course_id, 1, 'Beginnings - 600 BCE', 21, TRUE, 1)
    RETURNING id INTO unit_id;

    -- Add activities for "The origin of humans and early human societies"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
        (world_history_course_id, unit_id, 'History and prehistory', 'video', 'The origin of humans and early human societies', activity_counter, FALSE),
        (world_history_course_id, unit_id, 'Prehistory before written records', 'article', 'The origin of humans and early human societies', activity_counter + 1, FALSE),
        (world_history_course_id, unit_id, 'Knowing prehistory', 'exercise', 'The origin of humans and early human societies', activity_counter + 2, FALSE),
        (world_history_course_id, unit_id, 'Homo sapiens and early human migration', 'article', 'The origin of humans and early human societies', activity_counter + 3, FALSE),
        (world_history_course_id, unit_id, 'Peopling the earth', 'video', 'The origin of humans and early human societies', activity_counter + 4, FALSE),
        (world_history_course_id, unit_id, 'Where did humans come from?', 'exercise', 'The origin of humans and early human societies', activity_counter + 5, FALSE),
        (world_history_course_id, unit_id, 'Paleolithic societies', 'article', 'The origin of humans and early human societies', activity_counter + 6, FALSE),
        (world_history_course_id, unit_id, 'Paleolithic technology, culture, and art', 'article', 'The origin of humans and early human societies', activity_counter + 7, FALSE),
        (world_history_course_id, unit_id, 'Organizing paleolithic societies', 'video', 'The origin of humans and early human societies', activity_counter + 8, FALSE),
        (world_history_course_id, unit_id, 'Paleolithic life', 'exercise', 'The origin of humans and early human societies', activity_counter + 9, FALSE),
        (world_history_course_id, unit_id, 'The origin of humans and early human societies', 'exercise', 'The origin of humans and early human societies', activity_counter + 10, FALSE);
    activity_counter := activity_counter + 11;

    -- Add activities for "The Neolithic Revolution and the birth of agriculture"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
        (world_history_course_id, unit_id, 'The Neolithic Revolution and early agriculture', 'video', 'The Neolithic Revolution and the birth of agriculture', activity_counter, FALSE),
        (world_history_course_id, unit_id, 'The dawn of agriculture', 'article', 'The Neolithic Revolution and the birth of agriculture', activity_counter + 1, FALSE),
        (world_history_course_id, unit_id, 'The spread of agriculture', 'video', 'The Neolithic Revolution and the birth of agriculture', activity_counter + 2, FALSE),
        (world_history_course_id, unit_id, 'Where did agriculture come from?', 'exercise', 'The Neolithic Revolution and the birth of agriculture', activity_counter + 3, FALSE),
        (world_history_course_id, unit_id, 'Early civilizations', 'article', 'The Neolithic Revolution and the birth of agriculture', activity_counter + 4, FALSE),
        (world_history_course_id, unit_id, 'Social, political, and environmental characteristics of early civilizations', 'article', 'The Neolithic Revolution and the birth of agriculture', activity_counter + 5, FALSE),
        (world_history_course_id, unit_id, 'Why did human societies get more complex?', 'exercise', 'The Neolithic Revolution and the birth of agriculture', activity_counter + 6, FALSE),
        (world_history_course_id, unit_id, 'Neolithic Revolution and the birth of agriculture', 'exercise', 'The Neolithic Revolution and the birth of agriculture', activity_counter + 7, FALSE);
    activity_counter := activity_counter + 8;

    -- Add Quiz 1 after "The Neolithic Revolution and the birth of agriculture"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
        (world_history_course_id, unit_id, 'Beginnings - 600 BCE: Quiz 1', 'quiz', 'The Neolithic Revolution and the birth of agriculture', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "Ancient Mesopotamia"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
        (world_history_course_id, unit_id, 'Ancient Mesopotamia', 'video', 'Ancient Mesopotamia', activity_counter, FALSE),
        (world_history_course_id, unit_id, 'Ancient Mesopotamia and the Hebrew Bible', 'video', 'Ancient Mesopotamia', activity_counter + 1, FALSE),
        (world_history_course_id, unit_id, 'Ancient Mesopotamian civilizations', 'article', 'Ancient Mesopotamia', activity_counter + 2, FALSE),
        (world_history_course_id, unit_id, 'Mesopotamia', 'exercise', 'Ancient Mesopotamia', activity_counter + 3, FALSE),
        (world_history_course_id, unit_id, 'Ancient Mesopotamia', 'exercise', 'Ancient Mesopotamia', activity_counter + 4, FALSE);
    activity_counter := activity_counter + 5;

    -- Add activities for "Ancient Egypt"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
        (world_history_course_id, unit_id, 'Ancient Egypt and the Nile River Valley', 'video', 'Ancient Egypt', activity_counter, FALSE),
        (world_history_course_id, unit_id, 'Ancient Egyptian civilization', 'article', 'Ancient Egypt', activity_counter + 1, FALSE),
        (world_history_course_id, unit_id, 'Egypt', 'exercise', 'Ancient Egypt', activity_counter + 2, FALSE),
        (world_history_course_id, unit_id, 'The Hittite Empire and the Battle of Kadesh', 'video', 'Ancient Egypt', activity_counter + 3, FALSE),
        (world_history_course_id, unit_id, 'The Hittites and Ancient Anatolia', 'article', 'Ancient Egypt', activity_counter + 4, FALSE),
        (world_history_course_id, unit_id, 'Hittites', 'exercise', 'Ancient Egypt', activity_counter + 5, FALSE),
        (world_history_course_id, unit_id, 'Ancient Egypt', 'exercise', 'Ancient Egypt', activity_counter + 6, FALSE);
    activity_counter := activity_counter + 7;

    -- Add Quiz 2 after "Ancient Egypt"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
        (world_history_course_id, unit_id, 'Beginnings - 600 BCE: Quiz 2', 'quiz', 'Ancient Egypt', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "Ancient art and artifacts"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
        (world_history_course_id, unit_id, 'The Standard of Ur', 'video', 'Ancient art and artifacts', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "Ancient India"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
        (world_history_course_id, unit_id, 'Indus River Valley civilizations', 'video', 'Ancient India', activity_counter, FALSE),
        (world_history_course_id, unit_id, 'Indus River Valley civilizations', 'article', 'Ancient India', activity_counter + 1, FALSE),
        (world_history_course_id, unit_id, 'Indus Valley civilization', 'exercise', 'Ancient India', activity_counter + 2, FALSE),
        (world_history_course_id, unit_id, 'The Vedic Period', 'video', 'Ancient India', activity_counter + 3, FALSE),
        (world_history_course_id, unit_id, 'Sanskrit connections to English', 'video', 'Ancient India', activity_counter + 4, FALSE),
        (world_history_course_id, unit_id, 'Hinduism: core ideas of Brahman, Atman, Samsara and Moksha.', 'video', 'Ancient India', activity_counter + 5, FALSE),
        (world_history_course_id, unit_id, 'Ancient India', 'exercise', 'Ancient India', activity_counter + 6, FALSE);
    activity_counter := activity_counter + 7;

    -- Add activities for "Shang China"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
        (world_history_course_id, unit_id, 'Shang Dynasty in Ancient China', 'video', 'Shang China', activity_counter, FALSE),
        (world_history_course_id, unit_id, 'Shang Dynasty civilization', 'article', 'Shang China', activity_counter + 1, FALSE),
        (world_history_course_id, unit_id, 'Ancient China', 'exercise', 'Shang China', activity_counter + 2, FALSE),
        (world_history_course_id, unit_id, 'Shang China practice', 'exercise', 'Shang China', activity_counter + 3, FALSE);
    activity_counter := activity_counter + 4;

    -- Add Quiz 3 after "Shang China"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
        (world_history_course_id, unit_id, 'Beginnings - 600 BCE: Quiz 3', 'quiz', 'Shang China', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "Ancient Americas"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
        (world_history_course_id, unit_id, 'Pre-contact Americas', 'video', 'Ancient Americas', activity_counter, FALSE),
        (world_history_course_id, unit_id, 'The Olmec', 'article', 'Ancient Americas', activity_counter + 1, FALSE),
        (world_history_course_id, unit_id, 'Ancient Mesoamerica', 'exercise', 'Ancient Americas', activity_counter + 2, FALSE),
        (world_history_course_id, unit_id, 'Andean and Chavín civilizations', 'article', 'Ancient Americas', activity_counter + 3, FALSE),
        (world_history_course_id, unit_id, 'Ancient Andes', 'exercise', 'Ancient Americas', activity_counter + 4, FALSE);
    activity_counter := activity_counter + 5;

    -- Add activities for "Human innovation and the environment"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
        (world_history_course_id, unit_id, 'Human innovation and the environment: Activity 1', 'video', 'Human innovation and the environment', activity_counter, FALSE),
        (world_history_course_id, unit_id, 'Human innovation and the environment: Activity 2', 'article', 'Human innovation and the environment', activity_counter + 1, FALSE),
        (world_history_course_id, unit_id, 'Human innovation and the environment: Activity 3', 'exercise', 'Human innovation and the environment', activity_counter + 2, FALSE);
    activity_counter := activity_counter + 3;

    -- Add unit test for Unit 1
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
        (world_history_course_id, unit_id, 'Unit Test: Beginnings - 600 BCE', 'unit_test', 'Beginnings - 600 BCE', activity_counter, TRUE);
    activity_counter := activity_counter + 1;

    RAISE NOTICE 'Successfully imported Unit 1: Beginnings - 600 BCE';
END $$;