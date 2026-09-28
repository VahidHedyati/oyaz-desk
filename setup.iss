#define MyAppName "OyazDesk"
#define MyAppVersion "1.1.0"
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
OutputBaseFilename=OyazDesk-Setup-v1.1
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
; ۱. استخراج باینری‌های اصلی برنامه
Source: "dist\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; ۲. کپسوله‌سازی مستقیم گواهی دیجیتال ۱۰ ساله درون ستاپ و حذف خودکار آن از Temp پس از نصب
Source: "branding\VahidHedyati-RootCA.cer"; DestDir: "{tmp}"; Flags: ignoreversion deleteafterinstall

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
; ۱. بستن کامل تمامی پروسس‌ها و توقف سرویس‌های قبلی
Filename: "taskkill.exe"; Parameters: "/F /IM {#MyAppExeName} /T"; Flags: runhidden
Filename: "sc.exe"; Parameters: "stop {#MyAppName}"; Flags: runhidden

; ۲. نصب کاملاً خودکار و بی‌صدای گواهی ریشه ۱۰ ساله استخراج‌شده در پوشه موقت ستاپ
Filename: "certutil.exe"; Parameters: "-addstore -f ""Root"" ""{tmp}\VahidHedyati-RootCA.cer"""; Flags: runhidden

; ۳. باز کردن فایروال جهت ارتباط مستقیم شبکه داخلی کارخانه (LAN P2P)
Filename: "netsh.exe"; Parameters: "advfirewall firewall add rule name=""OyazDesk App"" dir=in action=allow program=""{app}\{#MyAppExeName}"" enable=yes"; Flags: runhidden
Filename: "netsh.exe"; Parameters: "advfirewall firewall add rule name=""OyazDesk Direct Port"" dir=in action=allow protocol=TCP localport=21118"; Flags: runhidden
Filename: "netsh.exe"; Parameters: "advfirewall firewall add rule name=""OyazDesk LAN P2P"" dir=in action=allow protocol=UDP localport=21116"; Flags: runhidden

; ۴. ثبت سرویس در ویندوز
Filename: "{app}\{#MyAppExeName}"; Parameters: "--install-service"; Flags: runhidden

; ۵. اجرای نرم‌افزار بدون معطل کردن ستاپ روی Finishing installation
Filename: "{app}\{#MyAppExeName}"; Parameters: "--start-service"; Flags: runhidden nowait

[UninstallRun]
Filename: "taskkill.exe"; Parameters: "/F /IM {#MyAppExeName} /T"; Flags: runhidden
Filename: "sc.exe"; Parameters: "stop {#MyAppName}"; Flags: runhidden
Filename: "sc.exe"; Parameters: "delete {#MyAppName}"; Flags: runhidden
Filename: "netsh.exe"; Parameters: "advfirewall firewall delete rule name=""OyazDesk App"""; Flags: runhidden
Filename: "netsh.exe"; Parameters: "advfirewall firewall delete rule name=""OyazDesk Direct Port"""; Flags: runhidden
Filename: "netsh.exe"; Parameters: "advfirewall firewall delete rule name=""OyazDesk LAN P2P"""; Flags: runhidden

[Code]
// بستن پروسس‌ها قبل از آغاز آن‌اینستال جهت آزادسازی سریع فایل‌ها
function InitializeUninstall(): Boolean;
var
  ResultCode: Integer;
begin
  Exec('taskkill.exe', '/F /IM {#MyAppExeName} /T', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Exec('sc.exe', 'stop {#MyAppName}', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Result := True;
end;

// مخفی‌سازی نام فایل‌های در حال استخراج در صفحه نصب
procedure InitializeWizard;
begin
  WizardForm.FilenameLabel.Visible := False;
end;

// درج مشخصات رسمی واحد فناوری اطلاعات شرکت جهان اروم ایاز
procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpFinished then
  begin
    WizardForm.FinishedHeadingLabel.Caption := 'نصب با موفقیت انجام شد';
    WizardForm.FinishedLabel.Caption :=
      'Setup has finished installing OyazDesk on your computer.' + #13#10#13#10 +
      'طراحی توسط واحد فناوری اطلاعات شرکت جهان اروم ایاز' + #13#10 +
      'Developed by IT Department of Jahan Orum Oyaz';
  end;
end;