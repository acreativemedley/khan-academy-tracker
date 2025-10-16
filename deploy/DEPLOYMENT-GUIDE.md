# How to Deploy Khan Academy Tracker to matthew.makealltheprojects.com

**Written for Complete Beginners** — Every step explained in plain English!

---

## What This Guide Will Help You Do

By the end, your Khan Academy Tracker app will be live on the internet at **matthew.makealltheprojects.com** with a secure HTTPS connection (padlock icon 🔒).

**Why a subdomain?** You already have:
- WordPress running at www.makealltheprojects.com
- Staff Scheduler running at scheduler.makealltheprojects.com

Using subdomains keeps them completely separate with no conflicts!

**Time estimate**: 30-45 minutes if this is your first time (faster on second deployment!)

---

## Before You Start - What You Need

✅ **You already have**:
- A DreamHost VPS account (vps30327.dreamhostps.com)
- SSH username: dh_k773dx
- The Khan Academy Tracker project on your Windows computer
- Node.js v22.12.0 installed (you already checked this!)
- Successful experience deploying staff-scheduler to scheduler.makealltheprojects.com

✅ **You'll create during this guide**:
- A subdomain: matthew.makealltheprojects.com (keeps WordPress and other React apps separate)
- SSH keys (we'll verify if you can reuse your existing ones)
- The actual live website!

---

## Quick Reference - Your Information

**Keep this handy** - you'll need these values later:

```
DreamHost Username:       dh_k773dx
VPS Host:                 vps30327.dreamhostps.com
New Subdomain:            matthew.makealltheprojects.com
Node.js Version:          v22.12.0 ✅
SSH Key Location:         C:\Users\felti\.ssh\id_ed25519
Project Directory:        C:\Users\felti\OneDrive\Documents\Coding\School2025\tracker
```

---

# PART 1: Create the Subdomain in DreamHost Panel

## Why are we doing this?
Your WordPress site is at www.makealltheprojects.com. Your Staff Scheduler is at scheduler.makealltheprojects.com. We need a separate place for Khan Academy Tracker. A subdomain is like a separate mini-website that won't interfere with your other sites.

## Step 1.1: Open DreamHost Panel

1. **Open your web browser** (Chrome, Firefox, Edge, etc.)
2. **Type this in the address bar**: `https://panel.dreamhost.com`
3. **Press Enter**
4. **Log in** with your DreamHost email and password

## Step 1.2: Add the Subdomain

1. **In DreamHost panel**, look for **"Websites"** or **"Domains"** in the left sidebar
2. **Click on it**
3. **Click the button** that says **"Add Website"** or similar
4. **In the domain field, type**: 
   ```
   matthew.makealltheprojects.com
   ```
5. **For "Web Directory"** (also called "Document Root"), it should auto-fill something like:
   ```
   /home/dh_k773dx/matthew.makealltheprojects.com
   ```
   - **Write down this exact path** — you'll need it later!
   - Example: `/home/dh_k773dx/matthew.makealltheprojects.com`

6. **Make sure** "HTTPS" or "Secure Hosting" is enabled (look for a checkbox or toggle)

7. **Click "Add Website"** or similar button

8. **Wait 5-10 minutes** for DreamHost to set up the subdomain and get an SSL certificate

> 📝 **Important**: Write down the web directory path! You'll need it in Part 5.

---

# PART 2: Prepare Your SSH Keys

## What are SSH Keys?
SSH keys are like a secure handshake between your computer and the server. You have two:
- **Private key** — stays on YOUR computer (never share!)
- **Public key** — given to DreamHost (safe to share)

This lets you upload files without typing a password every time.

## Step 2.1: Do You Already Have SSH Keys?

If you successfully deployed staff-scheduler to scheduler.makealltheprojects.com, you probably already have SSH keys!

1. **Press Windows key + R** on your keyboard
2. **Type this** and press Enter:
   ```
   notepad %USERPROFILE%\.ssh\id_ed25519.pub
   ```

**What happens next**:
- ✅ **If Notepad opens with text starting with `ssh-ed25519`**: You already have keys! Skip to Step 2.3
- ❌ **If you get an error**: You need to create new keys. Go to Step 2.2

## Step 2.2: Create New SSH Keys (if you don't have them)

1. **Press Windows key + X** on your keyboard
2. **Click "Windows PowerShell"** or **"Terminal"**
3. **Type this command exactly** and press Enter:
   ```powershell
   ssh-keygen -t ed25519 -f $env:USERPROFILE\.ssh\id_ed25519
   ```

4. **You'll see questions** — answer them like this:

   **"Enter file in which to save the key"**
   - Just press **Enter** (don't type anything)
   
   **"Enter passphrase"**
   - Press **Enter** for no password (easier for automation)
   - OR type a password if you want extra security
   
   **"Enter same passphrase again"**
   - Press **Enter** again

5. **You'll see a message** like:
   ```
   Your public key has been saved in C:\Users\YourName\.ssh\id_ed25519.pub
   ```
   ✅ Success!

## Step 2.3: Copy Your Public Key to DreamHost

### Part A: Copy Your Public Key

1. **Press Windows key + R**
2. **Type this** and press Enter:
   ```
   notepad %USERPROFILE%\.ssh\id_ed25519.pub
   ```
3. **Notepad will open** with random-looking text
4. **Select all** with **Ctrl+A**
5. **Copy** with **Ctrl+C**
6. **Keep Notepad open** (or minimize it)

### Part B: Paste Into DreamHost

1. **Go back to DreamHost panel** in your browser
2. **Click "Users"** or **"Account Users"** in the sidebar
3. **Look for your SSH user** (username: `dh_k773dx`)
   - If this is your first time, your main account user might be listed
4. **Click on it** to edit
5. **Look for a section called**:
   - "SSH Keys" or
   - "Authorized Keys" or
   - "Public Keys"
6. **If you don't see this section**, you might need to create a separate SSH user:
   - Click **"Add User"**
   - Set Username: something like `matthew-deploy`
   - Choose **"Shell User"** type (IMPORTANT!)
   - Choose `/bin/bash` as shell type
   - Click **"Create"**

7. **Once you're in the SSH Keys section**:
   - **Click in the text box**
   - **Press Ctrl+V** to paste
   - **Click "Save"** or **"Update"**

8. **Wait 5-10 minutes** for DreamHost to process this

---

# PART 3: Build Your React App

## What does "building" mean?
Your React app is written in modern code that browsers can't read directly. Building converts it into simple HTML, CSS, and JavaScript files that browsers understand.

## Step 3.1: Open PowerShell in Your Project Folder

1. **Open File Explorer** (folder icon in your taskbar)
2. **Navigate to your project**:
   ```
   C:\Users\felti\OneDrive\Documents\Coding\School2025\tracker
   ```
3. **Click in the address bar** at the very top (where the folder path is shown)
4. **Type**: `powershell` (or `cmd`)
5. **Press Enter**
6. **A terminal window will open** in your project folder

## Step 3.2: Install Dependencies

**What are dependencies?** These are pre-written code libraries your app uses.

1. **Type this** and press Enter:
   ```powershell
   npm install
   ```

2. **Wait 2-5 minutes** — you'll see lots of text scrolling
   - This is normal! Don't worry.
   - If you see warnings, that's usually fine

3. **When it finishes**, you'll get a prompt (the `>` symbol) again

## Step 3.3: Build the Website Files

1. **Type this** and press Enter:
   ```powershell
   npm run build
   ```

2. **Wait 1-2 minutes**

3. **When you see** a message like "built in 1.5s" or "Build complete" — you're done!

4. **Check your file explorer** — you should now see a **`dist`** folder in your project
   - This folder contains your complete website!

---

# PART 4: Upload to DreamHost

## Step 4.1: Get Your Information Ready

**Write down these values** (you collected them earlier):

1. **Your SSH Username**: 
   ```
   dh_k773dx
   ```

2. **Your Server Address**:
   ```
   vps30327.dreamhostps.com
   ```

3. **Your Web Directory Path** (from Step 1.2):
   ```
   /home/dh_k773dx/matthew.makealltheprojects.com
   ```
   (Replace with YOUR actual path if different)

4. **Your SSH Key Location**:
   ```
   C:\Users\<YourWindowsUsername>\.ssh\id_ed25519
   ```

## Step 4.2: Run the Deploy Script

1. **In PowerShell** (still in the tracker folder), type this command:
   ```powershell
   .\deploy\deploy.ps1 -RemoteUser dh_k773dx -RemoteHost vps30327.dreamhostps.com -RemotePath /home/dh_k773dx/matthew.makealltheprojects.com -KeyPath $env:USERPROFILE\.ssh\id_ed25519
   ```

   **Important**: Replace these values if they're different:
   - `dh_k773dx` → your SSH username
   - `vps30327.dreamhostps.com` → your server address
   - `/home/dh_k773dx/matthew.makealltheprojects.com` → your web directory path

2. **Press Enter**

3. **Watch the output**:
   - You'll see it building your app
   - Then uploading to the server
   - When you see **"Deploy completed."** at the end — Success! ✅

## Step 4.3: Troubleshooting the Deploy

**If you see errors**, here are common fixes:

### Error: "ssh: command not found"
- OpenSSH is not installed on your computer
- Follow the instructions in PART 2 Step 2.2 to install it

### Error: "Permission denied (publickey)"
- Your SSH key wasn't properly added to DreamHost
- Wait 5-10 minutes and try again
- Or check that you copied the full public key (should include `ssh-ed25519` at the start)

### Error: "Build failed"
- Make sure you ran `npm install` in Step 3.2
- Make sure you have Node.js v22.12.0 (check with: `node --version`)

### The script runs but website is blank
- Check that `.htaccess` file is in your remote `/home/dh_k773dx/matthew.makealltheprojects.com` directory
- This file is included in the deploy automatically, but verify it's there

---

# PART 5: Test Your Website

## Step 5.1: Wait for DNS to Update

After uploading, DNS (the internet's address book) needs to update:
- **Immediately**: Sometimes works right away (you're lucky!)
- **Usually**: 5-15 minutes
- **Worst case**: Up to 24 hours (rare)

## Step 5.2: Visit Your Website

1. **Open your web browser**
2. **Type this in the address bar**:
   ```
   https://matthew.makealltheprojects.com
   ```
3. **Press Enter**

## Step 5.3: What You Should See

✅ **Success indicators**:
- The Khan Academy Tracker appears
- You see your dashboard
- No blank page
- Padlock icon 🔒 appears (HTTPS is secure)

❌ **If you see an error**:
- "Page not found" or "404" error
- Wait 10 more minutes and try again (DNS delay)
- Check your web directory path is correct in Part 1
- Make sure `.htaccess` file was uploaded

❌ **If the page is blank**:
- Check that `dist/index.html` exists in your remote directory
- Verify `.htaccess` is properly configured
- Check Apache error logs on your server

---

# PART 6: Future Deployments (Much Faster!)

After your first deployment, updates are super quick:

1. **Make changes** to your app in VS Code
2. **In PowerShell** in the tracker folder, run:
   ```powershell
   .\deploy\deploy.ps1 -RemoteUser dh_k773dx -RemoteHost vps30327.dreamhostps.com -RemotePath /home/dh_k773dx/matthew.makealltheprojects.com -KeyPath $env:USERPROFILE\.ssh\id_ed25519
   ```
3. **Wait 1-2 minutes**
4. **Refresh your browser** (Ctrl+F5 to clear cache)
5. **Done!** ✅

You can also create a Windows batch file or PowerShell alias to make this even faster!

---

# PART 7: Important Notes

## ⚠️ Do NOT Do These Things

- ❌ Don't delete your Netlify deployment (it will stay active)
- ❌ Don't modify WordPress files in `/home/dh_k773dx/www` (that's your main site)
- ❌ Don't share your private SSH key with anyone
- ❌ Don't delete the `.htaccess` file after uploading
- ❌ Don't modify `/etc/apache2` files yourself (contact DreamHost support if needed)

## ✅ Environment Variables

Your app uses Supabase credentials (already in netlify.toml). These should be fine:
- They're read from the HTML build at runtime
- No secrets in the HTML, so it's safe

## 🔄 If You Need to Rollback

If something goes wrong:
1. Keep your previous `dist` folder zipped as backup
2. You can always re-run the deploy script with an older version
3. Or contact DreamHost support for restore options

## 📞 Getting Help

If something goes wrong:
1. **Check the error message** carefully (copy it to Google)
2. **Contact DreamHost support** - they're helpful!
   - Go to panel.dreamhost.com
   - Click "Support" or "Help"
   - They can check server logs for you
3. **Common DreamHost settings**:
   - SSH might take 10+ minutes to activate after creating user
   - DNS changes take up to 24 hours (usually faster)

---

# Checklist: Before You Deploy

- [ ] I have created the subdomain matthew.makealltheprojects.com in DreamHost
- [ ] I wrote down my web directory path: `/home/dh_k773dx/matthew.makealltheprojects.com`
- [ ] I have SSH keys set up (or just created them)
- [ ] I added my public key to DreamHost
- [ ] I waited 5-10 minutes for DreamHost to process
- [ ] I have all the deploy script files in `C:\Users\felti\OneDrive\Documents\Coding\School2025\tracker\deploy\`
- [ ] I successfully ran `npm install`
- [ ] I successfully ran `npm run build`
- [ ] I have my tracker folder open in PowerShell

**If all boxes are checked**, you're ready to run the deploy script! 🚀

