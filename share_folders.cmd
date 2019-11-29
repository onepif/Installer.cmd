:: =============================================================================
:: ./share_folders.cmd
:: <charset=cp866/>
:: =============================================================================

:: The script to share folders.
:: For the correct operation of the script must be run with administrator privileges

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

@if not defined CMD_DBG call header.cmd

%CMD_DBG% "=== Script %~n0 started ==="

set count=0
for %%i in (%*) do set /a count+=1
call debug_lvl 2 "%~n0" "count=%count%"

if %count% EQU 8 (
	for %%i in (%*) do call :arg_parsing %%i
) else (
	call logging.cmd %fCONS% %fLOG% -te -m "Argument set error" -cr
)
call debug_lvl 2 "%~n0" "pUser=%pUser%, pPass=%pPass%, pPath=%pPath%, pShare=%pShare%"

if /i not %USERNAME% == %pUser% (
	call logging %fCONS% %fLOG% -m "Create user: %pUser%" -cr
	net user %pUser% %pPass% /add /expires:never >nul 2>nul
	net localgroup "Администраторы" %pUser% /add >nul 2>nul
) else (
	call logging %fCONS% %fLOG% -m "Set user password" -cr
	net user %pUser% %pPass% >nul 2>nul
)

call logging %fCONS% %fLOG% -m "Create share: %pShare%... "
net share %pShare%=%pPath% /grant:%pUser%,full >nul 2>nul
if %errorlevel% == 0 (%CMD_OkCr%) else (
	if %errorlevel% == 2 (%CMD_OkCr%) else %CMD_ErrCr%
)

%CMD_DBG% "=== Script %~n0 completed ==="

exit /b %errorlevel%
:: =============================================================================
:: =============================================================================
:: =============================================================================
:arg_parsing
	if /i "%FLAG_GET_PARAM%" == "U" (
		set pUser=%1
		set FLAG_GET_PARAM=
		exit /b
	) else if /i "%FLAG_GET_PARAM%" == "P" (
		set pPass=%1
		set FLAG_GET_PARAM=
		exit /b
	) else if /i "%FLAG_GET_PARAM%" == "D" (
		set pPath=%1
		set FLAG_GET_PARAM=
		exit /b
	) else if /i "%FLAG_GET_PARAM%" == "S" (
		set pShare=%1$
		set FLAG_GET_PARAM=
		exit /b
	)

	if /i "%1" == "-u" (
		set FLAG_GET_PARAM=U
	) else if /i "%1" == "-p" (
		set FLAG_GET_PARAM=P
	) else if /i "%1" == "-d" (
		set FLAG_GET_PARAM=D
	) else if /i "%1" == "-s" (
		set FLAG_GET_PARAM=S
	)
exit /b
:: =============================================================================
