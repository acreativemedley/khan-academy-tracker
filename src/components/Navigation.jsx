import React from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import {
  AppBar,
  Toolbar,
  Typography,
  Button,
  Box,
  Chip
} from '@mui/material';
import {
  Dashboard as DashboardIcon,
  TrendingUp as ProgressIcon,
  Settings as SettingsIcon,
  Storage as DatabaseIcon,
  Today as TodayIcon,
  BeachAccess as VacationIcon
} from '@mui/icons-material';

const Navigation = () => {
  const navigate = useNavigate();
  const location = useLocation();

  const navigationItems = [
    {
      label: 'Dashboard',
      path: '/',
      icon: <DashboardIcon />,
      description: 'Course overview and today\'s tasks'
    },
    {
      label: 'Schedule',
      path: '/schedule',
      icon: <TodayIcon />,
      description: 'Daily, weekly, and monthly schedule view'
    },
    {
      label: 'Vacations',
      path: '/vacations',
      icon: <VacationIcon />,
      description: 'Manage vacation periods and regenerate schedules'
    },
    {
      label: 'Progress',
      path: '/progress',
      icon: <ProgressIcon />,
      description: 'Analytics and progress charts'
    },
    {
      label: 'Settings',
      path: '/settings',
      icon: <SettingsIcon />,
      description: 'Set target dates and configure courses'
    },
    {
      label: 'Test Student',
      path: '/test-student',
      icon: <DatabaseIcon />,
      description: 'Create authenticated student account'
    },
    {
      label: 'Test Profile',
      path: '/test-profile',
      icon: <DatabaseIcon />,
      description: 'Test student profile and data connection'
    }
  ];

  const isActivePath = (path) => {
    if (path === '/' && location.pathname === '/') return true;
    if (path !== '/' && location.pathname.startsWith(path)) return true;
    return false;
  };

  return (
    <AppBar position="static" sx={{ mb: 2 }}>
      <Toolbar>
        <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
          Khan Academy Tracker
        </Typography>
        
        <Box sx={{ display: 'flex', gap: 1 }}>
          {navigationItems.map((item) => (
            <Button
              key={item.path}
              color="inherit"
              onClick={() => navigate(item.path)}
              startIcon={item.icon}
              variant={isActivePath(item.path) ? 'outlined' : 'text'}
              sx={{
                color: 'white',
                borderColor: isActivePath(item.path) ? 'white' : 'transparent',
                '&:hover': {
                  backgroundColor: 'rgba(255, 255, 255, 0.1)'
                }
              }}
            >
              {item.label}
            </Button>
          ))}
        </Box>
      </Toolbar>
    </AppBar>
  );
};

export default Navigation;