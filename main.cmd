:: =============================================================================
:: ./main.cmd
:: <charset=cp866/>
:: =============================================================================

:: The initial configuration script windows.
:: For the correct operation of the script must be run with administrator privileges

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

@echo off
color 17
cd /d %~dp0

set fCONS=
call get_sid.cmd
for /f "tokens=3" %%i in ('reg query HKEY_USERS\%sid%\Console /v WindowSize 2^>nul') do set var=%%i
if /i not "%var%" == "0x280078" (
SetLocal EnableDelayedExpansion
	choice /c yn /n /d y /t 5 /m "Restart terminal with new window settings? [Y/n]: "
	if !errorlevel! EQU 1 (
		call configure_cmd_size.cmd
		start %~dpnx0 %*
		exit 0
	)
EndLocal
)

set arg=%*

for %%i in (%*) do if /i %%i == -C (
	call del_var.cmd
	set arg=%arg:-c=%
)

if defined arg (
	SetLocal EnableDelayedExpansion
	:loop
		set var=%~1
		if /i "!var:~0,2!" == "-D" (
			if /i not "!var:~2!" == "" (
				call logging.cmd -s -cr -tw -m "Debug mode is ON [level=!var:~2,2!]"
				set FLAG_DEBUG=!var:~2,2!
				goto :endloop
			) else (
				set var=%~2
				echo [ DEBUG LVL ] ^< %~nx0 ^> : var=!var!;
				if "!var!" == "" (
					call logging.cmd -s -cr -tw -m "Debug mode is ON [level=1]"
					set FLAG_DEBUG=1
					goto :endloop
				) else (
					if not "!var:~0,1!" == "-" (
						call logging.cmd -s -cr -tw -m "Debug mode is ON [level=!var!]"
						set FLAG_DEBUG=!var!
						goto :endloop
					) else (
						call logging.cmd -s -cr -tw -m "Debug mode is ON [level=1]"
						set FLAG_DEBUG=1
						goto :endloop
					)
				)
			)
		)
		shift /1
	if not "%~1" == "" goto :loop
	:endloop
	EndLocal & (
		set FLAG_DEBUG=%FLAG_DEBUG%
		call setxx.cmd FLAG_DEBUG %FLAG_DEBUG%
	)
	if defined arg for %%i in (%arg%) do call :arg_parsing %%i
)

SetLocal EnableDelayedExpansion
	if defined FLAG_CONS (
		if "%FLAG_CONS%" == "0" (call del_var.cmd fCONS) else call setxx.cmd fCONS "-s"
	) else (
		set var=1
		if not defined FLAG_DEBUG (
			if defined FLAG_GUI set var=0
			if defined fCONF set var=0
		)
		if !var! EQU 1 (call setxx.cmd fCONS "-s") else call del_var.cmd fCONS
	)
EndLocal & set fCONS=%fCONS%
call debug_lvl.cmd 2 "%~n0" "FLAG_CONS=%FLAG_CONS%, fCONS=%fCONS%;"

if not defined fCONF (set fCONF=%~dpn0.xml)
call debug_lvl.cmd 2 "%~n0" "fCONF=%fCONF%"

call install_tools.cmd

sed -n /COMMON/,/COMMON/{/file_log/p} "%fCONF%" >%tmp%\.tmp

for /f "tokens=3 delims=<>" %%i in (%tmp%\.tmp) do (
	if not "%%i" == "" (
		if not exist %%~dpi (md %%~dpi)
		set fLOG=-o"%%i"
	)
)
call debug_lvl.cmd 2 "%~n0" "fLOG=%fLOG%"

if not defined FLAG_DEBUG (
	sed -n /COMMON/,/COMMON/{/debug/p} "%fCONF%" >%tmp%\.tmp
	for /f "tokens=3 delims=<>" %%i in (%tmp%\.tmp) do (
		if not "%%i" == "" (call setxx.cmd FLAG_DEBUG %%i) else call del_var.cmd FLAG_DEBUG
	)
)

call header.cmd

call check_admin.cmd

title The initial configuration script Windows and special soft

