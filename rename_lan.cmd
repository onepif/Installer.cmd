:: ./rename_lan.cmd

:: The script to re-name eth and set ip address.
:: For the correct operation of the script must be run with administrator privileges

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

if not defined CMD_DBG call header.cmd

%CMD_DBG% "=== Script %~n0 started ==="

call logging.cmd %fCONS% %fLOG% -cr -m"Rename network connections and sets the IP address"
set count=0
set IP_WS=%1
if not defined IP_WS set IP_WS=%BLOCK%
for /f "usebackq skip=3 tokens=4*" %%i in (`netsh interface show interface`) do call :sub20 %%i "%%j"

%CMD_DBG% "=== Script %~n0 completed ==="

exit /b
:: =============================================================================
:: =============================================================================
:: =============================================================================
:sub20
	set /a count+=1
	set /a num=%count%*%stepNET%
	set arg1=%1
	call debug_lvl.cmd 2 "%~n0" "arg1=%1, arg2=%~2"

	if "%~2"=="" (call logging.cmd %fCONS% %fLOG% -tw -m "%1 to LAN%count%" -cr) else call logging.cmd %fCONS% %fLOG% -tw -m "%1 + %~2 to LAN%count%" -cr
	call debug_lvl.cmd 2 "%~n0" "LAN%count%: %subNET%.%num%.%IP_WS%"

	call logging.cmd %fCONS% %fLOG% -m"LAN%count%... "
	Setlocal EnableDelayedExpansion
	if "%~2"=="" (
		if "%arg1:~0,3%" == "LAN" (%CMD_Skip%) else (
			netsh interface set interface name = %1 newname = LAN%count% 1>nul
			if !errorlevel! == 0 (%CMD_Ok%) else %CMD_Err%
		)
	) else (
		netsh interface set interface name = "%1 %~2" newname = LAN%count% 1>nul
		if !errorlevel! == 0 (%CMD_Ok%) else %CMD_Err%
	)
	if "%arg1:~0,3%" == "LAN" (%CMD_SkipCr%) else (
		netsh interface ipv4 set address LAN%count% static %subNET%.%num%.%IP_WS% 255.255.255.0 %subNET%.%num%.2 1 1>nul
		if !errorlevel! == 0 (%CMD_OkCr%) else %CMD_ErrCr%
	)
	EndLocal
exit /b
:: =============================================================================
