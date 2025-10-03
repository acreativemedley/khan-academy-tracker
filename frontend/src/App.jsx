import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { ThemeProvider, createTheme } from '@mui/material/styles'
import CssBaseline from '@mui/material/CssBaseline'
import { Container, Typography, Box } from '@mui/material'
import StudentDashboard from './components/StudentDashboard'
import CourseDetail from './components/CourseDetail'
import ProgressCharts from './components/ProgressCharts'
import TargetDateSettings from './components/TargetDateSettings'
import Navigation from './components/Navigation'
import StudentAccountCreator from './components/StudentAccountCreator'
import TestStudentProfile from './components/TestStudentProfile'
import AuthWrapper from './components/AuthWrapper'

// Create Material-UI theme
const theme = createTheme({
  palette: {
    mode: 'light',
    primary: {
      main: '#1976d2',
    },
    secondary: {
      main: '#dc004e',
    },
  },
})

function App() {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <AuthWrapper>
        <Router>
          <Navigation />
          <Container maxWidth="lg">
            <Routes>
              <Route path="/" element={<StudentDashboard />} />
              <Route path="/courses/:courseId" element={<CourseDetail />} />
              <Route path="/progress" element={<ProgressCharts />} />
              <Route path="/settings" element={<TargetDateSettings />} />
              <Route path="/test-student" element={<StudentAccountCreator />} />
              <Route path="/test-profile" element={<TestStudentProfile />} />
            </Routes>
          </Container>
        </Router>
      </AuthWrapper>
    </ThemeProvider>
  )
}

export default App