if not defined ID (
	%CMD_EMPTY%
	call logging.cmd %fCONS% %fLOG% -cr -m"============================================================================="
	call logging.cmd %fCONS% %fLOG% -cr -m"=                            NEW_SESSION_STARTED                            ="
	call logging.cmd %fCONS% %fLOG% -cr -m"============================================================================="

	if not defined LOCALE_ID (call getLocale.cmd)

	%CMD_DBG% "=== Script %~n0 started ==="

	call question.cmd %ID_tmp% %BLOCK_tmp%
)
call configure_tools.cmd

%CMD_DBG% "=======================   Script %~n0 continuation    ======================="

if not defined FLAG_DEBUG start sys_info.cmd

:: del pinned
if exist "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Internet Explorer.lnk" (
	call logging.cmd %fCONS% %fLOG% -cr -m"Removing stitched shortcuts"
	del "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Internet Explorer.lnk" /f /q >nul 2>nul
	del "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Windows Media Player.lnk" /f /q >nul 2>nul
) else call logging.cmd %fCONS% %fLOG% -cr -tw -m"Stitched shortcuts not found"
if exist %userprofile%\AppData\Local\IconCache.db (del /a s %userprofile%\AppData\Local\IconCache.db /f /q >nul 2>nul)

:: Получение SID пользователя
if not defined sid call get_sid.cmd

:: Настройка правил Брандмауэра Windows для SS и OpenSSH...
call rules.cmd 4086 22

call get_var.cmd -f COMMON:subnet -v subNET -q "Specify the subNET "
call debug_lvl.cmd 2 "%~n0" "subNET=%subNET%"

call get_var.cmd -d 254 -f COMMON:stepnet -v stepNET -n "Specify the stepNET "
call debug_lvl.cmd 2 "%~n0" "stepNET=%stepNET%"

if %ID%==%SMART% (
	if %BLOCK% GEQ 10 (
		call setxx.cmd DEVICE BVZ
	) else if %BLOCK% GEQ 5 (
		call setxx.cmd DEVICE PLAYER3
	) else call setxx.cmd DEVICE RECORDER
) else if %ID%==%MASTER% (
	call setxx.cmd DEVICE MASTER
) else if %ID%==%RTS% (
	call setxx.cmd DEVICE RTS
) else if %ID%==%TACHYON% (
	call setxx.cmd DEVICE TACHYON
) else if %ID%==%IS% (
	call setxx.cmd DEVICE SERVER
) else if %ID%==%PS% (
	call setxx.cmd DEVICE AVIA
) else if %ID%==%TRS% (
	call setxx.cmd DEVICE TRS
)

SetLocal EnableDelayedExpansion
	if not %ID%==%TRS% (
		if not %ID% == %SMART% (
			call debug_lvl.cmd 2 "%~n0" "DEVICE=%DEVICE%"
			if not %BLOCK%==0 call get_var.cmd -d 254 -f %DEVICE%:ip_base -v ip_base -n "Specify base IP addresses "
		) else (
			if not %BLOCK%==0 call get_var.cmd -d 254 -f SMART:ip_base -v ip_base -n "Specify base IP addresses "
		)
		call debug_lvl.cmd 2 "%~n0" "base IP address selected: !ip_base!"
		set /a var=!ip_base! + %BLOCK%
		call rename_lan.cmd !var!
	)
EndLocal & set ip_base=%ip_base%

:: Задаем имя хоста и порядок автозагрузки
call choiceShell.cmd

