:: ./install_rts.cmd

:: The install script for soft @Tachyon.
:: For the correct operation of the script must be run with administrator privileges

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

if not defined CMD_DBG call header.cmd

%CMD_DBG% "=== Script %~n0 started ==="

:: Настройка правил Брандмауэра Windows для работы с табло...
call rules.cmd 5520 5522

call get_var.cmd -f "%DEVICE%:path_to_install" -v PATH_PELENG -q "Specify the folder name for install %DEVICE% "
if /i %PROCESSOR_ARCHITECTURE%==amd64 (
	echo %PATH_PELENG%>%tmp%\tmp.txt
	sed -i "s/Program Files\\/Program Files (x86)\\/i" %tmp%\tmp.txt
	set /p PATH_PELENG=<%tmp%\tmp.txt
)
call debug_lvl.cmd 2 "%~n0" "PATH_PELENG=%PATH_PELENG%"
call setxx.cmd PATH_PELENG "%PATH_PELENG%"

call logging.cmd %fCONS% %fLOG% -cr -m"Install soft environment"

if exist %SOFT_ENV%\vcredist_x%PROCESSOR_ARCHITECTURE:~-2%_2015sp3.exe (
	start %SOFT_ENV%\vcredist_x%PROCESSOR_ARCHITECTURE:~-2%_2015sp3.exe /q >nul 2>nul
) else call logging.cmd %fCONS% %fLOG% -cr -te -m"%SOFT_ENV%\vcredist_x%PROCESSOR_ARCHITECTURE:~-2%_2015sp3.exe not found"

call logging.cmd %fCONS% %fLOG% -m"Install %DEVICE% base pack... "
Setlocal EnableDelayedExpansion
if exist %SOFT_INST%\%DEVICE%\%DEVICE%_base.zip (
	7z x -y -o"%PATH_PELENG%" -r %SOFT_INST%\%DEVICE%\%DEVICE%_base.zip >nul 2>nul
	if !errorlevel! == 0 (%CMD_Ok%) else (
		%CMD_ErrCr%
		call logging.cmd %fCONS% %fLOG% -cr -te -m"Unpacking error"
	)
	move /y "%PATH_PELENG%"\*.dll %WINDIR% >nul 2>nul
	if !errorlevel! == 0 (%CMD_OkCr%) else %CMD_ErrCr%
) else (
	%CMD_ErrCr%
	call logging.cmd %fCONS% %fLOG% -cr -te -m"File %SOFT_INST%\%DEVICE%\%DEVICE%_base.zip not found"
)
EndLocal

call get_var.cmd -f %DEVICE%:version -v version -q "Specify the build number of software for installation %DEVICE%_Release_"
call logging.cmd %fCONS% %fLOG% -m"Install %DEVICE% Release pack... "
Setlocal EnableDelayedExpansion
if exist %SOFT_INST%\%DEVICE%\%DEVICE%_Release_%version%.zip (
	7z x -y -o"%PATH_PELENG%" -r "%SOFT_INST%\%DEVICE%\%DEVICE%_Release_%version%.zip" 2>nul 1>nul
	if !errorlevel! == 0 (%CMD_OkCr%) else (
		%CMD_ErrCr%
		call logging.cmd %fCONS% %fLOG% -cr -te -m"Unpacking error"
	)
) else (
	%CMD_ErrCr%
	call logging.cmd %fCONS% %fLOG% -cr -te -m"File %SOFT_INST%\%DEVICE%\%DEVICE%_Release_%version%.zip not found"
)
EndLocal

call get_var.cmd -f %DEVICE%:version_snd -v version -q "Specify the build number of Sound pack for installation %DEVICE%_Sound_"
call logging.cmd %fCONS% %fLOG% -m"Install %DEVICE% Sound pack... "
Setlocal EnableDelayedExpansion
if exist %SOFT_INST%\%DEVICE%\%DEVICE%_Release_%version%.zip (
	7z x -y -o"%PATH_PELENG%\Sound" -r "%SOFT_INST%\%DEVICE%\%DEVICE%_Sound_%version%.zip" 2>nul 1>nul
	if !errorlevel! == 0 (%CMD_OkCr%) else (
		%CMD_ErrCr%
		call logging.cmd %fCONS% %fLOG% -cr -te -m"Unpacking error"
	)
) else (
	%CMD_ErrCr%
	call logging.cmd %fCONS% %fLOG% -cr -te -m"File %SOFT_INST%\%DEVICE%\%DEVICE%_Release_%version%.zip not found"
)
EndLocal

%CMD_DBG% "=== Script %~n0 completed ==="

exit /b
