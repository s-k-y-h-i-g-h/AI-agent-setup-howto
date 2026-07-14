<#
.SYNOPSIS
Hermes AI Agent Installer - Stage 2 (PowerShell)
#>

# Require admin
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs
    exit
}

# Install Windows Terminal (if missing)
if (-not (Get-AppxPackage -Name "Microsoft.WindowsTerminal" -ErrorAction SilentlyContinue)) {
    Write-Host "🔹 Installing Windows Terminal..."
    winget install --id Microsoft.WindowsTerminal -e --silent --accept-package-agreements --accept-source-agreements
}

# Install WSL (if missing)
if (-not (wsl --list --quiet)) {
    Write-Host "🔹 Installing WSL..."
    wsl --install --distribution Arch --no-launch
    Write-Host "🔹 WSL installed. A restart is required. Please run this installer again after rebooting."
    Start-Sleep -Seconds 5
    Restart-Computer -Confirm:$false
    exit
}

# Download Stage 3 (Bash script)
$bashScriptUrl = "https://raw.githubusercontent.com/s-k-y-h-i-g-h/AI-agent-setup-howto/main/scripts/install.sh"
$bashScriptPath = "$env:USERPROFILE\install.sh"
Write-Host "🔹 Downloading Stage 3 (Bash script)..."
Invoke-WebRequest -Uri $bashScriptUrl -OutFile $bashScriptPath

# Run Stage 3 in WSL
Write-Host "🔹 Running Stage 3 (Bash script) in WSL..."
wsl -d Arch -u root -e bash $bashScriptPath

Write-Host "🎉 Hermes AI Agent is now installed!"
Write-Host "🔹 Open Windows Terminal and type 'hermes' to start."
