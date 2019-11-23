@echo off
color 17

cd /d %~d0

set LOGIN=ARMZ
set PASS=1
if x%COMPUTERNAME%==xBOI-1 (set PATH_PELENG=D:\ARMZ) else set PATH_PELENG=%PROGRAMFILES%\Peleng\ARMZ

:: [Auto logon]
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "AutoAdminLogon" /t reg_dword /d 1 /f >nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "DefaultDomainName" /d "PELENG" /f >nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "DefaultUserName" /d %LOGIN% /f >nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "DefaultPassword" /d "%PASS%" /f >nul

net user %LOGIN% %PASS% /add /expires:never >nul
net localgroup "Пользователи" %1 /add >nul

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "Shell" /d "%PATH_PELENG%\Recorder.exe" /f >nul
:: =============================================================================
:: =============================================================================
