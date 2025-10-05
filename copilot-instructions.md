# Copilot Instructions

## General Guidelines
- Do not make assumptions. Review the codebase for any variables or naming conventions.
- Ask questions if you do not know the answer, do not assume what I want or guess.
- Do not add or remove features without asking me.
- If you see a feature that could be improved, ask me before making changes.
- Always provide context for any code changes or additions.
- Keep changes minimal and focused on the request.
- Do not suggest code that has been deleted.
- Do not include any new features or functionality unless explicitly requested.
- Always follow the existing coding style and conventions in the codebase.
- When referencing files, use the full path as shown in the file tree.
- When referencing code snippets, use the full code block format with language specified.
- Do not include any additional context or explanations outside of the code blocks.
- Always confirm the project context and requirements before making changes.
- If unsure about any aspect of the project, ask for clarification.
- Always prioritize accuracy and alignment with project goals over speed.
- Ensure all code is tested and functional before finalizing changes.
- Provide clear and concise commit messages for any changes made.
- Always back up existing code before making significant changes.
- If you encounter any issues or errors, ask for help rather than trying to fix it yourself.
- Always keep the project goals and requirements in mind when making changes.
- Do not make changes that could compromise the integrity or functionality of the project.
- Always ensure that any changes made are reversible and do not cause data loss.
- Always document any changes made to the codebase for future reference.
- Always ensure that any changes made are in line with best practices and industry standards.
- Always prioritize code readability and maintainability.
- Always ensure that any changes made are compatible with the existing codebase.
- Always ensure that any changes made are compatible with the project's technical environment.
- Always ensure that any changes made are compatible with the project's target audience and users.
- Always ensure that any changes made are compatible with the project's goals and objectives.
- Always ensure that any changes made are compatible with the project's timeline and deadlines.
- 
- Always ensure that any changes made are compatible with the project's budget and resources.


## Technical Environment
- **Operating System**: Windows
- **Shell**: PowerShell v5.1 (default shell)
- **Terminal Syntax**: Use proper PowerShell syntax in terminal commands
  - **CRITICAL**: NEVER use `&&` for command chaining - it causes errors in PowerShell
  - Use semicolon (`;`) for command chaining instead
  - Use separate commands when chaining fails
  - Example: `cd frontend; npm install` NOT `cd frontend && npm install`
  - If unsure, use separate terminal commands rather than chaining
  - Always commit to the main branch on GitHub.

## NPM Commands
- **IMPORTANT**: Always ensure you are in the `frontend` directory before running any npm commands
- **Start Development Server**: Use `cd frontend; npm run dev` to launch localhost
- Check current directory with `pwd` before running npm commands
- Use `cd frontend` if not already in the frontend directory
- React application is located in `/frontend` subdirectory

## Project Context
- This is a Khan Academy course tracking application
- Technology stack: React + Supabase + Netlify
- Project Target completion date: 10/3/2025 
- Courses completion target date: 5/30/3026
- 4 courses with 1,030 total activities across 33 unit tests
- **Timezone**: US Central (America/Chicago) - DO NOT use America/New_York
- **CRITICAL**: NO TIME TRACKING, NO TIME GOALS, NO DAILY GOAL MINUTES - This system tracks activity completion only, NOT time spent

## Database / SQL Guidelines
- **PostgreSQL string_agg Function**: ALWAYS cast columns to text when using string_agg
  - **CRITICAL ERROR TO AVOID**: `string_agg(column_name, ', ')` will fail
  - **CORRECT SYNTAX**: `string_agg(column_name::text, ', ')` 
  - This error occurs frequently when creating verification queries
  - Always use explicit type casting for enum columns like activity_type
- **Ambiguous Column References**: ALWAYS prefix column names with table aliases in JOINs
  - **CRITICAL ERROR TO AVOID**: `SELECT constraint_name FROM table1 t1 JOIN table2 t2` will fail with "column reference is ambiguous"
  - **CORRECT SYNTAX**: `SELECT t1.constraint_name FROM table1 t1 JOIN table2 t2`
  - This error occurs frequently when querying information_schema tables
  - Always use table prefixes (kcu.constraint_name, rc.constraint_name, etc.)
- **Information Schema Foreign Keys**: Use correct table joins and column names
  - **INCORRECT**: `kcu.referenced_table_name` (column does not exist)
  - **CORRECT**: Use `constraint_column_usage` table and proper JOINs for foreign key info
  - Use `table_constraints`, `key_column_usage`, and `constraint_column_usage` tables together
- **Supabase Platform**: Using PostgreSQL database hosted on Supabase
- **Clean Import Pattern**: When updating existing data, always DELETE existing records before INSERT
  - Delete activities first, then units, to respect foreign key constraints
  - Use course_id filtering to target specific courses for cleanup