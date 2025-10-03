import React, { useState, useEffect } from 'react';
import {
  Box,
  Card,
  CardContent,
  Typography,
  TextField,
  Button,
  Alert,
  CircularProgress,
  Paper,
  Container
} from '@mui/material';
import { supabase } from '../services/supabase';

const AuthWrapper = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [signInLoading, setSignInLoading] = useState(false);
  const [signInData, setSignInData] = useState({ 
    email: 'mommymack@gmail.com', 
    password: '' 
  });
  const [error, setError] = useState(null);
  const [showCreateAccount, setShowCreateAccount] = useState(false);

  useEffect(() => {
    checkUser();
    
    // Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange((event, session) => {
      if (session?.user) {
        setUser(session.user);
      } else {
        setUser(null);
      }
      setLoading(false);
    });

    return () => subscription.unsubscribe();
  }, []);

  const checkUser = async () => {
    try {
      const { data: { user }, error } = await supabase.auth.getUser();
      if (user && !error) {
        setUser(user);
      }
    } catch (err) {
      console.log('No active session');
    } finally {
      setLoading(false);
    }
  };

  const handleSignIn = async () => {
    if (!signInData.email || !signInData.password) {
      setError('Please enter both email and password');
      return;
    }

    setSignInLoading(true);
    setError(null);

    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email: signInData.email,
        password: signInData.password
      });

      if (error) {
        throw new Error(error.message);
      }

      if (data.user) {
        setUser(data.user);
        console.log('✅ Signed in successfully:', data.user.id);
      }
    } catch (err) {
      setError(`Sign-in failed: ${err.message}`);
      console.error('❌ Sign-in error:', err);
    } finally {
      setSignInLoading(false);
    }
  };

  const handleSignOut = async () => {
    try {
      await supabase.auth.signOut();
      setUser(null);
      console.log('✅ Signed out successfully');
    } catch (err) {
      console.error('❌ Sign-out error:', err);
    }
  };

  const handleInputChange = (field) => (event) => {
    setSignInData(prev => ({
      ...prev,
      [field]: event.target.value
    }));
    setError(null);
  };

  const handleKeyPress = (event) => {
    if (event.key === 'Enter') {
      handleSignIn();
    }
  };

  if (loading) {
    return (
      <Box 
        sx={{ 
          display: 'flex', 
          justifyContent: 'center', 
          alignItems: 'center', 
          height: '100vh' 
        }}
      >
        <CircularProgress />
      </Box>
    );
  }

  if (!user) {
    return (
      <Container maxWidth="sm">
        <Box sx={{ mt: 8 }}>
          <Paper elevation={3} sx={{ p: 4 }}>
            <Typography variant="h4" align="center" gutterBottom>
              Khan Academy Tracker
            </Typography>
            
            <Typography variant="h6" align="center" gutterBottom>
              Sign In Required
            </Typography>
            
            <Typography variant="body2" color="text.secondary" align="center" sx={{ mb: 3 }}>
              Please sign in to access the student tracking system
            </Typography>

            {error && (
              <Alert severity="error" sx={{ mb: 3 }}>
                {error}
              </Alert>
            )}

            <Box sx={{ mb: 3 }}>
              <TextField
                fullWidth
                label="Email"
                type="email"
                value={signInData.email}
                onChange={handleInputChange('email')}
                onKeyPress={handleKeyPress}
                disabled={signInLoading}
                sx={{ mb: 2 }}
              />
              
              <TextField
                fullWidth
                label="Password"
                type="password"
                value={signInData.password}
                onChange={handleInputChange('password')}
                onKeyPress={handleKeyPress}
                disabled={signInLoading}
              />
            </Box>

            <Button
              fullWidth
              variant="contained"
              onClick={handleSignIn}
              disabled={signInLoading}
              sx={{ mb: 2 }}
            >
              {signInLoading ? <CircularProgress size={24} /> : 'Sign In'}
            </Button>

            <Box sx={{ textAlign: 'center' }}>
              <Button
                variant="text"
                onClick={() => setShowCreateAccount(!showCreateAccount)}
                disabled={signInLoading}
              >
                {showCreateAccount ? 'Hide Account Creation' : 'Need to create an account?'}
              </Button>
            </Box>

            {showCreateAccount && (
              <Alert severity="info" sx={{ mt: 2 }}>
                <Typography variant="body2">
                  To create a new account, use the "Test Student" link in the navigation after signing in, 
                  or contact your administrator.
                </Typography>
              </Alert>
            )}
          </Paper>
        </Box>
      </Container>
    );
  }

  // User is authenticated, show the app
  return (
    <>
      {children}
      {/* Optional: Add a sign-out button somewhere in the UI */}
      <Box sx={{ position: 'fixed', top: 10, right: 10, zIndex: 1000 }}>
        <Button 
          variant="outlined" 
          size="small" 
          onClick={handleSignOut}
          sx={{ 
            backgroundColor: 'white', 
            '&:hover': { backgroundColor: '#f5f5f5' } 
          }}
        >
          Sign Out
        </Button>
      </Box>
    </>
  );
};

export default AuthWrapper;