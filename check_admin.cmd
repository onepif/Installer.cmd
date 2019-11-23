:: ./check_admin.cmd

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

@echo off
color 17
cd /d %~dp0

net user %USERNAME% /time:all 2>nul >nul
if not %errorlevel% == 0 (
	color 84
	cls

	call logging.cmd %fCONS% %fLOG% -cr -m"This script must be run as Administrator"
	<nul set /p var="Press any key to exit..."
	pause >nul
	%CMD_EMPTY%

	color 17
	exit -10
)
