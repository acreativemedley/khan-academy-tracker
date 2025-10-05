-- This script imports all lessons, activities, quizzes, and tests for Unit 2 of the World History course

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

        -- Delete existing activities and the specific unit (unit_number = 2) only
        -- Qualify column names to avoid ambiguity with PL/pgSQL variables (e.g., unit_id)
        DELETE FROM activities
        WHERE activities.unit_id IN (
                SELECT units.id FROM units
                WHERE units.course_id = world_history_course_id
                    AND units.unit_number = 2
        );

        DELETE FROM units
        WHERE units.course_id = world_history_course_id
            AND units.unit_number = 2;

        RAISE NOTICE 'Deleted existing activities and unit 2 for World History (if present)';

    -- =============================================================================
    -- Unit: 600 BCE - 600 CE Second-Wave Civilizations
    -- =============================================================================

    -- Create Unit: 600 BCE - 600 CE Second-Wave Civilizations
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (world_history_course_id, 2, '600 BCE - 600 CE Second-Wave Civilizations', 0, TRUE, 2)
    RETURNING id INTO unit_id;

    -- Add activities for "Ancient Persia"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Ancient Persia', 'video', 'Ancient Persia', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Cyrus the Great and the Achaemenid Empire', 'video', 'Ancient Persia', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'The Rise of Persia', 'article', 'Ancient Persia', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Zoroastrianism', 'video', 'Ancient Persia', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'The Achaemenid Empire', 'exercise', 'Ancient Persia', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'State-building: The Persian Empire', 'exercise', 'Ancient Persia', activity_counter + 5, FALSE),
    (world_history_course_id, unit_id, 'Ancient Persia', 'exercise', 'Ancient Persia', activity_counter + 6, FALSE);
    activity_counter := activity_counter + 7;

    -- Add activities for "Classical Greece"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Classical Greece', 'video', 'Classical Greece', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'The Greek polis', 'article', 'Classical Greece', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'The Greek polis', 'exercise', 'Classical Greece', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'State-building: the Greek polis', 'exercise', 'Classical Greece', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'Greco Persian Wars', 'video', 'Classical Greece', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'Second Persian Invasion', 'video', 'Classical Greece', activity_counter + 5, FALSE),
    (world_history_course_id, unit_id, 'Classical Greek Society and Culture', 'video', 'Classical Greece', activity_counter + 6, FALSE),
    (world_history_course_id, unit_id, 'Philosophy: Socrates, Plato and Aristotle', 'video', 'Classical Greece', activity_counter + 7, FALSE),
    (world_history_course_id, unit_id, 'Classical Greek society', 'article', 'Classical Greece', activity_counter + 8, FALSE),
    (world_history_course_id, unit_id, 'Classical Greek culture', 'article', 'Classical Greece', activity_counter + 9, FALSE),
    (world_history_course_id, unit_id, 'Classical Greek society', 'exercise', 'Classical Greece', activity_counter + 10, FALSE),
    (world_history_course_id, unit_id, 'Classical Greek culture and society', 'exercise', 'Classical Greece', activity_counter + 11, FALSE),
    (world_history_course_id, unit_id, 'Classical Greece', 'exercise', 'Classical Greece', activity_counter + 12, FALSE),
    (world_history_course_id, unit_id, 'Prelude to the Peloponnesian War', 'video', 'Classical Greece', activity_counter + 13, FALSE),
    (world_history_course_id, unit_id, 'The Peloponnesian War', 'video', 'Classical Greece', activity_counter + 14, FALSE);
    activity_counter := activity_counter + 15;

    -- Add activities for "The rise and fall of empires"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Comparison: Rise of empires', 'video', 'The rise and fall of empires', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Comparison: Fall of empires', 'video', 'The rise and fall of empires', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Comparing the rise and fall of empires', 'article', 'The rise and fall of empires', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Rise and fall of empires', 'exercise', 'The rise and fall of empires', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'Focus on state-building: Empires', 'exercise', 'The rise and fall of empires', activity_counter + 4, FALSE);
    activity_counter := activity_counter + 5;

    -- Add activities for "Empire of Alexander the Great"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Philip of Macedon unifies Greece', 'video', 'Empire of Alexander the Great', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Alexander the Great takes power', 'video', 'Empire of Alexander the Great', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Alexander the Great conquers Persia', 'video', 'Empire of Alexander the Great', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Diadochi and the Hellenistic Period', 'video', 'Empire of Alexander the Great', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'Alexander the Great', 'article', 'Empire of Alexander the Great', activity_counter + 4, FALSE);
    activity_counter := activity_counter + 5;

    -- Add activities for "Rise of Rome"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'An Overview of Ancient Rome', 'video', 'Rise of Rome', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Roman social and political structures', 'video', 'Rise of Rome', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'The Roman Republic', 'article', 'Rise of Rome', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Exchange between Rome, Carthage, and the Phoenicians', 'video', 'Rise of Rome', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'Punic Wars between Rome and Carthage', 'video', 'Rise of Rome', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'Roman Republic', 'exercise', 'Rise of Rome', activity_counter + 5, FALSE);
    activity_counter := activity_counter + 6;

    -- Add activities for "From Roman Republic to Roman Empire"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Rise of Julius Caesar', 'video', 'From Roman Republic to Roman Empire', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Caesar, Cleopatra and the Ides of March', 'video', 'From Roman Republic to Roman Empire', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Ides of March spark a civil war', 'video', 'From Roman Republic to Roman Empire', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Augustus and the Roman Empire', 'video', 'From Roman Republic to Roman Empire', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'The Roman Empire', 'article', 'From Roman Republic to Roman Empire', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'Roman empire', 'exercise', 'From Roman Republic to Roman Empire', activity_counter + 5, FALSE),
    (world_history_course_id, unit_id, 'State building: Roman empire', 'exercise', 'From Roman Republic to Roman Empire', activity_counter + 6, FALSE),
    (world_history_course_id, unit_id, 'Ancient Rome', 'exercise', 'From Roman Republic to Roman Empire', activity_counter + 7, FALSE);
    activity_counter := activity_counter + 8;

    -- Add activities for "The Roman Empire"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Emperors of Pax Romana', 'video', 'The Roman Empire', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Fall of the Roman Empire', 'video', 'The Roman Empire', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Ara Pacis', 'video', 'The Roman Empire', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Visualizing Imperial Rome', 'video', 'The Roman Empire', activity_counter + 3, FALSE);
    activity_counter := activity_counter + 4;

    -- Add Quiz 1 after "The Roman Empire"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, '600 BCE - 600 CE Second-Wave Civilizations: Quiz 1', 'quiz', 'The Roman Empire', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "Ancient and Imperial China"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Zhou, Qin and Han Dynasties', 'video', 'Ancient and Imperial China', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Rise of Chinese dynasties', 'article', 'Ancient and Imperial China', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Rise of Chinese dynasties', 'exercise', 'Ancient and Imperial China', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'State building: Rise of Chinese dynasties', 'exercise', 'Ancient and Imperial China', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'Confucius and the Hundred Schools of Thought', 'video', 'Ancient and Imperial China', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'The Philosophers of the Warring States', 'article', 'Ancient and Imperial China', activity_counter + 5, FALSE),
    (world_history_course_id, unit_id, 'Philosophies of the Warring States Period', 'exercise', 'Ancient and Imperial China', activity_counter + 6, FALSE),
    (world_history_course_id, unit_id, 'Legalism and Daoism', 'exercise', 'Ancient and Imperial China', activity_counter + 7, FALSE),
    (world_history_course_id, unit_id, 'Ancient and Imperial China', 'exercise', 'Ancient and Imperial China', activity_counter + 8, FALSE);
    activity_counter := activity_counter + 9;

    -- Add activities for "Early Judaism"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Early Judaism, part 1', 'video', 'Early Judaism', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Early Judaism, part 2', 'video', 'Early Judaism', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Judaism develops', 'article', 'Early Judaism', activity_counter + 2, FALSE);
    activity_counter := activity_counter + 3;

    -- Add activities for "Early Christianity"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Early Christianity', 'video', 'Early Christianity', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'The spread of Christianity', 'video', 'Early Christianity', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Christianity in the Roman Empire', 'article', 'Early Christianity', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Christianity in the Roman Empire', 'video', 'Early Christianity', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'The Council of Nicaea', 'video', 'Early Christianity', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'Judaism and Christianity key terms', 'exercise', 'Early Christianity', activity_counter + 5, FALSE),
    (world_history_course_id, unit_id, 'Context: Judaism and Christianity', 'exercise', 'Early Christianity', activity_counter + 6, FALSE),
    (world_history_course_id, unit_id, 'Early Judaism and Early Christianity', 'exercise', 'Early Christianity', activity_counter + 7, FALSE);
    activity_counter := activity_counter + 8;

    -- Add Quiz 2
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, '600 BCE - 600 CE Second-Wave Civilizations: Quiz 2', 'quiz', 'Ancient and Imperial China', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "Early Americas"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Mayan civilization', 'video', 'Early Americas', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Chavin, Nazca, Moche, Huari and Tiwanaku civilizations', 'video', 'Early Americas', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Pre-contact Americas', 'article', 'Early Americas', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Early Americas', 'exercise', 'Early Americas', activity_counter + 3, FALSE);
    activity_counter := activity_counter + 4;

    -- Add activities for "Empires in India"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'The rise of empires in India', 'video', 'Empires in India', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Gupta Dynasty', 'video', 'Empires in India', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'The Maurya and Gupta Empires', 'article', 'Empires in India', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Empires in India', 'exercise', 'Empires in India', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'The history of Hinduism', 'article', 'Empires in India', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'The history of Buddhism', 'article', 'Empires in India', activity_counter + 5, FALSE),
    (world_history_course_id, unit_id, 'Key concepts: Hinduism and Buddhism', 'exercise', 'Empires in India', activity_counter + 6, FALSE),
    (world_history_course_id, unit_id, 'Indian cultures: focus on Hinduism and Buddhism', 'exercise', 'Empires in India', activity_counter + 7, FALSE);
    activity_counter := activity_counter + 8;

    -- Add activities for "Early Hinduism"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'The Vedic Period', 'video', 'Early Hinduism', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Sanskrit connections to English', 'video', 'Early Hinduism', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Hinduism: core ideas of Brahman, Atman, Samsara and Moksha.', 'video', 'Early Hinduism', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Hindu gods overview', 'video', 'Early Hinduism', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'Hindu scripture overview', 'video', 'Early Hinduism', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'Varnas and the Caste System', 'video', 'Early Hinduism', activity_counter + 5, FALSE),
    (world_history_course_id, unit_id, 'Bhakti movement', 'video', 'Early Hinduism', activity_counter + 6, FALSE);
    activity_counter := activity_counter + 7;

    -- Add activities for "Early Buddhism"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Hinduism: core ideas of Brahman, Atman, Samsara and Moksha.', 'video', 'Early Buddhism', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Early Buddhism', 'video', 'Early Buddhism', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Core spiritual ideas of Buddhism', 'video', 'Early Buddhism', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Buddhism: context and comparison', 'video', 'Early Buddhism', activity_counter + 3, FALSE),
    (world_history_course_id, unit_id, 'Theravada and Mahayana Buddhism', 'video', 'Early Buddhism', activity_counter + 4, FALSE),
    (world_history_course_id, unit_id, 'Early Hinduism and Early Buddhism', 'exercise', 'Early Buddhism', activity_counter + 5, FALSE);
    activity_counter := activity_counter + 6;

    -- Add Quiz 3
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, '600 BCE - 600 CE Second-Wave Civilizations: Quiz 3', 'quiz', 'Early Buddhism', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "Syncretism"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Cultural Syncretism in Central Asia', 'video', 'Syncretism', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Syncretism', 'article', 'Syncretism', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Syncretism', 'exercise', 'Syncretism', activity_counter + 2, FALSE);
    activity_counter := activity_counter + 3;

    -- Add activities for "Women and families"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Comparative roles of women in Rome and Han China', 'video', 'Women and families', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Women and families in classical society', 'article', 'Women and families', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Women and families in classical societies', 'exercise', 'Women and families', activity_counter + 2, FALSE);
    activity_counter := activity_counter + 3;

    -- Add activities for "Transregional Trade: the Silk Road"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'The Silk Road', 'video', 'Transregional Trade: the Silk Road', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'The Silk Road', 'article', 'Transregional Trade: the Silk Road', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'The Silk Road', 'exercise', 'Transregional Trade: the Silk Road', activity_counter + 2, FALSE),
    (world_history_course_id, unit_id, 'Transregional trade', 'exercise', 'Transregional Trade: the Silk Road', activity_counter + 3, FALSE);
    activity_counter := activity_counter + 4;

    -- Add Quiz 4
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, '600 BCE - 600 CE Second-Wave Civilizations: Quiz 4', 'quiz', 'Transregional Trade: the Silk Road', activity_counter, FALSE);
    activity_counter := activity_counter + 1;

    -- Add activities for "Survey of second-wave civilizations"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, 'Survey from Neo Babylonians to Persians', 'video', 'Survey of second-wave civilizations', activity_counter, FALSE),
    (world_history_course_id, unit_id, 'Ancient Greeks and Persians', 'video', 'Survey of second-wave civilizations', activity_counter + 1, FALSE),
    (world_history_course_id, unit_id, 'Rome becomes dominant', 'video', 'Survey of second-wave civilizations', activity_counter + 2, FALSE);
    activity_counter := activity_counter + 3;

    -- Add Unit test
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index, is_exam) VALUES
    (world_history_course_id, unit_id, '600 BCE - 600 CE Second-Wave Civilizations: Unit test', 'unit_test', 'Survey of second-wave civilizations', activity_counter, TRUE);
    activity_counter := activity_counter + 1;

    RAISE NOTICE 'Successfully imported Unit 2: 600 BCE - 600 CE Second-Wave Civilizations';
END $$;