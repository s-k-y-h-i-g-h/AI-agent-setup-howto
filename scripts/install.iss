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

[Files]
Source: "install.ps1"; DestDir: "{tmp}"; Flags: deleteafterinstall

[Run]
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -File \"{tmp}\install.ps1\""; StatusMsg: "Installing Hermes AI Agent..."; Flags: runhidden shellexec waituntilterminated; Verb: runas