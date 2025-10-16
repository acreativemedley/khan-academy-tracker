# How to Add SSH Keys to DreamHost via Command Line

**Status**: ✅ Verified Working (October 15-16, 2025)

This guide documents the method for adding SSH public keys to a DreamHost user account when the SSH key field is not available in the DreamHost web panel.

---

## 📋 Overview

**When to use this method:**
- ✅ SSH key field not visible in DreamHost web panel
- ✅ You already have SSH keys generated locally
- ✅ You want to use key-based authentication (more secure than password)
- ✅ You need to automate deployments (like with PowerShell scripts)

**What you'll accomplish:**
- Add your public SSH key to DreamHost
- Enable key-based SSH authentication
- Allow automated deployment scripts to work

---

## 🔑 Prerequisites

Before starting, you need:

1. **SSH Keys Generated Locally**
   - Private key: `C:\Users\[YourName]\.ssh\id_ed25519`
   - Public key: `C:\Users\[YourName]\.ssh\id_ed25519.pub`
   
   ✅ To check if you have them:
   ```powershell
   Get-ChildItem $env:USERPROFILE\.ssh\
   ```

2. **DreamHost User Account with SSH Access**
   - Your DreamHost username (e.g., `dh_k773dx`)
   - Your DreamHost VPS hostname (e.g., `vps30327.dreamhostps.com`)
   - SSH must be enabled for this user (you can toggle it in DreamHost panel)

3. **PowerShell/Terminal on Your Local Machine**
   - Windows: PowerShell or Windows Terminal
   - Mac/Linux: Terminal

---

## 🚀 Step-by-Step Instructions

### **Step 1: Connect to Your DreamHost Server via SSH**

Open PowerShell and run:

```powershell
ssh -i $env:USERPROFILE\.ssh\id_ed25519 dh_k773dx@vps30327.dreamhostps.com
```

**Replace:**
- `dh_k773dx` with your DreamHost username
- `vps30327.dreamhostps.com` with your DreamHost VPS hostname

**Expected output:**
```
The authenticity of host 'vps30327.dreamhostps.com (X.X.X.X)' can't be established.
ED25519 key fingerprint is [fingerprint].
Are you sure you want to continue connecting (yes/no)?
```

**Type:** `yes` and press Enter

---

### **Step 2: Check if authorized_keys File Exists**

