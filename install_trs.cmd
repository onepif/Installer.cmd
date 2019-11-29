:: ./install_trs.cmd

:: The install script for soft @TRS (Blokc communications).
:: For the correct operation of the script must be run with administrator privileges

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

if not defined CMD_DBG call header.cmd

%CMD_DBG% "=== Script %~n0 started ==="

if not exist %WINDIR%\7z.exe copy /Y "%SOFT_ENV%\7z\%PROCESSOR_ARCHITECTURE%\*.exe" %WINDIR% >nul

call get_var.cmd -f TRS:path_to_install -v PATH_PELENG -q "Specify the folder name for install TRS "
if /i %PROCESSOR_ARCHITECTURE%==amd64 (
	echo %PATH_PELENG%>%tmp%\tmp.txt
	sed -i "s/Program Files\\/Program Files (x86)\\/i" %tmp%\tmp.txt
	set /p PATH_PELENG=<%tmp%\tmp.txt
)
call debug_lvl.cmd 2 "%~n0" "PATH_PELENG=%PATH_PELENG%"
call setxx.cmd PATH_PELENG "%PATH_PELENG%"

:: ru, po, dl, dp, zip
set LIST=ru po1 dl1 dl2 zip

call logging.cmd %fCONS% %fLOG% -m"Install TRS... "

Setlocal EnableDelayedExpansion
for %%i in (%SOFT_INST%\tdk\*.zip) do (
	if exist %%i (
		7z x -y -o"%PATH_PELENG%" -r %%i >nul 2>nul
		if !errorlevel! == 0 (%CMD_Ok%) else (
			%CMD_ErrCr%
			call logging.cmd %fCONS% %fLOG% -cr -te -m"Unpacking error: %%i"
		)
	) else (
		%CMD_ErrCr%
		call logging.cmd %fCONS% %fLOG% -cr -te -m"File %%i not found"
	)
)
EndLocal
%CMD_EMPTY%

call logging.cmd %fCONS% %fLOG% -m"Make scripts... "
for %%i in (%LIST%) do (
	echo cd /d %%~dp0>"%PATH_PELENG%"\etc\rc.d\set_host_%%i.cmd
	echo set_host.cmd -m %%i>>"%PATH_PELENG%"\etc\rc.d\set_host_%%i.cmd
)
%CMD_OkCr%

call logging.cmd %fCONS% %fLOG% -m"Share folders... "
call share_folders.cmd -u pilot -p pilot -d "%PATH_PELENG%" -s trs
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%
if not exist "%PATH_PELENG%"\rec (mkdir "%PATH_PELENG%"\rec)
call share_folders.cmd -u pilot -p pilot -d "%PATH_PELENG%"\rec -s rec
if %errorlevel% == 0 (%CMD_OkCr%) else %CMD_ErrCr%

%CMD_DBG% "=== Script %~n0 completed ==="

exit /b
:: =============================================================================
:: =============================================================================
:: =============================================================================
