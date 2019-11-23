
if not defined CMD_DBG call header.cmd

%CMD_DBG% "=== Script %~n0 started ==="

:: DBsync.exe и xml - в %WINDIR%
set /a IP_DBL_BLOCK=%ip_base% + 1 + (%BLOCK% + 2) % 2
call debug_lvl.cmd 2 "%~n0" "ip_base=%ip_base%; BLOCK=%BLOCK%; IP_DBL_BLOCK=%IP_DBL_BLOCK%"

call get_var.cmd -f DBSYNC:path_to_install -v PATH_DBS -q "Specify the folder name for install DBsync "
call debug_lvl.cmd 2 "%~n0" "PATH_DBS=%PATH_DBS%"
call get_var.cmd -f DBSYNC:version -v version -q "Specify the build number of DBsync."
call debug_lvl.cmd 2 "%~n0" "version=%version%"

call logging.cmd %fCONS% %fLOG% -m"DBsync copy... "
Setlocal EnableDelayedExpansion
if exist %SOFT_INST%\master\DBsync.%version%.zip (
	7z x -y -o"%PATH_DBS%" -r %SOFT_INST%\master\DBsync.%version%.zip >nul 2>nul
	if !errorlevel! == 0 (
		%CMD_OkCr%
		call logging.cmd %fCONS% %fLOG% -m"Run command sed for editing config.xml... "
		for /f "tokens=1" %%i in ('findstr /i /n /c:connect2 "%PATH_DBS%\config.xml"') do set var=%%i
		set var=!var::=!
		sed -i !var!s/Server=.*/"Server=%subNET%.%stepNET%.%IP_DBL_BLOCK%\/xe<\/Connect2>"/ "%PATH_DBS%\config.xml"
		if !errorlevel! == 0 (%CMD_OkCr%) else %CMD_ErrCr%
	) else (
		%CMD_ErrCr%
		call logging.cmd %fCONS% %fLOG% -cr -te -m"Unpacking error"
	)
) else (
	%CMD_ErrCr%
	call logging.cmd %fCONS% %fLOG% -cr -te -m"File %SOFT_INST%\master\DBsync.%version%.zip not found"
)

%CMD_DBG% "=== Script %~n0 completed ==="

exit /b
:: =============================================================================
:: =============================================================================
:: =============================================================================
