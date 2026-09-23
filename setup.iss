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

[InstallDelete]
; حذف ایمن فایل‌های قفل‌شده قبلی قبل از کپی نسخه جدید
Type: files; Name: "{app}\{#MyAppExeName}"
Type: files; Name: "{app}\librustdesk.dll"

[Files]
Source: "dist\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
; ۱. توقف سرویس‌های قدیمی پیش از شروع کار
Filename: "taskkill.exe"; Parameters: "/F /IM {#MyAppExeName} /T"; Flags: runhidden
Filename: "sc.exe"; Parameters: "stop {#MyAppName}"; Flags: runhidden

; ۲. نصب قطعی سرتیفیکیت دائمی وحید هدیتی
Filename: "certutil.exe"; Parameters: "-addstore -f ""Root"" ""{app}\VahidHedyati-RootCA.cer"""; Flags: runhidden

; ۳. باز کردن فایروال جهت ارتباط مستقیم شبکه داخلی کارخانه
Filename: "netsh.exe"; Parameters: "advfirewall firewall add rule name=""OyazDesk App"" dir=in action=allow program=""{app}\{#MyAppExeName}"" enable=yes"; Flags: runhidden
Filename: "netsh.exe"; Parameters: "advfirewall firewall add rule name=""OyazDesk Direct Port"" dir=in action=allow protocol=TCP localport=21118"; Flags: runhidden

; ۴. ثبت و اجرای سرویس سیستمی دائم
Filename: "{app}\{#MyAppExeName}"; Parameters: "--install-service"; Flags: runhidden
Filename: "{app}\{#MyAppExeName}"; Parameters: "--start-service"; Flags: runhidden

; ۵. اجرای برنامه پس از اتمام نصب
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "{app}\{#MyAppExeName}"; Parameters: "--stop-service"; Flags: runhidden
Filename: "{app}\{#MyAppExeName}"; Parameters: "--uninstall-service"; Flags: runhidden
Filename: "taskkill.exe"; Parameters: "/F /IM {#MyAppExeName} /T"; Flags: runhidden
Filename: "netsh.exe"; Parameters: "advfirewall firewall delete rule name=""OyazDesk App"""; Flags: runhidden
Filename: "netsh.exe"; Parameters: "advfirewall firewall delete rule name=""OyazDesk Direct Port"""; Flags: runhidden