# Khan Academy Tracker - Deployment Files

This folder contains all the files you need to deploy the Khan Academy Tracker to matthew.makealltheprojects.com on your DreamHost VPS.

## 📁 Files in This Folder

### 1. **DEPLOYMENT-GUIDE.md**
   - **What it is**: A complete, beginner-friendly step-by-step guide
   - **When to read it**: First time! Start here and follow every step
   - **Time needed**: 30-45 minutes for first deployment
   - **Content includes**:
     - Creating the subdomain in DreamHost
     - Setting up SSH keys
     - Building your React app
     - Uploading to the server
     - Testing your live website

### 2. **deploy.ps1**
   - **What it is**: A PowerShell automation script
   - **When to use it**: After following the DEPLOYMENT-GUIDE once
   - **What it does**:
     - Installs npm dependencies
     - Builds your React app
     - Creates a zip file
     - Uploads via SSH
     - Extracts on the server
     - Cleans up temporary files
   - **How to run it**: See PART 4 of DEPLOYMENT-GUIDE.md

### 3. **.htaccess**
   - **What it is**: Apache web server configuration
   - **What it does**:
     - Enables React Router to work properly
     - Routes requests to index.html (required for single-page apps)
     - Caches static files for performance
     - Enables compression
     - Adds security headers
   - **Auto-deployed**: The deploy.ps1 script includes this automatically

### 4. **README.md** (this file)
   - **What it is**: Quick reference for what's in this folder
   - **What it does**: Explains each file and how to use them

---

## 🚀 Quick Start

### First Time Setup (Total: ~45 minutes)

1. **Read**: `DEPLOYMENT-GUIDE.md` — Follow Part 1 through Part 5
   - Create subdomain
   - Set up SSH keys
   - Build your app
   - Upload to server
   - Test

2. **Your subdomain will be live**: https://matthew.makealltheprojects.com ✅

### Future Deployments (Total: ~2 minutes)

After the first deployment, updating is super fast:

1. **Make changes** to your app in VS Code
2. **In PowerShell**, from your tracker folder, run:
   ```powershell
   .\deploy\deploy.ps1 -RemoteUser dh_k773dx -RemoteHost vps30327.dreamhostps.com -RemotePath /home/dh_k773dx/matthew.makealltheprojects.com -KeyPath $env:USERPROFILE\.ssh\id_ed25519
   ```
3. **Wait 1-2 minutes** for upload
4. **Refresh browser** (Ctrl+F5) and see your changes live! ✅

---

## 📋 Your Setup Information

Save this for future reference:

```
DreamHost Username:       dh_k773dx
VPS Host:                 vps30327.dreamhostps.com
Live URL:                 https://matthew.makealltheprojects.com
Web Directory:            /home/dh_k773dx/matthew.makealltheprojects.com
Local Project:            C:\Users\felti\OneDrive\Documents\Coding\School2025\tracker
```

---

## ❓ Troubleshooting

### "Permission denied (publickey)"
- Wait 5-10 minutes after adding SSH key to DreamHost
- Verify you copied the ENTIRE public key (includes `ssh-ed25519` prefix)
- Try re-adding the key if it's been more than 10 minutes

### "Deploy completed" but website is blank
- Wait 5-10 minutes for DNS to update
- Clear browser cache: Ctrl+Shift+Delete
- Try visiting in an incognito/private window
- Verify `.htaccess` is in your web directory (should be auto-deployed)

### "ssh: command not found"
- OpenSSH is not installed
- Follow Step 2.2 in DEPLOYMENT-GUIDE.md to install it

### "Build failed"
- Make sure you ran `npm install` first
- Verify Node.js: `node --version` (should be v22.12.0 or similar)
- Check for syntax errors in your code

---

## 🔒 Security Notes

- ✅ **Keep your private SSH key safe** — never share it
- ✅ **Keep your public key on DreamHost** — this is intentional
- ✅ **HTTPS is enabled** by DreamHost automatically (padlock 🔒)
- ✅ **Supabase credentials in build are safe** — they're read-only keys

---

## 📞 Getting Help

1. **Read the DEPLOYMENT-GUIDE.md** thoroughly — most answers are there
2. **Check DreamHost support** — visit panel.dreamhost.com → Support
3. **Common issues**:
   - DNS takes up to 24 hours to update (usually faster)
   - SSH key changes take 5-10 minutes to process
   - Browser cache can show old versions

---

## ✅ Deployment Checklist

Before running the deploy script:

- [ ] I created the subdomain in DreamHost
- [ ] I wrote down my web directory path
- [ ] I created/verified SSH keys
- [ ] I added my public key to DreamHost and waited 5-10 minutes
- [ ] I have `.htaccess` in this deploy folder
- [ ] I have `deploy.ps1` in this deploy folder
- [ ] I ran `npm install` in the project root
- [ ] I have the tracker folder open in PowerShell
- [ ] I'm ready to run the deploy.ps1 script

If all boxes are checked → You're ready to deploy! 🚀

---

## 📚 Additional Resources

- **Vite Documentation**: https://vitejs.dev/
- **React Router**: https://reactrouter.com/
- **DreamHost Documentation**: https://help.dreamhost.com/
- **Apache .htaccess Reference**: https://httpd.apache.org/docs/

