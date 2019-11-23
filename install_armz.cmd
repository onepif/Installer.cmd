:: ./install_armz.cmd

:: The install script for soft @ARMZ.
:: For the correct operation of the script must be run with administrator privileges

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

if not defined FLAG_DBG call header.cmd

%CMD_DBG% "=== Script %~n0 started ==="

label c:sys >nul
label d:data >nul
label e:arch >nul

call get_var.cmd -f RECORDER:path_to_install -v PATH_PELENG -q "Specify the folder name for install ARMZ "
for /f %%i in ('echo %PATH_PELENG% | sed -n /"Program Files"/ip') do if "%%i" == "" (set var=0) else set var=1
if %var% == 1 (
	for /f %%i in ('echo %PATH_PELENG% | sed -n /\(x86\)/p') do if "%%i" == "" (set var=0) else set var=1
	if %var% == 0 if /i %PROCESSOR_ARCHITECTURE%==amd64 sed s/"Program Files"/"Program Files (x86)"/i
)
call debug_lvl.cmd 2 "%~n0" "PATH_PELENG=%PATH_PELENG%"
call setxx.cmd PATH_PELENG "%PATH_PELENG%"

call get_var.cmd -f RECORDER:version -v version -q "Specify the build number of software for installation setup_armz_"
call debug_lvl.cmd 2 "%~n0" "errorlevel=%errorlevel%, version=%version%"

if exist %SOFT_INST%\smar-t\setup_armz_%version%.exe (
	call %SOFT_INST%\smar-t\setup_armz_%version%.exe
) else (
	call logging.cmd %fCONS% %fLOG% -cr -te -m"File %SOFT_INST%\smar-t\setup_armz_%version%.exe not found"
)

Setlocal EnableDelayedExpansion
if not defined FLAG_WOQUERY (
	choice /c yn /n /m "Run configuring section? [Y/n]: "
	if !errorlevel! EQU 1 call :configure
) else call :configure

EndLocal

%CMD_DBG% "=== Script %~n0 completed ==="

exit /b
:: =============================================================================
:: =============================================================================
:: =============================================================================
:configure
	reg add HKLM\SOFTWARE\peleng\recorder\Complect /v ComplectNumber /d %BLOCK% /f >nul

	for /f "tokens=2 delims==" %%i in ('findstr /b /i /c:"local ip=" %fCONF%') do set LocalIP=%%i
	for /f "tokens=2 delims==" %%i in ('findstr /b /i /c:"remote ip=" %fCONF%') do set RemoteIP=%%i
	for /f "tokens=1,2 delims=." %%i in ('echo %subNET%') do (call to_hex.cmd %%i 1>%tmp%\.tmp1 & call to_hex.cmd %%j 1>%tmp%\.tmp2)
	set /a var=%stepNET%*2
	call to_hex.cmd %var% 1>%tmp%\.tmp3
	call to_hex.cmd %LocalIP% 1>%tmp%\.tmp4
	set /p pos1=<%tmp%\.tmp1 & set /p pos2=<%tmp%\.tmp2 & set /p pos3=<%tmp%\.tmp3 & set /p pos4=<%tmp%\.tmp4
	reg add HKLM\SOFTWARE\peleng\recorder\Network /v LocalIP /d %pos1%%pos2%%pos3%%pos4% /f >nul
	call to_hex.cmd %RemoteIP% 1>%tmp%\.tmp4
	set /p pos4=<%tmp%\.tmp4
	reg add HKLM\SOFTWARE\peleng\recorder\Network /v RemoteIP /d %pos1%%pos2%%pos3%%pos4% /f >nul

	for /f "tokens=2 delims==" %%i in ('findstr /b /i /c:"path to gnrl=" %fCONF%') do set var=%%i
	reg add HKLM\SOFTWARE\peleng\recorder\Storages /v GeneralStoragePath /d %var% /f >nul

	call logging.cmd %fCONS% %fLOG% -m"Make folder %var%... "

	Setlocal EnableDelayedExpansion
		if not exist %var% (
			mkdir %var% >nul 2>nul
			if !errorlevel! == 0 (%CMD_OkCr%) else %CMD_ErrCr%
		) else %CMD_SkipCr%
		for /f "tokens=2 delims==" %%i in ('findstr /b /i /c:"path to arch=" %fCONF%') do set var=%%i
		reg add HKLM\SOFTWARE\peleng\recorder\Storages /v ArchiveStoragePath /d %var% /f >nul

		call logging.cmd %fCONS% %fLOG% -m"Make folder %var%... "
		if not exist %var% (
			mkdir %var% >nul 2>nul
			if !errorlevel! == 0 (%CMD_OkCr%) else %CMD_ErrCr%
		) else %CMD_SkipCr%
	EndLocal
exit /b
:: =============================================================================
