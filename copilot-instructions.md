# Copilot Instructions

## General Guidelines
- Do not make assumptions. Review the codebase for any variables or naming conventions.
- Ask questions if you do not know the answer, do not assume what I want or guess.
- Do not add or remove features without asking me.

## Technical Environment
- **Operating System**: Windows
- **Shell**: PowerShell v5.1 (default shell)
- **Terminal Syntax**: Use proper PowerShell syntax in terminal commands
  - Use semicolon (`;`) for command chaining, NOT `&&`
  - Use PowerShell-specific commands when needed
  - Example: `cd frontend; npm install` instead of `cd frontend && npm install`

## Project Context
- This is a Khan Academy course tracking application
- Technology stack: React + Supabase + Netlify
- Target completion date: May 30, 2026
- 4 courses with 1,030 total activities across 33 unit tests