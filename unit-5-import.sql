-- This script imports all lessons, activities, quizzes, and tests for Unit 5 of the World History course

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

        -- Delete existing activities and the specific unit (unit_number = 5) only
        DELETE FROM activities
        WHERE activities.unit_id IN (
                SELECT units.id FROM units
                WHERE units.course_id = world_history_course_id
                    AND units.unit_number = 5
        );

        DELETE FROM units
        WHERE units.course_id = world_history_course_id
            AND units.unit_number = 5;

        RAISE NOTICE 'Deleted existing activities and unit 5 for World History (if present)';

    -- =============================================================================
    -- Unit: 1750 -1900 Enlightenment and Revolution
    -- =============================================================================

    -- Create Unit: 1750 -1900 Enlightenment and Revolution
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (world_history_course_id, 5, '1750 -1900 Enlightenment and Revolution', 24, TRUE, 5)
    RETURNING id INTO unit_id;

    -- Add activities for "American Revolution"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'The Seven Years'' War: background and combatants', 'video', 'American Revolution', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'The Seven Years'' War: battles and legacy', 'video', 'American Revolution', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Background and introduction to the - United States Declaration of Independence', 'video', 'American Revolution', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Birth of the US Constitution', 'video', 'American Revolution', activity_counter + 3, FALSE);
    activity_counter := activity_counter + 4;

    -- Add activities for "French Revolution"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'French Revolution (part 1)', 'video', 'French Revolution', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'French Revolution (part 2)', 'video', 'French Revolution', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'French Revolution (part 3) - Reign of Terror', 'video', 'French Revolution', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'French Revolution (part 4) - The Rise of Napoleon Bonaparte', 'video', 'French Revolution', activity_counter + 3, FALSE);
    activity_counter := activity_counter + 4;

    -- Add activities for "Napoleon Bonaparte"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Napoleon and the Wars of the First and Second Coalitions', 'video', 'Napoleon Bonaparte', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Napoleon and the War of the Third Coalition', 'video', 'Napoleon Bonaparte', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Napoleon and the War of the Fourth Coalition', 'video', 'Napoleon Bonaparte', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Napoleon''s Peninsular Campaigns', 'video', 'Napoleon Bonaparte', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'French invasion of Russia', 'video', 'Napoleon Bonaparte', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'Napoleon forced to abdicate', 'video', 'Napoleon Bonaparte', activity_counter + 5, FALSE),
    (world_history_course_id, unit_id, 'Hundred days and Waterloo', 'video', 'Napoleon Bonaparte', activity_counter + 6, FALSE);
    activity_counter := activity_counter + 7;

    -- Add activities for "France's many revolutions and republics"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Les Miserables and France''s many revolutions', 'video', 'France''s many revolutions and republics', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "Haitian Revolution"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Haitian Revolution (Part 1)', 'video', 'Haitian Revolution', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Haitian Revolution (Part 2)', 'video', 'Haitian Revolution', activity_counter + 1, FALSE);
    activity_counter := activity_counter + 2;

    -- Add activities for "Latin American independence"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Latin American independence movements', 'video', 'Latin American independence', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "Imperialism"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Industrialization and imperialism', 'video', 'Imperialism', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'WATCH: Opium Wars', 'video', 'Imperialism', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Japanese Imperialism', 'video', 'Imperialism', activity_counter + 2, FALSE);
    activity_counter := activity_counter + 3;

    -- Note: This markdown does not list a unit test; if you track unit tests separately, add one with is_exam=TRUE.

    RAISE NOTICE 'Successfully imported Unit 5: 1750 -1900 Enlightenment and Revolution';
END $$;
