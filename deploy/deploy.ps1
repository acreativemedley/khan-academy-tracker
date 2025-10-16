<#
.SYNOPSIS
Deploy Khan Academy Tracker to DreamHost VPS using SSH/SCP.

.DESCRIPTION
This PowerShell script automates the deployment process:
1. Installs dependencies (npm install)
2. Builds the Vite React app (npm run build)
3. Creates a zip file of the dist folder
4. Uploads via SCP to the remote server
5. Extracts and deploys to the web directory
6. Cleans up temporary files

.PARAMETER RemoteUser
SSH username (e.g., dh_k773dx)

.PARAMETER RemoteHost
Server hostname (e.g., vps30327.dreamhostps.com)

.PARAMETER RemotePath
Web directory on server (e.g., /home/dh_k773dx/matthew.makealltheprojects.com)

.PARAMETER KeyPath
Path to your SSH private key (default: ~/.ssh/id_ed25519)

.PARAMETER BuildCommand
The npm command to run (default: npm run build)

.EXAMPLE
.\deploy.ps1 -RemoteUser dh_k773dx -RemoteHost vps30327.dreamhostps.com -RemotePath /home/dh_k773dx/matthew.makealltheprojects.com

.NOTES
- Requires OpenSSH Client installed on Windows
- SSH key should already be added to DreamHost authorized_keys
- This script is for manual deployment (not CI/CD)
#>

param(
    [Parameter(Mandatory=$true)] 
    [string] $RemoteUser,
    
    [Parameter(Mandatory=$true)] 
    [string] $RemoteHost,
    
    [Parameter(Mandatory=$true)] 
    [string] $RemotePath,
    
    [string] $KeyPath = "$env:USERPROFILE\.ssh\id_ed25519",
    
    [string] $BuildCommand = "npm run build"
)

# Set error action to stop on any error
$ErrorActionPreference = "Stop"

Write-Output "=========================================="
Write-Output "Khan Academy Tracker - Deployment Script"
Write-Output "=========================================="
Write-Output ""

# Step 1: Run the build
Write-Output "Step 1: Building your app..."
Write-Output "Running: $BuildCommand"
Write-Output ""

if ($BuildCommand -match '^npm') {
    Write-Output "Installing dependencies first..."
    npm install
    if ($LASTEXITCODE -ne 0) { 
        Write-Output "❌ npm install failed"
        throw "npm install failed with exit code $LASTEXITCODE" 
    }
}

cmd /c $BuildCommand
if ($LASTEXITCODE -ne 0) { 
    Write-Output "❌ Build failed"
    throw "Build failed with exit code $LASTEXITCODE" 
}

Write-Output "✅ Build completed successfully"
Write-Output ""

# Step 2: Verify dist folder exists
Write-Output "Step 2: Checking build output..."
$buildDir = Join-Path -Path (Get-Location) -ChildPath 'dist'
if (-not (Test-Path $buildDir)) { 
    throw "❌ Build output directory 'dist' not found. Make sure 'npm run build' completed successfully."
}
Write-Output "✅ Found dist folder: $buildDir"
Write-Output ""

# Step 3: Create zip archive
Write-Output "Step 3: Creating deployment archive..."
$archive = Join-Path -Path (Get-Location) -ChildPath "dist.zip"
if (Test-Path $archive) { 
    Remove-Item $archive
    Write-Output "Removed old dist.zip"
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($buildDir, $archive)
Write-Output "✅ Created archive: $archive"
Write-Output ""

# Step 4: Check SSH key
Write-Output "Step 4: Checking SSH configuration..."
if (-not (Test-Path $KeyPath)) { 
    Write-Output "⚠️  Warning: SSH key not found at $KeyPath"
    Write-Output "   Will attempt password authentication instead"
} else {
    Write-Output "✅ SSH key found: $KeyPath"
}
Write-Output ""

# Step 5: Upload to server
Write-Output "Step 5: Uploading to server..."
Write-Output "Target: ${RemoteUser}@${RemoteHost}:/tmp/"
Write-Output ""

$archiveFileName = Split-Path -Path $archive -Leaf
$remoteDest = "${RemoteUser}@${RemoteHost}:/tmp/"

# Build SCP command
$scpCmd = "scp -i `"$KeyPath`" -o StrictHostKeyChecking=no `"$archive`" $remoteDest"

Write-Output "Uploading $archiveFileName..."
cmd /c $scpCmd

if ($LASTEXITCODE -ne 0) { 
    throw "❌ Upload failed with exit code $LASTEXITCODE"
}
Write-Output "✅ Upload completed"
Write-Output ""

# Step 6: Extract on remote server
Write-Output "Step 6: Deploying on remote server..."
Write-Output "Destination: $RemotePath"
Write-Output ""

$remoteCommands = "mkdir -p $RemotePath; rm -rf $RemotePath/*; unzip -o /tmp/$archiveFileName -d $RemotePath; rm /tmp/$archiveFileName"
$sshTarget = "${RemoteUser}@${RemoteHost}"
$sshCmd = "ssh -i `"$KeyPath`" -o StrictHostKeyChecking=no $sshTarget `"$remoteCommands`""

Write-Output "Running remote commands..."
cmd /c $sshCmd

if ($LASTEXITCODE -ne 0) { 
    throw "❌ Remote deployment failed with exit code $LASTEXITCODE"
}
Write-Output "✅ Files deployed to remote server"
Write-Output ""

# Final message
Write-Output "=========================================="
Write-Output "✅ DEPLOYMENT COMPLETED SUCCESSFULLY!"
Write-Output "=========================================="
Write-Output ""
Write-Output "Your app should be live at:"
Write-Output "https://matthew.makealltheprojects.com"
Write-Output ""
Write-Output "If you don't see it yet:"
Write-Output "  1. Wait 5-10 minutes for DNS to update"
Write-Output "  2. Try Ctrl+Shift+Delete to clear your browser cache"
Write-Output "  3. Use an incognito/private window to test"
Write-Output ""

