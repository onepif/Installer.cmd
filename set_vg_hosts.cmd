:: ./set_VGrabber_hosts.cmd

:: The configuration script VGrabber.
:: For the settings VGrabber hosts

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

@echo off
color 17

%CMD_DBG% "=== Script %~n0 started ==="

if not x%2 == x (
	if not x%1 == x (
		reg add HKEY_CURRENT_USER\Software\peleng\vgrabber /v output_folder /d "" /f >nul
		reg add HKEY_CURRENT_USER\Software\peleng\vgrabber /v output_hosts /d %subNET%.%stepNET%.%1;%subNET%.%stepNET%.%2 /f >nul
		reg add HKEY_CURRENT_USER\Software\peleng\vgrabber /v frame_rate /t reg_dword /d 2 /f >nul
		reg add HKEY_CURRENT_USER\Software\peleng\vgrabber /v sv_port /t reg_dword /d 5544 /f >nul
		reg add HKEY_CURRENT_USER\Software\peleng\vgrabber /v rotate /t reg_dword /d 2 /f >nul
		reg add HKEY_CURRENT_USER\Software\peleng\vgrabber /v is_recording /d "false" /f >nul

		reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v vgrabber /f >nul 2>nul
	) else call logging.cmd %fCONS% %fLOG% -te -cr -m"Incorrect parameters specified arg1=%1, arg2=%2;"
) else call logging.cmd %fCONS% %fLOG% -te -cr -m"Incorrect parameters specified arg1=%1, arg2=%2;"

%CMD_DBG% "=== Script %~n0 completed ==="
exit /b
