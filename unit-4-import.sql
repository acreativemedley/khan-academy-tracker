-- This script imports all lessons, activities, quizzes, and tests for Unit 4 of the World History course

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

        -- Delete existing activities and the specific unit (unit_number = 4) only
        DELETE FROM activities
        WHERE activities.unit_id IN (
                SELECT units.id FROM units
                WHERE units.course_id = world_history_course_id
                    AND units.unit_number = 4
        );

        DELETE FROM units
        WHERE units.course_id = world_history_course_id
            AND units.unit_number = 4;

        RAISE NOTICE 'Deleted existing activities and unit 4 for World History (if present)';

    -- =============================================================================
    -- Unit: 1450 - 1750 Renaissance and Reformation
    -- =============================================================================

    -- Create Unit: 1450 - 1750 Renaissance and Reformation
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (world_history_course_id, 4, '1450 - 1750 Renaissance and Reformation', 16, TRUE, 4)
    RETURNING id INTO unit_id;

    -- Add activities for "Spanish and Portuguese Empires"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Spain, Portugal, and the creation of a global economy', 'video', 'Spanish and Portuguese Empires', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "Scientific Revolution and Enlightenment"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'WATCH: The Scientific Revolution and the Age of Enlightenment', 'video', 'Scientific Revolution and Enlightenment', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "Mughal rule in India"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Mughal rule in India', 'video', 'Mughal rule in India', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'WATCH: Ottoman, Safavid and Mughal Empires', 'video', 'Mughal rule in India', activity_counter + 1, FALSE);
    activity_counter := activity_counter + 2;

    -- Add activities for "Sikhism"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Sikhism introduction', 'video', 'Sikhism', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Continuity-Sikhism connections to Hinduism and Islam', 'video', 'Sikhism', activity_counter + 1, FALSE);
    activity_counter := activity_counter + 2;

    -- Add activities for "The Protestant Reformation"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'An introduction to the Protestant Reformation', 'article', 'The Protestant Reformation', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Introduction to the Protestant Reformation: Setting the stage', 'video', 'The Protestant Reformation', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Introduction to the Protestant Reformation: Martin Luther', 'video', 'The Protestant Reformation', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Introduction to the Protestant Reformation: Varieties of Protestantism', 'video', 'The Protestant Reformation', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'Introduction to the Protestant Reformation: The Counter-Reformation', 'video', 'The Protestant Reformation', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'Read + Discuss', 'article', 'The Protestant Reformation', activity_counter + 5, FALSE),
    (world_history_course_id, unit_id, 'Protestant Reformation', 'exercise', 'The Protestant Reformation', activity_counter + 6, FALSE),
    (world_history_course_id, unit_id, 'Cranach, Law and Gospel (Law and Grace)', 'article', 'The Protestant Reformation', activity_counter + 7, FALSE),
    (world_history_course_id, unit_id, 'Cranach, Law and Gospel', 'exercise', 'The Protestant Reformation', activity_counter + 8, FALSE);
    activity_counter := activity_counter + 9;

    -- Add activities for "The Russian Empire"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'How did Russia begin?', 'video', 'The Russian Empire', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add Unit test
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, '1450 - 1750 Renaissance and Reformation: Unit test', 'unit_test', '1450 - 1750 Renaissance and Reformation', activity_counter, TRUE);
    activity_counter := activity_counter + 1;

    RAISE NOTICE 'Successfully imported Unit 4: 1450 - 1750 Renaissance and Reformation';
END $$;
