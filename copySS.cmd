if not defined CMD_DBG call header.cmd

if not defined step (set /a step=0)

%CMD_DBG% "=== Script %~n0 started ==="

:: dll => system32, SupervisorServer.exe, cmd, xml => %WINDIR%
call logging.cmd %fCONS% %fLOG% -m"Supervisor copy... "
if /i %PROCESSOR_ARCHITECTURE%==amd64 (
	copy /Y %SOFT_ENV%\sys\Supervisor\lib\*.dll %WINDIR%\sysWOW64 >nul 2>nul
) else copy /Y %SOFT_ENV%\sys\Supervisor\lib\*.dll %WINDIR%\system32 >nul 2>nul
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%

for /f %%i in (
	%SOFT_ENV%\sys\Supervisor\bin\Supervisor*.exe
	%SOFT_ENV%\sys\Supervisor\bin\rc.SS.cmd
	%SOFT_ENV%\sys\Supervisor\etc\*.xml
	logging.cmd
	debug_lvl.cmd
	header.cmd
	choiceShell.cmd
	get_var.cmd
	get_num.cmd
	choice_cli.cmd
	work_int.cmd
) do (
	copy /y %%i* %WINDIR%\ >nul 2>nul
	if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%
)

::copy /Y %SOFT_ENV%\sys\Supervisor\bin\Supervisor*.exe %WINDIR%\ >nul 2>nul
::if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%

::copy /Y %SOFT_ENV%\sys\Supervisor\etc\*.xml %WINDIR%\ >nul 2>nul
::if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%

::copy /Y %SOFT_ENV%\sys\Supervisor\bin\rc.SS.cmd %WINDIR%\ >nul 2>nul
::if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%

::copy /Y logging.cmd %WINDIR%\ >nul 2>nul
::if %errorlevel% == 0 (%CMD_OkCr%) else %CMD_ErrCr%

if "%1" == "" (
	if not defined DEVICE (
		%CMD_EMPTY%
		call logging.cmd %fCONS% %fLOG% -cr -tw -m "---=== !!! ATTENTION !!! ===---"
		call logging.cmd %fCONS% %fLOG% -cr -tw -m "No item selected!"
		call logging.cmd %fCONS% %fLOG% -cr -tw -m "Edit the %WINDIR%\SupervisorServer.xml file manually."
		%CMD_EMPTY%
	) else call :sub
) else (
	set POUCH_CSS=%DEVICE%
	set DEVICE=%1
	call :sub
	set DEVICE=%POUCH_CSS%
)
%CMD_DBG% "=== Script %~n0 completed ==="

