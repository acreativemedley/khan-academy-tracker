-- High School Chemistry Units 6-10 Import Script
-- This script imports Units 6-10 with their activities
-- Based on chemistry-data-formatted.md

-- =============================================================================
-- HIGH SCHOOL CHEMISTRY - UNITS 6-10 IMPORT
-- Clean import process for Units 6-10 activities
-- =============================================================================

DO $$
DECLARE
    chemistry_course_id UUID;
    unit_6_id UUID;
    unit_7_id UUID;
    unit_8_id UUID;
    unit_9_id UUID;
    unit_10_id UUID;
    activity_counter INTEGER := 1;
BEGIN
    -- Get the High School Chemistry course ID
    SELECT id INTO chemistry_course_id FROM courses WHERE name = 'High School Chemistry';
    
    IF chemistry_course_id IS NULL THEN
        RAISE EXCEPTION 'High School Chemistry course not found. Please import courses first.';
    END IF;

    RAISE NOTICE 'Found High School Chemistry course: %', chemistry_course_id;

    -- Delete existing activities and units for this course (Units 6-10 only)
    DELETE FROM activities WHERE course_id = chemistry_course_id AND unit_id IN (
        SELECT id FROM units WHERE course_id = chemistry_course_id AND unit_number BETWEEN 6 AND 10
    );
    DELETE FROM units WHERE course_id = chemistry_course_id AND unit_number BETWEEN 6 AND 10;
    
    RAISE NOTICE 'Deleted existing units 6-10 and their activities for High School Chemistry';

    -- =============================================================================
    -- CREATE UNITS 6-10
    -- =============================================================================
    
    -- Create Unit 6: States of matter
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (chemistry_course_id, 6, 'States of matter', 30, TRUE, 6)
    RETURNING id INTO unit_6_id;
    
    -- Create Unit 7: Thermochemistry
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (chemistry_course_id, 7, 'Thermochemistry', 8, TRUE, 7)
    RETURNING id INTO unit_7_id;
    
    -- Create Unit 8: Solutions, acids, and bases
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (chemistry_course_id, 8, 'Solutions, acids, and bases', 25, TRUE, 8)
    RETURNING id INTO unit_8_id;
    
    -- Create Unit 9: Reaction rates and equilibrium
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (chemistry_course_id, 9, 'Reaction rates and equilibrium', 17, TRUE, 9)
    RETURNING id INTO unit_9_id;
    
    -- Create Unit 10: Nuclear chemistry
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (chemistry_course_id, 10, 'Nuclear chemistry', 23, TRUE, 10)
    RETURNING id INTO unit_10_id;

    RAISE NOTICE 'Created units 6-10';

    -- Reset activity counter
    activity_counter := 1;

    -- =============================================================================
    -- UNIT 6: STATES OF MATTER (30 activities)
    -- =============================================================================
    
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    -- Lesson 1: Electronegativity and bond polarity (8 activities)
    (chemistry_course_id, unit_6_id, 'Electronegativity', 'video', 'Electronegativity and bond polarity', activity_counter),
    (chemistry_course_id, unit_6_id, 'Predicting bond type (electronegativity)', 'video', 'Electronegativity and bond polarity', activity_counter + 1),
    (chemistry_course_id, unit_6_id, 'Electronegativity and bond type', 'video', 'Electronegativity and bond polarity', activity_counter + 2),
    (chemistry_course_id, unit_6_id, 'Understand: electronegativity and bond polarity', 'exercise', 'Electronegativity and bond polarity', activity_counter + 3),
    (chemistry_course_id, unit_6_id, 'Apply: electronegativity and bond polarity', 'exercise', 'Electronegativity and bond polarity', activity_counter + 4),
    (chemistry_course_id, unit_6_id, 'Molecular geometry (VSEPR theory)', 'video', 'Electronegativity and bond polarity', activity_counter + 5),
    (chemistry_course_id, unit_6_id, 'Molecular polarity', 'video', 'Electronegativity and bond polarity', activity_counter + 6),
    (chemistry_course_id, unit_6_id, 'Apply: shapes of molecules', 'exercise', 'Electronegativity and bond polarity', activity_counter + 7);
    activity_counter := activity_counter + 8;
    
    -- Quiz 1: States of matter
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_6_id, 'Quiz 1: States of matter', 'quiz', 'Quiz 1: States of matter', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 2: Intermolecular forces (5 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_6_id, 'London dispersion forces introduction', 'video', 'Intermolecular forces', activity_counter),
    (chemistry_course_id, unit_6_id, 'Dipole–dipole forces', 'video', 'Intermolecular forces', activity_counter + 1),
    (chemistry_course_id, unit_6_id, 'Hydrogen bonding', 'video', 'Intermolecular forces', activity_counter + 2),
    (chemistry_course_id, unit_6_id, 'Understand: intermolecular forces', 'exercise', 'Intermolecular forces', activity_counter + 3),
    (chemistry_course_id, unit_6_id, 'Apply: intermolecular forces', 'exercise', 'Intermolecular forces', activity_counter + 4);
    activity_counter := activity_counter + 5;
    
    -- Lesson 3: Activity: How does water form droplets on surfaces? (1 activity)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_6_id, 'Activity: How does water form droplets on surfaces?', 'article', 'Activity: How does water form droplets on surfaces?', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 4: Liquids and solids (3 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_6_id, 'Intermolecular forces and vapor pressure', 'video', 'Liquids and solids', activity_counter),
    (chemistry_course_id, unit_6_id, 'Apply: properties of liquids', 'exercise', 'Liquids and solids', activity_counter + 1),
    (chemistry_course_id, unit_6_id, 'Apply: properties of solids', 'exercise', 'Liquids and solids', activity_counter + 2);
    activity_counter := activity_counter + 3;
    
    -- Quiz 2: States of matter
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_6_id, 'Quiz 2: States of matter', 'quiz', 'Quiz 2: States of matter', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 5: Gases (7 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_6_id, 'The kinetic molecular theory of gases', 'video', 'Gases', activity_counter),
    (chemistry_course_id, unit_6_id, 'Kinetic molecular theory and the gas laws', 'video', 'Gases', activity_counter + 1),
    (chemistry_course_id, unit_6_id, 'Understand: kinetic molecular theory', 'exercise', 'Gases', activity_counter + 2),
    (chemistry_course_id, unit_6_id, 'Apply: properties of gases', 'exercise', 'Gases', activity_counter + 3),
    (chemistry_course_id, unit_6_id, 'Worked example: Using the ideal gas law to calculate a change in volume', 'video', 'Gases', activity_counter + 4),
    (chemistry_course_id, unit_6_id, 'Gas mixtures and partial pressures', 'video', 'Gases', activity_counter + 5),
    (chemistry_course_id, unit_6_id, 'Apply: gas law calculations', 'exercise', 'Gases', activity_counter + 6);
    activity_counter := activity_counter + 7;
    
    -- Quiz 3: States of matter
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_6_id, 'Quiz 3: States of matter', 'quiz', 'Quiz 3: States of matter', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Unit Test: States of matter
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_6_id, 'Unit Test: States of matter', 'unit_test', 'Unit Test: States of matter', activity_counter);
    activity_counter := activity_counter + 1;

    -- =============================================================================
    -- UNIT 7: THERMOCHEMISTRY (8 activities)
    -- =============================================================================
    
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    -- Lesson 1: Thermal energy and equilibrium (4 activities)
    (chemistry_course_id, unit_7_id, 'Thermal energy, temperature, and heat', 'video', 'Thermal energy and equilibrium', activity_counter),
    (chemistry_course_id, unit_7_id, 'First and second laws of thermodynamics', 'video', 'Thermal energy and equilibrium', activity_counter + 1),
    (chemistry_course_id, unit_7_id, 'Understand: thermal energy and equilibrium', 'exercise', 'Thermal energy and equilibrium', activity_counter + 2),
    (chemistry_course_id, unit_7_id, 'Apply: thermal energy and equilibrium', 'exercise', 'Thermal energy and equilibrium', activity_counter + 3);
    activity_counter := activity_counter + 4;
    
    -- Quiz 1: Thermochemistry
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_7_id, 'Quiz 1: Thermochemistry', 'quiz', 'Quiz 1: Thermochemistry', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 2: Specific heat capacity (1 activity)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_7_id, 'Specific heat capacity', 'video', 'Specific heat capacity', activity_counter),
    (chemistry_course_id, unit_7_id, 'Apply: specific heat capacity', 'exercise', 'Specific heat capacity', activity_counter + 1);
    activity_counter := activity_counter + 2;
    
    -- Lesson 3: Activity: Why does sand at the beach feel hot, even when the water feels cool? (1 activity)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_7_id, 'Activity: Why does sand at the beach feel hot, even when the water feels cool?', 'article', 'Activity: Why does sand at the beach feel hot, even when the water feels cool?', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 4: Calorimetry (2 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_7_id, 'Constant-pressure calorimetry', 'video', 'Calorimetry', activity_counter),
    (chemistry_course_id, unit_7_id, 'Apply: calorimetry', 'exercise', 'Calorimetry', activity_counter + 1);
    activity_counter := activity_counter + 2;
    
    -- Unit Test: Thermochemistry
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_7_id, 'Unit Test: Thermochemistry', 'unit_test', 'Unit Test: Thermochemistry', activity_counter);
    activity_counter := activity_counter + 1;

    -- =============================================================================
    -- UNIT 8: SOLUTIONS, ACIDS, AND BASES (25 activities)
    -- =============================================================================
    
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    -- Lesson 1: Aqueous solutions (2 activities)
    (chemistry_course_id, unit_8_id, 'Aqueous solutions', 'video', 'Aqueous solutions', activity_counter),
    (chemistry_course_id, unit_8_id, 'Understand: aqueous solutions', 'exercise', 'Aqueous solutions', activity_counter + 1);
    activity_counter := activity_counter + 2;
    
    -- Lesson 2: Solubility (6 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_8_id, 'Solubility and intermolecular forces', 'video', 'Solubility', activity_counter),
    (chemistry_course_id, unit_8_id, 'Apply: solubility', 'exercise', 'Solubility', activity_counter + 1),
    (chemistry_course_id, unit_8_id, 'Double replacement reactions', 'video', 'Solubility', activity_counter + 2),
    (chemistry_course_id, unit_8_id, 'Double replacement reactions', 'article', 'Solubility', activity_counter + 3),
    (chemistry_course_id, unit_8_id, 'Apply: solubility rules', 'exercise', 'Solubility', activity_counter + 4),
    (chemistry_course_id, unit_8_id, 'Apply: double replacement reactions', 'exercise', 'Solubility', activity_counter + 5);
    activity_counter := activity_counter + 6;
    
    -- Lesson 3: Activity: How can solubility principles help us detect and eliminate chemical contaminants in our water supply? (1 activity)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_8_id, 'Activity: How can solubility principles help us detect and eliminate chemical contaminants in our water supply?', 'article', 'Activity: How can solubility principles help us detect and eliminate chemical contaminants in our water supply?', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 4: Molarity (4 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_8_id, 'Molarity', 'video', 'Molarity', activity_counter),
    (chemistry_course_id, unit_8_id, 'Dilutions', 'video', 'Molarity', activity_counter + 1),
    (chemistry_course_id, unit_8_id, 'Understand: molarity', 'exercise', 'Molarity', activity_counter + 2),
    (chemistry_course_id, unit_8_id, 'Apply: molarity', 'exercise', 'Molarity', activity_counter + 3);
    activity_counter := activity_counter + 4;
    
    -- Quiz 1: Solutions, acids, and bases
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_8_id, 'Quiz 1: Solutions, acids, and bases', 'quiz', 'Quiz 1: Solutions, acids, and bases', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 5: Intro to acids and bases (7 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_8_id, 'Intro to acids and bases', 'video', 'Intro to acids and bases', activity_counter),
    (chemistry_course_id, unit_8_id, 'Understand: intro to acids and bases', 'exercise', 'Intro to acids and bases', activity_counter + 1),
    (chemistry_course_id, unit_8_id, 'Apply: intro to acids and bases', 'exercise', 'Intro to acids and bases', activity_counter + 2),
    (chemistry_course_id, unit_8_id, 'Naming acids and bases', 'article', 'Intro to acids and bases', activity_counter + 3),
    (chemistry_course_id, unit_8_id, 'Apply: naming acids and bases', 'exercise', 'Intro to acids and bases', activity_counter + 4),
    (chemistry_course_id, unit_8_id, 'Introduction to pH', 'video', 'Intro to acids and bases', activity_counter + 5),
    (chemistry_course_id, unit_8_id, 'Apply: the pH scale', 'exercise', 'Intro to acids and bases', activity_counter + 6);
    activity_counter := activity_counter + 7;
    
    -- Quiz 2: Solutions, acids, and bases
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_8_id, 'Quiz 2: Solutions, acids, and bases', 'quiz', 'Quiz 2: Solutions, acids, and bases', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Unit Test: Solutions, acids, and bases
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_8_id, 'Unit Test: Solutions, acids, and bases', 'unit_test', 'Unit Test: Solutions, acids, and bases', activity_counter);
    activity_counter := activity_counter + 1;

    -- =============================================================================
    -- UNIT 9: REACTION RATES AND EQUILIBRIUM (17 activities)
    -- =============================================================================
    
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    -- Lesson 1: Reaction rates (5 activities)
    (chemistry_course_id, unit_9_id, 'Collision theory', 'video', 'Reaction rates', activity_counter),
    (chemistry_course_id, unit_9_id, 'Understand: collision theory', 'exercise', 'Reaction rates', activity_counter + 1),
    (chemistry_course_id, unit_9_id, 'Factors affecting reaction rates', 'video', 'Reaction rates', activity_counter + 2),
    (chemistry_course_id, unit_9_id, 'Understand: factors affecting reaction rates', 'exercise', 'Reaction rates', activity_counter + 3),
    (chemistry_course_id, unit_9_id, 'Apply: factors affecting reaction rates', 'exercise', 'Reaction rates', activity_counter + 4);
    activity_counter := activity_counter + 5;
    
    -- Lesson 2: Activity: Why does food in a refrigerator stay fresh for longer? (1 activity)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_9_id, 'Activity: Why does food in a refrigerator stay fresh for longer?', 'article', 'Activity: Why does food in a refrigerator stay fresh for longer?', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Quiz 1: Reaction rates and equilibrium
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_9_id, 'Quiz 1: Reaction rates and equilibrium', 'quiz', 'Quiz 1: Reaction rates and equilibrium', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 3: Catalysts (2 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_9_id, 'Catalysts', 'video', 'Catalysts', activity_counter),
    (chemistry_course_id, unit_9_id, 'Understand: catalysts', 'exercise', 'Catalysts', activity_counter + 1);
    activity_counter := activity_counter + 2;
    
    -- Lesson 4: Equilibrium & Le Châtelier's principle (4 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_9_id, 'Reversible reactions and equilibrium', 'video', 'Equilibrium & Le Châtelier''s principle', activity_counter),
    (chemistry_course_id, unit_9_id, 'Le Châtelier''s principle', 'video', 'Equilibrium & Le Châtelier''s principle', activity_counter + 1),
    (chemistry_course_id, unit_9_id, 'Understand: equilibrium and Le Châtelier''s principle', 'exercise', 'Equilibrium & Le Châtelier''s principle', activity_counter + 2),
    (chemistry_course_id, unit_9_id, 'Apply: Le Châtelier''s principle', 'exercise', 'Equilibrium & Le Châtelier''s principle', activity_counter + 3);
    activity_counter := activity_counter + 4;
    
    -- Quiz 2: Reaction rates and equilibrium
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_9_id, 'Quiz 2: Reaction rates and equilibrium', 'quiz', 'Quiz 2: Reaction rates and equilibrium', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Unit Test: Reaction rates and equilibrium
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_9_id, 'Unit Test: Reaction rates and equilibrium', 'unit_test', 'Unit Test: Reaction rates and equilibrium', activity_counter);
    activity_counter := activity_counter + 1;

    -- =============================================================================
    -- UNIT 10: NUCLEAR CHEMISTRY (23 activities)
    -- =============================================================================
    
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    -- Lesson 1: Radioactive decay (8 activities)
    (chemistry_course_id, unit_10_id, 'Intro to radioactive decay', 'video', 'Radioactive decay', activity_counter),
    (chemistry_course_id, unit_10_id, 'Alpha decay', 'video', 'Radioactive decay', activity_counter + 1),
    (chemistry_course_id, unit_10_id, 'Apply: alpha decay', 'exercise', 'Radioactive decay', activity_counter + 2),
    (chemistry_course_id, unit_10_id, 'Beta decay', 'video', 'Radioactive decay', activity_counter + 3),
    (chemistry_course_id, unit_10_id, 'Apply: beta decay', 'exercise', 'Radioactive decay', activity_counter + 4),
    (chemistry_course_id, unit_10_id, 'Gamma decay', 'video', 'Radioactive decay', activity_counter + 5),
    (chemistry_course_id, unit_10_id, 'Understand: radioactive decay', 'exercise', 'Radioactive decay', activity_counter + 6),
    (chemistry_course_id, unit_10_id, 'Apply: alpha, beta, and gamma decay', 'exercise', 'Radioactive decay', activity_counter + 7);
    activity_counter := activity_counter + 8;
    
    -- Quiz 1: Nuclear chemistry
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_10_id, 'Quiz 1: Nuclear chemistry', 'quiz', 'Quiz 1: Nuclear chemistry', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 2: Half-life and radiometric dating (3 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_10_id, 'Half-life', 'video', 'Half-life and radiometric dating', activity_counter),
    (chemistry_course_id, unit_10_id, 'Understand: half-life and radiometric dating', 'exercise', 'Half-life and radiometric dating', activity_counter + 1),
    (chemistry_course_id, unit_10_id, 'Apply: half-life and radiometric dating', 'exercise', 'Half-life and radiometric dating', activity_counter + 2);
    activity_counter := activity_counter + 3;
    
    -- Lesson 3: Activity: How do we know when dinosaurs lived on Earth? (1 activity)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_10_id, 'Activity: How do we know when dinosaurs lived on Earth?', 'article', 'Activity: How do we know when dinosaurs lived on Earth?', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Quiz 2: Nuclear chemistry
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_10_id, 'Quiz 2: Nuclear chemistry', 'quiz', 'Quiz 2: Nuclear chemistry', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 4: Nuclear fusion (2 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_10_id, 'Nuclear fusion', 'video', 'Nuclear fusion', activity_counter),
    (chemistry_course_id, unit_10_id, 'Understand: nuclear fusion', 'exercise', 'Nuclear fusion', activity_counter + 1);
    activity_counter := activity_counter + 2;
    
    -- Lesson 5: Nuclear fission (3 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_10_id, 'Nuclear fission', 'video', 'Nuclear fission', activity_counter),
    (chemistry_course_id, unit_10_id, 'Understand: nuclear fission', 'exercise', 'Nuclear fission', activity_counter + 1),
    (chemistry_course_id, unit_10_id, 'Apply: nuclear fission', 'exercise', 'Nuclear fission', activity_counter + 2);
    activity_counter := activity_counter + 3;
    
    -- Quiz 3: Nuclear chemistry
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_10_id, 'Quiz 3: Nuclear chemistry', 'quiz', 'Quiz 3: Nuclear chemistry', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Unit Test: Nuclear chemistry
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_10_id, 'Unit Test: Nuclear chemistry', 'unit_test', 'Unit Test: Nuclear chemistry', activity_counter);
    activity_counter := activity_counter + 1;

    RAISE NOTICE 'Completed import of % activities across units 6-10', activity_counter - 1;

