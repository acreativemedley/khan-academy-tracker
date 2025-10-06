# Project Structure Update - October 5, 2025

## ✅ Correct File Structure

The Khan Academy Tracker project has the following structure:

### Active Development Location: `tracker/` (root)

```
tracker/
├── src/                          ← ACTIVE React application
│   ├── components/
│   │   ├── StudentAccountCreator.jsx
│   │   ├── StudentDashboard.jsx
│   │   ├── CourseDetail.jsx
│   │   ├── TargetDateSettings.jsx
│   │   └── ... (all other components)
│   ├── services/
│   │   └── supabase.js
│   ├── utils/
│   │   ├── dateUtils.js
│   │   └── testStudentUtils.js
│   ├── App.jsx
│   ├── main.jsx
│   └── index.css
├── public/
├── course-data/
├── package.json              ← Active package.json (React 19)
├── vite.config.js
├── index.html
└── ...

frontend/                     ← LEGACY - DO NOT USE
├── package.json             ← Old package.json (React 18)
├── test-student-creation.js
└── (no src folder)
```

---

## ⚠️ Important Notes

### Active Development
- **Source Code Location:** `tracker/src/`
- **Package Manager:** `tracker/package.json`
- **Dev Server Command:** `npm run dev` (from `tracker` directory)
- **React Version:** 19.1.1 (latest)

### Legacy/Unused
- **`frontend/` folder** - appears to be from an older project structure
- **DO NOT** develop in `frontend/`
- **DO NOT** run `npm` commands from `frontend/`

---

## Correct Development Commands

### Start Dev Server
```powershell
# From project root (tracker directory)
npm run dev
```

### Install Dependencies
```powershell
# From project root (tracker directory)
npm install
```

### Build for Production
```powershell
# From project root (tracker directory)
npm run build
```

---

## File Locations Reference

| Item | Location |
|------|----------|
| React Components | `tracker/src/components/` |
| Services (Supabase) | `tracker/src/services/` |
| Utilities | `tracker/src/utils/` |
| Main App | `tracker/src/App.jsx` |
| Course Data | `tracker/course-data/` |
| Documentation | `tracker/*.md` |
| Package Config | `tracker/package.json` |
| Vite Config | `tracker/vite.config.js` |

---

## ✅ Copilot Instructions Updated

The `copilot-instructions.md` file has been updated to reflect:
- Dev server runs from `tracker` root directory
- All source code is in `tracker/src/`
- `frontend/` folder is legacy and should not be used
- Examples updated to use correct paths

---

## Next Actions

1. **Stop** the dev server currently running from `frontend/`
2. **Restart** dev server from correct location (`tracker/`)
3. **Verify** application loads correctly at http://localhost:5173/
4. **Proceed** with Task 1 (Create Test Student)

---

**Date:** October 5, 2025  
**Status:** Structure documented and copilot instructions updated
