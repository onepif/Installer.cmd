:: ./choiceShell.cmd
call header.cmd

if "%1" == "1" (
	call :shell
) else if "%1" == "2" (
	call :programm
) else (
	Setlocal EnableDelayedExpansion
	call get_var.cmd -f %DEVICE%:run_as_desktop -v run_as -c "How to run software:;  Desktop   - 1;  Program - 2"

	if /i "!run_as!" == "yes" (
		call :desktop
		exit /b
	) else if /i "!run_as!" == "1" (
		call :desktop
		exit /b
	) else if /i "!run_as!" == "no" (
		call :programm
		exit /b
	) else if /i "!run_as!" == "2" (
		call :programm
		exit /b
	) else (
		call logging.cmd %fCONS% %fLOG% -te -cr -m"Incorrect value specified - %run_as%."
		exit /b
	)
	EndLocal
)
exit /b
:: =============================================================================
:: =============================================================================
:: =============================================================================
:desktop
	call debug_lvl.cmd 2 "%~n0" "Selected as 'desktop'"
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "Shell" /d "%WINDIR%\rc.SS.cmd" /f >nul
	reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SS" /f 2>nul >nul
exit /b
:: =============================================================================
:programm
	call debug_lvl.cmd 2 "%~n0" "Selected as 'programm'"
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SS" /d "%WINDIR%\rc.SS.cmd" /f >nul
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "Shell" /d "explorer.exe" /f >nul
exit /b
:: =============================================================================
