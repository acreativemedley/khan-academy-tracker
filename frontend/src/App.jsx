import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { ThemeProvider, createTheme } from '@mui/material/styles'
import CssBaseline from '@mui/material/CssBaseline'
import { Container, Typography, Box } from '@mui/material'

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

// Placeholder components for routes
const Dashboard = () => (
  <Box sx={{ mt: 4 }}>
    <Typography variant="h4" component="h1" gutterBottom>
      Khan Academy Course Tracker
    </Typography>
    <Typography variant="body1">
      Welcome to your Khan Academy multi-course academic planner!
    </Typography>
    <Typography variant="body2" sx={{ mt: 2 }}>
      📚 Tracking 4 courses with 1,030 activities
    </Typography>
    <Typography variant="body2">
      🎯 Target completion: May 30, 2026
    </Typography>
  </Box>
)

const Courses = () => (
  <Box sx={{ mt: 4 }}>
    <Typography variant="h4" component="h1" gutterBottom>
      Courses
    </Typography>
    <Typography variant="body1">
      Course management will be implemented here.
    </Typography>
  </Box>
)

const Progress = () => (
  <Box sx={{ mt: 4 }}>
    <Typography variant="h4" component="h1" gutterBottom>
      Progress
    </Typography>
    <Typography variant="body1">
      Progress tracking will be implemented here.
    </Typography>
  </Box>
)

function App() {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <Router>
        <Container maxWidth="lg">
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/courses" element={<Courses />} />
            <Route path="/progress" element={<Progress />} />
          </Routes>
        </Container>
      </Router>
    </ThemeProvider>
  )
}

export default App
