-- This script imports all lessons, activities, quizzes, and tests for Unit 6 of the World History course

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

        -- Delete existing activities and the specific unit (unit_number = 6) only
        DELETE FROM activities
        WHERE activities.unit_id IN (
                SELECT units.id FROM units
                WHERE units.course_id = world_history_course_id
                    AND units.unit_number = 6
        );

        DELETE FROM units
        WHERE units.course_id = world_history_course_id
            AND units.unit_number = 6;

        RAISE NOTICE 'Deleted existing activities and unit 6 for World History (if present)';

    -- =============================================================================
    -- Unit: The 20th century
    -- =============================================================================

    -- Create Unit: The 20th century
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (world_history_course_id, 6, 'The 20th century', 73, TRUE, 6)
    RETURNING id INTO unit_id;

    -- Add activities for "Beginning of World War I"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Empires before World War I', 'video', 'Beginning of World War I', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'German and Italian Empires in 1914', 'video', 'Beginning of World War I', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Alliances leading to World War I', 'video', 'Beginning of World War I', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Language and religion of the former Yugoslavia', 'video', 'Beginning of World War I', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'Assassination of Franz Ferdinand', 'video', 'Beginning of World War I', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'The Great War begins', 'video', 'Beginning of World War I', activity_counter + 5, FALSE),
    (world_history_course_id, unit_id, 'Causes of World War I', 'exercise', 'Beginning of World War I', activity_counter + 6, FALSE);
    activity_counter := activity_counter + 7;

    -- Add activities for "Other fronts of World War I"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Serbian and Macedonian fronts', 'video', 'Other fronts of World War I', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Serbian losses in World War I', 'video', 'Other fronts of World War I', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Italy backs out of Triple Alliance', 'video', 'Other fronts of World War I', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Italian front in World War I', 'video', 'Other fronts of World War I', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'Japan in World War I', 'video', 'Other fronts of World War I', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'Secondary fronts of WWI', 'exercise', 'Other fronts of World War I', activity_counter + 5, FALSE);
    activity_counter := activity_counter + 6;

    -- Add activities for "Western and Eastern fronts of World War I"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Schlieffen Plan and the First Battle of the Marne', 'video', 'Western and Eastern fronts of World War I', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Comparing the Eastern and Western fronts in WWI', 'video', 'Western and Eastern fronts of World War I', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'World War I Eastern front', 'video', 'Western and Eastern fronts of World War I', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Battles of Verdun, Somme and the Hindenburg Line', 'video', 'Western and Eastern fronts of World War I', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'Closing stages of World War I', 'video', 'Western and Eastern fronts of World War I', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'Technology in World War I', 'video', 'Western and Eastern fronts of World War I', activity_counter + 5, FALSE),
    (world_history_course_id, unit_id, 'Eastern and Western fronts of World War I', 'exercise', 'Western and Eastern fronts of World War I', activity_counter + 6, FALSE);
    activity_counter := activity_counter + 7;

    -- Add activities for "Blockades and American entry"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Blockades, u-boats and sinking of the Lusitania', 'video', 'Blockades and American entry', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Zimmermann Telegram', 'video', 'Blockades and American entry', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'United States enters World War I', 'video', 'Blockades and American entry', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Wilson''s war message to Congress -- April 2, 1917', 'article', 'Blockades and American entry', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, '1917 speech by Senator George Norris in opposition to American entry', 'article', 'Blockades and American entry', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'WWI Blockades and America', 'exercise', 'Blockades and American entry', activity_counter + 5, FALSE);
    activity_counter := activity_counter + 6;

    -- Add Quiz 1
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'The 20th century : Quiz 1', 'quiz', 'Blockades and American entry', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "World War I shapes the Middle East"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Theodor Herzl and the birth of political Zionism', 'video', 'World War I shapes the Middle East', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Sinai, Palestine and Mesopotamia campaigns', 'video', 'World War I shapes the Middle East', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Sykes-Picot Agreement and the Balfour Declaration', 'video', 'World War I shapes the Middle East', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Arabia after World War I', 'video', 'World War I shapes the Middle East', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'The Middle East during and after WWI', 'exercise', 'World War I shapes the Middle East', activity_counter + 4, FALSE);
    activity_counter := activity_counter + 5;

    -- Add activities for "Aftermath of World War I"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Deaths in World War I', 'video', 'Aftermath of World War I', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Woodrow Wilson''s Fourteen Points', 'video', 'Aftermath of World War I', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Paris Peace Conference and Treaty of Versailles', 'video', 'Aftermath of World War I', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'More detail on the Treaty of Versailles and Germany', 'video', 'Aftermath of World War I', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'Arabia after World War I', 'video', 'Aftermath of World War I', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'WWI Aftermath', 'exercise', 'Aftermath of World War I', activity_counter + 5, FALSE);
    activity_counter := activity_counter + 6;

    -- Add standalone exercise "World War I"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'World War I', 'exercise', 'Aftermath of World War I', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add Quiz 2
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'The 20th century : Quiz 2', 'quiz', 'Aftermath of World War I', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "Rise of Hitler and the Nazis"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Initial rise of Hitler and the Nazis', 'video', 'Rise of Hitler and the Nazis', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Hitler''s Beer Hall Putsch', 'video', 'Rise of Hitler and the Nazis', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Hitler and the Nazis come to power', 'video', 'Rise of Hitler and the Nazis', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Night of the Long Knives', 'video', 'Rise of Hitler and the Nazis', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'Nazi aggression and appeasement', 'video', 'Rise of Hitler and the Nazis', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'Rise of Hitler', 'exercise', 'Rise of Hitler and the Nazis', activity_counter + 5, FALSE);
    activity_counter := activity_counter + 6;

    -- Add activities for "Rise of Mussolini and Fascism"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Fascism and Mussolini', 'video', 'Rise of Mussolini and Fascism', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Mussolini becomes Prime Minister', 'video', 'Rise of Mussolini and Fascism', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Mussolini becomes absolute dictator (Il Duce)', 'video', 'Rise of Mussolini and Fascism', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Mussolini aligns with Hitler', 'video', 'Rise of Mussolini and Fascism', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'Fascism and Mussolini', 'exercise', 'Rise of Mussolini and Fascism', activity_counter + 4, FALSE);
    activity_counter := activity_counter + 5;

    -- Add Quiz 3
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'The 20th century : Quiz 3', 'quiz', 'Rise of Mussolini and Fascism', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "Overview of Chinese history 1911-1949"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Overview of Chinese history 1911 - 1949', 'video', 'Overview of Chinese history 1911-1949', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "Overview of World War II"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Beginning of World War II', 'video', 'Overview of World War II', activity_counter, FALSE),
    (world_history_course_id, unit_id, '1940 - Axis gains momentum in World War II', 'video', 'Overview of World War II', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, '1941 Axis momentum accelerates in WW2', 'video', 'Overview of World War II', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, '1942 - World War II in the Pacific', 'video', 'Overview of World War II', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, '1942 - Tide turning in World War II in Europe', 'video', 'Overview of World War II', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, '1943 - Axis powers losing in Europe', 'video', 'Overview of World War II', activity_counter + 5, FALSE),
    (world_history_course_id, unit_id, 'American progress in the Pacific in 1944', 'video', 'Overview of World War II', activity_counter + 6, FALSE),
    (world_history_course_id, unit_id, '1944 - Allies advance further in Europe', 'video', 'Overview of World War II', activity_counter + 7, FALSE),
    (world_history_course_id, unit_id, '1945 - End of World War II', 'video', 'Overview of World War II', activity_counter + 8, FALSE);
    activity_counter := activity_counter + 9;

    -- Add activities for "The Cold War"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Communism', 'video', 'The Cold War', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Korean War overview', 'video', 'The Cold War', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Bay of Pigs Invasion', 'video', 'The Cold War', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Cuban Missile Crisis', 'video', 'The Cold War', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'Vietnam War', 'video', 'The Cold War', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'Allende and Pinochet in Chile', 'video', 'The Cold War', activity_counter + 5, FALSE),
    (world_history_course_id, unit_id, 'Pattern of US Cold War interventions', 'video', 'The Cold War', activity_counter + 6, FALSE);
    activity_counter := activity_counter + 7;

    -- Add activities for "Human rights"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'The Holocaust', 'video', 'Human rights', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'International Human Rights', 'video', 'Human rights', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Independence movements in the 20th Century', 'video', 'Human rights', activity_counter + 2, FALSE);
    activity_counter := activity_counter + 3;

    -- Add Unit test
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'The 20th century : Unit test', 'unit_test', 'The 20th century', activity_counter, TRUE);
    activity_counter := activity_counter + 1;

    RAISE NOTICE 'Successfully imported Unit 6: The 20th century';
END $$;
