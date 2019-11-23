:: ./rsrv.cmd
:: The script reserving copyng RLI

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

@echo off
color 17

:: ��।��塞 �� ����㯭� ��᪨
@for /f "usebackq tokens=1,*" %%i in (`"fsutil fsinfo drives"`) do @set disks=%%j >nul
echo Disk founded in system: %disks%
:: �⠥� ��⪨ ��᪮�
for /d %%i in (%disks%) do call :sub10 %%i
echo Reserve disk not detected.
exit -1
:: *****************************************************************************
:sub10
	echo Check disk: %1
	for /f "usebackq tokens=3" %%i in (`"fsutil fsinfo volumeInfo %1|findstr /C:"��� ⮬�""`) do @set label=%%i >nul
	echo Disk label: %label%
:: �஢��塞 ���� �� ᮮ⢥��⢨�
	if %label% == rsrv (
:: �믮��塞 ����஢����
		echo Start reserve copy.
		robocopy /xo d:\rts\rli %1RLI /mir
		exit (1)
	) 	else ( echo Disk %1 not reserve. )
exit /b
:: *****************************************************************************
