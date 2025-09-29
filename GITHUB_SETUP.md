# GitHub Repository Setup Instructions

## Create Repository on GitHub

1. **Go to GitHub.com** and sign in to your account

2. **Create New Repository**
   - Click the "+" icon in the top right corner
   - Select "New repository"

3. **Repository Settings**
   - **Repository name**: `khan-academy-tracker` (or your preferred name)
   - **Description**: `Khan Academy Multi-Course Academic Planner - React app with Supabase backend for tracking progress across 4 courses targeting May 30, 2026 completion`
   - **Visibility**: Private (recommended) or Public
   - **DO NOT** initialize with README, .gitignore, or license (we already have these)

4. **Create Repository**
   - Click "Create repository"

5. **Connect Local Repository**
   - Copy the repository URL from GitHub
   - Run the commands below in your terminal

## Terminal Commands to Connect

Once you have the GitHub repository URL, run these commands:

```powershell
# Add the remote origin (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/khan-academy-tracker.git

# Rename the default branch to main (if desired)
git branch -M main

# Push the initial commit to GitHub
git push -u origin main
```

## Verify Setup

After pushing, you should see all your files on GitHub including:
- README.md with project overview
- PROJECT_PLAN.md with comprehensive documentation  
- course-data/ folder with all 4 course structures
- .gitignore configured for React/Node.js projects

## Next Steps

Once the repository is created:
1. Set up branch protection rules (optional)
2. Configure GitHub Actions for CI/CD (future)
3. Add collaborators if needed
4. Set up Netlify integration for deployment (future)

---

**Note**: Save the repository URL for future reference!