:: ./header.cmd

:: The header configuration script.

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

set POUCH_HDR=%var%

call debug_lvl.cmd 4 "%~n0" "CMD_DBG=%CMD_DBG%; CMD_Ok=%CMD_Ok%"

for /f "usebackq tokens=7" %%i in (`echo`) do @set var=%%i
if "%var%" == "включен." (
	@echo off
	color 17
)

cd /d %~dp0

if not defined SOFT_ENV set SOFT_ENV=%~dp0..\soft_environment
if not defined SOFT_INST set SOFT_INST=%~dp0..\soft_install

if not defined CMD_DBG (
	set PATH_ZENITY=%~dp0..\soft_environment\sys\Zenity
	set ZENITY_DATADIR=%PATH_ZENITY%\share\zenity
	set PATH_ZENITY_BIN=%PATH_ZENITY%\bin

	set CMD_EMPTY=call logging.cmd %fCONS% %fLOG% -empty
	set CMD_DBG=if defined FLAG_DEBUG call logging.cmd %fCONS% %fLOG% -td -cr -m

	set CMD_Ok=call logging.cmd %fCONS% %fLOG% -ok
	set CMD_OkCr=call logging.cmd %fCONS% %fLOG% -cr -ok
	set CMD_Err=call logging.cmd %fCONS% %fLOG% -err
	set CMD_ErrCr=call logging.cmd %fCONS% %fLOG% -cr -err
	set CMD_Skip=call logging.cmd %fCONS% %fLOG% -skip
	set CMD_SkipCr=call logging.cmd %fCONS% %fLOG% -cr -skip
)

set var=%POUCH_HDR%

exit /b
