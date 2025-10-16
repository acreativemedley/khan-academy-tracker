# Quick Command Reference Card

Print this out or bookmark it! You'll need these commands for deployment.

---

## Your Specific Values

```
SSH Username:          dh_k773dx
VPS Host:              vps30327.dreamhostps.com
Subdomain:             matthew.makealltheprojects.com
Web Directory:         /home/dh_k773dx/matthew.makealltheprojects.com
SSH Key Path:          C:\Users\felti\.ssh\id_ed25519
Project Folder:        C:\Users\felti\OneDrive\Documents\Coding\School2025\tracker
```

---

## Initial Setup Commands (One-Time)

### 1. Check Node.js Version
```powershell
node --version
```
✅ Should show: v22.x.x (yours is v22.12.0)

### 2. Create SSH Keys (If Needed)
```powershell
ssh-keygen -t ed25519 -f $env:USERPROFILE\.ssh\id_ed25519
```
- Press Enter when asked for passphrase (or set one)

### 3. View Your Public Key (to add to DreamHost)
```powershell
notepad $env:USERPROFILE\.ssh\id_ed25519.pub
```
- Copy all the text (starts with `ssh-ed25519`)
- Paste into DreamHost panel

---

## Build Commands (Local - Your Computer)

### 1. Install Dependencies (First Time Only)
```powershell
npm install
```

### 2. Build Your App
```powershell
npm run build
```
✅ Creates a `dist` folder

### 3. Test Locally (Optional)
```powershell
npm run preview
```

---

## Deployment Command (The Main Command!)

### Run This to Deploy:
```powershell
.\deploy\deploy.ps1 -RemoteUser dh_k773dx -RemoteHost vps30327.dreamhostps.com -RemotePath /home/dh_k773dx/matthew.makealltheprojects.com -KeyPath $env:USERPROFILE\.ssh\id_ed25519
```

**Copy/paste exactly** (replace paths if different)

