:: ./install_master.cmd

:: The install script for soft @Master.
:: For the correct operation of the script must be run with administrator privileges

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

@if not defined CMD_DBG call header.cmd

%CMD_DBG% "=== Script %~n0 started ==="

if not exist %WINDIR%\7z.exe copy /Y "%SOFT_ENV%\7z\%PROCESSOR_ARCHITECTURE%\*.exe" %WINDIR% >nul

call get_var.cmd -f MASTER:path_to_install -v PATH_PELENG -q "Specify the folder name for install Master "
if /i %PROCESSOR_ARCHITECTURE%==amd64 (
	echo %PATH_PELENG%>%tmp%\tmp.txt
	sed -i "s/Program Files\\/Program Files (x86)\\/i" %tmp%\tmp.txt
	set /p PATH_PELENG=<%tmp%\tmp.txt
)
::for /f %%i in ("echo %PATH_PELENG% ^| sed -n /"Program Files"/p") do if "%%i" == "" (set var=0) else set var=1
::if %var% == 1 (
::	for /f %%i in ("echo %PATH_PELENG% ^| sed -n /\(x86\)/p") do if "%%i" == "" (set var=0) else set var=1
::	if %var% == 0 if /i %PROCESSOR_ARCHITECTURE%==amd64 sed s/"Program Files"/"Program Files (x86)"/i
::)
call debug_lvl.cmd 2 "%~n0" "PATH_PELENG=%PATH_PELENG%"
call setxx.cmd PATH_PELENG "%PATH_PELENG%"

call logging.cmd %fCONS% %fLOG% -cr -m"Install soft environment"

::set fNAME=vcredist_x%PROCESSOR_ARCHITECTURE:~-2%_2008sp1
set fNAME=vcredist_x86_2008sp1

if exist %SOFT_ENV%\%fNAME%.exe (
	start %SOFT_ENV%\%fNAME%.exe /q >nul 2>nul
) else call logging.cmd %fCONS% %fLOG% -cr -te -m"%SOFT_ENV%\fNAME.exe not found"

set var=
sc query OracleXETNSListener 2>nul 1>nul

if "%errorlevel%" == "1060" (call :instDB) else (
	call logging.cmd %fCONS% %fLOG% -tw -cr -m"OracleXE database allready installed"
	set FLAG_INST_ORACLE=1
)

call logging.cmd %fCONS% %fLOG% -m"Install Master base pack... "

Setlocal EnableDelayedExpansion
if exist %SOFT_INST%\master\master_base.zip (
	7z x -y -o"%PATH_PELENG%" -r %SOFT_INST%\master\master_base.zip >nul 2>nul
	if !errorlevel! == 0 (%CMD_Ok%) else (
		%CMD_ErrCr%
		call logging.cmd %fCONS% %fLOG% -cr -te -m"Unpacking error"
	)
	if /i %PROCESSOR_ARCHITECTURE%==amd64 (
		move /y "%PATH_PELENG%"\*.dll %WINDIR%\sysWOW64 >nul 2>nul
	) else move /y "%PATH_PELENG%"\*.dll %WINDIR%\system32 >nul 2>nul
	if !errorlevel! == 0 (%CMD_OkCr%) else %CMD_ErrCr%
) else (
	%CMD_ErrCr%
	call logging.cmd %fCONS% %fLOG% -cr -te -m"File %SOFT_INST%\master\master_base.zip not found"
)
EndLocal

call get_var.cmd -f MASTER:version -v version -q "Specify the build number of software for installation, Release."

call logging.cmd %fCONS% %fLOG% -m"Install Master Release pack... "
Setlocal EnableDelayedExpansion
if exist %SOFT_INST%\master\Release.%version%.zip (
	7z x -y -o"%PATH_PELENG%" -r %SOFT_INST%\master\Release.%version%.zip 2>nul 1>nul
	if !errorlevel! == 0 (%CMD_OkCr%) else (
		%CMD_ErrCr%
		call logging.cmd %fCONS% %fLOG% -cr -te -m"Unpacking error"
	)
) else (
	%CMD_ErrCr%
	call logging.cmd %fCONS% %fLOG% -cr -te -m"File %SOFT_INST%\master\Release.%version%.zip not found"
)
EndLocal