if %ID%==%SMART% (
	%CMD_DBG% "Section SMART started"
	if %BLOCK% GEQ 10 (
		call install_vg.cmd
		SetLocal EnableDelayedExpansion
			set /a var=%BLOCK%-10 >nul
			call rename_pc.cmd BVZ-!var!
		EndLocal
	) else if %BLOCK% GEQ 5 (
		call install_armv.cmd
		SetLocal EnableDelayedExpansion
			set /a var=%BLOCK%-4
			call rename_pc.cmd BVI-!var!
		EndLocal
	) else (
		call install_armz.cmd
		call rename_pc.cmd BRI-%BLOCK%
	)
) else if %ID%==%MASTER% (
	%CMD_DBG% "Section MASTER started"
:: Настройка правил Брандмауэра Windows для ORACLE
	call rules.cmd 1521
	call install_master.cmd
	call rename_pc.cmd BOI-%BLOCK%
	call share_folders.cmd -u %pUser% -p %pPass% -d "%PATH_PELENG%" -s %DEVICE%
) else if %ID%==%RTS% (
	%CMD_DBG% "Section RTS started"
	call install_rts.cmd
	if %BLOCK% EQU 1 (call rename_pc.cmd BKDI) else call rename_pc.cmd BKDI-%BLOCK%
) else if %ID%==%TACHYON% (
	%CMD_DBG% "Section TACHYON started"
	call install_tachyon.cmd
	call rename_pc.cmd BHS-%BLOCK%
) else if %ID%==%IS% (
	%CMD_DBG% "Section IS started"
	call install_is.cmd
	call rename_pc.cmd BOI-%BLOCK%
) else if %ID%==%PS% (
	%CMD_DBG% "Section PS started"
	call install_ps.cmd
	call rename_pc.cmd BOI-%BLOCK%
) else if %ID%==%TRS% (
	%CMD_DBG% "Section TRS started"
	call install_trs.cmd
	if defined BLOCK (
		if not %BLOCK% == 0 (call configure_trs.cmd -m %BLOCK%) else call configure_trs.cmd
	) else call configure_trs.cmd
) else (
	call logging.cmd %fCONS% %fLOG% -te -cr -m "No item selected!"
	exit -5
)

%CMD_DBG% "Section COMMON started"

if '%LOCALE_ID%'=='00000419' (net user Гость /active:yes >nul) else net user Guest /active:yes >nul

call copySS.cmd

call set_pwr.cmd

call logging.cmd %fCONS% %fLOG% -m"Setting timeout OS to 3 sec... "
bcdedit /timeout 3 >nul
if %errorlevel% == 0 (%CMD_OkCr%) else %CMD_ErrCr%

set var=
if %ID%==%TACHYON% set var=1
if %ID%==%SMART% if %BLOCK%==1 set var=1

SetLocal EnableDelayedExpansion
	if defined var (
		call logging.cmd %fCONS% %fLOG% -m"Time server activating... "
		call srv.cmd
		%CMD_OkCr%
	) else (
		set /a var=2*%stepNET%
		call get_var.cmd -f COMMON:time_servers_ip -v ip_tm_srv -q "Specify the fourth group ip address of the time server "
		call debug_lvl.cmd 2 "%~n0" "IP addresses were selected: '%subNET%.%stepNET%.!ip_tm_srv! %subNET%.!var!.!ip_tm_srv!'"
		call logging.cmd %fCONS% %fLOG% -m"Time synchronization... "
		call clt.cmd %subNET%.%stepNET%.!ip_tm_srv! %subNET%.%var%.!ip_tm_srv!
		%CMD_OkCr%
	)
EndLocal

call dis_arun.cmd

call logging.cmd %fCONS% %fLOG% -m"Services stop... "
:: Узел универсальных PNP-устройств [upnphost]
:: Обнаружение SSDP [SSDPSRV]
:: Определение оборудования оболочки [ShellHWDetection]
:: Доступ к HID-устройствам [hidserv]
for %%i in (upnphost SSDPSRV ShellHWDetection hidserv) do (
	for /f "usebackq tokens=3" %%j in (`"sc query %%i|findstr /i "STOPPED RUNNING""`) do if %%j==4 (net stop %%i >nul)
	sc config %%i start= disabled >nul
)
%CMD_OkCr%

