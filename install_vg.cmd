:: ./install_vg.cmd

:: The install script for soft @VGrabber.
:: For the correct operation of the script must be run with administrator privileges

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved
:: Script installation VGrabber

@if not defined CMD_DBG call header.cmd

%CMD_DBG% "=== Script %~n0 started ==="

call get_var -f VGRABBER:path_to_install -v PATH_VG -q "Specify the folder name for install VGrabber "

for /f %%i in ('echo %PATH_VG% | sed -n /"Program Files"/ip') do if "%%i" == "" (set var=0) else set var=1
if %var% == 1 (
	for /f %%i in ('echo %PATH_VG% | sed -n /\(x86\)/p') do if "%%i" == "" (set var=0) else set var=1
	if %var% == 0 if /i %PROCESSOR_ARCHITECTURE%==amd64 sed s/"Program Files"/"Program Files (x86)"/i
)
call debug_lvl.cmd 2 "%~n0" "PATH_VG=%PATH_VG%"

if "%DEVICE%" == "BVZ" (
	call setxx.cmd PATH_PELENG "%PATH_VG%"
	call debug_lvl.cmd 2 "%~n0" "DEVICE=%DEVICE%, PATH_PELENG=%PATH_VG%"
) else (
	for /f "tokens=1*" %%i in ('echo "%PATH_VG%"^|sed s/\\/\\\\/g') do if "%%j" == "" (set path_tmp=%%i) else set path_tmp=%%i %%j
	set path_tmp=%path_tmp:"=%
	call debug_lvl.cmd 2 "%~n0" "PATH_VG_TMP=%path_tmp%"

	iconv.exe -f utf-8 -t cp1251 %SOFT_ENV%\sys\Supervisor\etc\SupervisorServer.xml >%tmp%\tmp.xml
	call logging.cmd %fCONS% %fLOG% -m"Run command sed for editing path to VGrabber... "
	sed -i s/^.*VGrabber.exe/"\t\t\t<path>%path_tmp%\\VGrabber.exe"/i %tmp%\tmp.xml 2>nul
	if %errorlevel% == 0 (%CMD_OkCr%) else %CMD_ErrCr%
	iconv.exe -f cp1251 -t utf-8 %tmp%\tmp.xml >%SOFT_ENV%\sys\Supervisor\etc\SupervisorServer.xml
)
call get_var -f VGRABBER:version -v version -q "Specify the build number VGrabber "
call debug_lvl.cmd 2 "%~n0" "version=%version%"

call logging.cmd %fCONS% %fLOG% -m"Unpacking VGrabber_screen... "
if exist %SOFT_INST%\smar-t\VGrabber_screen_%version%.zip (
	if not exist "%PATH_VG%" (md "%PATH_VG%")
	SetLocal EnableDelayedExpansion
	7z x -y -o"%PATH_VG%" -r %SOFT_INST%\smar-t\VGrabber_screen_%version%.zip >nul 2>nul
	if !errorlevel! == 0 (
		%CMD_OkCr%
		call get_var.cmd -f VGRABBER:ip_bri -v ip_bri -q "Specify the IP addresses of the BRI blocks "
		call debug_lvl.cmd 2 "%~n0" "IP addresses: !ip_bri!"
		call set_vg_hosts.cmd !ip_bri!
	) else (
		%CMD_ErrCr%
		call logging.cmd %fCONS% %fLOG% -te -cr -m"Unpacking error"
	)
	EndLocal
) else (
	%CMD_ErrCr%
	call logging.cmd %fCONS% %fLOG% -te -cr -m"Not found file VGrabber_screen"
)

%CMD_DBG% "=== Script %~n0 completed ==="

exit /b
:: =============================================================================
:: =============================================================================
:: =============================================================================