exit /b
:: =============================================================================
:sub
	for /f "tokens=1*" %%i in ('echo "%PATH_PELENG%"^|sed s/\\/\\\\/g') do if "%%j" == "" (set path_tmp=%%i) else set path_tmp=%%i %%j
	set path_tmp=%path_tmp:"=%
	call debug_lvl.cmd 2 "%~n0" "DEVICE=%DEVICE%, PATH_PELENG_TMP=%path_tmp%"

	Setlocal EnableDelayedExpansion
		if defined PATH_DBS (
			for /f "tokens=1*" %%i in ('echo %PATH_DBS%^|sed s/\\/\\\\/g') do if "%%j" == "" (set path_dbs_tmp=%%i) else set path_dbs_tmp=%%i %%j
			call debug_lvl.cmd 2 "%~n0" "PATH_DBS_TMP=!path_dbs_tmp!"
		)

		if %ID% == %TRS% (
			iconv.exe -f utf-8 -t cp1251 "%PATH_PELENG%"\etc\SS_trs.xml>%tmp%\tmp.xml
			call debug_lvl.cmd 2 "%~n0" "NAME_WS=%NAME_WS:~1,-1%, NUMB_WS=%NUMB_WS%."
			call logging.cmd %fCONS% %fLOG% -m"Run command sed for editing the Work station... "
			sed -i s/"Блок связи, ".*", конф\."/"Блок связи, %NAME_WS:~1,-1% %NUMB_WS%, конф\."/g %tmp%\tmp.xml 2>nul
			if !errorlevel! == 0 (%CMD_OkCr%) else %CMD_ErrCr%

			call logging.cmd %fCONS% %fLOG% -m"Run command sed for editing path to scripts... "
			sed -i s/^.*set_host_/"\t\t\t<path>%path_tmp%\\etc\\rc.d\\set_host_"/ %tmp%\tmp.xml 2>nul
			if !errorlevel! == 0 (%CMD_OkCr%) else %CMD_ErrCr%
			call logging.cmd %fCONS% %fLOG% -m"Run command sed for editing path to soft... "
			sed -i s/^.*%DEVICE%.exe/"\t\t\t<path>%path_tmp%\\bin\\%DEVICE%.exe"/i %tmp%\tmp.xml 2>nul
			if !errorlevel! == 0 (%CMD_OkCr%) else %CMD_ErrCr%
		) else (
			iconv.exe -f utf-8 -t cp1251 %SOFT_ENV%\sys\Supervisor\etc\SupervisorServer.xml >%tmp%\tmp.xml
			call logging.cmd %fCONS% %fLOG% -m"Run command sed for editing the Active_Group... "
			if defined FLAG_HOTR (
				sed -i s/^.*active_group.$/"\t<active_group>%DEVICE%HR<\/active_group>"/i %tmp%\tmp.xml 2>nul
				if !errorlevel! == 0 (%CMD_OkCr%) else %CMD_ErrCr%
				call logging.cmd %fCONS% %fLOG% -m"Run command sed for editing path to DBsync... "
				sed -i s/^.*DBsync.exe/"\t\t\t<path>!path_dbs_tmp!\\DBsync.exe"/ %tmp%\tmp.xml 2>nul
			) else (
				sed -i s/^.*active_group.$/"\t<active_group>%DEVICE%<\/active_group>"/i %tmp%\tmp.xml 2>nul
			)
			if !errorlevel! == 0 (%CMD_OkCr%) else %CMD_ErrCr%
			sed -in /active_group/p %tmp%\tmp.xml >%tmp%\tmp.txt
			set /p var=<%tmp%\tmp.txt
			call debug_lvl.cmd 8 "%~n0" "result: !var!"
			if %DEVICE% == BVZ (
				call logging.cmd %fCONS% %fLOG% -m"Run command sed for editing path to VGrabber... "
				sed -i s/^.*VGrabber.exe/"\t\t\t<path>%path_tmp%\\VGrabber.exe"/i %tmp%\tmp.xml 2>nul
			) else (
				call logging.cmd %fCONS% %fLOG% -m"Run command sed for editing path to %DEVICE%... "
				sed -i s/^.*%DEVICE%.exe/"\t\t\t<path>%path_tmp%\\%DEVICE%.exe"/i %tmp%\tmp.xml 2>nul
			)
			if !errorlevel! == 0 (%CMD_OkCr%) else %CMD_ErrCr%
		)
	EndLocal

	set PATH_DBS=
	call logging.cmd %fCONS% %fLOG% -m"Run command sed for editing path to log... "
	sed -i s/^.*%DEVICE%.log/"\t\t\t<log_path>%PROGRAMDATA%\\logfiles\\%DEVICE%.log"/i %tmp%\tmp.xml 2>nul
	if %errorlevel% == 0 (%CMD_OkCr%) else %CMD_ErrCr%
	iconv.exe -f cp1251 -t utf-8 %tmp%\tmp.xml >%WINDIR%\SupervisorServer.xml

	call logging.cmd %fCONS% %fLOG% -m"Delete temporary files... "
	del %tmp%\tmp.xml %tmp%\tst.xml %tmp%\.tmp /f /q >nul
	if %errorlevel% == 0 (%CMD_OkCr%) else %CMD_ErrCr%
exit /b
