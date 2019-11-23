:: ./question_gui.cmd

:: The initial configuration script windows.
:: For the correct operation of the script must be run with administrator privileges

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

if not defined CMD_DBG call header.cmd

%CMD_DBG% "=== Script %~n0 started ==="

call getLocale.cmd

call check_admin.cmd

call :check_run

if not "%*" == "" (for %%i in (%*) do call :arg_parsing %%i)

%CMD_DBG% "===> Start section Selector <==="

zenity --forms --title="Product choice..." --separator=" " --add-combo="Product: " --combo-values="SMAR-T|Master|RTS|Tachyon|IS|PS|TDK [BS]" >%tmp%\.tmp
for /f "usebackq tokens=1" %%i in (%tmp%\.tmp) do set ID=%%i
for /f "usebackq tokens=2" %%i in (%tmp%\.tmp) do set BLOCK=%%i

if %ID% == SMAR-T (
	zenity --forms --title="SMAR-T settings..." --separator=" " --text="" \
 --add-combo=Block --combo-values="1|2|3"		
	for /f "usebackq tokens=1" %%i in (%tmp%\.tmp) do set ID=%%i

) else if %ID% == Master (
	zenity --forms --text="Master settings..." --separator=" " \
		--add-combo="Use hot backup mode?: " --combo-values="Yes|No" \
		--add-combo="How to run software?: " --combo-values="Shell|Program" \
		--add-combo="Select sound scheme: " --combo-values="Notify|Ivona|Valera" \
		--add-entry="Specify IP address of BOI-%BLOCK% blocks: " \
		--add-entry="Specify 1-st IP address of time servers: " \
		--add-entry="Specify 2-nd IP address of time servers: " \
	Please wait, installation of OracleXE database...
	Open LOG file? [Y/n]:
	The system will restart in 30
	Info: usage


		--add-combo="Install VGrabber?: " --combo-values="Yes|No" \
		--add-entry="Specify IP address of BRI-1 blocks: " \
		--add-entry="Specify IP address of BRI-2 blocks: " \

		--add-combo="" --combo-values="" \
		--add-combo="" --combo-values="" \
) else if %ID% == RTS (
) else if %ID% == Tachyon (
) else if %ID% == IS (
) else if %ID% == PS (
) else if %ID% == TDK (
)
	--add-combo="yes/no" --combo-values="yes|no" \
	--add-entry="PORT" --add-combo="Sound scheme: " --combo-values="Notify|Ivonna|Lerron" --add-entry="IP address NTP servers: " 2>/dev/null SMAR-T|Master|ACK|Tachyon|IS|PS|TDK [BS]: if!==User: reboot|logoff
set var=
if not defined FLAG_FULL (
	if not defined FLAG_LIGHT (
		if defined FLAG_GUI (
			%PATH_ZENITY_BIN%\zenity --list --title="Select mode:" --width=250 --height=300 --column=N --column=Mode 1 "Full install" 2 "Update soft only" 3 "Update soft & database" 4 "Save/Restore settings" 5 "Restore soft only" 6 "Restore soft & database" >%tmp%\.tmp
		) else (
			choice_cli.cmd "Select mode:" "Full install       - 1" "Update soft only     - 2" "Update soft & database       - 3" "Save/Restore settings  - 4" "Restore soft only - 5" "Restore soft & database   - 6"
		)
	) else (
		if defined FLAG_GUI (
			%PATH_ZENITY_BIN%\zenity --list --title="Select mode:" --width=250 --height=300 --column=N --column=Mode 1 "Update soft only" 2 "Update soft & database" 3 "Restore soft only" 4 "Restore soft & database" >%tmp%\.tmp
		) else (
			choice_cli.cmd "Select mode:" "Update soft only     - 1" "Update soft & database       - 2" "Restore soft only - 3" "Restore soft & database   - 4"
		)
	)
) else (
	call :sub
	exit 0
)
set /p var=<%tmp%\.tmp
if not defined var ( call work_int.cmd )

