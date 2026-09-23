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
Type: files; Name: "{app}\{#MyAppExeName}"
Type: files; Name: "{app}\librustdesk.dll"

[Files]
Source: "dist\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
; ۱. بستن کامل تمامی پروسس‌ها و توقف سرویس‌های قبلی
Filename: "taskkill.exe"; Parameters: "/F /IM {#MyAppExeName} /T"; Flags: runhidden
Filename: "sc.exe"; Parameters: "stop {#MyAppName}"; Flags: runhidden

; ۲. نصب بی‌صدای گواهی ریشه ۱۰ ساله اختصاصی وحید هدیتی
Filename: "certutil.exe"; Parameters: "-addstore -f ""Root"" ""{app}\VahidHedyati-RootCA.cer"""; Flags: runhidden

; ۳. باز کردن فایروال جهت ارتباط مستقیم شبکه داخلی کارخانه (LAN P2P)
Filename: "netsh.exe"; Parameters: "advfirewall firewall add rule name=""OyazDesk App"" dir=in action=allow program=""{app}\{#MyAppExeName}"" enable=yes"; Flags: runhidden
Filename: "netsh.exe"; Parameters: "advfirewall firewall add rule name=""OyazDesk Direct Port"" dir=in action=allow protocol=TCP localport=21118"; Flags: runhidden
Filename: "netsh.exe"; Parameters: "advfirewall firewall add rule name=""OyazDesk LAN P2P"" dir=in action=allow protocol=UDP localport=21116"; Flags: runhidden

; ۴. ثبت سرویس و بستن پردازش گرافیکی زودهنگام در سشن کاربر بدون آسیب به سرویس پس‌زمینه
Filename: "{app}\{#MyAppExeName}"; Parameters: "--install-service"; Flags: runhidden waituntilterminated
Filename: "powershell.exe"; Parameters: "-NoProfile -Command ""Start-Sleep -Milliseconds 600; Get-Process {#MyAppName} -ErrorAction SilentlyContinue | Where-Object { $_.SessionId -ne 0 } | Stop-Process -Force"""; Flags: runhidden

; ۵. اجرای تمیز و تک‌باره برنامه منحصراً پس از کلیک کاربر روی دکمه Finish
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "{app}\{#MyAppExeName}"; Parameters: "--stop-service"; Flags: runhidden
Filename: "{app}\{#MyAppExeName}"; Parameters: "--uninstall-service"; Flags: runhidden
Filename: "taskkill.exe"; Parameters: "/F /IM {#MyAppExeName} /T"; Flags: runhidden
Filename: "netsh.exe"; Parameters: "advfirewall firewall delete rule name=""OyazDesk App"""; Flags: runhidden
Filename: "netsh.exe"; Parameters: "advfirewall firewall delete rule name=""OyazDesk Direct Port"""; Flags: runhidden
Filename: "netsh.exe"; Parameters: "advfirewall firewall delete rule name=""OyazDesk LAN P2P"""; Flags: runhidden

[Code]
// مخفی‌سازی نام فایل‌های در حال استخراج جهت حفظ ظاهر شرکتی و تمیز
procedure InitializeWizard;
begin
  WizardForm.FilenameLabel.Visible := False;
end;