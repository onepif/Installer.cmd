@echo off
color 17

call logging.cmd %fCONS% %fLOG% -m"Disable autorun... "

reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Cdrom" /v AutoRun /t reg_dword /d 0 /f >nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Explorer" /v NoDriveTypeAutoRun /t reg_dword /d 0xff /f >nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\IniFileMapping" /v "Autorun.inf" /d "@SYS:DoesNotExist" /f >nul
%CMD_OkCr%

exit /b
