:: ./add_user.cmd
:: <charset=cp866/>

call header.cmd

%CMD_DBG% "=== Script %~n0 started ==="
:: Установка признака исполнения скрипта add_user
call setxx.cmd FLAG_ADD_U 1

:: UAC -> off
for /F "usebackq tokens=3" %%i in (`reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA`) do set var=%%i
if "%var%" equ "0x1" (
	call logging.cmd %fCONS% %fLOG% -m"UAC off... "
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t reg_dword /d 0 /f >nul
	%CMD_OkCr%
) else call logging.cmd %fCONS% %fLOG% -tw -cr -m"UAC allready off"

call get_var.cmd -f COMMON:uname -v pUser -q "Specify 'USERNAME'"
call get_var.cmd -f COMMON:password -v pPass -q "Specify 'PASSWORD'"
call setxx.cmd pUser %pUser%
call setxx.cmd pPass %pPass%

:: [Auto logon]
call autologon.cmd

Setlocal EnableDelayedExpansion
	set FLAG_USER=0
	if /i not %USERNAME% == %pUser% (
		for /f "tokens=2 delims==" %%i in ('wmic useraccount list full^|findstr /b /i /c:name') do if "%pUser%" == "%%i" (set FLAG_USER=1)
		if not !FLAG_USER! EQU 1 (
			call logging.cmd %fCONS% %fLOG% -m"Create user '%pUser%'... "
			net user %pUser% %pPass% /add /expires:never >nul 2>nul
			if !errorlevel! == 0 (%CMD_Ok%) else (if !errorlevel! ==2 (%CMD_Skip%) else %CMD_Err%)
			if '%LOCALE_ID%'=='00000419' (
				net localgroup "Администраторы" %pUser% /add >nul 2>nul
			) else net localgroup "Administrators" %pUser% /add >nul 2>nul
			if !errorlevel! == 0 (%CMD_OkCr%) else %CMD_ErrCr%
		) else call :set_pass
	) else call :set_pass
Endlocal

%CMD_DBG% "=== Script %~n0 completed ==="

Setlocal EnableDelayedExpansion
if /i not %USERNAME% == %pUser% (
	call setxx.cmd FLAG_DEBUG %FLAG_DEBUG%
	call setxx.cmd FLAG_CONF %FLAG_CONF%
	call setxx.cmd fCONF %fCONF%
	call setxx.cmd fLOG %fLOG%
	choice /c rlq /d l /t 7 /n /m "Press 'R' for reboot or 'L' for logoff [r/L]: "
	if /i !errorlevel! == 1 (
		if defined FLAG_DEBUG call :_pause
		shutdown.exe /r /t 0
		exit 0
	) else if !errorlevel! == 2 (
		if defined FLAG_DEBUG call :_pause
		logoff
		exit 0
	) else if !errorlevel! == 3 (
		if defined FLAG_DEBUG call :_pause
		call work_int.cmd
	)
) else (
	%CMD_EMPTY%
	call logging.cmd %fCONS% %fLOG% -tw -m "Auto reStart Main" -cr
	exit /b
)
:: =============================================================================
:: =============================================================================
:: =============================================================================
:set_pass
	call logging.cmd %fCONS% %fLOG% -tw -cr -m"User '%pUser%' already exists"
	call logging.cmd %fCONS% %fLOG% -m"Setting password for user '%USERNAME%': %pPass%... "
	net user %pUser% %pPass% >nul 2>nul
	if !errorlevel! == 0 (%CMD_OkCr%) else %CMD_ErrCr%
exit /b
:: =============================================================================
:_pause
	echo.
	<nul set /p var="Press any key to continue..."
	pause >nul
exit /b
:: =============================================================================
