:: ./install_rts.cmd

:: The install script for soft @RTS.
:: For the correct operation of the script must be run with administrator privileges

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

if not defined CMD_DBG call header.cmd

%CMD_DBG% "=== Script %~n0 started ==="

if not exist %WINDIR%\7z.exe copy /Y "%SOFT_ENV%\7z\%PROCESSOR_ARCHITECTURE%\*.exe" %WINDIR% >nul

call get_var.cmd -f "RTS:path_to_install" -v PATH_PELENG -q "Specify the folder name for install RTS "
if /i %PROCESSOR_ARCHITECTURE%==amd64 (
	echo %PATH_PELENG%>%tmp%\tmp.txt
	sed -i "s/Program Files\\/Program Files (x86)\\/i" %tmp%\tmp.txt
	set /p PATH_PELENG=<%tmp%\tmp.txt
)
call debug_lvl.cmd 2 "%~n0" "PATH_PELENG=%PATH_PELENG%"
call setxx.cmd PATH_PELENG "%PATH_PELENG%"

call logging.cmd %fCONS% %fLOG% -cr -m"Install soft environment"

if exist %SOFT_ENV%\vcredist_x%PROCESSOR_ARCHITECTURE:~-2%_2008sp1.exe (
	start %SOFT_ENV%\vcredist_x%PROCESSOR_ARCHITECTURE:~-2%_2008sp1.exe /q >nul 2>nul
) else call logging.cmd %fCONS% %fLOG% -cr -te -m"%SOFT_ENV%\vcredist_x%PROCESSOR_ARCHITECTURE:~-2%_2008sp1.exe not found"

call logging.cmd %fCONS% %fLOG% -m"Install RTS base pack... "

Setlocal EnableDelayedExpansion
if exist %SOFT_INST%\rts\rts_base.zip (
	7z x -y -o"%PATH_PELENG%" -r %SOFT_INST%\rts\rts_base.zip >nul 2>nul
	if !errorlevel! == 0 (%CMD_Ok%) else (
		%CMD_ErrCr%
		call logging.cmd %fCONS% %fLOG% -cr -te -m"Unpacking error"
	)
	move /y "%PATH_PELENG%"\*.dll %WINDIR% >nul 2>nul
	if !errorlevel! == 0 (%CMD_OkCr%) else %CMD_ErrCr%
) else (
	%CMD_ErrCr%
	call logging.cmd %fCONS% %fLOG% -cr -te -m"File %SOFT_INST%\rts\rts_base.zip not found"
)
EndLocal

call get_var.cmd -f RTS:version -v version -q "Specify the build number of software for installation rts_Release_"

call logging.cmd %fCONS% %fLOG% -m"Install RTS Release pack... "
Setlocal EnableDelayedExpansion
if exist %SOFT_INST%\rts\rts_Release_%version%.zip (
	7z x -y -o"%PATH_PELENG%" -r "%SOFT_INST%\rts\rts_Release_%version%.zip" 2>nul 1>nul
	if !errorlevel! == 0 (%CMD_OkCr%) else (
		%CMD_ErrCr%
		call logging.cmd %fCONS% %fLOG% -cr -te -m"Unpacking error"
	)
) else (
	%CMD_ErrCr%
	call logging.cmd %fCONS% %fLOG% -cr -te -m"File %SOFT_INST%\rts\rts_Release_%version%.zip not found"
)
EndLocal

%CMD_DBG% "=== Script %~n0 completed ==="

exit /b
