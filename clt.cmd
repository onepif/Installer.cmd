@echo off
color 17

:: MaxAllowedPhaseOffset - максимально допустипое расхождение:
::		0x012c - 5 мин
::		0x0e10 - 1 час
if "%1" == "" (
	set s1=192.168.10.11
	set s2=192.168.10.12
) else (
	set s1=%1
	set s2=%2
)

reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Config" /v MaxAllowedPhaseOffset /t reg_dword /d 1 /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Config" /v MaxPosPhaseCorrection /t reg_dword /d 0xFFFFFFFF /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Config" /v MaxNegPhaseCorrection /t reg_dword /d 0xFFFFFFFF /f >nul

reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" /v "NtpServer" /d "%s1%,0x1 %s2%,0x1" /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" /v "Type" /d "NTP" /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient" /v Enabled /t reg_dword /d 1 /f >nul
:: 0x003c - 60 сек
:: 0x0e10 - 3600 сек
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient" /v SpecialPollInterval /t reg_dword /d 0x0e10 /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpServer" /v Enabled /t reg_dword /d 0 /f >nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers" /v "" /d "6" /f >nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers" /v "6" /d "%s1%" /f >nul
