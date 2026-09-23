#define MyAppName "OyazDesk"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Vahid Hedyati"
#define MyAppURL "https://vahid.hedyati.ir"
#define MyAppExeName "OyazDesk.exe"

[Setup]
AppId={{D37E6F40-8F92-4B21-B072-OYAZDESK2026}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
; قفل کردن اینستالر روی معماری ۶۴ بیتی خالص جهت نصب در C:\Program Files
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
OutputDir=output
OutputBaseFilename=OyazDesk-Setup-v1.0
SetupIconFile=branding\icon.ico
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin
CloseApplications=yes
RestartApplications=no
UninstallDisplayIcon={app}\{#MyAppExeName}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
; کپی تمامی فایل‌های هسته فلاتر، DLLها و دیتا
Source: "dist\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
; ۱. نصب بی‌صدا و قطعی سرتیفیکیت در مخزن معتمد سیستم مقصد
Filename: "certutil.exe"; Parameters: "-addstore -f ""Root"" ""{app}\VahidHedyati-RootCA.cer"""; Flags: runhidden

; ۲. باز کردن فایروال برای اتصال مستقیم در شبکه کارخانه
Filename: "netsh.exe"; Parameters: "advfirewall firewall add rule name=""OyazDesk App"" dir=in action=allow program=""{app}\{#MyAppExeName}"" enable=yes"; Flags: runhidden
Filename: "netsh.exe"; Parameters: "advfirewall firewall add rule name=""OyazDesk Direct Port"" dir=in action=allow protocol=TCP localport=21118"; Flags: runhidden

; ۳. راه‌اندازی سرویس دائمی ویندوز
Filename: "{app}\{#MyAppExeName}"; Parameters: "--install-service"; Flags: runhidden
Filename: "{app}\{#MyAppExeName}"; Parameters: "--start-service"; Flags: runhidden

; ۴. اجرای نرم‌افزار پس از نصب
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "{app}\{#MyAppExeName}"; Parameters: "--stop-service"; Flags: runhidden
Filename: "{app}\{#MyAppExeName}"; Parameters: "--uninstall-service"; Flags: runhidden
Filename: "taskkill.exe"; Parameters: "/F /IM {#MyAppExeName} /T"; Flags: runhidden
Filename: "netsh.exe"; Parameters: "advfirewall firewall delete rule name=""OyazDesk App"""; Flags: runhidden
Filename: "netsh.exe"; Parameters: "advfirewall firewall delete rule name=""OyazDesk Direct Port"""; Flags: runhidden