Once connected (you'll see a prompt like `[servername]$`), run:

```bash
cat ~/.ssh/authorized_keys
```

**If you see:**
- ✅ Your SSH key(s) displayed → Key already added! Go to Step 4.
- ❌ "No such file or directory" → Continue to Step 3.

---

### **Step 3: Add Your SSH Public Key**

Run this command on the server:

```bash
mkdir -p ~/.ssh && echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ7AC+WEzks.JlG2Tmaqksn8vQJK5plo/1HD5rGuOul" >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
```

⚠️ **IMPORTANT**: Replace the key in the command with YOUR actual public key!

**To get your actual public key**, from your **local** PowerShell (not the SSH session), run:

```powershell
Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub
```

Copy the entire output (it starts with `ssh-ed25519`).

**The command does three things:**
1. `mkdir -p ~/.ssh` → Creates `.ssh` directory if needed
2. `echo "..." >> ~/.ssh/authorized_keys` → Adds your public key
3. `chmod 600 ~/.ssh/authorized_keys` → Sets correct permissions (important!)

---

### **Step 4: Verify the Key Was Added**

Still on the server, run:

```bash
cat ~/.ssh/authorized_keys
```

You should see your public key displayed. ✅

---

### **Step 5: Disconnect from the Server**

Type:

```bash
exit
```

You're now back on your local machine.

---

## ✅ Verification: Test Your SSH Connection

### **Test 1: Connect Without Password Prompt**

From PowerShell, run:

```powershell
ssh -i $env:USERPROFILE\.ssh\id_ed25519 dh_k773dx@vps30327.dreamhostps.com "echo 'SSH Key Authentication Works!'"
```

**Expected:**
- ✅ Message displays: "SSH Key Authentication Works!"
- ❌ Password prompt appears: Key not configured correctly

---

### **Test 2: Run a Remote Command**

```powershell
ssh -i $env:USERPROFILE\.ssh\id_ed25519 dh_k773dx@vps30327.dreamhostps.com "ls -la /home/dh_k773dx/"
```

**Expected:**
- ✅ Directory listing displays
- ❌ Error or password prompt: Check your setup

---

## 🔧 Troubleshooting

### **Problem: "Permission denied (publickey)"**

**Causes:**
1. Wrong SSH key path
2. Wrong DreamHost username
3. Key not in authorized_keys
4. Permissions on ~/.ssh are wrong

**Solutions:**
1. Verify key exists: `Get-ChildItem $env:USERPROFILE\.ssh\`
2. Verify username matches DreamHost panel
3. SSH back in and check: `cat ~/.ssh/authorized_keys`
4. Fix permissions: `chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys`

---

### **Problem: "No such file or directory" for ~/.ssh/authorized_keys**

**Solution:**
Run the command from Step 3 again - it will create the file:

```bash
mkdir -p ~/.ssh && echo "YOUR_PUBLIC_KEY_HERE" >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
```

---

### **Problem: Connection Times Out or Hangs**

**Causes:**
1. Wrong hostname
2. Firewall blocking port 22
3. SSH not enabled for this user

**Solutions:**
1. Verify hostname: Check DreamHost panel
2. Check firewall settings
3. Verify SSH is enabled for user in DreamHost panel

---

## 📝 Reference: Your Information

**Save this for future deployments:**

```
DreamHost Username:     dh_k773dx
VPS Hostname:          vps30327.dreamhostps.com
SSH Key Location:      C:\Users\felti\.ssh\id_ed25519
Public Key Location:   C:\Users\felti\.ssh\id_ed25519.pub
SSH Port:              22 (default)
Authentication:        ED25519 key-based
```

---

## 🔐 Security Notes

- ✅ **Private key stays on your computer** - Never share it
- ✅ **Public key on server is safe** - Can't be used to access your computer
- ✅ **authorized_keys file is read-only** (chmod 600) - Only owner can read
- ✅ **.ssh directory is restricted** (chmod 700) - Only owner can access
- ✅ **Ed25519 keys are modern and secure** - Better than RSA for most uses

---

## 🔄 For Multiple Users

If you have multiple DreamHost users (like `dh_k773dx` for matthew and `dh_quhiu7` for scheduler), you can:

1. Follow this same process for each user
2. Each user will have its own `authorized_keys` file
3. Each can use the same SSH key (recommended) or different keys

**To add multiple keys to one user:**

```bash
echo "ssh-ed25519 FIRST_KEY_HERE" >> ~/.ssh/authorized_keys
echo "ssh-ed25519 SECOND_KEY_HERE" >> ~/.ssh/authorized_keys
```

---

## 💡 Using This With Deployment Scripts

Once your SSH key is set up, deployment scripts can:

1. Connect without prompting for password
2. Run commands automatically
3. Upload files securely
4. Run on schedule or automation

**Example in PowerShell:**

```powershell
# Deploy script no longer needs to prompt for password
ssh -i $env:USERPROFILE\.ssh\id_ed25519 dh_k773dx@vps30327.dreamhostps.com "ls -la /home/dh_k773dx/matthew.makealltheprojects.com/"
```

---

## 📚 Related Documentation

- **Main Deployment Guide**: `DEPLOYMENT-GUIDE.md`
- **Command Reference**: `COMMAND-REFERENCE.md`
- **DreamHost SSH Docs**: https://help.dreamhost.com/hc/en-us/articles/216499537-How-to-configure-passwordless-login-in-Mac-OS-X-and-Linux

---

## ✅ Checklist: SSH Key Setup Complete

- [ ] SSH keys exist locally (`id_ed25519` and `id_ed25519.pub`)
- [ ] Connected to DreamHost server via SSH
- [ ] Created/verified `.ssh` directory exists
- [ ] Added public key to `authorized_keys`
- [ ] Set correct permissions (chmod 600)
- [ ] Verified key works (test connection)
- [ ] Saved DreamHost connection info
- [ ] Ready for automated deployments

---

## 🎓 What You Learned

By following this process, you now understand:

1. **SSH Key Authentication** - How keys replace passwords
2. **Public Key Infrastructure** - Public/private key concepts
3. **File Permissions** - Why .ssh needs specific permissions
4. **SSH Connection** - How to connect to remote servers
5. **Automation** - Why SSH keys enable scripts to work

---

## 📞 Future Reference

**If you need to add SSH keys to another DreamHost user in the future:**

1. Find this file: `tracker/deploy/SSH-KEYS-DREAMHOST.md`
2. Follow Steps 1-5 above
3. Replace username/hostname as needed
4. Done! ✅

---

**Last Verified**: October 16, 2025  
**Status**: ✅ Working and Tested  
**For**: Khan Academy Tracker Deployment  

