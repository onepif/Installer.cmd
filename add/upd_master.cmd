:: ./upd_master.cmd

:: The script for updating special soft.

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

@if not defined CMD_DBG call header.cmd

if not defined PATH_PELENG call setxx.cmd PATH_PELENG D:\Master
if not defined PATH_BACKUP call setxx.cmd PATH_BACKUP D:\backUp

if not exist %WINDIR%\7z.exe copy /y "%SOFT_ENV%\7z\%PROCESSOR_ARCHITECTURE%\*.exe" %WINDIR% >nul

:: 0 - полное обновление
:: 1 - только софт и база
:: 2 - только софт
set arg=%1
if not defined arg set arg=0

if %arg%==0 (
	call sys_info.cmd
	if not defined FLAG_ADD_U ( call add_user.cmd ) else call del_var.cmd FLAG_ADD_U

	call rules.cmd 1521 4086 22 123

	call choiseShell.cmd

	call copySS.cmd

	call pwr_stp.cmd

:: Настройка правил Брандмауэра Windows
	call str2log.cmd INFO "[ Настройка правил Брандмауэра Windows ]..."
	netsh advfirewall firewall set rule group="Дистанционное управление рабочим столом" new enable=yes >nul
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Terminal Server" /v fDenyTSConnections /t reg_dword /d 0 /f >nul
	call str2log.cmd INF0 "[ Done ]"

:: Завершение -> Перезагрузка
	reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_PowerButtonAction /t reg_dword /d 4 /f >nul

:: Layout
	reg add "HKEY_USERS\%sid%\Keyboard Layout\Preload" /v 2 /d "00000419" /f >nul
	reg add "HKEY_USERS\%sid%\Keyboard Layout\Preload" /v 1 /d "00000409" /f >nul

:: EnableAutoTray
	reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer /v EnableAutoTray /t reg_dword /d 0 /f >nul

:: Отказываемся от обновления до Windows 10
	call disWin10upd.cmd
)

start rc.SS.cmd 0
ping -n 5 localhost >nul
for /f "usebackq tokens=1,2 delims=:" %%i in (`"echo %time%"`) do (set var=%%i&&if "%var:~0,1%" == " " ( set var1=0%var:~1,2%.%%j ) else set var1=%%i.%%j)
for /f "usebackq tokens=1,2,3 delims=." %%i in (`echo %date%`) do set var2=%%k.%%j.%%i
if not exist "%PATH_BACKUP%" md "%PATH_BACKUP%"

7z a -r "%PATH_BACKUP%\Master - %var2%-%var1%.zip" "%PATH_PELENG%\*" -xr!*.rrf
if not %arg%==2 (
	exp master/master file=master.dmp
	exp aero/aero file=aero.dmp
	7z a "%PATH_BACKUP%\Master - %var2%-%var1%.zip" -i!*.dmp
	del *.dmp /f /q >nul
)

7z x -y ..\master\upd_master.zip -o"%PATH_PELENG%"
if not %arg%==2 (
	cd /d "%PATH_PELENG%"
	if exist db_prepare.sql (
		sqlplus system/password @db_prepare.sql
		imp master/master file=master.dmp
		imp aero/aero file=aero.dmp
		7z a "%PATH_BACKUP%\Master - %var2%-%var1%.zip" -i!db_prepare.sql
	)
	del *.dmp *.sql /f /q >nul
)

if %arg%==0 (
	if defined FLAG_GUI (call :choice_gui) else :choice_cli
) else start rc.SS.cmd

exit 0
:: =============================================================================
:: =============================================================================
:: =============================================================================
:: =============================================================================
:: =============================================================================
:choice_gui
	%PATH_ZENITY_BIN%\zenity --question --text="Choice:" --ok-label=Reboot --cancel-label=LogOff
	if %errorlevel% EQU 0 (shutdown.exe /r /t 0) else logoff
exit /b
:: =============================================================================
:choice_cli
	choice /c rкlд /n /m "press [R] for reboot or [L] for logoff: "
	if %errorlevel% LEQ 2 (shutdown.exe /r /t 0) else logoff
exit /b
:: =============================================================================
