:: ./rename_pc.cmd

:: The to re-name PC.
:: For the correct operation of the script must be run with administrator privileges

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

if not defined CMD_DBG call header.cmd

%CMD_DBG% "=== Script %~n0 started ==="

set var=%1
if /i not '%var:~0,1%' == 'B' (set /a var-=10)
wmic computersystem where name="%computername%" call rename name="%var%" >nul 2>nul
reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D} /v "" /d "%var%" /f >nul

call debug_lvl.cmd 2 "%~n0" "Rename to %var%"

%CMD_DBG% "=== Script %~n0 completed ==="

exit /b
