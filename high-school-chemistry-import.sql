-- High School Chemistry Import Script - FROM FORMATTED DATA
-- This script imports all units and activities for High School Chemistry
-- Based on high-school-chemistry.md (the corrected, cleaned data)

-- =============================================================================
-- HIGH SCHOOL CHEMISTRY - COMPLETE IMPORT
-- =============================================================================

DO $$
DECLARE
    chemistry_course_id UUID;
    unit_1_id UUID;
    unit_2_id UUID;
    unit_3_id UUID;
    unit_4_id UUID;
    unit_5_id UUID;
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

    -- Delete existing activities and units for this course
    DELETE FROM activities WHERE course_id = chemistry_course_id;
    DELETE FROM units WHERE course_id = chemistry_course_id;
    
    RAISE NOTICE 'Deleted existing units and activities for High School Chemistry';

    -- =============================================================================
    -- CREATE ALL UNITS (Based on formatted data structure)
    -- =============================================================================

    -- Create Unit 1: Atoms, isotopes, and ions
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (chemistry_course_id, 1, 'Atoms, isotopes, and ions', 17, TRUE, 1)
    RETURNING id INTO unit_1_id;

    -- Create Unit 2: Atomic models and periodicity
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (chemistry_course_id, 2, 'Atomic models and periodicity', 30, TRUE, 2)
    RETURNING id INTO unit_2_id;

    -- Create Unit 3: Chemical bonding
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (chemistry_course_id, 3, 'Chemical bonding', 24, TRUE, 3)
    RETURNING id INTO unit_3_id;

    -- Create Unit 4: Chemical reactions
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (chemistry_course_id, 4, 'Chemical reactions', 23, TRUE, 4)
    RETURNING id INTO unit_4_id;

    -- Create Unit 5: Stoichiometry and the mole
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (chemistry_course_id, 5, 'Stoichiometry and the mole', 22, TRUE, 5)
    RETURNING id INTO unit_5_id;

    -- Create Unit 6: States of matter
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (chemistry_course_id, 6, 'States of matter', 28, TRUE, 6)
    RETURNING id INTO unit_6_id;

    -- Create Unit 7: Thermochemistry
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (chemistry_course_id, 7, 'Thermochemistry', 11, TRUE, 7)
    RETURNING id INTO unit_7_id;

    -- Create Unit 8: Solutions, acids, and bases
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (chemistry_course_id, 8, 'Solutions, acids, and bases', 23, TRUE, 8)
    RETURNING id INTO unit_8_id;

    -- Create Unit 9: Reaction rates and equilibrium
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (chemistry_course_id, 9, 'Reaction rates and equilibrium', 15, TRUE, 9)
    RETURNING id INTO unit_9_id;

    -- Create Unit 10: Nuclear chemistry
    INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
    VALUES (chemistry_course_id, 10, 'Nuclear chemistry', 21, TRUE, 10)
    RETURNING id INTO unit_10_id;

    RAISE NOTICE 'Created all units for High School Chemistry';

    -- Reset activity counter
    activity_counter := 1;

    -- =============================================================================
    -- UNIT 1: ATOMS, ISOTOPES, AND IONS (17 activities)
    -- =============================================================================
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_1_id, 'Protons, neutrons, and electrons in atoms', 'video', 'Atomic structure', activity_counter),
    (chemistry_course_id, unit_1_id, 'Elements and atomic number', 'video', 'Atomic structure', activity_counter + 1),
    (chemistry_course_id, unit_1_id, 'Understand: atomic structure', 'exercise', 'Atomic structure', activity_counter + 2),
    (chemistry_course_id, unit_1_id, 'Apply: atomic structure', 'exercise', 'Atomic structure', activity_counter + 3),
    (chemistry_course_id, unit_1_id, 'Isotopes', 'video', 'Isotopes', activity_counter + 4),
    (chemistry_course_id, unit_1_id, 'Worked example: using the mass number equation', 'video', 'Isotopes', activity_counter + 5),
    (chemistry_course_id, unit_1_id, 'Average atomic mass', 'video', 'Isotopes', activity_counter + 6),
    (chemistry_course_id, unit_1_id, 'Understand: isotopes', 'exercise', 'Isotopes', activity_counter + 7),
    (chemistry_course_id, unit_1_id, 'Apply: isotopes', 'exercise', 'Isotopes', activity_counter + 8),
    (chemistry_course_id, unit_1_id, 'Apply: calculating average atomic mass', 'exercise', 'Isotopes', activity_counter + 9),
    (chemistry_course_id, unit_1_id, 'Introduction to ions', 'video', 'Ions', activity_counter + 10),
    (chemistry_course_id, unit_1_id, 'Worked example: calculating ion charge', 'video', 'Ions', activity_counter + 11),
    (chemistry_course_id, unit_1_id, 'Understand: ions', 'exercise', 'Ions', activity_counter + 12),
    (chemistry_course_id, unit_1_id, 'Apply: ions', 'exercise', 'Ions', activity_counter + 13),
    (chemistry_course_id, unit_1_id, 'Atoms, isotopes, and ions: Quiz 1', 'quiz', 'Quiz 1', activity_counter + 14),
    (chemistry_course_id, unit_1_id, 'Atoms, isotopes, and ions: Quiz 2', 'quiz', 'Quiz 2', activity_counter + 15),
    (chemistry_course_id, unit_1_id, 'Atoms, isotopes, and ions: Unit test', 'unit_test', 'Unit Test', activity_counter + 16);
    activity_counter := activity_counter + 17;

    -- =============================================================================
    -- UNIT 2: ATOMIC MODELS AND PERIODICITY (30 activities)
    -- =============================================================================
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_2_id, 'The Bohr model', 'article', 'The Bohr model and atomic spectra', activity_counter),
    (chemistry_course_id, unit_2_id, 'Understand: Bohr models', 'exercise', 'The Bohr model and atomic spectra', activity_counter + 1),
    (chemistry_course_id, unit_2_id, 'Apply: Bohr models', 'exercise', 'The Bohr model and atomic spectra', activity_counter + 2),
    (chemistry_course_id, unit_2_id, 'The electromagnetic spectrum', 'article', 'The Bohr model and atomic spectra', activity_counter + 3),
    (chemistry_course_id, unit_2_id, 'Apply: the electromagnetic spectrum', 'exercise', 'The Bohr model and atomic spectra', activity_counter + 4),
    (chemistry_course_id, unit_2_id, 'Atomic spectra', 'video', 'The Bohr model and atomic spectra', activity_counter + 5),
    (chemistry_course_id, unit_2_id, 'Absorption/emission lines', 'article', 'The Bohr model and atomic spectra', activity_counter + 6),
    (chemistry_course_id, unit_2_id, 'Apply: atomic spectra', 'exercise', 'The Bohr model and atomic spectra', activity_counter + 7),
    (chemistry_course_id, unit_2_id, 'Activity: What makes a neon sign glow?', 'article', 'Activity - What makes a neon sign glow?', activity_counter + 8),
    (chemistry_course_id, unit_2_id, 'Lewis diagrams for atoms and ions', 'video', 'Lewis diagrams', activity_counter + 9),
    (chemistry_course_id, unit_2_id, 'Apply: Lewis diagrams of atoms', 'exercise', 'Lewis diagrams', activity_counter + 10),
    (chemistry_course_id, unit_2_id, 'Apply: Lewis diagrams of ions', 'exercise', 'Lewis diagrams', activity_counter + 11),
    (chemistry_course_id, unit_2_id, 'Shells, subshells, and orbitals', 'video', 'The quantum model', activity_counter + 12),
    (chemistry_course_id, unit_2_id, 'Introduction to electron configurations', 'video', 'The quantum model', activity_counter + 13),
    (chemistry_course_id, unit_2_id, 'The Aufbau principle', 'video', 'The quantum model', activity_counter + 14),
    (chemistry_course_id, unit_2_id, 'Electron configurations of ions', 'video', 'The quantum model', activity_counter + 15),
    (chemistry_course_id, unit_2_id, 'Electron configurations with the periodic table', 'video', 'The quantum model', activity_counter + 16),
    (chemistry_course_id, unit_2_id, 'The periodic table, electron shells, and orbitals', 'article', 'The quantum model', activity_counter + 17),
    (chemistry_course_id, unit_2_id, 'Apply: electron configurations', 'exercise', 'The quantum model', activity_counter + 18),
    (chemistry_course_id, unit_2_id, 'Atomic models and periodicity: Quiz 1', 'quiz', 'Quiz 1', activity_counter + 19),
    (chemistry_course_id, unit_2_id, 'The periodic table', 'video', 'The periodic table', activity_counter + 20),
    (chemistry_course_id, unit_2_id, 'Determine valence electrons using the periodic table', 'article', 'The periodic table', activity_counter + 21),
    (chemistry_course_id, unit_2_id, 'Apply: number of valence electrons', 'exercise', 'The periodic table', activity_counter + 22),
    (chemistry_course_id, unit_2_id, 'Understand: structure of the periodic table', 'exercise', 'The periodic table', activity_counter + 23),
    (chemistry_course_id, unit_2_id, 'Atomic radii trends', 'video', 'Periodic trends', activity_counter + 24),
    (chemistry_course_id, unit_2_id, 'Apply: atomic radii trends', 'exercise', 'Periodic trends', activity_counter + 25),
    (chemistry_course_id, unit_2_id, 'Ionization energy trends', 'video', 'Periodic trends', activity_counter + 26),
    (chemistry_course_id, unit_2_id, 'Apply: ionization energy trends', 'exercise', 'Periodic trends', activity_counter + 27),
    (chemistry_course_id, unit_2_id, 'Atomic models and periodicity: Quiz 2', 'quiz', 'Quiz 2', activity_counter + 28),
    (chemistry_course_id, unit_2_id, 'Atomic models and periodicity: Unit test', 'unit_test', 'Unit Test', activity_counter + 29);
    activity_counter := activity_counter + 30;

    -- =============================================================================
    -- UNIT 3: CHEMICAL BONDING (24 activities)
    -- =============================================================================
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_3_id, 'Activity: What hidden trade-offs exist when we choose aluminum cans versus glass bottles for packaging?', 'article', 'Activity - Aluminum cans vs glass bottles', activity_counter),
    (chemistry_course_id, unit_3_id, 'Valence electrons and ionic compounds', 'video', 'Ionic bonds', activity_counter + 1),
    (chemistry_course_id, unit_3_id, 'Ionic bonds', 'video', 'Ionic bonds', activity_counter + 2),
    (chemistry_course_id, unit_3_id, 'Representing ionic solids using particulate models', 'video', 'Ionic bonds', activity_counter + 3),
    (chemistry_course_id, unit_3_id, 'Apply: predicting ion formation', 'exercise', 'Ionic bonds', activity_counter + 4),
    (chemistry_course_id, unit_3_id, 'Apply: ionic bonds and compounds', 'exercise', 'Ionic bonds', activity_counter + 5),
    (chemistry_course_id, unit_3_id, 'Naming ions and ionic compounds', 'video', 'Ionic nomenclature', activity_counter + 6),
    (chemistry_course_id, unit_3_id, 'Naming ions and ionic compounds', 'article', 'Ionic nomenclature', activity_counter + 7),
    (chemistry_course_id, unit_3_id, 'Naming ionic compound with polyvalent ion', 'video', 'Ionic nomenclature', activity_counter + 8),
    (chemistry_course_id, unit_3_id, 'Polyatomic ions', 'article', 'Ionic nomenclature', activity_counter + 9),
    (chemistry_course_id, unit_3_id, 'Apply: polyatomic ions', 'exercise', 'Ionic nomenclature', activity_counter + 10),
    (chemistry_course_id, unit_3_id, 'Apply: naming main group ionic compounds', 'exercise', 'Ionic nomenclature', activity_counter + 11),
    (chemistry_course_id, unit_3_id, 'Chemical bonding: Quiz 1', 'quiz', 'Quiz 1', activity_counter + 12),
    (chemistry_course_id, unit_3_id, 'Covalent bonds', 'video', 'Covalent bonds', activity_counter + 13),
    (chemistry_course_id, unit_3_id, 'Lewis diagrams for molecules', 'video', 'Covalent bonds', activity_counter + 14),
    (chemistry_course_id, unit_3_id, 'Molecules, salts, compounds, and chemicals: What''s the difference?', 'article', 'Covalent bonds', activity_counter + 15),
    (chemistry_course_id, unit_3_id, 'Understand: covalent bonds', 'exercise', 'Covalent bonds', activity_counter + 16),
    (chemistry_course_id, unit_3_id, 'Apply: predicting covalent bonds', 'exercise', 'Covalent bonds', activity_counter + 17),
    (chemistry_course_id, unit_3_id, 'Apply: covalent bonds and molecules', 'exercise', 'Covalent bonds', activity_counter + 18),
    (chemistry_course_id, unit_3_id, 'Metallic bonds', 'video', 'Metallic bonds', activity_counter + 19),
    (chemistry_course_id, unit_3_id, 'Predicting bond type (metals vs. nonmetals)', 'video', 'Metallic bonds', activity_counter + 20),
    (chemistry_course_id, unit_3_id, 'Apply: predicting bond type', 'exercise', 'Metallic bonds', activity_counter + 21),
    (chemistry_course_id, unit_3_id, 'Chemical bonding: Quiz 2', 'quiz', 'Quiz 2', activity_counter + 22),
    (chemistry_course_id, unit_3_id, 'Chemical bonding: Unit test', 'unit_test', 'Unit Test', activity_counter + 23);
    activity_counter := activity_counter + 24;

    -- =============================================================================
    -- UNIT 4: CHEMICAL REACTIONS (23 activities)
    -- =============================================================================
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_4_id, 'Physical and chemical changes', 'video', 'Representing chemical reactions', activity_counter),
    (chemistry_course_id, unit_4_id, 'Intro to chemical reactions', 'video', 'Representing chemical reactions', activity_counter + 1),
    (chemistry_course_id, unit_4_id, 'Symbols in chemical equations', 'article', 'Representing chemical reactions', activity_counter + 2),
    (chemistry_course_id, unit_4_id, 'Apply: representing chemical reactions', 'exercise', 'Representing chemical reactions', activity_counter + 3),
    (chemistry_course_id, unit_4_id, 'Apply: counting atoms in chemical equations', 'exercise', 'Representing chemical reactions', activity_counter + 4),
    (chemistry_course_id, unit_4_id, 'Balancing chemical equations', 'video', 'Balancing chemical equations', activity_counter + 5),
    (chemistry_course_id, unit_4_id, 'Balancing more complex chemical equations', 'video', 'Balancing chemical equations', activity_counter + 6),
    (chemistry_course_id, unit_4_id, 'Visually understanding balancing chemical equations', 'video', 'Balancing chemical equations', activity_counter + 7),
    (chemistry_course_id, unit_4_id, 'Balancing another combustion reaction', 'video', 'Balancing chemical equations', activity_counter + 8),
    (chemistry_course_id, unit_4_id, 'Apply: balancing equations', 'exercise', 'Balancing chemical equations', activity_counter + 9),
    (chemistry_course_id, unit_4_id, 'Activity: How can a big log turn into a tiny pile of ash when it burns?', 'article', 'Activity - How can a big log turn into a tiny pile of ash?', activity_counter + 10),
    (chemistry_course_id, unit_4_id, 'Chemical reactions: Quiz 1', 'quiz', 'Quiz 1', activity_counter + 11),
    (chemistry_course_id, unit_4_id, 'Endothermic and exothermic reactions', 'video', 'Energy of chemical reactions', activity_counter + 12),
    (chemistry_course_id, unit_4_id, 'Understand: energy of chemical reactions', 'exercise', 'Energy of chemical reactions', activity_counter + 13),
    (chemistry_course_id, unit_4_id, 'Apply: energy of chemical reactions', 'exercise', 'Energy of chemical reactions', activity_counter + 14),
    (chemistry_course_id, unit_4_id, 'Chemical reactions: Quiz 2', 'quiz', 'Quiz 2', activity_counter + 15),
    (chemistry_course_id, unit_4_id, 'Combination and decomposition reaction', 'video', 'Types of chemical reactions', activity_counter + 16),
    (chemistry_course_id, unit_4_id, 'Simple redox reactions', 'video', 'Types of chemical reactions', activity_counter + 17),
    (chemistry_course_id, unit_4_id, 'Apply: synthesis, decomposition, and combustion reactions', 'exercise', 'Types of chemical reactions', activity_counter + 18),
    (chemistry_course_id, unit_4_id, 'Single replacement reactions', 'video', 'Types of chemical reactions', activity_counter + 19),
    (chemistry_course_id, unit_4_id, 'Single replacement reactions', 'article', 'Types of chemical reactions', activity_counter + 20),
    (chemistry_course_id, unit_4_id, 'Apply: single replacement reactions', 'exercise', 'Types of chemical reactions', activity_counter + 21),
    (chemistry_course_id, unit_4_id, 'Chemical reactions: Unit test', 'unit_test', 'Unit Test', activity_counter + 22);
    activity_counter := activity_counter + 23;

    -- =============================================================================
    -- UNIT 5: STOICHIOMETRY AND THE MOLE (22 activities)
    -- =============================================================================
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_5_id, 'Scientific notation review', 'article', 'Moles and molar mass', activity_counter),
    (chemistry_course_id, unit_5_id, 'Apply: scientific notation', 'exercise', 'Moles and molar mass', activity_counter + 1),
    (chemistry_course_id, unit_5_id, 'Calculations using Avogadro''s number (part 1)', 'video', 'Moles and molar mass', activity_counter + 2),
    (chemistry_course_id, unit_5_id, 'Worked example: Calculating molar mass and number of moles', 'video', 'Moles and molar mass', activity_counter + 3),
    (chemistry_course_id, unit_5_id, 'Understand: moles and molar mass', 'exercise', 'Moles and molar mass', activity_counter + 4),
    (chemistry_course_id, unit_5_id, 'Empirical, molecular, and structural formulas', 'video', 'Mole calculations', activity_counter + 5),
    (chemistry_course_id, unit_5_id, 'Worked example: Calculating mass percent', 'video', 'Mole calculations', activity_counter + 6),
    (chemistry_course_id, unit_5_id, 'Calculations using Avogadro''s number (part 2)', 'video', 'Mole calculations', activity_counter + 7),
    (chemistry_course_id, unit_5_id, 'Apply: mole calculations with elements', 'exercise', 'Mole calculations', activity_counter + 8),
    (chemistry_course_id, unit_5_id, 'Apply: calculating the molar mass of compounds', 'exercise', 'Mole calculations', activity_counter + 9),
    (chemistry_course_id, unit_5_id, 'Apply: mole calculations with compounds', 'exercise', 'Mole calculations', activity_counter + 10),
    (chemistry_course_id, unit_5_id, 'Stoichiometry and the mole: Quiz 1', 'quiz', 'Quiz 1', activity_counter + 11),
    (chemistry_course_id, unit_5_id, 'Stoichiometry: mole-to-mole and percent yield', 'video', 'Stoichiometry', activity_counter + 12),
    (chemistry_course_id, unit_5_id, 'Stoichiometry', 'article', 'Stoichiometry', activity_counter + 13),
    (chemistry_course_id, unit_5_id, 'Apply: mole-to-mole stoichiometry', 'exercise', 'Stoichiometry', activity_counter + 14),
    (chemistry_course_id, unit_5_id, 'Stoichiometry: mass-to-mass and limiting reagent', 'video', 'Stoichiometry', activity_counter + 15),
    (chemistry_course_id, unit_5_id, 'Apply: mass-to-mass stoichiometry', 'exercise', 'Stoichiometry', activity_counter + 16),
    (chemistry_course_id, unit_5_id, 'Limiting reactant and reaction yields', 'article', 'Stoichiometry', activity_counter + 17),
    (chemistry_course_id, unit_5_id, 'Apply: limiting reactants', 'exercise', 'Stoichiometry', activity_counter + 18),
    (chemistry_course_id, unit_5_id, 'Stoichiometry and the mole: Quiz 2', 'quiz', 'Quiz 2', activity_counter + 19),
    (chemistry_course_id, unit_5_id, 'Activity: How does the International Space Station produce enough oxygen to keep the astronauts alive?', 'article', 'Activity - International Space Station oxygen', activity_counter + 20),
    (chemistry_course_id, unit_5_id, 'Stoichiometry and the mole: Unit test', 'unit_test', 'Unit Test', activity_counter + 21);
    activity_counter := activity_counter + 22;

    -- =============================================================================
    -- UNIT 6: STATES OF MATTER (28 activities)
    -- =============================================================================
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_6_id, 'Electronegativity', 'video', 'Electronegativity and bond polarity', activity_counter),
    (chemistry_course_id, unit_6_id, 'Predicting bond type (electronegativity)', 'video', 'Electronegativity and bond polarity', activity_counter + 1),
    (chemistry_course_id, unit_6_id, 'Electronegativity and bond type', 'video', 'Electronegativity and bond polarity', activity_counter + 2),
    (chemistry_course_id, unit_6_id, 'Understand: electronegativity and bond polarity', 'exercise', 'Electronegativity and bond polarity', activity_counter + 3),
    (chemistry_course_id, unit_6_id, 'Apply: electronegativity and bond polarity', 'exercise', 'Electronegativity and bond polarity', activity_counter + 4),
    (chemistry_course_id, unit_6_id, 'Molecular geometry (VSEPR theory)', 'video', 'Electronegativity and bond polarity', activity_counter + 5),
    (chemistry_course_id, unit_6_id, 'Molecular polarity', 'video', 'Electronegativity and bond polarity', activity_counter + 6),
    (chemistry_course_id, unit_6_id, 'Apply: shapes of molecules', 'exercise', 'Electronegativity and bond polarity', activity_counter + 7),
    (chemistry_course_id, unit_6_id, 'States of matter: Quiz 1', 'quiz', 'Quiz 1', activity_counter + 8),
    (chemistry_course_id, unit_6_id, 'London dispersion forces introduction', 'video', 'Intermolecular forces', activity_counter + 9),
    (chemistry_course_id, unit_6_id, 'Dipole–dipole forces', 'video', 'Intermolecular forces', activity_counter + 10),
    (chemistry_course_id, unit_6_id, 'Hydrogen bonding', 'video', 'Intermolecular forces', activity_counter + 11),
    (chemistry_course_id, unit_6_id, 'Understand: intermolecular forces', 'exercise', 'Intermolecular forces', activity_counter + 12),
    (chemistry_course_id, unit_6_id, 'Apply: intermolecular forces', 'exercise', 'Intermolecular forces', activity_counter + 13),
    (chemistry_course_id, unit_6_id, 'Activity: How does water form droplets on surfaces?', 'article', 'Activity - Water droplets', activity_counter + 14),
    (chemistry_course_id, unit_6_id, 'Intermolecular forces and vapor pressure', 'video', 'Liquids and solids', activity_counter + 15),
    (chemistry_course_id, unit_6_id, 'Apply: properties of liquids', 'exercise', 'Liquids and solids', activity_counter + 16),
    (chemistry_course_id, unit_6_id, 'Apply: properties of solids', 'exercise', 'Liquids and solids', activity_counter + 17),
    (chemistry_course_id, unit_6_id, 'States of matter: Quiz 2', 'quiz', 'Quiz 2', activity_counter + 18),
    (chemistry_course_id, unit_6_id, 'The kinetic molecular theory of gases', 'video', 'Gases', activity_counter + 19),
    (chemistry_course_id, unit_6_id, 'Kinetic molecular theory and the gas laws', 'video', 'Gases', activity_counter + 20),
    (chemistry_course_id, unit_6_id, 'Understand: kinetic molecular theory', 'exercise', 'Gases', activity_counter + 21),
    (chemistry_course_id, unit_6_id, 'Apply: properties of gases', 'exercise', 'Gases', activity_counter + 22),
    (chemistry_course_id, unit_6_id, 'Worked example: Using the ideal gas law to calculate a change in volume', 'video', 'Gases', activity_counter + 23),
    (chemistry_course_id, unit_6_id, 'Gas mixtures and partial pressures', 'video', 'Gases', activity_counter + 24),
    (chemistry_course_id, unit_6_id, 'Apply: gas law calculations', 'exercise', 'Gases', activity_counter + 25),
    (chemistry_course_id, unit_6_id, 'States of matter: Quiz 3', 'quiz', 'Quiz 3', activity_counter + 26),
    (chemistry_course_id, unit_6_id, 'States of matter: Unit test', 'unit_test', 'Unit Test', activity_counter + 27);
    activity_counter := activity_counter + 28;

    -- =============================================================================
    -- UNIT 7: THERMOCHEMISTRY (11 activities)
    -- =============================================================================
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_7_id, 'Thermal energy, temperature, and heat', 'video', 'Thermal energy and equilibrium', activity_counter),
    (chemistry_course_id, unit_7_id, 'First and second laws of thermodynamics', 'video', 'Thermal energy and equilibrium', activity_counter + 1),
    (chemistry_course_id, unit_7_id, 'Understand: thermal energy and equilibrium', 'exercise', 'Thermal energy and equilibrium', activity_counter + 2),
    (chemistry_course_id, unit_7_id, 'Apply: thermal energy and equilibrium', 'exercise', 'Thermal energy and equilibrium', activity_counter + 3),
    (chemistry_course_id, unit_7_id, 'Thermochemistry: Quiz 1', 'quiz', 'Quiz 1', activity_counter + 4),
    (chemistry_course_id, unit_7_id, 'Specific heat capacity', 'video', 'Specific heat capacity', activity_counter + 5),
    (chemistry_course_id, unit_7_id, 'Apply: specific heat capacity', 'exercise', 'Specific heat capacity', activity_counter + 6),
    (chemistry_course_id, unit_7_id, 'Activity: Why does sand at the beach feel hot, even when the water feels cool?', 'article', 'Activity - Sand vs water temperature', activity_counter + 7),
    (chemistry_course_id, unit_7_id, 'Constant-pressure calorimetry', 'video', 'Calorimetry', activity_counter + 8),
    (chemistry_course_id, unit_7_id, 'Apply: calorimetry', 'exercise', 'Calorimetry', activity_counter + 9),
    (chemistry_course_id, unit_7_id, 'Thermochemistry: Unit test', 'unit_test', 'Unit Test', activity_counter + 10);
    activity_counter := activity_counter + 11;

    -- =============================================================================
    -- UNIT 8: SOLUTIONS, ACIDS, AND BASES (23 activities)
    -- =============================================================================
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_8_id, 'Aqueous solutions', 'video', 'Aqueous solutions', activity_counter),
    (chemistry_course_id, unit_8_id, 'Understand: aqueous solutions', 'exercise', 'Aqueous solutions', activity_counter + 1),
    (chemistry_course_id, unit_8_id, 'Solubility and intermolecular forces', 'video', 'Solubility', activity_counter + 2),
    (chemistry_course_id, unit_8_id, 'Apply: solubility', 'exercise', 'Solubility', activity_counter + 3),
    (chemistry_course_id, unit_8_id, 'Double replacement reactions', 'video', 'Solubility', activity_counter + 4),
    (chemistry_course_id, unit_8_id, 'Double replacement reactions', 'article', 'Solubility', activity_counter + 5),
    (chemistry_course_id, unit_8_id, 'Apply: solubility rules', 'exercise', 'Solubility', activity_counter + 6),
    (chemistry_course_id, unit_8_id, 'Apply: double replacement reactions', 'exercise', 'Solubility', activity_counter + 7),
    (chemistry_course_id, unit_8_id, 'Activity: How can solubility principles help us detect and eliminate chemical contaminants in our water supply?', 'article', 'Activity - Water contaminants', activity_counter + 8),
    (chemistry_course_id, unit_8_id, 'Molarity', 'video', 'Molarity', activity_counter + 9),
    (chemistry_course_id, unit_8_id, 'Dilutions', 'video', 'Molarity', activity_counter + 10),
    (chemistry_course_id, unit_8_id, 'Understand: molarity', 'exercise', 'Molarity', activity_counter + 11),
    (chemistry_course_id, unit_8_id, 'Apply: molarity', 'exercise', 'Molarity', activity_counter + 12),
    (chemistry_course_id, unit_8_id, 'Solutions, acids, and bases: Quiz 1', 'quiz', 'Quiz 1', activity_counter + 13),
    (chemistry_course_id, unit_8_id, 'Intro to acids and bases', 'video', 'Intro to acids and bases', activity_counter + 14),
    (chemistry_course_id, unit_8_id, 'Understand: intro to acids and bases', 'exercise', 'Intro to acids and bases', activity_counter + 15),
    (chemistry_course_id, unit_8_id, 'Apply: intro to acids and bases', 'exercise', 'Intro to acids and bases', activity_counter + 16),
    (chemistry_course_id, unit_8_id, 'Naming acids and bases', 'article', 'Intro to acids and bases', activity_counter + 17),
    (chemistry_course_id, unit_8_id, 'Apply: naming acids and bases', 'exercise', 'Intro to acids and bases', activity_counter + 18),
    (chemistry_course_id, unit_8_id, 'Introduction to pH', 'video', 'Intro to acids and bases', activity_counter + 19),
    (chemistry_course_id, unit_8_id, 'Apply: the pH scale', 'exercise', 'Intro to acids and bases', activity_counter + 20),
    (chemistry_course_id, unit_8_id, 'Solutions, acids, and bases: Quiz 2', 'quiz', 'Quiz 2', activity_counter + 21),
    (chemistry_course_id, unit_8_id, 'Solutions, acids, and bases: Unit test', 'unit_test', 'Unit Test', activity_counter + 22);
    activity_counter := activity_counter + 23;

    -- =============================================================================
    -- UNIT 9: REACTION RATES AND EQUILIBRIUM (15 activities)
    -- =============================================================================
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_9_id, 'Collision theory', 'video', 'Reaction rates', activity_counter),
    (chemistry_course_id, unit_9_id, 'Understand: collision theory', 'exercise', 'Reaction rates', activity_counter + 1),
    (chemistry_course_id, unit_9_id, 'Factors affecting reaction rates', 'video', 'Reaction rates', activity_counter + 2),
    (chemistry_course_id, unit_9_id, 'Understand: factors affecting reaction rates', 'exercise', 'Reaction rates', activity_counter + 3),
    (chemistry_course_id, unit_9_id, 'Apply: factors affecting reaction rates', 'exercise', 'Reaction rates', activity_counter + 4),
    (chemistry_course_id, unit_9_id, 'Activity: Why does food in a refrigerator stay fresh for longer?', 'article', 'Activity - Food refrigeration', activity_counter + 5),
    (chemistry_course_id, unit_9_id, 'Reaction rates and equilibrium: Quiz 1', 'quiz', 'Quiz 1', activity_counter + 6),
    (chemistry_course_id, unit_9_id, 'Catalysts', 'video', 'Catalysts', activity_counter + 7),
    (chemistry_course_id, unit_9_id, 'Understand: catalysts', 'exercise', 'Catalysts', activity_counter + 8),
    (chemistry_course_id, unit_9_id, 'Reversible reactions and equilibrium', 'video', 'Equilibrium & Le Châtelier''s principle', activity_counter + 9),
    (chemistry_course_id, unit_9_id, 'Le Châtelier''s principle', 'video', 'Equilibrium & Le Châtelier''s principle', activity_counter + 10),
    (chemistry_course_id, unit_9_id, 'Understand: equilibrium and Le Châtelier''s principle', 'exercise', 'Equilibrium & Le Châtelier''s principle', activity_counter + 11),
    (chemistry_course_id, unit_9_id, 'Apply: Le Châtelier''s principle', 'exercise', 'Equilibrium & Le Châtelier''s principle', activity_counter + 12),
    (chemistry_course_id, unit_9_id, 'Reaction rates and equilibrium: Quiz 2', 'quiz', 'Quiz 2', activity_counter + 13),
    (chemistry_course_id, unit_9_id, 'Reaction rates and equilibrium: Unit test', 'unit_test', 'Unit Test', activity_counter + 14);
    activity_counter := activity_counter + 15;

    -- =============================================================================
    -- UNIT 10: NUCLEAR CHEMISTRY (21 activities)
    -- =============================================================================
    INSERT INTO activities (course_id, unit_id, activity_name, activity_type, lesson_name, order_index) VALUES
    (chemistry_course_id, unit_10_id, 'Intro to radioactive decay', 'video', 'Radioactive decay', activity_counter),
    (chemistry_course_id, unit_10_id, 'Alpha decay', 'video', 'Radioactive decay', activity_counter + 1),
    (chemistry_course_id, unit_10_id, 'Apply: alpha decay', 'exercise', 'Radioactive decay', activity_counter + 2),
    (chemistry_course_id, unit_10_id, 'Beta decay', 'video', 'Radioactive decay', activity_counter + 3),
    (chemistry_course_id, unit_10_id, 'Apply: beta decay', 'exercise', 'Radioactive decay', activity_counter + 4),
    (chemistry_course_id, unit_10_id, 'Gamma decay', 'video', 'Radioactive decay', activity_counter + 5),
    (chemistry_course_id, unit_10_id, 'Understand: radioactive decay', 'exercise', 'Radioactive decay', activity_counter + 6),
    (chemistry_course_id, unit_10_id, 'Apply: alpha, beta, and gamma decay', 'exercise', 'Radioactive decay', activity_counter + 7),
    (chemistry_course_id, unit_10_id, 'Nuclear chemistry: Quiz 1', 'quiz', 'Quiz 1', activity_counter + 8),
    (chemistry_course_id, unit_10_id, 'Half-life', 'video', 'Half-life and radiometric dating', activity_counter + 9),
    (chemistry_course_id, unit_10_id, 'Understand: half-life and radiometric dating', 'exercise', 'Half-life and radiometric dating', activity_counter + 10),
    (chemistry_course_id, unit_10_id, 'Apply: half-life and radiometric dating', 'exercise', 'Half-life and radiometric dating', activity_counter + 11),
    (chemistry_course_id, unit_10_id, 'Activity: How do we know when dinosaurs lived on Earth?', 'article', 'Activity - Dinosaur dating', activity_counter + 12),
    (chemistry_course_id, unit_10_id, 'Nuclear chemistry: Quiz 2', 'quiz', 'Quiz 2', activity_counter + 13),
    (chemistry_course_id, unit_10_id, 'Nuclear fusion', 'video', 'Nuclear fusion', activity_counter + 14),
    (chemistry_course_id, unit_10_id, 'Understand: nuclear fusion', 'exercise', 'Nuclear fusion', activity_counter + 15),
    (chemistry_course_id, unit_10_id, 'Nuclear fission', 'video', 'Nuclear fission', activity_counter + 16),
    (chemistry_course_id, unit_10_id, 'Understand: nuclear fission', 'exercise', 'Nuclear fission', activity_counter + 17),
    (chemistry_course_id, unit_10_id, 'Apply: nuclear fission', 'exercise', 'Nuclear fission', activity_counter + 18),
    (chemistry_course_id, unit_10_id, 'Nuclear chemistry: Quiz 3', 'quiz', 'Quiz 3', activity_counter + 19),
    (chemistry_course_id, unit_10_id, 'Nuclear chemistry: Unit test', 'unit_test', 'Unit Test', activity_counter + 20);
    activity_counter := activity_counter + 21;

    RAISE NOTICE 'Created all units and activities for High School Chemistry';

END $$;