END $$;

-- =============================================================================
-- VERIFICATION QUERIES
-- =============================================================================

-- Verify unit counts
SELECT 
    u.unit_number,
    u.title,
    u.total_activities as expected_activities,
    COUNT(a.id) as actual_activities
FROM units u
LEFT JOIN activities a ON u.id = a.unit_id
JOIN courses c ON u.course_id = c.id
WHERE c.name = 'High School Chemistry' 
    AND u.unit_number BETWEEN 6 AND 10
GROUP BY u.unit_number, u.title, u.total_activities
ORDER BY u.unit_number;

-- Verify activity type distribution for units 6-10
SELECT 
    a.activity_type::text,
    COUNT(*) as count
FROM activities a
JOIN units u ON a.unit_id = u.id
JOIN courses c ON u.course_id = c.id
WHERE c.name = 'High School Chemistry' 
    AND u.unit_number BETWEEN 6 AND 10
GROUP BY a.activity_type::text
ORDER BY count DESC;

-- Total activity count for units 6-10
SELECT COUNT(*) as total_activities_units_6_10
FROM activities a
JOIN units u ON a.unit_id = u.id
JOIN courses c ON u.course_id = c.id
WHERE c.name = 'High School Chemistry' 
    AND u.unit_number BETWEEN 6 AND 10;

-- Combined totals for all chemistry units
SELECT 
    'Units 1-5' as unit_range,
    COUNT(*) as activity_count
FROM activities a
JOIN units u ON a.unit_id = u.id
JOIN courses c ON u.course_id = c.id
WHERE c.name = 'High School Chemistry' 
    AND u.unit_number BETWEEN 1 AND 5
UNION ALL
SELECT 
    'Units 6-10' as unit_range,
    COUNT(*) as activity_count
FROM activities a
JOIN units u ON a.unit_id = u.id
JOIN courses c ON u.course_id = c.id
WHERE c.name = 'High School Chemistry' 
    AND u.unit_number BETWEEN 6 AND 10
UNION ALL
SELECT 
    'All Chemistry Units' as unit_range,
    COUNT(*) as activity_count
FROM activities a
JOIN units u ON a.unit_id = u.id
JOIN courses c ON u.course_id = c.id
WHERE c.name = 'High School Chemistry';