if defined FLAG_LIGHT ( if %var% LEQ 2 (set /a var+=1) else (set /a var+=2) )
if %var% == 0 (
	echo.
) else if %var% == 1 (
	call :sub
) else if %var% == 2 (
	start upd_master.cmd 2
) else if %var% == 3 (
	start upd_master.cmd 1
) else if %var% == 4 (
	start sett_master.cmd
) else if %var% == 5 (
	start restore_master.cmd 2
) else if %var% == 6 (
	start restore_master.cmd 1
) else if %var% == 7 (
	start xxx.cmd
) else if %var% == 8 (
	start xxx.cmd
) else if %var% == 9 (
	start xxx.cmd
)

%CMD_DBG% "=== Script %~n0 completed ==="

exit 0
:: =============================================================================
:: =============================================================================
:: =============================================================================
:check_run
	if not defined FLAG_INSTALL_1 set FLAG_INSTALL_1=0
	if not defined FLAG_INSTALL_2 set FLAG_INSTALL_2=0
	set /a var=%FLAG_INSTALL_1%+%FLAG_INSTALL_2%
	if defined FLAG_CONF (
		if %var% GEQ 1 ( call del_var.cmd ) else start main.cmd & exit 0
	)
exit /b
:: =============================================================================
:sub
	set var=
	if defined FLAG_GUI (
		%PATH_ZENITY_BIN%\zenity --list --title="Select block:" --width=150 --height=200 --column=N --column=Block 1 BOI-1 2 BOI-2 3 BOI-3 >%tmp%\.tmp
	) else call choice_cli.cmd "Выберите блок:" "Мастер(BOI-1) - 1" "      (BOI-2) - 2" "      (BOI-3) - 3"
	set /p var= <%tmp%\.tmp
	if not defined var ( call work_int.cmd ) else if %var%==-1 ( call work_int.cmd )
	call setxx.cmd BLOCK %var%
	set arg=-I2 -B%var%

	if defined FLAG_GUI (call :add_modes_gui) else call :add_modes_cli

	call debug_lvl.cmd 2 %~n0 "all arg: '%*'"
	%CMD_DBG% "===> End section Selector <==="

	start main.cmd %arg%
exit /b
:: =============================================================================
:add_modes_gui
	%PATH_ZENITY_BIN%\zenity --list --checklist --hide-column=2 --title="Add modes:" --width=300 --height=230 --column="" --column=N --column=Func 1 D "режим DEBUG" 2 L "логирование в файл" 3 R "режим Горячего резервирования" --timeout=10 >%tmp%\.tmp
	for /f "tokens=1,2,3 delims=|" %%i in (%tmp%\.tmp) do (
		if not "%%i"=="" (call :add_arg -%%i)
		if not "%%j"=="" (call :add_arg -%%j)
		if not "%%k"=="" (call :add_arg -%%k)
	)
exit /b
:: =============================================================================
:add_arg
	set arg=%1 %arg%
exit /b
:: =============================================================================
:add_modes_cli
	choice /c yнnт /n /t 7 /d n /m "Включить режим DEBUG [y/N]?: "
	if %errorlevel% LEQ 2 (set arg=-D %arg%)

	choice /c yнnт /n /t 7 /d n /m "Включить логирование в файл [y/N]?: "
	if %errorlevel% LEQ 2 (set arg=-L %arg%)

	choice /c yнnт /n /t 7 /d n /m "Изделие в режиме Горячего резервирования [y/N]?: "
	if %errorlevel% LEQ 2 (set arg=-R %arg%)
exit /b
:: =============================================================================
:arg_parsing
	set var=%1
	if %var% == 0 (
		echo.
	) else if /i "%var:~0,2%"=="-L" (
		set FLAG_LIGHT=1
	) else if /i "%var:~0,2%"=="-F" (
		set FLAG_FULL=1
	) else if /i "%var:~0,2%"=="-G" (
		call setxx.cmd FLAG_GUI 1
	) else if /i "%var:~0,2%"=="-" (
		echo.
	) else if /i "%var:~0,2%"=="-" (
		echo.
	) else if /i "%var:~0,2%"=="-" (
		echo.
	) else if /i "%var:~0,2%"=="-" (
		echo.
	) else echo Допустимые параметры для командной строки: -L -F -G
exit /b