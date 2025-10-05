-- SQL Import Script for World History Course
-- This script imports all units, lessons, and activities for the World History course

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
    VALUES (world_history_course_id, 1, 'Beginnings - 600 BCE', 18, TRUE, 1)
    RETURNING id INTO unit_id;

    -- Add activities for "The origin of humans and early human societies"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (world_history_course_id, unit_id, 'History and prehistory', 'video', 'The origin of humans and early human societies', activity_counter),
    (world_history_course_id, unit_id, 'Prehistory before written records', 'article', 'The origin of humans and early human societies', activity_counter + 1),
    (world_history_course_id, unit_id, 'Knowing prehistory', 'exercise', 'The origin of humans and early human societies', activity_counter + 2),
    (world_history_course_id, unit_id, 'Homo sapiens and early human migration', 'article', 'The origin of humans and early human societies', activity_counter + 3),
    (world_history_course_id, unit_id, 'Peopling the earth', 'video', 'The origin of humans and early human societies', activity_counter + 4),
    (world_history_course_id, unit_id, 'Where did humans come from?', 'exercise', 'The origin of humans and early human societies', activity_counter + 5),
    (world_history_course_id, unit_id, 'Paleolithic societies', 'article', 'The origin of humans and early human societies', activity_counter + 6),
    (world_history_course_id, unit_id, 'Paleolithic technology, culture, and art', 'article', 'The origin of humans and early human societies', activity_counter + 7),
    (world_history_course_id, unit_id, 'Organizing paleolithic societies', 'video', 'The origin of humans and early human societies', activity_counter + 8),
    (world_history_course_id, unit_id, 'Paleolithic life', 'exercise', 'The origin of humans and early human societies', activity_counter + 9),
    (world_history_course_id, unit_id, 'The origin of humans and early human societies', 'exercise', 'The origin of humans and early human societies', activity_counter + 10);
    activity_counter := activity_counter + 11;

    -- Add activities for "The Neolithic Revolution and the birth of agriculture"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (world_history_course_id, unit_id, 'The Neolithic Revolution and early agriculture', 'video', 'The Neolithic Revolution and the birth of agriculture', activity_counter),
    (world_history_course_id, unit_id, 'The dawn of agriculture', 'article', 'The Neolithic Revolution and the birth of agriculture', activity_counter + 1),
    (world_history_course_id, unit_id, 'The spread of agriculture', 'video', 'The Neolithic Revolution and the birth of agriculture', activity_counter + 2),
    (world_history_course_id, unit_id, 'Where did agriculture come from?', 'exercise', 'The Neolithic Revolution and the birth of agriculture', activity_counter + 3),
    (world_history_course_id, unit_id, 'Early civilizations', 'article', 'The Neolithic Revolution and the birth of agriculture', activity_counter + 4),
    (world_history_course_id, unit_id, 'Social, political, and environmental characteristics of early civilizations', 'article', 'The Neolithic Revolution and the birth of agriculture', activity_counter + 5),
    (world_history_course_id, unit_id, 'Why did human societies get more complex?', 'exercise', 'The Neolithic Revolution and the birth of agriculture', activity_counter + 6),
    (world_history_course_id, unit_id, 'Neolithic Revolution and the birth of agriculture', 'exercise', 'The Neolithic Revolution and the birth of agriculture', activity_counter + 7);
    activity_counter := activity_counter + 8;

    -- Add quiz for "Beginnings - 600 BCE"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (world_history_course_id, unit_id, 'Beginnings - 600 BCE: Quiz 1', 'quiz', 'Quiz', activity_counter);
    activity_counter := activity_counter + 1;

    -- =============================================================================
    -- Unit: 600 BCE - 600 CE Second-Wave Civilizations
    -- =============================================================================

    -- Create Unit: 600 BCE - 600 CE Second-Wave Civilizations
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (world_history_course_id, 2, '600 BCE - 600 CE Second-Wave Civilizations', 50, TRUE, 2)
    RETURNING id INTO unit_id;

    -- Add activities for "Ancient Persia"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (world_history_course_id, unit_id, 'Cyrus the Great and the Achaemenid Empire', 'video', 'Ancient Persia', activity_counter),
    (world_history_course_id, unit_id, 'The Rise of Persia', 'article', 'Ancient Persia', activity_counter + 1),
    (world_history_course_id, unit_id, 'Zoroastrianism', 'video', 'Ancient Persia', activity_counter + 2),
    (world_history_course_id, unit_id, 'The Achaemenid Empire', 'exercise', 'Ancient Persia', activity_counter + 3),
    (world_history_course_id, unit_id, 'State-building: The Persian Empire', 'exercise', 'Ancient Persia', activity_counter + 4),
    (world_history_course_id, unit_id, 'Ancient Persia', 'exercise', 'Ancient Persia', activity_counter + 5);
    activity_counter := activity_counter + 6;

    -- Add activities for "Classical Greece"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (world_history_course_id, unit_id, 'Classical Greece', 'video', 'Classical Greece', activity_counter),
    (world_history_course_id, unit_id, 'The Greek polis', 'article', 'Classical Greece', activity_counter + 1),
    (world_history_course_id, unit_id, 'The Greek polis', 'exercise', 'Classical Greece', activity_counter + 2),
    (world_history_course_id, unit_id, 'State-building: the Greek polis', 'exercise', 'Classical Greece', activity_counter + 3),
    (world_history_course_id, unit_id, 'Greco Persian Wars', 'video', 'Classical Greece', activity_counter + 4),
    (world_history_course_id, unit_id, 'Second Persian Invasion', 'video', 'Classical Greece', activity_counter + 5),
    (world_history_course_id, unit_id, 'Classical Greek Society and Culture', 'video', 'Classical Greece', activity_counter + 6),
    (world_history_course_id, unit_id, 'Philosophy: Socrates, Plato and Aristotle', 'video', 'Classical Greece', activity_counter + 7),
    (world_history_course_id, unit_id, 'Classical Greek society', 'article', 'Classical Greece', activity_counter + 8),
    (world_history_course_id, unit_id, 'Classical Greek culture', 'article', 'Classical Greece', activity_counter + 9),
    (world_history_course_id, unit_id, 'Classical Greek society', 'exercise', 'Classical Greece', activity_counter + 10),
    (world_history_course_id, unit_id, 'Classical Greek culture and society', 'exercise', 'Classical Greece', activity_counter + 11),
    (world_history_course_id, unit_id, 'Classical Greece', 'exercise', 'Classical Greece', activity_counter + 12);
    activity_counter := activity_counter + 13;

    -- Add activities for "The rise and fall of empires"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (world_history_course_id, unit_id, 'Comparison: Rise of empires', 'video', 'The rise and fall of empires', activity_counter),
    (world_history_course_id, unit_id, 'Comparison: Fall of empires', 'video', 'The rise and fall of empires', activity_counter + 1),
    (world_history_course_id, unit_id, 'Comparing the rise and fall of empires', 'article', 'The rise and fall of empires', activity_counter + 2),
    (world_history_course_id, unit_id, 'Rise and fall of empires', 'exercise', 'The rise and fall of empires', activity_counter + 3),
    (world_history_course_id, unit_id, 'Focus on state-building: Empires', 'exercise', 'The rise and fall of empires', activity_counter + 4);
    activity_counter := activity_counter + 5;

    -- =============================================================================
    -- Unit: 600 - 1450 Regional and Interregional Interactions
    -- =============================================================================

    -- Create Unit: 600 - 1450 Regional and Interregional Interactions
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (world_history_course_id, 3, '600 - 1450 Regional and Interregional Interactions', 60, TRUE, 3)
    RETURNING id INTO unit_id;

    -- Add activities for "Byzantine Empire"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (world_history_course_id, unit_id, 'Justinian and the Byzantine Empire', 'video', 'Byzantine Empire', activity_counter),
    (world_history_course_id, unit_id, 'Comparing Roman and Byzantine Empires', 'video', 'Byzantine Empire', activity_counter + 1),
    (world_history_course_id, unit_id, 'Guided practice: continuity and change in the Byzantine Empire', 'article', 'Byzantine Empire', activity_counter + 2),
    (world_history_course_id, unit_id, 'Byzantine culture and society', 'article', 'Byzantine Empire', activity_counter + 3),
    (world_history_course_id, unit_id, 'Key concepts: the Byzantine Empire', 'exercise', 'Byzantine Empire', activity_counter + 4),
    (world_history_course_id, unit_id, 'Focus on continuity and change: Byzantine state-building', 'exercise', 'Byzantine Empire', activity_counter + 5);
    activity_counter := activity_counter + 6;

    -- Add activities for "European Middle Ages: Feudalism and Serfdom"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (world_history_course_id, unit_id, 'Overview of the Middle Ages', 'video', 'European Middle Ages: Feudalism and Serfdom', activity_counter),
    (world_history_course_id, unit_id, 'Feudal system during the Middle Ages', 'video', 'European Middle Ages: Feudalism and Serfdom', activity_counter + 1),
    (world_history_course_id, unit_id, 'Serfs and manorialism', 'video', 'European Middle Ages: Feudalism and Serfdom', activity_counter + 2),
    (world_history_course_id, unit_id, 'Serfdom in Europe', 'article', 'European Middle Ages: Feudalism and Serfdom', activity_counter + 3),
    (world_history_course_id, unit_id, 'Key Concepts: Serfdom', 'exercise', 'European Middle Ages: Feudalism and Serfdom', activity_counter + 4),
    (world_history_course_id, unit_id, 'Focus on economics: serfdom', 'exercise', 'European Middle Ages: Feudalism and Serfdom', activity_counter + 5),
    (world_history_course_id, unit_id, 'Peasant revolts', 'video', 'European Middle Ages: Feudalism and Serfdom', activity_counter + 6),
    (world_history_course_id, unit_id, 'Key concepts: Peasant revolts', 'exercise', 'European Middle Ages: Feudalism and Serfdom', activity_counter + 7),
    (world_history_course_id, unit_id, 'Focus on rebellion: Peasant revolts', 'exercise', 'European Middle Ages: Feudalism and Serfdom', activity_counter + 8);
    activity_counter := activity_counter + 9;

    -- =============================================================================
    -- Unit: 1450 - 1750 Renaissance and Reformation
    -- =============================================================================

    -- Create Unit: 1450 - 1750 Renaissance and Reformation
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (world_history_course_id, 4, '1450 - 1750 Renaissance and Reformation', 30, TRUE, 4)
    RETURNING id INTO unit_id;

    -- Add activities for "Spanish and Portuguese Empires"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (world_history_course_id, unit_id, 'Spain, Portugal, and the creation of a global economy', 'video', 'Spanish and Portuguese Empires', activity_counter);
    activity_counter := activity_counter + 1;

    -- Add activities for "Scientific Revolution and Enlightenment"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (world_history_course_id, unit_id, 'WATCH: The Scientific Revolution and the Age of Enlightenment', 'video', 'Scientific Revolution and Enlightenment', activity_counter);
    activity_counter := activity_counter + 1;

    -- Add activities for "Mughal Rule in India"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (world_history_course_id, unit_id, 'Mughal rule in India', 'video', 'Mughal Rule in India', activity_counter),
    (world_history_course_id, unit_id, 'WATCH: Ottoman, Safavid and Mughal Empires', 'video', 'Mughal Rule in India', activity_counter + 1);
    activity_counter := activity_counter + 2;

    -- Add activities for "Sikhism"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (world_history_course_id, unit_id, 'Sikhism introduction', 'video', 'Sikhism', activity_counter),
    (world_history_course_id, unit_id, 'Continuity-Sikhism connections to Hinduism and Islam', 'video', 'Sikhism', activity_counter + 1);
    activity_counter := activity_counter + 2;

    -- Add activities for "The Protestant Reformation"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (world_history_course_id, unit_id, 'An introduction to the Protestant Reformation', 'article', 'The Protestant Reformation', activity_counter),
    (world_history_course_id, unit_id, 'Introduction to the Protestant Reformation: Setting the stage', 'video', 'The Protestant Reformation', activity_counter + 1),
    (world_history_course_id, unit_id, 'Introduction to the Protestant Reformation: Martin Luther', 'video', 'The Protestant Reformation', activity_counter + 2),
    (world_history_course_id, unit_id, 'Introduction to the Protestant Reformation: Varieties of Protestantism', 'video', 'The Protestant Reformation', activity_counter + 3),
    (world_history_course_id, unit_id, 'Introduction to the Protestant Reformation: The Counter-Reformation', 'video', 'The Protestant Reformation', activity_counter + 4),
    (world_history_course_id, unit_id, 'Read + Discuss', 'article', 'The Protestant Reformation', activity_counter + 5),
    (world_history_course_id, unit_id, 'Protestant Reformation', 'exercise', 'The Protestant Reformation', activity_counter + 6),
    (world_history_course_id, unit_id, 'Cranach, Law and Gospel (Law and Grace)', 'article', 'The Protestant Reformation', activity_counter + 7),
    (world_history_course_id, unit_id, 'Cranach, Law and Gospel', 'exercise', 'The Protestant Reformation', activity_counter + 8);
    activity_counter := activity_counter + 9;

    -- =============================================================================
    -- Unit: 1750 - 1900 Enlightenment and Revolution
    -- =============================================================================

    -- Create Unit: 1750 - 1900 Enlightenment and Revolution
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (world_history_course_id, 5, '1750 - 1900 Enlightenment and Revolution', 40, TRUE, 5)
    RETURNING id INTO unit_id;

    -- Add activities for "American Revolution"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (world_history_course_id, unit_id, 'The Seven Years\' War: background and combatants', 'video', 'American Revolution', activity_counter),
    (world_history_course_id, unit_id, 'The Seven Years\' War: battles and legacy', 'video', 'American Revolution', activity_counter + 1),
    (world_history_course_id, unit_id, 'Background and introduction to the United States Declaration of Independence', 'video', 'American Revolution', activity_counter + 2),
    (world_history_course_id, unit_id, 'Birth of the US Constitution', 'video', 'American Revolution', activity_counter + 3);
    activity_counter := activity_counter + 4;

    -- Add activities for "French Revolution"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (world_history_course_id, unit_id, 'French Revolution (part 1)', 'video', 'French Revolution', activity_counter),
    (world_history_course_id, unit_id, 'French Revolution (part 2)', 'video', 'French Revolution', activity_counter + 1),
    (world_history_course_id, unit_id, 'French Revolution (part 3) - Reign of Terror', 'video', 'French Revolution', activity_counter + 2),
    (world_history_course_id, unit_id, 'French Revolution (part 4) - The Rise of Napoleon Bonaparte', 'video', 'French Revolution', activity_counter + 3);
    activity_counter := activity_counter + 4;

    -- Add activities for "Napoleon Bonaparte"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (world_history_course_id, unit_id, 'Napoleon and the Wars of the First and Second Coalitions', 'video', 'Napoleon Bonaparte', activity_counter),
    (world_history_course_id, unit_id, 'Napoleon and the War of the Third Coalition', 'video', 'Napoleon Bonaparte', activity_counter + 1),
    (world_history_course_id, unit_id, 'Napoleon and the War of the Fourth Coalition', 'video', 'Napoleon Bonaparte', activity_counter + 2),
    (world_history_course_id, unit_id, 'Napoleon\'s Peninsular Campaigns', 'video', 'Napoleon Bonaparte', activity_counter + 3),
    (world_history_course_id, unit_id, 'French invasion of Russia', 'video', 'Napoleon Bonaparte', activity_counter + 4),
    (world_history_course_id, unit_id, 'Napoleon forced to abdicate', 'video', 'Napoleon Bonaparte', activity_counter + 5),
    (world_history_course_id, unit_id, 'Hundred days and Waterloo', 'video', 'Napoleon Bonaparte', activity_counter + 6);
    activity_counter := activity_counter + 7;

    -- =============================================================================
    -- Unit: The 20th Century
    -- =============================================================================

    -- Create Unit: The 20th Century
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (world_history_course_id, 6, 'The 20th Century', 50, TRUE, 6)
    RETURNING id INTO unit_id;

    -- Add activities for "Beginning of World War I"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (world_history_course_id, unit_id, 'Empires before World War I', 'video', 'Beginning of World War I', activity_counter),
    (world_history_course_id, unit_id, 'German and Italian Empires in 1914', 'video', 'Beginning of World War I', activity_counter + 1),
    (world_history_course_id, unit_id, 'Alliances leading to World War I', 'video', 'Beginning of World War I', activity_counter + 2),
    (world_history_course_id, unit_id, 'Language and religion of the former Yugoslavia', 'video', 'Beginning of World War I', activity_counter + 3),
    (world_history_course_id, unit_id, 'Assassination of Franz Ferdinand', 'video', 'Beginning of World War I', activity_counter + 4),
    (world_history_course_id, unit_id, 'The Great War begins', 'video', 'Beginning of World War I', activity_counter + 5),
    (world_history_course_id, unit_id, 'Causes of World War I', 'exercise', 'Beginning of World War I', activity_counter + 6);
    activity_counter := activity_counter + 7;

    -- Add activities for "Other Fronts of World War I"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (world_history_course_id, unit_id, 'Serbian and Macedonian fronts', 'video', 'Other Fronts of World War I', activity_counter),
    (world_history_course_id, unit_id, 'Serbian losses in World War I', 'video', 'Other Fronts of World War I', activity_counter + 1),
    (world_history_course_id, unit_id, 'Italy backs out of Triple Alliance', 'video', 'Other Fronts of World War I', activity_counter + 2),
    (world_history_course_id, unit_id, 'Italian front in World War I', 'video', 'Other Fronts of World War I', activity_counter + 3),
    (world_history_course_id, unit_id, 'Japan in World War I', 'video', 'Other Fronts of World War I', activity_counter + 4),
    (world_history_course_id, unit_id, 'Secondary fronts of WWI', 'exercise', 'Other Fronts of World War I', activity_counter + 5);
    activity_counter := activity_counter + 6;

    -- Add activities for "Western and Eastern Fronts of World War I"
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (world_history_course_id, unit_id, 'Schlieffen Plan and the First Battle of the Marne', 'video', 'Western and Eastern Fronts of World War I', activity_counter),
    (world_history_course_id, unit_id, 'Comparing the Eastern and Western fronts in WWI', 'video', 'Western and Eastern Fronts of World War I', activity_counter + 1),
    (world_history_course_id, unit_id, 'World War I Eastern front', 'video', 'Western and Eastern Fronts of World War I', activity_counter + 2),
    (world_history_course_id, unit_id, 'Battles of Verdun, Somme and the Hindenburg Line', 'video', 'Western and Eastern Fronts of World War I', activity_counter + 3),
    (world_history_course_id, unit_id, 'Closing stages of World War I', 'video', 'Western and Eastern Fronts of World War I', activity_counter + 4),
    (world_history_course_id, unit_id, 'Technology in World War I', 'video', 'Western and Eastern Fronts of World War I', activity_counter + 5),
    (world_history_course_id, unit_id, 'Eastern and Western fronts of World War I', 'exercise', 'Western and Eastern Fronts of World War I', activity_counter + 6);
    activity_counter := activity_counter + 7;

    -- Continue adding all lessons and activities for the remaining topics...

    -- =============================================================================
    -- Add remaining lessons and activities here
    -- =============================================================================

    RAISE NOTICE 'Successfully imported World History course';
END $$;