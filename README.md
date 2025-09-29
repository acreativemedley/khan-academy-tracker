# Khan Academy Multi-Course Academic Planner

A comprehensive React web application with Supabase backend to plan, schedule, and track progress across multiple Khan Academy courses with automated calendar generation and progress monitoring.

## 🎯 Project Overview

This application helps students and parents track progress across 4 Khan Academy courses simultaneously, with automated scheduling to meet target completion dates and comprehensive progress monitoring.

### Target Completion Date: May 30, 2026

## 📚 Tracked Courses

1. **High School Chemistry** - 214 activities (10 unit tests)
2. **Integrated Math 3** - 363 activities (13 unit tests)  
3. **World History** - 372 activities (6 unit tests)
4. **10th Grade Reading & Vocabulary** - 81 activities (4 unit tests)

**Total: 1,030 activities across 33 unit tests**

## 🚀 Key Features

### Core Functionality
- **Multi-Course Management**: Track 4 Khan Academy courses simultaneously
- **Automated Scheduling**: Generate daily study plans based on May 30, 2026 completion goal
- **Progress Tracking**: Monitor completion status across all courses
- **Calendar Integration**: Create daily assignments with special day handling
- **Dynamic Recalculation**: Adjust schedules based on progress and changes

### Special Scheduling
- **School Days**: Sunday, Monday, Thursday, Friday, Saturday (5 days/week)
- **Non-School Days**: Tuesday, Wednesday (no assignments)
- **Unit Exams**: Dedicated exam days with only unit test scheduled
- **Review Days**: Scheduled before each unit exam
- **Holiday Handling**: Configurable breaks for Thanksgiving, Christmas, New Year

### User Interfaces
- **Student Dashboard**: View daily assignments and track progress
- **Admin Dashboard**: Manage courses, generate schedules, monitor student progress

## 🛠️ Technology Stack

### Frontend
- **React 18+** - Core frontend framework
- **Vite** - Build tool for fast development
- **Material-UI or Tailwind CSS** - UI component library
- **Chart.js/Recharts** - Progress visualization
- **React Hook Form** - Form management

### Backend
- **Supabase** - Backend-as-a-Service
- **PostgreSQL** - Primary database with real-time capabilities
- **Supabase Auth** - Authentication system
- **Row Level Security** - Data protection

### Deployment
- **Netlify** - Frontend hosting with continuous deployment
- **GitHub Actions** - CI/CD pipeline

## 📊 Scheduling Calculations

- **Available School Days**: ~173 days (Sep 29, 2025 - May 30, 2026)
- **Regular Study Days**: ~107 days (after accounting for 33 exam days + 33 review days)
- **Daily Workload**: ~9.6 activities/day on regular study days
- **Estimated Study Time**: ~180+ hours total

## 🗂️ Project Structure

```
/
├── PROJECT_PLAN.md           # Comprehensive project documentation
├── course-data/              # Khan Academy course structures
│   ├── high-school-chemistry.md
│   ├── integrated-math-3.md
│   ├── world-history.md
│   └── 10th-grade-reading-vocabulary.md
├── src/                      # React application source (to be created)
├── docs/                     # Additional documentation
└── .github/                  # GitHub workflows and templates
```

## 🚦 Development Status

### ✅ Completed
- [x] Project planning and requirements analysis
- [x] Complete course data collection (4/5 courses)
- [x] Scheduling calculations and workload analysis
- [x] Technology stack selection and architecture design

### 🔄 In Progress
- [ ] Development environment setup
- [ ] Database schema design and implementation
- [ ] React application development

### 📋 Upcoming
- [ ] Authentication system implementation
- [ ] Core functionality development
- [ ] User interface creation
- [ ] Deployment and testing

## 🔮 Future Enhancements

### Student Support Features
- **Help Request System**: Students can flag assignments with "I need help"
- **Help queue management** for parents/administrators

### Parental Notifications
- **Daily completion alerts** when student finishes last assignment for each day
- **Behind schedule notifications** when student falls behind by configurable threshold

### Technical Improvements
- Khan Academy API integration for automatic progress sync
- Enhanced mobile responsiveness
- Offline mode with sync capabilities
- Progress report exports (PDF/Excel)

## 🏁 Getting Started

> **Note**: This project is currently in the setup phase. Development environment and application setup instructions will be added as the project progresses.

### Prerequisites
- Node.js 18+ 
- Git
- Supabase account
- Netlify account

### Initial Setup
1. Clone this repository
2. Follow setup instructions in PROJECT_PLAN.md
3. Configure environment variables
4. Run development server

## 📖 Documentation

- **[PROJECT_PLAN.md](PROJECT_PLAN.md)**: Comprehensive project plan with detailed requirements, architecture, and implementation phases
- **[course-data/](course-data/)**: Complete Khan Academy course structures with activity breakdowns

## 🤝 Contributing

This is a personal academic project. Please refer to the project plan for development guidelines and contribution standards.

## 📄 License

This project is for educational purposes. Khan Academy content and course structures are used for reference and scheduling only.

---

**Target Launch**: October 27, 2025  
**Full Deployment**: November 3, 2025