call get_var.cmd -f MASTER:sound -v sound -c "Specify the sound scheme:;  Notify - 1;  Ivona  - 2;  Valera - 3"
call logging.cmd %fCONS% %fLOG% -m"Sound scheme unpacking... "
Setlocal EnableDelayedExpansion
	if exist %SOFT_INST%\master\wav.zip (
		7z x -y -o"%PATH_PELENG%" -r %SOFT_INST%\master\wav.zip >nul 2>nul
		if !errorlevel! == 0 (
			%CMD_OkCr%
			if %sound% == 2 (
				set name_sheme=Ivona
			) else if !sound! == 3 (
				set name_sheme=Valera
			) else set name_sheme=Notify

			call debug_lvl.cmd 2 "%~n0" "Choice sheme '!name_sheme!'"

			call logging.cmd %fCONS% %fLOG% -m"Sound sheme '!name_sheme!' [code: %sound%] copy... "
			move /y "%PATH_PELENG%"\wav\wav_!name_sheme!\*.wav "%PATH_PELENG%" >nul 2>nul
			if !errorlevel! == 0 (%CMD_OkCr%) else %CMD_ErrCr%
			rmdir /s /q "%PATH_PELENG%"\wav >nul 2>nul
		) else (
			%CMD_ErrCr%
			call logging.cmd %fCONS% %fLOG% -cr -te -m"Unpacking error"
		)
	) else (
		%CMD_ErrCr%
		call logging.cmd %fCONS% %fLOG% -cr -te -m"File %SOFT_INST%\master\wav.zip not found"
	)
EndLocal

call get_var.cmd -f MASTER:hot_reserv -v FLAG_HOTR -q "Install 'Hot Reserv' "
call debug_lvl 2 "%~n0" "Install 'Hot Reserv'; you answerd: %FLAG_HOTR%"
if /i %FLAG_HOTR% == true (
	call setxx.cmd FLAG_HOTR 1
	call copyDBs.cmd
) else call del_var.cmd FLAG_HOTR

call get_var.cmd -f MASTER:install_vg -v vg -q "Install VGrabber "
call debug_lvl 2 "%~n0" "Install VGrabber; you answerd: %vg%"
if /i %vg% == true (call install_vg.cmd)

%CMD_DBG% "=== Script %~n0 completed ==="

exit /b
:: =============================================================================
:: =============================================================================
:: =============================================================================
:instDB
::	set fNAME=OracleXE112_Win_x%PROCESSOR_ARCHITECTURE:~-2%
	set fNAME=OracleXE112_Win_x86
	call logging.cmd %fCONS% %fLOG% -m"Unpacking %fNAME%... "
	if exist %SOFT_ENV%\%fNAME%.zip (
		Setlocal EnableDelayedExpansion
		7z x -y -o%tmp% -r %SOFT_ENV%\%fNAME%.zip >nul
		if !errorlevel! == 0 (
			%CMD_OkCr%
			if exist c:\oraclexe ( rd /s /q c:\oraclexe )
			sed -i s/SYSPassword=.*$/SYSPassword=password/ "%tmp%\DISK1\response\OracleXE-install.iss"
			call logging.cmd %fCONS% %fLOG% -cr -m"Run install OracleXE Database in parallel process"
			del /f /q "%tmp%\DISK1\setup.log" 2>nul >nul
			start cmd /c "mode con:cols=30 lines=2&color 17&echo Install OracleXE dyatabase...&"%tmp%\DISK1\setup.exe" /S -f1"%tmp%\DISK1\response\OracleXE-install.iss""
		) else (
			%CMD_ErrCr%
			call logging.cmd %fCONS% %fLOG% -te -cr -m"Unpacking error"
		)
		EndLocal
	) else (
		%CMD_ErrCr%
		call logging.cmd %fCONS% %fLOG% -te -cr -m"Not found file %fNAME%.zip"
	)
exit /b
:: =============================================================================