### OR Create an Alias for Faster Future Deploys:
```powershell
$ProfilePath = $env:USERPROFILE\Documents\WindowsPowerShell\profile.ps1

# Create profile if it doesn't exist
if (-not (Test-Path $ProfilePath)) {
    New-Item -Path $env:USERPROFILE\Documents\WindowsPowerShell -Name "profile.ps1" -Type File -Force | Out-Null
}

# Add the alias
Add-Content -Path $ProfilePath -Value @"
function deploy-tracker {
    cd 'C:\Users\felti\OneDrive\Documents\Coding\School2025\tracker'
    .\deploy\deploy.ps1 -RemoteUser dh_k773dx -RemoteHost vps30327.dreamhostps.com -RemotePath /home/dh_k773dx/matthew.makealltheprojects.com -KeyPath `$env:USERPROFILE\.ssh\id_ed25519
}
"@
```

Then just type: `deploy-tracker` next time!

---

## SSH Direct Access (For Troubleshooting)

### Connect to Your Server
```powershell
ssh -i $env:USERPROFILE\.ssh\id_ed25519 dh_k773dx@vps30327.dreamhostps.com
```

### View Website Files
```bash
ls -la /home/dh_k773dx/matthew.makealltheprojects.com/
```

### Check if .htaccess is There
```bash
ls -la /home/dh_k773dx/matthew.makealltheprojects.com/.htaccess
```

### View Last Few Lines of Apache Error Log
```bash
tail -50 /var/log/apache2/error.log
```

### Exit SSH Connection
```bash
exit
```

---

## DNS Check Commands (If Website Doesn't Show Up)

### Check DNS Resolution (Windows)
```powershell
Resolve-DnsName matthew.makealltheprojects.com
```
Should show an IP address matching your server.

### Check DNS from Command Line
```powershell
nslookup matthew.makealltheprojects.com
```

---

## Troubleshooting Commands

### Clear PowerShell History
```powershell
Clear-History
```

### Check if Port 22 (SSH) is Open
```powershell
Test-NetConnection -ComputerName vps30327.dreamhostps.com -Port 22
```

### Check if Port 443 (HTTPS) is Open
```powershell
Test-NetConnection -ComputerName vps30327.dreamhostps.com -Port 443
```

### View Available npm Scripts
```powershell
npm run
```

### Check npm Cache
```powershell
npm cache verify
```

### Clear npm Cache (if having issues)
```powershell
npm cache clean --force
```

---

## Browser Troubleshooting

### Clear Browser Cache
```
Windows:   Ctrl + Shift + Delete
Mac:       Cmd + Shift + Delete
```

### Force Refresh (Bypass Cache)
```
Windows:   Ctrl + F5
Mac:       Cmd + Shift + R
```

### Test in Private/Incognito Window
- No cached files
- Fresh connection
- Good for testing

---

## File Location Reminders

### Your Deployment Folder
```
C:\Users\felti\OneDrive\Documents\Coding\School2025\tracker\deploy\
```

### Your Build Output
```
C:\Users\felti\OneDrive\Documents\Coding\School2025\tracker\dist\
```

### Your SSH Keys
```
C:\Users\felti\.ssh\
```

### Your Source Code
```
C:\Users\felti\OneDrive\Documents\Coding\School2025\tracker\src\
```

---

## DreamHost Panel Shortcuts

- **Main Site**: https://www.makealltheprojects.com
- **Staff Scheduler**: https://scheduler.makealltheprojects.com
- **Khan Tracker** (NEW): https://matthew.makealltheprojects.com
- **DreamHost Panel**: https://panel.dreamhost.com
- **DreamHost Docs**: https://help.dreamhost.com

---

## Emergency Commands

### If Deploy Goes Wrong

**Step 1: Check What Happened**
```powershell
# Look at the error message from deploy.ps1
# Usually tells you exactly what failed
```

**Step 2: Check Server Space**
```bash
ssh -i $env:USERPROFILE\.ssh\id_ed25519 dh_k773dx@vps30327.dreamhostps.com "df -h"
```

**Step 3: Check File Permissions**
```bash
ssh -i $env:USERPROFILE\.ssh\id_ed25519 dh_k773dx@vps30327.dreamhostps.com "ls -la /home/dh_k773dx/matthew.makealltheprojects.com/"
```

**Step 4: Restart Apache** (contact DreamHost for this)
```
Go to DreamHost panel → Support → Live Chat
```

---

## Useful One-Liners

### Build and Deploy in One Go
```powershell
npm run build; .\deploy\deploy.ps1 -RemoteUser dh_k773dx -RemoteHost vps30327.dreamhostps.com -RemotePath /home/dh_k773dx/matthew.makealltheprojects.com -KeyPath $env:USERPROFILE\.ssh\id_ed25519
```

### Check File Size of dist.zip (After Build)
```powershell
Get-Item ".\dist.zip" | Select-Object -ExpandProperty Length
```

### List All Files That Will Be Deployed
```powershell
Get-ChildItem -Path ".\dist" -Recurse | Measure-Object
```

---

## Important: Save Your Passwords/Keys Location

Write these down somewhere safe (NOT in code or public):

```
SSH Private Key:       C:\Users\felti\.ssh\id_ed25519
DreamHost Username:    dh_k773dx
DreamHost Login URL:   https://panel.dreamhost.com
SSH Password/Passphrase: [your choice - if set]
```

---

## Quick Help

**Stuck?**
1. Read DEPLOYMENT-GUIDE.md again
2. Check troubleshooting section in README.md
3. Contact DreamHost support
4. Google the error message

**Still Stuck?**
1. Take a screenshot of error
2. Note the exact command you ran
3. Note the exact error message
4. Contact DreamHost support with these details

---

**Last Updated**: October 16, 2025
**For**: Khan Academy Tracker Deployment
**To**: matthew.makealltheprojects.com

