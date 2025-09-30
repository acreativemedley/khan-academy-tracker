-- Khan Academy Course Data Import
-- Execute this after creating the database schema

-- Insert the 4 courses we're tracking
INSERT INTO courses (name, description, khan_academy_url, total_activities, total_units, estimated_hours, status) VALUES
(
    'High School Chemistry',
    'Complete high school chemistry course covering atomic structure, chemical bonding, reactions, and more.',
    'https://www.khanacademy.org/science/chemistry',
    214,
    10,
    40,
    'not_started'
),
(
    'Integrated Math 3',
    'Advanced high school mathematics including polynomial arithmetic, trigonometry, and modeling.',
    'https://www.khanacademy.org/math/algebra2',
    363,
    16,
    60,
    'not_started'
),
(
    'World History',
    'Comprehensive world history from prehistoric times through the 20th century.',
    'https://www.khanacademy.org/humanities/world-history',
    372,
    6,
    60,
    'not_started'
),
(
    '10th Grade Reading and Vocabulary',
    'Reading comprehension and vocabulary building for 10th grade level.',
    'https://www.khanacademy.org/ela/reading-vocabulary',
    81,
    6,
    20,
    'not_started'
);

-- Note: You'll need to create detailed import scripts for units and activities
-- based on the markdown files we created. This can be done programmatically
-- or through a data import tool.

-- Example for High School Chemistry Unit 1:
-- INSERT INTO units (course_id, unit_number, title, total_activities, has_unit_test, order_index)
-- SELECT c.id, 1, 'Atoms, compounds, and ions', 21, TRUE, 1
-- FROM courses c WHERE c.name = 'High School Chemistry';

-- The activities would then be inserted referencing the unit_id
-- This process should be automated using the course data markdown files we created.