call logging.cmd %fCONS% %fLOG% -m"Services start... "
:: Службы, клторые должны работать:
:: Центр обеспечения безопасности [wscsvc]
:: Брандмауэр Windows [MpsSvc]
:: Вторичный вход в систем [seclogon]
:: Windows Audio [MMCSS AudioEndpointBuilder Audiosrv] 'sc start %1; sc config %1 start=auto'
for %%i in (wscsvc MpsSvc seclogon) do (
	for /f "usebackq tokens=3" %%j in (`"sc query %%i|findstr /i "STOPPED RUNNING""`) do if %%j==1 (net start %%i >nul)
	sc config %%i start= auto >nul
)
%CMD_OkCr%

:: Настройка правил Брандмауэра Windows для NTP
call rules.cmd 123

:: Сетевое обнаружение и RDP
call logging.cmd %fCONS% %fLOG% -m"Setting LAN and RDP... "
for %%i in (
	"Общий доступ к файлам и принтерам"
	"Обнаружение сети"
	"Дистанционное управление рабочим столом"
) do @netsh advfirewall firewall set rule group=%%i new enable=yes >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Terminal Server" /v fDenyTSConnections /t reg_dword /d 0 /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t reg_dword /d 0 /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t reg_dword /d 0 /f >nul
%CMD_OkCr%

:: Отключение параметров "Безопасность и обслуживание"
::reg add

:: Отключить Windows Update
:: HKEY_LOCAL_MACHINE/HKEY_CURRENT_USER
:: \Software\Microsoft\Windows\CurrentVersion\Policies
:: DisableWindowsUpdate = 1

:: Завершение -> Перезагрузка
reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_PowerButtonAction /t reg_dword /d 4 /f >nul

call logging.cmd %fCONS% %fLOG% -m"Sound off... "
reg add HKEY_USERS\%sid%\AppEvents\Schemes\ /v "" /d ".None" /f >nul
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation /v DisableStartupSound /t reg_dword /d 1 /f >nul
%CMD_OkCr%

call logging.cmd %fCONS% %fLOG% -m"Disable auto reboot at crash... "
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CrashControl /v AutoReboot /t reg_dword /d 0 /f >nul
reg add HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\CrashControl /v AutoReboot /t reg_dword /d 0 /f >nul
%CMD_OkCr%

call logging.cmd %fCONS% %fLOG% -m"UTC setting... "
tzutil /s UTC
if %errorlevel% == 0 (%CMD_OkCr%) else %CMD_ErrCr%

call logging.cmd %fCONS% %fLOG% -m"Icons on Desktop... "
reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t reg_dword /d 0 /f >nul
reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu /v {645FF040-5081-101B-9F08-00AA002F954E} /t reg_dword /d 0 /f >nul
reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu /v {F02C1A0D-BE21-4350-88B0-7367FC96EF3C} /t reg_dword /d 0 /f >nul
reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t reg_dword /d 0 /f >nul
reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {645FF040-5081-101B-9F08-00AA002F954E} /t reg_dword /d 0 /f >nul
reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel /v {F02C1A0D-BE21-4350-88B0-7367FC96EF3C} /t reg_dword /d 0 /f >nul
%CMD_OkCr%

call logging.cmd %fCONS% %fLOG% -m"Icons in Taskbar and StartMenu... "
reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarSmallIcons /t reg_dword /d 1 /f >nul
reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_ShowControlPanel /t reg_dword /d 2 /f >nul
reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_NotifyNewApps /t reg_dword /d 0 /f >nul
reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_ShowMyDocs /t reg_dword /d 0 /f >nul
reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_ShowMyGames /t reg_dword /d 0 /f >nul
reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_ShowMyPics /t reg_dword /d 0 /f >nul
reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_ShowRun /t reg_dword /d 1 /f >nul
reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_LargeMFUIcons /t reg_dword /d 0 /f >nul
reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_ShowMyMusic /t reg_dword /d 0 /f >nul
%CMD_OkCr%

:: Определяем версию Windows
for /f "usebackq tokens=4" %%i in (`ver`) do for /f "usebackq delims=. tokens=1" %%k in (`echo %%i`) do set WINVER=%%k

