-- This script imports all lessons, activities, quizzes, and tests for Unit 3 of the World History course

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

        -- Delete existing activities and the specific unit (unit_number = 3) only
        -- Qualify column names to avoid ambiguity with PL/pgSQL variables
        DELETE FROM activities
        WHERE activities.unit_id IN (
                SELECT units.id FROM units
                WHERE units.course_id = world_history_course_id
                    AND units.unit_number = 3
        );

        DELETE FROM units
        WHERE units.course_id = world_history_course_id
            AND units.unit_number = 3;

        RAISE NOTICE 'Deleted existing activities and unit 3 for World History (if present)';

    -- =============================================================================
    -- Unit: 600 - 1450 Regional and interregional interactions
    -- =============================================================================

    -- Create Unit: 600 - 1450 Regional and interregional interactions
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (world_history_course_id, 3, '600 - 1450 Regional and interregional interactions', 92, TRUE, 3)
    RETURNING id INTO unit_id;

    -- Add activities for "Byzantine Empire"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Justinian and the Byzantine Empire', 'video', 'Byzantine Empire', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Comparing Roman and Byzantine Empires', 'video', 'Byzantine Empire', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Guided practice: continuity and change in the Byzantine Empire', 'article', 'Byzantine Empire', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Byzantine culture and society', 'article', 'Byzantine Empire', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'Key concepts: the Byzantine Empire', 'exercise', 'Byzantine Empire', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'Focus on continuity and change: Byzantine state-building', 'exercise', 'Byzantine Empire', activity_counter + 5, FALSE);
    activity_counter := activity_counter + 6;

    -- Add activities for "European Middle Ages: feudalism and serfdom"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Overview of the Middle Ages', 'video', 'European Middle Ages: feudalism and serfdom', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Feudal system during the Middle Ages', 'video', 'European Middle Ages: feudalism and serfdom', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Serfs and manorialism', 'video', 'European Middle Ages: feudalism and serfdom', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Serfdom in Europe', 'article', 'European Middle Ages: feudalism and serfdom', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'Key Concepts: Serfdom', 'exercise', 'European Middle Ages: feudalism and serfdom', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'Focus on economics: serfdom', 'exercise', 'European Middle Ages: feudalism and serfdom', activity_counter + 5, FALSE),
    (world_history_course_id, unit_id, 'Peasant revolts', 'video', 'European Middle Ages: feudalism and serfdom', activity_counter + 6, FALSE),
    (world_history_course_id, unit_id, 'Key concepts: Peasant revolts', 'exercise', 'European Middle Ages: feudalism and serfdom', activity_counter + 7, FALSE),
    (world_history_course_id, unit_id, 'Focus on rebellion: Peasant revolts', 'exercise', 'European Middle Ages: feudalism and serfdom', activity_counter + 8, FALSE),
    (world_history_course_id, unit_id, 'An overview of the Crusades (part 2)', 'video', 'European Middle Ages: feudalism and serfdom', activity_counter + 9, FALSE);
    activity_counter := activity_counter + 10;

    -- Add Quiz 1
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, '600 - 1450 Regional and interregional interactions: Quiz 1', 'quiz', 'European Middle Ages: feudalism and serfdom', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "Origins of Islam"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Introduction to Islam', 'video', 'Origins of Islam', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Beginnings of Islam: The life of Muhammad', 'video', 'Origins of Islam', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Beginnings of Islam: The Hijra to Medina and the conversion of Mecca', 'video', 'Origins of Islam', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Contextualization of the development of Islam', 'video', 'Origins of Islam', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'Context of pre-Islamic Arabia', 'article', 'Origins of Islam', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'Key concepts: The origins of Islam', 'exercise', 'Origins of Islam', activity_counter + 5, FALSE),
    (world_history_course_id, unit_id, 'Focus on context: The origins of Islam', 'exercise', 'Origins of Islam', activity_counter + 6, FALSE);
    activity_counter := activity_counter + 7;

    -- Add activities for "Spread of Islam"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'The spread of Islam', 'video', 'Spread of Islam', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'The rise of Islamic empires and states', 'article', 'Spread of Islam', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Spread of Islamic Culture', 'video', 'Spread of Islam', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'The development and spread of Islamic cultures', 'article', 'Spread of Islam', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'Key concepts: the spread of Islam', 'exercise', 'Spread of Islam', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'Focus on continuity and change: the spread of Islam', 'exercise', 'Spread of Islam', activity_counter + 5, FALSE);
    activity_counter := activity_counter + 6;

    -- Add activities for "Sunni and Shia Islam"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Sunni and Shia Islam part 1', 'video', 'Sunni and Shia Islam', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Sunni and Shia Islam part 2', 'video', 'Sunni and Shia Islam', activity_counter + 1, FALSE);
    activity_counter := activity_counter + 2;

    -- Add activities for "Golden Age of Islam"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Golden age of Islam', 'video', 'Golden Age of Islam', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'The golden age of Islam', 'article', 'Golden Age of Islam', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Key concepts: golden age of Islam', 'exercise', 'Golden Age of Islam', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Focus on Baghdad: the golden age of Islam', 'exercise', 'Golden Age of Islam', activity_counter + 3, FALSE);
    activity_counter := activity_counter + 4;

    -- Add Quiz 2
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, '600 - 1450 Regional and interregional interactions: Quiz 2', 'quiz', 'Golden Age of Islam', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "The Great Schism"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Christianity in the Roman Empire', 'video', 'The Great Schism', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'The Council of Nicaea', 'video', 'The Great Schism', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Great Schism or East-West Schism part 1', 'video', 'The Great Schism', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Great Schism or East-West Schism part 2', 'video', 'The Great Schism', activity_counter + 3, FALSE);
    activity_counter := activity_counter + 4;

    -- Add activities for "The Crusades"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Introduction to the Crusades', 'video', 'The Crusades', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'An overview of the Crusades (part 2)', 'video', 'The Crusades', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'WATCH: Impact of the crusades', 'video', 'The Crusades', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Knights Templar', 'video', 'The Crusades', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'Technology and cultural transfers during the Crusades', 'exercise', 'The Crusades', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'State-building: technology and cultural transfers during the Crusades', 'exercise', 'The Crusades', activity_counter + 5, FALSE);
    activity_counter := activity_counter + 6;

    -- Add Quiz 3
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, '600 - 1450 Regional and interregional interactions: Quiz 3', 'quiz', 'The Crusades', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "The Mongols"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Genghis Khan and the Mongol Empire', 'video', 'The Mongols', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Why were the Mongols so effective?', 'video', 'The Mongols', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Timur', 'video', 'The Mongols', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'WATCH: Ottoman, Safavid and Mughal Empires', 'video', 'The Mongols', activity_counter + 3, FALSE);
    activity_counter := activity_counter + 4;

    -- Add activities for "Song China"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Chinese Imperial Dynasties', 'video', 'Song China', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Neo-Confucianism and Zhu Xi', 'video', 'Song China', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Prosperity in Song China (960-1279)', 'video', 'Song China', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Key concepts: Song China', 'exercise', 'Song China', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'Focus on state building: Song China', 'exercise', 'Song China', activity_counter + 4, FALSE);
    activity_counter := activity_counter + 5;

    -- Add activities for "Medieval Japan"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Classical Japan during the Heian Period', 'video', 'Medieval Japan', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'WATCH: Shoguns, samurai and the Japanese Middle Ages', 'video', 'Medieval Japan', activity_counter + 1, FALSE);
    activity_counter := activity_counter + 2;

    -- Add Quiz 4
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, '600 - 1450 Regional and interregional interactions: Quiz 4', 'quiz', 'Medieval Japan', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "Maya, Aztec, and Inca"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'WATCH: Aztec Empire', 'video', 'Maya, Aztec, and Inca', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'WATCH: Inca Empire Overview', 'video', 'Maya, Aztec, and Inca', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Key concepts: Maya, Aztec, and Inca civilizations', 'exercise', 'Maya, Aztec, and Inca', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Focus on state building: Maya, Aztec, and Inca civilizations', 'exercise', 'Maya, Aztec, and Inca', activity_counter + 3, FALSE);
    activity_counter := activity_counter + 4;

    -- Add activities for "Environment and trade"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Early medieval trade', 'video', 'Environment and trade', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Environment and Trade: Viking Age', 'article', 'Environment and trade', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Key Concepts: environment and trade', 'exercise', 'Environment and trade', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Focus on environment: trade', 'exercise', 'Environment and trade', activity_counter + 3, FALSE);
    activity_counter := activity_counter + 4;

    -- Add Quiz 5
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, '600 - 1450 Regional and interregional interactions: Quiz 5', 'quiz', 'Environment and trade', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "Human migration"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Causes and effects of human migration', 'video', 'Human migration', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Causes and effects of human migration', 'article', 'Human migration', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Key concepts: Human Migration', 'exercise', 'Human migration', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Focus on causation: Human migration', 'exercise', 'Human migration', activity_counter + 3, FALSE);
    activity_counter := activity_counter + 4;

    -- Add activities for "Development of new trading cities"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Development of new trading cities', 'article', 'Development of new trading cities', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Key concepts: development of new trading cities', 'exercise', 'Development of new trading cities', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Focus on economy: development of new trading cities', 'exercise', 'Development of new trading cities', activity_counter + 2, FALSE);
    activity_counter := activity_counter + 3;

    -- Add Quiz 6
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, '600 - 1450 Regional and interregional interactions: Quiz 6', 'quiz', 'Development of new trading cities', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "Cultural interactions along trade routes"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'The Srivijaya Empire: trade and culture in the Indian Ocean', 'article', 'Cultural interactions along trade routes', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Key concepts: The Srivijaya Empire', 'exercise', 'Cultural interactions along trade routes', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Focus on cultural interactions: Srivijaya Empire', 'exercise', 'Cultural interactions along trade routes', activity_counter + 2, FALSE);
    activity_counter := activity_counter + 3;

    -- Add activities for "Development of financial institutions"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Knights Templar', 'video', 'Development of financial institutions', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Financial institutions', 'article', 'Development of financial institutions', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Key concepts: financial institutions', 'exercise', 'Development of financial institutions', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Focus on spread of knowledge: financial institutions', 'exercise', 'Development of financial institutions', activity_counter + 3, FALSE);
    activity_counter := activity_counter + 4;

    -- Add Quiz 7
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, '600 - 1450 Regional and interregional interactions: Quiz 7', 'quiz', 'Development of financial institutions', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "Disease and demography"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Bubonic Plague', 'article', 'Disease and demography', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Key concepts: disease and demography', 'exercise', 'Disease and demography', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Focus on context: disease and demography', 'exercise', 'Disease and demography', activity_counter + 2, FALSE);
    activity_counter := activity_counter + 3;

    -- Add activities for "Social institutions in the Islamic world"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Medieval Muslim societies', 'article', 'Social institutions in the Islamic world', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Key concepts: Medieval Muslim Societies', 'exercise', 'Social institutions in the Islamic world', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Focus on social structures: gender in medieval Muslim societies', 'exercise', 'Social institutions in the Islamic world', activity_counter + 2, FALSE);
    activity_counter := activity_counter + 3;

    -- Add Unit test
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, '600 - 1450 Regional and interregional interactions: Unit test', 'unit_test', '600 - 1450 Regional and interregional interactions', activity_counter, TRUE);
    activity_counter := activity_counter + 1;

    RAISE NOTICE 'Successfully imported Unit 3: 600 - 1450 Regional and interregional interactions';
END $$;
