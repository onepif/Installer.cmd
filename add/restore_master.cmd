:: ./restore_master.cmd

:: The script for restore special soft.

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

@echo off
color 17

if not defined TRUE call set_env.cmd

if not defined PATH_PELENG call setxx.cmd PATH_PELENG D:\Master

if not defined PATH_BACKUP call	setxx.cmd PATH_BACKUP D:\backUp

set SOFT_ENV=%~dp0..\soft_environment
if not exist %WINDIR%\7z.exe copy /Y %SOFT_ENV%\sys\7z\%PROCESSOR_ARCHITECTURE%\*.exe %WINDIR% >nul

set ZENITY_DATADIR=%SOFT_ENV%\sys\Zenity\share\zenity
set  PATH_ZENITY=%SOFT_ENV%\sys\Zenity\bin

:: 0 - полное обновление
:: 1 - только софт и база
:: 2 - только софт
set arg=%1
if not defined arg set arg=0

cd /d %~dp0

if %var%==0 (
	call sys_info.cmd
	if not defined FLAG_ADD_U ( call add_user.cmd ) else call del_var.cmd FLAG_ADD_U

:: Настройка правил Брандмауэра Windows для: ORACLE, SS, OpenSSH, NTP
	call rules.cmd 1521 4086 22 123

	call choiseShell.cmd

	call copySS.cmd

	call pwr_stp.cmd

:: Настройка правил Брандмауэра Windows
	call logging.cmd -s %fLOG% -m"Настройка правил Брандмауэра Windows... "
	netsh advfirewall firewall set rule group="Дистанционное управление рабочим столом" new enable=yes >nul
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Terminal Server" /v fDenyTSConnections /t reg_dword /d 0 /f >nul
	%CMD_OkCr%

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
set var=
if defined FLAG_GUI (
	%PATH_ZENITY_BIN%\zenity --file-selection --filename="%PATH_BACKUP%" --text="Select file for restore..." >%tmp%\.tmp
	set /p var= <%tmp%\.tmp
) else (
	dir D:\BackUp /b /d
	<nul set /p var="Укажите имя файла для восстановления [%PATH_BACKUP%]: "
)
if not defined var (start rc.SS.cmd&exit 0)
if not exist %PATH_BACKUP\%%var% (start rc.SS.cmd&exit 0)

rd /s /q "%PATH_PELENG%"
7z x "%var%" -o"%PATH_PELENG%" -r -y >nul

if not %arg%==2 (
	cd /d "%PATH_PELENG%"
	if exist db_prepare.sql (
		sqlplus system/password @db_prepare.sql >nul
		imp master/master file=master.dmp >nul
		imp aero/aero file=aero.dmp >nul
	)
	del *.dmp *.sql /f /q >nul
)

if %arg%==0 (
	if defined FLAG_GUI (%PATH_ZENITY_BIN%\zenity --info --title="Info..." --text="Нажмите OK для перзапуска компьютера...") else (
		<nul set /p var="Нажмите Enter для перзапуска компьютера..."
		pause >nul
	)
	shutdown.exe /r /t 0
) else start rc.SS.cmd

exit 0