if %WINVER% EQU 10 (
	call logging.cmd %fCONS% %fLOG% -m"Icons in Taskbar and StartMenu in Windows 10... "
	reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowTaskViewButton /t reg_dword /d 0 /f >nul
	reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v ShowTaskViewButton /t reg_dword /d 0 /f >nul
	reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v Start_SearchFiles /t reg_dword /d 0 /f >nul
	reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People /v PeopleBand /t reg_dword /d 0 /f >nul
	reg add HKEY_USERS\%sid%\Software\Policies\Microsoft\WindowsStore /v RemoveWindowsStore /t reg_dword /d 1 /f >nul
	reg add HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\OneDrive /v DisableFileSyncNGSC /t reg_dword /d 1 /f >nul
	%CMD_OkCr%
)

call logging.cmd %fCONS% %fLOG% -m"Layout... "
reg add "HKEY_USERS\%sid%\Keyboard Layout\Preload" /v 2 /d "00000419" /f >nul
reg add "HKEY_USERS\%sid%\Keyboard Layout\Preload" /v 1 /d "00000409" /f >nul
%CMD_OkCr%

call logging.cmd %fCONS% %fLOG% -m"EnableAutoTray... "
reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer /v EnableAutoTray /t reg_dword /d 0 /f >nul
%CMD_OkCr%

if %DEVICE% == Master (
	call logging.cmd %fCONS% %fLOG% -m"OFF Visual effects... "
	reg add "HKEY_USERS\%sid%\Control Panel\Desktop" /v DragFullWindows /d "0" /f >nul
	reg add "HKEY_USERS\%sid%\Control Panel\Desktop\WindowMetrics" /v MinAnimate /d "0" /f >nul
	reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v TaskbarAnimations /t reg_dword /d 0x00000000 /f >nul
	reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects /v VisualFXSetting /t reg_dword /d 0x00000003 /f >nul
	if %BLOCK% GEQ 5 (if %BLOCK% LSS 8 (reg add HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Themes /v CurrentTheme /d "C:\Windows\resources\Ease of Access Themes\basic.theme" /f >nul))
	%CMD_OkCr%
)

if not %WINVER% == 10 call disWin10upd.cmd

:: OFF Scheduled
call logging.cmd %fCONS% %fLOG% -m"ScheduledDefrag off... "
Schtasks.exe /change /TN \Microsoft\Windows\Defrag\ScheduledDefrag /disable >nul
if %errorlevel% == 0 (%CMD_OkCr%) else %CMD_ErrCr%

if %WINVER% == 7 (
	call logging.cmd %fCONS% %fLOG% -m"MP Scheduled Scan off... "
	SetLocal EnableDelayedExpansion
		Schtasks.exe /change /TN "\Microsoft\Windows Defender\MP Scheduled Scan" /disable >nul
		if !errorlevel! == 0 (%CMD_OkCr%) else %CMD_ErrCr%
	EndLocal
)

:: Uninstall
if not defined FLAG_DEBUG call uninst.cmd

if not defined FLAG_WOQUERY (
	call logging.cmd %fCONS% %fLOG% -cr -m"Run control panel to disable Security center messages"
	control /name Microsoft.ActionCenter

	call logging.cmd %fCONS% %fLOG% -cr -m"Run control panel to disable access to mass storage devices"
	start gpedit.txt
	start gpedit.msc
)

