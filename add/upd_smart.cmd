:: ./upd_smart.cmd

:: The script for updating special soft.

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

@echo off
color 17

setx tmp c:\tmp

setx TRUE		1
setx FALSE		0

setx stop		0
setx start		1
setx restart	2
setx status		3

setx SMART		1
setx MASTER		2
setx RTS		3
setx TACHYON	4
setx IS			5
setx PS			6

set  PATH_PELENG=D:\ARMZ\
setx PATH_PELENG D:\ARMZ\

cd /d %~dp0
call sys_info.cmd
if not defined FLAG_ADD_U ( call add_user.cmd ) else call del_var.cmd FLAG_ADD_U

call choiseShell.cmd

call copySS.cmd

<nul set /p strTemp=Настройка электропитания...
call pwr_stp.cmd

:: Настройка правил Брандмауэра Windows
<nul set /p strTemp=Настройка правил Брандмауэра Windows...
netsh advfirewall firewall set rule group="Дистанционное управление рабочим столом" new enable=yes >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Terminal Server" /v fDenyTSConnections /t reg_dword /d 0 /f >nul

echo Настройка правил Брандмауэра Windows для: SS, OpenSSH, NTP...
call rules.cmd 4086 22 123

:: Завершение -> Перезагрузка
reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_PowerButtonAction /t reg_dword /d 4 /f >nul

:: Layout
reg add "HKEY_USERS\%sid%\Keyboard Layout\Preload" /v 2 /d "00000419" /f >nul
reg add "HKEY_USERS\%sid%\Keyboard Layout\Preload" /v 1 /d "00000409" /f >nul

:: EnableAutoTray
reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer /v EnableAutoTray /t reg_dword /d 0 /f >nul

:: Отказываемся от обновления до Windows 10
call disWin10upd.cmd

call rc.SS.cmd 0
"%PROGRAMFILES%\7-Zip\7z.exe" a -y -r -x!*.rrf "D:\backUp\ARMZ - %date%.zip" -o"%PATH_PELENG%"
"%PROGRAMFILES%\7-Zip\7z.exe" x -y upd.zip -o"%PATH_PELENG%"

echo press Enter for reboot...
pause >nul
shutdown.exe /r /t 0
exit 0
