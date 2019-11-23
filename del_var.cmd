:: ./del_arg.cmd

@echo off
color 17
cd /d %~dp0

if "%*" == "" (
	set var=FLAG_NOQUERY FLAG_GUI FLAG_HOTR FLAG_ADD_U FLAG_CONF FLAG_WOQUERY ID ID_tmp BLOCK BLOCK_tmp fLOG fCONF fCONS CMD_DBG pUser pPass FLAG_DEBUG
) else set var=%*

for %%i in (%var%) do (
	call debug_lvl.cmd 4 %~n0 "Deleting variable %%i"
	set %%i=
	reg delete HKCU\Environment /v %%i /f >nul 2>nul
	reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v %%i /f >nul 2>nul
)

exit /b
