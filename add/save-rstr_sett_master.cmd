:: ./save-rstr_sett_master.cmd

:: The script for save/restore settings special soft.

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

if not defined CMD_DBG call header.cmd

if not defined PATH_PELENG call setxx.cmd PATH_PELENG D:\Master\
if not defined PATH_BACKUP call setxx.cmd PATH_BACKUP D:\backUp

if not exist %WINDIR%\7z.exe copy /Y %SOFT_ENV%\sys\7z\%PROCESSOR_ARCHITECTURE%\*.exe %WINDIR% >nul

start rc.SS.cmd 0
ping -n 5 localhost >nul

set var=%1
if not defined var call :choice_mode

if %errorlevel% == 1 (
:: Mode "Save settings"
	for /f "usebackq tokens=1,2 delims=:" %%i in (`"echo %time%"`) do (set var=%%i&&if "%var:~0,1%" == " " ( set var1=0%var:~1,2%.%%j ) else set var1=%%i.%%j)
	for /f "usebackq tokens=1,2,3 delims=." %%i in (`echo %date%`) do set var2=%%k.%%j.%%i
	if not exist "%PATH_BACKUP%" md "%PATH_BACKUP%"

	echo %PATH_PELENG%|sed s/\\/\\\\/g >%tmp%\.tmp
	set /p PATH_PELENG_tmp= <%tmp%\.tmp
	echo %PATH_BACKUP%|sed s/\\/\\\\/g >%tmp%\.tmp
	set /p PATH_BACKUP_tmp= <%tmp%\.tmp

	if not exist listfiles.txt (
		echo %PATH_PELENG%\Peleng >listfiles.txt
		echo %PATH_PELENG_tmp%\Position >>listfiles.txt
		echo %PATH_PELENG_tmp%\Radar >>listfiles.txt
		echo %PATH_PELENG_tmp%\Settings >>listfiles.txt
		echo %PATH_PELENG_tmp%\*.dat >>listfiles.txt
		echo %PATH_PELENG_tmp%\*.key >>listfiles.txt
		echo %PATH_PELENG_tmp%\cwp.config.xml >>listfiles.txt
		echo %PATH_BACKUP_tmp%\sett_Master.reg >>listfiles.txt
		echo %PATH_BACKUP_tmp%\master.dmp >>listfiles.txt
		echo %PATH_BACKUP_tmp%\aero.dmp >>listfiles.txt
	)
	reg save HKLM\SOFTWARE\WOW6432Node\Peleng %PATH_BACKUP%\sett_Master.reg
	exp master/master file=%PATH_BACKUP%\master.dmp
	exp aero/aero file=%PATH_BACKUP%\aero.dmp
	7z a %PATH_BACKUP%\sett_Master - %var2%-%var1%.zip -ir@listfiles
	del %PATH_BACKUP%\*.reg %PATH_BACKUP%\*.dmp %tmp%\.tmp listfiles /f /q >nul
) else (
:: Mode "Restore settings"
	set var=
	%PATH_ZENITY_BIN%\zenity.exe --file-selection --title="Select a File" --filename=D:\backUp >%tmp%\.tmp
	set /p var= <%tmp%\.tmp
	if not defined var exit /b
	7z x -y -r %var% -o"%PATH_PELENG%"
	cd /d "%PATH_PELENG%"
	reg load sett_Master.reg
	imp master\master file=master.dmp >nul
	imp aero\aero file=aero.dmp >nul
	del "%PATH_PELENG%"\*.reg "%PATH_PELENG%"\*.dmp %tmp%\.tmp /f /q >nul
)

start rc.SS.cmd

exit 0
:: =============================================================================
:: =============================================================================
:: =============================================================================
:choice_mode
	if defined FLAG_GUI ( call :choice_mode_gui ) else call choice_cli.cmd "Choice mode:" "Save settings    - 1" " Restore settings - 2"
	if '%errorlevel%'=='-1' ( call work_int.cmd )
exit /b %errorlevel%
:: =============================================================================
:choice_mode_gui
	set var=
	%PATH_ZENITY_BIN%\zenity.exe --list --title="Choice mode:" --column=N --column=Mode 1 "Save settings" 2 "Restore settings" >%tmp%\.tmp
	set /p var= <%tmp%\.tmp
	if not defined var ( call work_int.cmd )
exit /b
