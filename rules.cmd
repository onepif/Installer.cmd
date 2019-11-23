:: ./rules.cmd

:: The script for configuring brandmouer - enabled port from konsole.

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

@echo off
color 17

:: Настройка правил Брандмауэра Windows
call logging.cmd %fCONS% %fLOG% -m"Configuring Windows Firewall rules for ports: %*... "

for %%e in (%*) do (
	for %%j in (in out) do (
		for %%i in (TCP UDP) do (
			@netsh advfirewall firewall add rule name="port number %%e %%i %%j is enable" dir=%%j action=allow protocol=%%i localport=%%e 2>nul >nul
		)
	)
)
if %errorlevel% == 0 (%CMD_OkCr%) else %CMD_ErrCr%

exit /b