:: Удаляем сообщение вида ***Log.iniis lost
:: reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\ASUS" 1>nul 2>nul
:: if %errorlevel%==0 (reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\ASUS\" /f >nul)

if /i %DEVICE% == Master (
	if defined FLAG_INST_ORACLE (
		call :confDB_unpack
	) else call :end_instOracle
)

if not "%fLOG%" == "" (
	if not defined FLAG_WOQUERY (
		SetLocal EnableDelayedExpansion
			if defined FLAG_GUI (
				%PATH_ZENITY_BIN%\zenity --question --default-cancel --text="Open LOG file?" --timeout=7 --width=200 --height=100 >%tmp%\.tmp
				set /p var=<%tmp%\.tmp
				if !var! EQU 0 (call "%PROGRAMFILES%\Notepad++\notepad++.exe" %fLOG:~2%)
			) else (
				echo.
				choice /c yn /n /t 7 /d n /m "Open LOG file? [Y/n]:"
				if !errorlevel! EQU 1 (call "%PROGRAMFILES%\Notepad++\notepad++.exe" %fLOG:~2%)
			)
		EndLocal
	)
)

call make_scripts.cmd

set var_cons=%fCONS%
set var_log=%fLOG%
set var_dbg=%FLAG_DEBUG%
set var_cmd_dbg=%CMD_DBG%
if defined FLAG_WOQUERY (call del_var.cmd) else (
	SetLocal EnableDelayedExpansion
		if defined FLAG_GUI (
			%PATH_ZENITY_BIN%\zenity --question --text="Delete environment variables?" --timeout=7 --width=200 --height=100 >%tmp%\.tmp
			set /p var=<%tmp%\.tmp
			if !var! EQU 0 call del_var.cmd
		) else (
			echo.
			choice /c yn /n /m "Delete environment variables? [Y/n]: "
			if !errorlevel! EQU 1 call del_var.cmd
		)
	EndLocal
)

set fCONS=%var_cons%
set fLOG=%var_log%
set FLAG_DEBUG=%var_dbg%
set CMD_DBG=%var_cmd_dbg%
call debug_lvl.cmd 4 %~n0 "fCONS=%fCONS%, fLOG=%fLOG%, FLAG_DEBUG=%FLAG_DEBUG%, CMD_DBG=%CMD_DBG%"

%CMD_DBG% "=== Script %~n0 completed ==="
%CMD_EMPTY%
call logging.cmd %fCONS% %fLOG% -cr -m"============================================================================="
call logging.cmd %fCONS% %fLOG% -cr -m"=                             SESSION FINISHED                              ="
call logging.cmd %fCONS% %fLOG% -cr -m"============================================================================="
%CMD_EMPTY%

echo %fLOG% >%tmp%\tmp.txt
sed -i s/-o// %tmp%\tmp.txt
set /p var1=<%tmp%\tmp.txt
for /f "skip=2 tokens=4" %%i in ('reg query HKEY_USERS\%sid%\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D} /v ""') do set var2=%%i
copy /y %var1% %~dp0\install_%var2%.log

del /f /q sed*
set fCONS=&set fLOG=&set CMD_DBG=

SetLocal EnableDelayedExpansion
	<nul set /p var="The system will restart in 30"
	for /l %%i in (29;-1;1) do (
		choice /c qrn /n /t 1 /d n >nul
		if !errorlevel! EQU 1 (
			echo.
			call debug_lvl.cmd 2 %~n0 "FLAG_DEBUG=%FLAG_DEBUG%, !FLAG_DEBUG!"
			<nul set /p var="Press any key to exit..."
			pause >nul
			if defined FLAG_DEBUG (exit /b 100) else exit 100
		) else if !errorlevel! EQU 2 shutdown /r /t 0
		<nul set /p var=..%%i
	)
EndLocal

set FLAG_DEBUG=

choice /c n /n /t 1 /d n >nul
<nul set /p var=..0..reboot.
choice /c n /n /t 3 /d n >nul

shutdown.exe /r /t 0

exit /b
:: =============================================================================
:: =============================================================================
:: =============================================================================
:end_instOracle
	call logging.cmd %fCONS% %fLOG% -m"Please wait, installation of OracleXE database"
	call :wait_inst_oracle

	set var=NULL
	for /f "usebackq skip=1 tokens=2 delims==" %%i in ("%tmp%\DISK1\setup.log") do set var=%%i
	%CMD_EMPTY%
	call logging.cmd %fCONS% %fLOG% -cr -m"OracleXE database installation completion code: %var% "
	if %var% EQU 0 (
		call logging.cmd %fCONS% %fLOG% -cr -m"Install Oracle XE database successful!"
		sed -i s/HOST.*$/"HOST = BOI-%BLOCK%)(PORT = 1521))"/ C:\oraclexe\app\oracle\product\11.2.0\server\network\ADMIN\listener.ora
		sed -i s/HOST.*$/"HOST = BOI-%BLOCK%)(PORT = 1521))"/ C:\oraclexe\app\oracle\product\11.2.0\server\network\ADMIN\tnsnames.ora
		call :confDB_unpack
	) else (
		call logging.cmd %fCONS% %fLOG% -te -cr -m"Install Oracle XE database unsuccessful!"
	)
exit /b
:: =============================================================================
:confDB_unpack
	call logging.cmd %fCONS% %fLOG% -m"configDB unpacking... "
	7z x -y -o"%PATH_PELENG%" -r %SOFT_INST%\master\configDB.zip 2>nul >nul
	if %errorlevel% == 0 (
		%CMD_OkCr%
		call logging.cmd %fCONS% %fLOG% -cr -m"Session configDB started"

		SetLocal EnableDelayedExpansion
			call get_var.cmd -f %DEVICE%:sectors -v sectors -q "Enter sectors with space delims "
			call get_var.cmd -f %DEVICE%:rw -v rw -q "Enter runways with space delims "
			call debug_lvl.cmd 2 "%~n0" "Sectors: !sectors!, RW: !rw!"
			cd /d "%PATH_PELENG%"\configDB
			call install.cmd "!sectors!" !rw!
		EndLocal

		cd %~dp0
		rmdir /s /q "%PATH_PELENG%"\confDB >nul 2>nul
		call logging.cmd %fCONS% %fLOG% -cr -m"Session configDB finished"
	) else %CMD_ErrCr%
exit /b
:: =============================================================================
:: Ждём окончания установки OracleXE database
:wait_inst_oracle_test
	for /l %%i in (1;0;2) do (
		<nul set /p var=.
		choice /c n /n /t 1 /d n >nul
		if exist "%tmp%\DISK1\setup.log" (exit /b)
	)
exit /b
:: =============================================================================
:: Ждём окончания установки OracleXE database
:wait_inst_oracle
	if not exist "%tmp%\DISK1\setup.log" (
		<nul set /p var=.
		choice /c n /n /t 1 /d n >nul
		goto :wait_inst_oracle
	) else exit /b
:: =============================================================================
:arg_parsing
	set var=%1
	set var_woq=%var:"=%

	if x%FLAG_GET_PARAM% == xNULL (
		echo.>nul
		exit /b
	) else if /i x%FLAG_GET_PARAM% == xI (
		set FLAG_GET_PARAM=
		if not %var_woq:~0,1% == - (
			set ID_tmp=%var_woq%
			if defined FLAG_DEBUG call logging.cmd -td -cr -m "ID_tmp=%var_woq%."
			exit /b
		)
	) else if /i x%FLAG_GET_PARAM% == xB (
		set FLAG_GET_PARAM=
		if not %var_woq:~0,1% == - (
			set BLOCK_tmp=%var_woq%
			if defined FLAG_DEBUG call logging.cmd -td -cr -m "BLOCK_tmp=%var_woq%."
			exit /b
		)
	) else if /i x%FLAG_GET_PARAM% == xO (
		set FLAG_GET_PARAM=
		if not %var_woq:~0,1% == - (
			if not exist "%PROGRAMDATA%\logfiles\" (md "%PROGRAMDATA%\logfiles\")
			set fLOG=-o"%PROGRAMDATA%\logfiles\install_%var_woq%.log"
			if defined FLAG_DEBUG call logging.cmd -td -cr -m "LOG file=%PROGRAMDATA%\logfiles\install_%var_woq%.log"
			exit /b
		)
	) else if /i x%FLAG_GET_PARAM% == xS (
		set FLAG_GET_PARAM=
		if not %var_woq:~0,1% == - (
			if /i "%var_woq%" == "off" (set FLAG_CONS=0) else (
				if /i "%var_woq%" == "on" (set FLAG_CONS=1)
			)
			exit /b
		)
	) else if /i x%FLAG_GET_PARAM% == xF (
		set FLAG_GET_PARAM=
		if not %var_woq:~0,1% == - (
			set fCONF="%var_woq%"
			set FLAG_CONF=1
			if defined FLAG_DEBUG call logging.cmd -td -cr -m "Configuration file=%var_woq%"
			exit /b
		)
	)

	if /i "%var:~0,2%" == "-I" (
		if "%var:~2,1%" == "" (set FLAG_GET_PARAM=I) else set ID_tmp=%var:~2,1%
		if defined FLAG_DEBUG call logging.cmd -td -cr -m "ID_tmp=%var:~2,1%."
	) else if /i "%var:~0,2%" == "-B" (
		if "%var:~2,1%" == "" (set FLAG_GET_PARAM=B) else set BLOCK_tmp=%var:~2%
		if defined FLAG_DEBUG call logging.cmd -td -cr -m "BLOCK_tmp=%var:~2%."
	) else if /i "%var:~0,2%" == "-O" (
		if not "%var_woq:~2%" == "" (
			if not exist "%PROGRAMDATA%\logfiles\" (md "%PROGRAMDATA%\logfiles\")
			set fLOG=-o"%PROGRAMDATA%\logfiles\install_%var_woq:~2%.log"
		) else set FLAG_GET_PARAM=O
	) else if /i "%var:~0,2%" == "-S" (
		if not "%var_woq:~2%" == "" (
			if /i "%var_woq:~2%" == "off" (set FLAG_CONS=0) else (
				if /i "%var_woq:~2%" == "on" (set FLAG_CONS=1)
			)
		) else set FLAG_GET_PARAM=S
	) else if /i "%var:~0,2%" == "-G" (
		if exist %PATH_ZENITY_BIN%\zenity.exe set FLAG_GUI=1
	) else if /i "%var:~0,2%" == "-F" (
		if not "%var_woq:~2%" == "" (
			set fCONF="%var_woq:~2%"
			set FLAG_CONF=1
		) else set FLAG_GET_PARAM=F
	) else if /i "%var:~0,2%"=="-Y" (
		call setxx.cmd FLAG_WOQUERY 1
	) else if /i "%var:~0,2%"=="-H" (
		call :usage
	)
exit /b
:: =============================================================================
:usage
	echo Использование: main.cmd [args]
	echo.
	echo [args] могут принимать следующие значения:
	echo -D [1^|..] : включить отладочный режим. Будет производится вывод дополнительной информации;
	echo -O [path\to\file.ext]: включить режим вывода информации в файл [по умолчанию - %PROGRAMDATA%\logfiles\install.log];
	echo -S on^|off  : если задан явно, то однозначно определяет режим вывода информации в консоль;
	echo               если не задан, то вывод в консоль будет отключён при параметрах -E или -G [по умолчанию включён];
	echo -In : установить номер изделия, где n:
	echo           1 - СМАР-Т
	echo           2 - Мастер
	echo           3 - АСК
	echo           4 - Тахион
	echo           5 - Информационный сервер
	echo           6 - Плановый сервер
	echo           7 - ТДК [Блок Связи]
	echo -Bn : установить номер блока [1, 2, и т.д];
	echo -G  : разрешить графический интерфейс [GUI]. По умолчанию выбран режим командной строки [CLI];
	echo -C  : сбросить все заданные ранее настройки [флаги] и выполнить скрипт с запросом всех параметров;
	echo -F path\to\file.ext : использовать file.ext для конфигурирования процесса установки,если не задан,
	echo					   то ищется файл с именем main.xml;
	echo -Y  : отвечать 'ДА' на все вопросы ['тихий' режим];
	echo -H  : эта справочная информация.
	echo.
	echo Пример:
	echo	main.cmd -i2 -b1 -y - будет выполнена 'тихая' установка СПО 'Мастер' на ПК с назначением ему имени 'BOI-1'
	<nul set /p var="Press any key to exit..."
	pause >nul
	start cmd
if defined FLAG_DEBUG (exit /b) else exit
:: =============================================================================
:: ИС		- 1,2
:: Тахион	- 10,11,12
:: A/V		- 101,102,111..., 121...
:: СМАР-Т	- 131,132,133[134], 141...159
:: Мастер	- 171,172,173
:: АСК		- 191
