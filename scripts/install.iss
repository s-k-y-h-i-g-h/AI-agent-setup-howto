[Setup]
AppName=Hermes AI Agent
AppVersion=1.0
DefaultDirName={autopf}\HermesAI
DefaultGroupName=Hermes AI Agent
OutputDir=output
OutputBaseFilename=HermesAI_Installer
Compression=lzma
SolidCompression=yes
WizardStyle=modern
AppPublisher=Skyhigh AI
AppPublisherURL=https://github.com/s-k-y-h-i-g-h
AppSupportURL=https://github.com/s-k-y-h-i-g-h/AI-agent-setup-howto/issues

[Files]
; Embed the PowerShell script
Source: "install.ps1"; DestDir: "{tmp}"; Flags: deleteafterinstall

[Icons]
Name: "{group}\Hermes AI Agent"; Filename: "{app}\HermesAI_Installer.exe"; WorkingDir: "{app}"
Name: "{group}\Uninstall Hermes AI Agent"; Filename: "{uninstallexe}"

[Run]
; Install PowerShell (if missing)
Filename: "powershell.exe"; Parameters: "-Command `"if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) { winget install --id Microsoft.PowerShell --accept-package-agreements --accept-source-agreements -e --silent }`""; StatusMsg: "Checking for PowerShell..."; Flags: runhidden shellexec waituntilterminated; Description: "Installing PowerShell (if missing)..."; Check: not IsPowerShellInstalled

; Install Docker Desktop
Filename: "powershell.exe"; Parameters: "-Command `"if (-not (Get-AppxPackage -Name Docker.DockerDesktop -ErrorAction SilentlyContinue)) { $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri 'https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe' -OutFile $env:TEMP\DockerDesktopInstaller.exe; Start-Process -Wait -FilePath $env:TEMP\DockerDesktopInstaller.exe -ArgumentList 'install --quiet'; Remove-Item $env:TEMP\DockerDesktopInstaller.exe }`""; StatusMsg: "Installing Docker Desktop..."; Flags: runhidden shellexec waituntilterminated; Description: "Installing Docker Desktop..."

; Run the main PowerShell script
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File `"{tmp}\install.ps1`""; StatusMsg: "Installing Hermes AI Agent..."; Flags: runhidden shellexec waituntilterminated; Verb: runas; Description: "Configuring Hermes AI Agent..."

[Code]
function IsPowerShellInstalled: Boolean;
var
  ResultCode: Integer;
begin
  Result := False;
  if Exec('powershell.exe', '-Command "Get-Command pwsh -ErrorAction SilentlyContinue"', '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then
    Result := (ResultCode = 0);
end;
