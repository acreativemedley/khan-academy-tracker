# Deployment Setup - Question & Answer Document

This document records all the setup information needed for deploying the Khan Academy Tracker to matthew.makealltheprojects.com on DreamHost.

---

## Question 1: Node.js Version

**Question**: What version of Node.js do you have installed on your local machine?

**How to find out**:
1. **Press Windows key + X** on your keyboard
2. **Click "Windows PowerShell"** or **"Terminal"**
3. **Type this** and press Enter:
   ```powershell
   node --version
   ```
4. **You'll see something like**: `v20.10.0` or `v22.12.0`

**Your Answer**: 
- ✅ **Node.js Version**: `v22.12.0`
- ✅ **Status**: This version is recent and will work perfectly!
- ℹ️ **Note**: This is the same version you used for the staff-scheduler app, so your server will be compatible.

**What this means**: You don't need to do anything! Your setup is ready to go.

---

## Question 2: SSH Authentication Setup

**Question**: Do you have SSH key authentication set up?

**Your Answer**:
- You set up a **password** on DreamHost
- You need help with this
- ✅ **We will use the same SSH key setup method** that you successfully used for staff-scheduler

**What we'll do**:
1. Create SSH keys on your Windows computer (if you haven't already)
2. Add your public key to DreamHost
3. This allows your computer to automatically authenticate with your server

**Note**: You might already have SSH keys from your staff-scheduler deployment! We can check and reuse them.

---

## Question 3: Subdomain Management

**Question**: How do you manage the subdomain setup?

**Your Answer**:
- ✅ You manage it through the **DreamHost panel** (not command-line)
- ✅ You have access to the DreamHost control panel
- ✅ You've already done this successfully for scheduler.makealltheprojects.com

**New Subdomain Details**:
- **Subdomain**: matthew.makealltheprojects.com
- **SSH Username**: dh_k773dx (from your hosting account)
- **Host**: vps30327.dreamhostps.com
- **Web Directory Path**: Will be created when you add the subdomain (typically `/home/dh_k773dx/matthew.makealltheprojects.com`)

---

## Your Hosting Account Information

**Save this information - you'll need it during deployment!**

```
DreamHost Username:    dh_k773dx
VPS Host:              vps30327.dreamhostps.com
New Subdomain:         matthew.makealltheprojects.com
Main Site:             makealltheprojects.com (WordPress - leave untouched)
Other Subdomain:       scheduler.makealltheprojects.com (staff-scheduler app)
WordPress Location:    Main site (no changes needed)
```

---

## Project Information

**Khan Academy Tracker App**:
```
Project Name:    Khan Academy Tracker
Type:            React + Vite
Node.js Version: v22.12.0
Build Tool:      Vite
Database:        Supabase (cloud-hosted, no server setup needed)
```

---

## Deployment Method

**Based on your successful staff-scheduler deployment, we'll use**:
- ✅ **Build locally** on your Windows machine (using `npm run build`)
- ✅ **Upload to server** using PowerShell script with SSH/SCP
- ✅ **Use Apache** to serve the app (already configured on your VPS)
- ✅ **Keep Netlify deployment** active (no conflicts)

---

## Next Steps

1. ✅ **Answer 1 Complete**: Node.js v22.12.0 is ready
2. ✅ **Answer 2 Complete**: We'll set up SSH authentication 
3. ✅ **Answer 3 Complete**: Using DreamHost panel for subdomain

**What happens next**:
- We'll create a detailed step-by-step deployment guide
- We'll create all necessary configuration files
- We'll create a PowerShell script to automate the upload
- Everything will be tested and verified before you use it

---

## Questions to Ask Next

- Do you know your web server directory path for matthew.makealltheprojects.com? (We can find this in Step 1 of the deployment guide)
- Do you have your SSH public key already set up, or should we create one fresh?

