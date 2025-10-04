-- High School Chemistry Units 1-5 Import Script
-- This script imports Units 1-5 with their activities
-- Based on chemistry-data-formatted.md

-- =============================================================================
-- HIGH SCHOOL CHEMISTRY - UNITS 1-5 IMPORT
-- Clean import process for Units 1-5 activities
-- =============================================================================

DO $$
DECLARE
    chemistry_course_id UUID;
    unit_1_id UUID;
    unit_2_id UUID;
    unit_3_id UUID;
    unit_4_id UUID;
    unit_5_id UUID;
    activity_counter INTEGER := 1;
BEGIN
    -- Get the High School Chemistry course ID
    SELECT id INTO chemistry_course_id FROM courses WHERE name = 'High School Chemistry';
    
    IF chemistry_course_id IS NULL THEN
        RAISE EXCEPTION 'High School Chemistry course not found. Please import courses first.';
    END IF;

    RAISE NOTICE 'Found High School Chemistry course: %', chemistry_course_id;

    -- Delete existing activities and units for this course (Units 1-5 only)
    DELETE FROM activities WHERE course_id = chemistry_course_id AND unit_id IN (
        SELECT id FROM units WHERE course_id = chemistry_course_id AND unit_number BETWEEN 1 AND 5
    );
    DELETE FROM units WHERE course_id = chemistry_course_id AND unit_number BETWEEN 1 AND 5;
    
    RAISE NOTICE 'Deleted existing units 1-5 and their activities for High School Chemistry';

    -- =============================================================================
    -- CREATE UNITS 1-5
    -- =============================================================================
    
    -- Create Unit 1: Atoms, compounds, and ions
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (chemistry_course_id, 1, 'Atoms, compounds, and ions', 28, TRUE, 1)
    RETURNING id INTO unit_1_id;
    
    -- Create Unit 2: More about atoms
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (chemistry_course_id, 2, 'More about atoms', 15, TRUE, 2)
    RETURNING id INTO unit_2_id;
    
    -- Create Unit 3: More about molecular composition
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (chemistry_course_id, 3, 'More about molecular composition', 18, TRUE, 3)
    RETURNING id INTO unit_3_id;
    
    -- Create Unit 4: Chemical reactions
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (chemistry_course_id, 4, 'Chemical reactions', 22, TRUE, 4)
    RETURNING id INTO unit_4_id;
    
    -- Create Unit 5: Stoichiometry and the mole
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (chemistry_course_id, 5, 'Stoichiometry and the mole', 20, TRUE, 5)
    RETURNING id INTO unit_5_id;

    RAISE NOTICE 'Created units 1-5';

    -- Reset activity counter
    activity_counter := 1;

    -- =============================================================================
    -- UNIT 1: ATOMS, COMPOUNDS, AND IONS (28 activities)
    -- =============================================================================
    
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    -- Lesson 1: Elements and atoms (6 activities)
    (chemistry_course_id, unit_1_id, 'Introduction to the atom', 'video', 'Elements and atoms', activity_counter),
    (chemistry_course_id, unit_1_id, 'Understand: elements and atoms', 'exercise', 'Elements and atoms', activity_counter + 1),
    (chemistry_course_id, unit_1_id, 'Apply: elements and atoms', 'exercise', 'Elements and atoms', activity_counter + 2),
    (chemistry_course_id, unit_1_id, 'Worked example: Identifying isotopes and ions', 'video', 'Elements and atoms', activity_counter + 3),
    (chemistry_course_id, unit_1_id, 'Understand: isotopes and ions', 'exercise', 'Elements and atoms', activity_counter + 4),
    (chemistry_course_id, unit_1_id, 'Apply: isotopes and ions', 'exercise', 'Elements and atoms', activity_counter + 5);
    activity_counter := activity_counter + 6;
    
    -- Lesson 2: Compounds and ions (5 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_1_id, 'Introduction to compounds', 'video', 'Compounds and ions', activity_counter),
    (chemistry_course_id, unit_1_id, 'Understand: compounds and ions', 'exercise', 'Compounds and ions', activity_counter + 1),
    (chemistry_course_id, unit_1_id, 'Apply: compounds and ions', 'exercise', 'Compounds and ions', activity_counter + 2),
    (chemistry_course_id, unit_1_id, 'Introduction to ionic bonding', 'video', 'Compounds and ions', activity_counter + 3),
    (chemistry_course_id, unit_1_id, 'Naming ionic compound with polyvalent ion', 'video', 'Compounds and ions', activity_counter + 4);
    activity_counter := activity_counter + 5;
    
    -- Quiz 1: Atoms, compounds, and ions
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_1_id, 'Quiz 1: Atoms, compounds, and ions', 'quiz', 'Quiz 1: Atoms, compounds, and ions', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 3: Names and formulas of ionic compounds (6 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_1_id, 'Naming monatomic ions and ionic compounds', 'video', 'Names and formulas of ionic compounds', activity_counter),
    (chemistry_course_id, unit_1_id, 'Understand: naming ionic compounds', 'exercise', 'Names and formulas of ionic compounds', activity_counter + 1),
    (chemistry_course_id, unit_1_id, 'Apply: naming ionic compounds', 'exercise', 'Names and formulas of ionic compounds', activity_counter + 2),
    (chemistry_course_id, unit_1_id, 'Polyatomic ions', 'video', 'Names and formulas of ionic compounds', activity_counter + 3),
    (chemistry_course_id, unit_1_id, 'Understand: polyatomic ions', 'exercise', 'Names and formulas of ionic compounds', activity_counter + 4),
    (chemistry_course_id, unit_1_id, 'Apply: polyatomic ions', 'exercise', 'Names and formulas of ionic compounds', activity_counter + 5);
    activity_counter := activity_counter + 6;
    
    -- Lesson 4: Molecular and ionic compound structure and properties (4 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_1_id, 'Introduction to ionic bonds', 'video', 'Molecular and ionic compound structure and properties', activity_counter),
    (chemistry_course_id, unit_1_id, 'Introduction to covalent bonds', 'video', 'Molecular and ionic compound structure and properties', activity_counter + 1),
    (chemistry_course_id, unit_1_id, 'Understand: molecular and ionic compound structure and properties', 'exercise', 'Molecular and ionic compound structure and properties', activity_counter + 2),
    (chemistry_course_id, unit_1_id, 'Apply: molecular and ionic compound structure and properties', 'exercise', 'Molecular and ionic compound structure and properties', activity_counter + 3);
    activity_counter := activity_counter + 4;
    
    -- Quiz 2: Atoms, compounds, and ions
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_1_id, 'Quiz 2: Atoms, compounds, and ions', 'quiz', 'Quiz 2: Atoms, compounds, and ions', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 5: Names and formulas of molecular compounds (4 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_1_id, 'Naming covalent molecular compounds', 'video', 'Names and formulas of molecular compounds', activity_counter),
    (chemistry_course_id, unit_1_id, 'Understand: naming molecular compounds', 'exercise', 'Names and formulas of molecular compounds', activity_counter + 1),
    (chemistry_course_id, unit_1_id, 'Apply: naming molecular compounds', 'exercise', 'Names and formulas of molecular compounds', activity_counter + 2),
    (chemistry_course_id, unit_1_id, 'Activity: Is water a compound or a mixture?', 'article', 'Names and formulas of molecular compounds', activity_counter + 3);
    activity_counter := activity_counter + 4;
    
    -- Unit Test: Atoms, compounds, and ions
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_1_id, 'Unit Test: Atoms, compounds, and ions', 'unit_test', 'Unit Test: Atoms, compounds, and ions', activity_counter);
    activity_counter := activity_counter + 1;

    -- =============================================================================
    -- UNIT 2: MORE ABOUT ATOMS (15 activities)
    -- =============================================================================
    
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    -- Lesson 1: Electronic structure of atoms (7 activities)
    (chemistry_course_id, unit_2_id, 'The Bohr model of the hydrogen atom', 'video', 'Electronic structure of atoms', activity_counter),
    (chemistry_course_id, unit_2_id, 'Understand: electronic structure of atoms', 'exercise', 'Electronic structure of atoms', activity_counter + 1),
    (chemistry_course_id, unit_2_id, 'Apply: electronic structure of atoms', 'exercise', 'Electronic structure of atoms', activity_counter + 2),
    (chemistry_course_id, unit_2_id, 'Quantum numbers', 'video', 'Electronic structure of atoms', activity_counter + 3),
    (chemistry_course_id, unit_2_id, 'Electron configurations', 'video', 'Electronic structure of atoms', activity_counter + 4),
    (chemistry_course_id, unit_2_id, 'Understand: electron configurations', 'exercise', 'Electronic structure of atoms', activity_counter + 5),
    (chemistry_course_id, unit_2_id, 'Apply: electron configurations', 'exercise', 'Electronic structure of atoms', activity_counter + 6);
    activity_counter := activity_counter + 7;
    
    -- Quiz 1: More about atoms
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_2_id, 'Quiz 1: More about atoms', 'quiz', 'Quiz 1: More about atoms', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 2: Periodic table (6 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_2_id, 'Introduction to the periodic table', 'video', 'Periodic table', activity_counter),
    (chemistry_course_id, unit_2_id, 'Understand: periodic table', 'exercise', 'Periodic table', activity_counter + 1),
    (chemistry_course_id, unit_2_id, 'Apply: periodic table', 'exercise', 'Periodic table', activity_counter + 2),
    (chemistry_course_id, unit_2_id, 'Periodic trends', 'video', 'Periodic table', activity_counter + 3),
    (chemistry_course_id, unit_2_id, 'Understand: periodic trends', 'exercise', 'Periodic table', activity_counter + 4),
    (chemistry_course_id, unit_2_id, 'Apply: periodic trends', 'exercise', 'Periodic table', activity_counter + 5);
    activity_counter := activity_counter + 6;
    
    -- Unit Test: More about atoms
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_2_id, 'Unit Test: More about atoms', 'unit_test', 'Unit Test: More about atoms', activity_counter);
    activity_counter := activity_counter + 1;

    -- =============================================================================
    -- UNIT 3: MORE ABOUT MOLECULAR COMPOSITION (18 activities)
    -- =============================================================================
    
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    -- Lesson 1: Chemical bonds (7 activities)
    (chemistry_course_id, unit_3_id, 'Types of chemical bonds', 'video', 'Chemical bonds', activity_counter),
    (chemistry_course_id, unit_3_id, 'Understand: chemical bonds', 'exercise', 'Chemical bonds', activity_counter + 1),
    (chemistry_course_id, unit_3_id, 'Apply: chemical bonds', 'exercise', 'Chemical bonds', activity_counter + 2),
    (chemistry_course_id, unit_3_id, 'Reasonable Lewis dot structures', 'video', 'Chemical bonds', activity_counter + 3),
    (chemistry_course_id, unit_3_id, 'Understand: Lewis dot structures', 'exercise', 'Chemical bonds', activity_counter + 4),
    (chemistry_course_id, unit_3_id, 'Apply: Lewis dot structures', 'exercise', 'Chemical bonds', activity_counter + 5),
    (chemistry_course_id, unit_3_id, 'Formal charge and Lewis structures', 'video', 'Chemical bonds', activity_counter + 6);
    activity_counter := activity_counter + 7;
    
    -- Quiz 1: More about molecular composition
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_3_id, 'Quiz 1: More about molecular composition', 'quiz', 'Quiz 1: More about molecular composition', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 2: Molecular structure and properties (5 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_3_id, 'Molecular geometry', 'video', 'Molecular structure and properties', activity_counter),
    (chemistry_course_id, unit_3_id, 'Understand: molecular structure and properties', 'exercise', 'Molecular structure and properties', activity_counter + 1),
    (chemistry_course_id, unit_3_id, 'Apply: molecular structure and properties', 'exercise', 'Molecular structure and properties', activity_counter + 2),
    (chemistry_course_id, unit_3_id, 'Hybridization and hybrid orbitals', 'video', 'Molecular structure and properties', activity_counter + 3),
    (chemistry_course_id, unit_3_id, 'Activity: What shape is water?', 'article', 'Molecular structure and properties', activity_counter + 4);
    activity_counter := activity_counter + 5;
    
    -- Quiz 2: More about molecular composition
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_3_id, 'Quiz 2: More about molecular composition', 'quiz', 'Quiz 2: More about molecular composition', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 3: Mass spectrometry (3 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_3_id, 'Mass spectrometry', 'video', 'Mass spectrometry', activity_counter),
    (chemistry_course_id, unit_3_id, 'Understand: mass spectrometry', 'exercise', 'Mass spectrometry', activity_counter + 1),
    (chemistry_course_id, unit_3_id, 'Apply: mass spectrometry', 'exercise', 'Mass spectrometry', activity_counter + 2);
    activity_counter := activity_counter + 3;
    
    -- Unit Test: More about molecular composition
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_3_id, 'Unit Test: More about molecular composition', 'unit_test', 'Unit Test: More about molecular composition', activity_counter);
    activity_counter := activity_counter + 1;

    -- =============================================================================
    -- UNIT 4: CHEMICAL REACTIONS (22 activities)
    -- =============================================================================
    
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    -- Lesson 1: Representing chemical reactions (5 activities)
    (chemistry_course_id, unit_4_id, 'Introduction to balancing chemical equations', 'video', 'Representing chemical reactions', activity_counter),
    (chemistry_course_id, unit_4_id, 'Understand: representing chemical reactions', 'exercise', 'Representing chemical reactions', activity_counter + 1),
    (chemistry_course_id, unit_4_id, 'Apply: representing chemical reactions', 'exercise', 'Representing chemical reactions', activity_counter + 2),
    (chemistry_course_id, unit_4_id, 'Worked example: Balancing a chemical equation', 'video', 'Representing chemical reactions', activity_counter + 3),
    (chemistry_course_id, unit_4_id, 'Balancing equations', 'article', 'Representing chemical reactions', activity_counter + 4);
    activity_counter := activity_counter + 5;
    
    -- Lesson 2: Balancing chemical equations (5 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_4_id, 'Balancing chemical equations', 'video', 'Balancing chemical equations', activity_counter),
    (chemistry_course_id, unit_4_id, 'Understand: balancing chemical equations', 'exercise', 'Balancing chemical equations', activity_counter + 1),
    (chemistry_course_id, unit_4_id, 'Apply: balancing chemical equations', 'exercise', 'Balancing chemical equations', activity_counter + 2),
    (chemistry_course_id, unit_4_id, 'Worked example: Balancing a more complex chemical equation', 'video', 'Balancing chemical equations', activity_counter + 3),
    (chemistry_course_id, unit_4_id, 'Worked example: Using chemical equations to solve stoichiometry problems', 'video', 'Balancing chemical equations', activity_counter + 4);
    activity_counter := activity_counter + 5;
    
    -- Quiz 1: Chemical reactions
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_4_id, 'Quiz 1: Chemical reactions', 'quiz', 'Quiz 1: Chemical reactions', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 3: Activity lesson (1 activity)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_4_id, 'Activity: Why do we cook food?', 'article', 'Activity lesson', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 4: Energy of chemical reactions (3 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_4_id, 'Bond energy and enthalpy change', 'video', 'Energy of chemical reactions', activity_counter),
    (chemistry_course_id, unit_4_id, 'Understand: energy of chemical reactions', 'exercise', 'Energy of chemical reactions', activity_counter + 1),
    (chemistry_course_id, unit_4_id, 'Apply: energy of chemical reactions', 'exercise', 'Energy of chemical reactions', activity_counter + 2);
    activity_counter := activity_counter + 3;
    
    -- Quiz 2: Chemical reactions
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_4_id, 'Quiz 2: Chemical reactions', 'quiz', 'Quiz 2: Chemical reactions', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 5: Types of chemical reactions (6 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_4_id, 'Combination and decomposition reaction', 'video', 'Types of chemical reactions', activity_counter),
    (chemistry_course_id, unit_4_id, 'Simple redox reactions', 'video', 'Types of chemical reactions', activity_counter + 1),
    (chemistry_course_id, unit_4_id, 'Apply: synthesis, decomposition, and combustion reactions', 'exercise', 'Types of chemical reactions', activity_counter + 2),
    (chemistry_course_id, unit_4_id, 'Single replacement reactions', 'video', 'Types of chemical reactions', activity_counter + 3),
    (chemistry_course_id, unit_4_id, 'Single replacement reactions', 'article', 'Types of chemical reactions', activity_counter + 4),
    (chemistry_course_id, unit_4_id, 'Apply: single replacement reactions', 'exercise', 'Types of chemical reactions', activity_counter + 5);
    activity_counter := activity_counter + 6;
    
    -- Unit Test: Chemical reactions
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_4_id, 'Unit Test: Chemical reactions', 'unit_test', 'Unit Test: Chemical reactions', activity_counter);
    activity_counter := activity_counter + 1;

    -- =============================================================================
    -- UNIT 5: STOICHIOMETRY AND THE MOLE (20 activities)
    -- =============================================================================
    
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    -- Lesson 1: Moles and molar mass (5 activities)
    (chemistry_course_id, unit_5_id, 'Scientific notation review', 'article', 'Moles and molar mass', activity_counter),
    (chemistry_course_id, unit_5_id, 'Apply: scientific notation', 'exercise', 'Moles and molar mass', activity_counter + 1),
    (chemistry_course_id, unit_5_id, 'Calculations using Avogadro''s number (part 1)', 'video', 'Moles and molar mass', activity_counter + 2),
    (chemistry_course_id, unit_5_id, 'Worked example: Calculating molar mass and number of moles', 'video', 'Moles and molar mass', activity_counter + 3),
    (chemistry_course_id, unit_5_id, 'Understand: moles and molar mass', 'exercise', 'Moles and molar mass', activity_counter + 4);
    activity_counter := activity_counter + 5;
    
    -- Lesson 2: Mole calculations (6 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_5_id, 'Empirical, molecular, and structural formulas', 'video', 'Mole calculations', activity_counter),
    (chemistry_course_id, unit_5_id, 'Worked example: Calculating mass percent', 'video', 'Mole calculations', activity_counter + 1),
    (chemistry_course_id, unit_5_id, 'Calculations using Avogadro''s number (part 2)', 'video', 'Mole calculations', activity_counter + 2),
    (chemistry_course_id, unit_5_id, 'Apply: mole calculations with elements', 'exercise', 'Mole calculations', activity_counter + 3),
    (chemistry_course_id, unit_5_id, 'Apply: calculating the molar mass of compounds', 'exercise', 'Mole calculations', activity_counter + 4),
    (chemistry_course_id, unit_5_id, 'Apply: mole calculations with compounds', 'exercise', 'Mole calculations', activity_counter + 5);
    activity_counter := activity_counter + 6;
    
    -- Quiz 1: Stoichiometry and the mole
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_5_id, 'Quiz 1: Stoichiometry and the mole', 'quiz', 'Quiz 1: Stoichiometry and the mole', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 3: Stoichiometry (7 activities)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_5_id, 'Stoichiometry: mole-to-mole and percent yield', 'video', 'Stoichiometry', activity_counter),
    (chemistry_course_id, unit_5_id, 'Stoichiometry', 'article', 'Stoichiometry', activity_counter + 1),
    (chemistry_course_id, unit_5_id, 'Apply: mole-to-mole stoichiometry', 'exercise', 'Stoichiometry', activity_counter + 2),
    (chemistry_course_id, unit_5_id, 'Stoichiometry: mass-to-mass and limiting reagent', 'video', 'Stoichiometry', activity_counter + 3),
    (chemistry_course_id, unit_5_id, 'Apply: mass-to-mass stoichiometry', 'exercise', 'Stoichiometry', activity_counter + 4),
    (chemistry_course_id, unit_5_id, 'Limiting reactant and reaction yields', 'article', 'Stoichiometry', activity_counter + 5),
    (chemistry_course_id, unit_5_id, 'Apply: limiting reactants', 'exercise', 'Stoichiometry', activity_counter + 6);
    activity_counter := activity_counter + 7;
    
    -- Quiz 2: Stoichiometry and the mole
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_5_id, 'Quiz 2: Stoichiometry and the mole', 'quiz', 'Quiz 2: Stoichiometry and the mole', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Lesson 4: Activity: How does the International Space Station produce enough oxygen to keep the astronauts alive? (1 activity)
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_5_id, 'Activity: How does the International Space Station produce enough oxygen to keep the astronauts alive?', 'article', 'Activity: How does the International Space Station produce enough oxygen to keep the astronauts alive?', activity_counter);
    activity_counter := activity_counter + 1;
    
    -- Unit Test: Stoichiometry and the mole
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_5_id, 'Unit Test: Stoichiometry and the mole', 'unit_test', 'Unit Test: Stoichiometry and the mole', activity_counter);
    activity_counter := activity_counter + 1;

    RAISE NOTICE 'Completed import of % activities across units 1-5', activity_counter - 1;

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
    AND u.unit_number BETWEEN 1 AND 5
GROUP BY u.unit_number, u.title, u.total_activities
ORDER BY u.unit_number;

-- Verify activity type distribution for units 1-5
SELECT 
    a.activity_type::text,
    COUNT(*) as count
FROM activities a
JOIN units u ON a.unit_id = u.id
JOIN courses c ON u.course_id = c.id
WHERE c.name = 'High School Chemistry' 
    AND u.unit_number BETWEEN 1 AND 5
GROUP BY a.activity_type::text
ORDER BY count DESC;

-- Total activity count for units 1-5
SELECT COUNT(*) as total_activities_units_1_5
FROM activities a
JOIN units u ON a.unit_id = u.id
JOIN courses c ON u.course_id = c.id
WHERE c.name = 'High School Chemistry' 
    AND u.unit_number BETWEEN 1 AND 5;