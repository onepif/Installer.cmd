:: ./install_armv.cmd

:: The install script for soft @ARMV.
:: For the correct operation of the script must be run with administrator privileges

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

if not defined FLAG_DBG call header.cmd

%CMD_DBG% "=== Script %~n0 started ==="

call get_var.cmd -f PLAYER3:version -v version -q "Specify the build number of software for installation "

call debug_lvl.cmd 2 "%~n0" "errorlevel=%errorlevel%, version=%version%"
call debug_lvl.cmd 2 "%~n0" "Build number: %version%"

call get_var.cmd -f PLAYER3:path_to_install -v PATH_PELENG -q "Specify the folder name for install ARMV "
if /i %PROCESSOR_ARCHITECTURE%==amd64 (
	echo %PATH_PELENG%>%tmp%\tmp.txt
	sed -i "s/Program Files\\/Program Files (x86)\\/i" %tmp%\tmp.txt
	set /p PATH_PELENG=<%tmp%\tmp.txt
)
call debug_lvl.cmd 2 "%~n0" "PATH_PELENG=%PATH_PELENG%"
call setxx.cmd PATH_PELENG "%PATH_PELENG%"

Setlocal EnableDelayedExpansion
	if exist %SOFT_INST%\smar-t\setup_armv_%version%.exe (
		call %SOFT_INST%\smar-t\setup_armv_%version%.exe 2>nul

		set /a var1=%ip_base%+1
		set /a var2=%ip_base%+2

		if exist "%PATH_PELENG%"/config.ini (
			sed -i /"size=0"/d "%PATH_PELENG%"/config.ini
			sed -i s/"\[paths\]"/"[paths]\nsize=2\n1\\path=\/\/%subNET%.%stepNET%.!var1!\/Signals\n1\\islast=false\n2\\path=\/\/%subNET%.%stepNET%.!var2!\/Signals\n2\\islast=false\n"/ "%PATH_PELENG%"/config.ini
		) else (
			echo [paths]>"%PATH_PELENG%"/config.ini
			echo size=^2>>"%PATH_PELENG%"/config.ini
			echo 1\path=//%subNET%.%stepNET%.!var1!/Signals>>"%PATH_PELENG%"/config.ini
			echo 1\islast=false>>"%PATH_PELENG%"/config.ini
			echo 2\path=//%subNET%.%stepNET%.!var2!/Signals>>"%PATH_PELENG%"/config.ini
			echo 2\islast=false>>"%PATH_PELENG%"/config.ini
		)
	) else (
		call logging.cmd %fCONS% %fLOG% -cr -te -m"File %SOFT_INST%\smar-t\setup_armv_%base_ver%.%def_ver%.exe not found"
	)
EndLocal

%CMD_DBG% "=== Script %~n0 completed ==="

exit /b
:: =============================================================================
:: =============================================================================
:: =============================================================================
