:: ./configure_trs.cmd

:: For the correct operation of the script must be run with administrator privileges

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

if not defined CMD_DBG call header.cmd

:: ru, po, dl, dp, zip
set ru=1&set po=2&set dl=3&set dp=4&set zi=5
set LIST="Select mode WS:;  1 - Exercise leader;  2 - Pilot Operator;  3 - Radar Dispatcher;  4 - Procedural Control Manager;  5 - SPTA"

%CMD_DBG% "=== Script %~n0 started ==="

call check_admin.cmd

set ws=&set arg=%*
call debug_lvl.cmd 4 %~n0 "arg=%arg%"
if defined arg for %%i in (%*) do if /i %%i==-D (
	set FLAG_DEBUG=1
	set arg=%arg:-d=%
	call logging.cmd -td -m "Debug mode is ON" -cr
)

call debug_lvl.cmd 4 %~n0 "arg=%arg%"
if defined arg for %%i in (%arg%) do call :arg_parsing %%i

call get_var.cmd -d 254 -f TRS:ip_base -v ip_base -n "Specify base IP address "
call debug_lvl.cmd 2 %~n0 "base IP address selected: %ip_base%"

call debug_lvl.cmd 4 %~n0 "ws: %ws%"
Setlocal EnableDelayedExpansion
	if not defined ws (
		call get_var -v ws -c %LIST%
		choice /c 1234567q /n /m "Specify the number WS [1..5]: "
		set NUMB_WS=!errorlevel!
		call :configure !ws!
		set /a IP_WS=!ws!-1
	) else (
		set /a NUMB_WS=!ws:~-1!
		call :configure !%ws:~,2%!
		set /a IP_WS=!%ws:~,2%!-1
	)
	set /a IP_WS*=10
	set /a IP_WS+=%ip_base%

	call debug_lvl 2 %~n0 "IP_WS=%IP_WS%, NUMB_WS=%NUMB_WS%"

	if !NUMB_WS! GTR 9 (
		set NUMB_WS=1
		call rename_pc.cmd BS-!ALIAS_WS!
	) else if !NUMB_WS! == 0 (
		set NUMB_WS=1
		call rename_pc.cmd BS-!ALIAS_WS!
	) else (
		call rename_pc.cmd BS-!ALIAS_WS!!NUMB_WS!
	)

	set /a IP_WS+=!NUMB_WS!

	call debug_lvl.cmd 2 "%~n0" "Selected WS: %NAME_WS:~1,-1%, Alias: %ALIAS_WS%, №WS=%NUMB_WS%, IP_WS=%IP_WS%"

	call rename_lan.cmd %IP_WS%

:: настройка масштабирования экрана
	if not defined sid (call get_sid.cmd)
	reg add HKLM\SYSTEM\ControlSet001\Control\GraphicsDrivers\ScaleFactors\CMN15C50_03_07DE_C4^B87E39C17B9D3B50DE4BD4E519D81377 /v DpiValue /t reg_dword /d 2 /f >nul
	reg add "HKU\%sid%\Control Panel\Desktop\PerMonitorSettings\CMN15C50_03_07DE_C4^B87E39C17B9D3B50DE4BD4E519D81377" /v DpiValue /t reg_dword /d 0 /f >nul
	reg add "HKU\%sid%\Control Panel\Desktop\WindowMetrics" /v AppliedDPI /t reg_dword /d 134 /f >nul

EndLocal&(
	set NAME_WS=%NAME_WS%
	set ALIAS_WS=%ALIAS_WS%
	set NUMB_WS=%NUMB_WS%
	set IP_WS=%IP_WS%
)

%CMD_DBG% "=== Script %~n0 completed ==="

exit /b
:: =============================================================================
:: =============================================================================
:: =============================================================================
:: =============================================================================
:arg_parsing
	set arg=%1
	set arg=%arg:"=%
	call debug_lvl.cmd 2 %~n0 "arg=%arg%"

	if x%FLAG_GET_PARAM% == xNULL (
		echo.>nul
		exit /b
	) else if /i x%FLAG_GET_PARAM% == xM (
		set FLAG_GET_PARAM=
		if not %arg:~0,1% == - (
			set ws=%arg%
			exit /b
		)
	)

	if /i "%arg%" == "" (
		echo.>nul
		exit /b
	) else if /i %arg:~0,2% == -M (
		if "%arg:~2%" == "" (set FLAG_GET_PARAM=M) else set ws=%arg:~2%
	) else if /i %arg:~0,2% == -H (
		call :usage
	)
exit /b
:: =============================================================================
:configure
	if %1 == 0 (
		echo.>nul
	) else if %1 == 1 (
		set NAME_WS="Руководитель упражнения"
		set ALIAS_WS=RU
	) else if %1 == 2 (
		set NAME_WS="Пилот Оператор"
		set ALIAS_WS=PO
	) else if %1 == 3 (
		set NAME_WS="Дисп. РЛК"
		set ALIAS_WS=DL
	) else if %1 == 4 (
		set NAME_WS="Дисп. ПК"
		set ALIAS_WS=DP
	) else if %1 == 5 (
		set NAME_WS="ЗИП"
		set ALIAS_WS=ZIP
	) else (
		set NAME_WS=NULL
		set ALIAS_WS=NULL
	)
exit /b
:: =============================================================================
:usage
	<nul set /p var="Quick reference on the use of the script: -d, -m{ dl[X]| dp[X]| po[X]| ru[X]| zip[X]}, -h"
	echo.
	<nul set /p var="Press any key to exit..."
	pause >nul
	start cmd /k
exit
:: =============================================================================
