set POUCH_GV=%var%

if not defined CMD_DBG call header.cmd

set FLAG_GET_PARAM=&set FLAG_QUERY=&set str2found=&set str2question=

for %%i in (%*) do call :arg_parsing %%i

set var=NULL

:: берем переменную из конфигурационного файла
for /f "tokens=1,2 delims=:" %%i in ("%str2found%") do (
	if "%%j" == "" (sed -n /%%i/p "%fCONF%" >%tmp%\.tmp) else (
		sed -n /%%i/,/\/%%i/{/%%j/p} "%fCONF%" >%tmp%\.tmp
	)
	for /f "tokens=3 delims=<>" %%i in (%tmp%\.tmp) do (
		if not "%%i" == "" (set var=%%i) else (
			call logging.cmd %fCONS% %fLOG% -te -cr -m"Parameter %str2found% not found in file: '%fCONF%'"
		)
	)
)

if "%var%" == "NULL" (call :get_param) else if not defined FLAG_WOQUERY (call :get_param)
set %variable%=%var%

Setlocal EnableDelayedExpansion
	call debug_lvl.cmd 4 "%~n0" "%variable%=!%variable%!"
EndLocal

set var=%POUCH_GV%
exit /b
:: =============================================================================
:: =============================================================================
:: =============================================================================
:arg_parsing
	set arg=%1
	set arg=%arg:"=%
	if x%FLAG_GET_PARAM% == xNULL (
		echo.>nul
		exit /b
	) else if /i x%FLAG_GET_PARAM% == xD (
		set def_var=%arg%
		set FLAG_GET_PARAM=
		exit /b
	) else if /i x%FLAG_GET_PARAM% == xF (
		set str2found=%arg%
		set FLAG_GET_PARAM=
		exit /b
	) else if /i x%FLAG_GET_PARAM% == xV (
		set variable=%arg%
		set FLAG_GET_PARAM=
		exit /b
	) else if /i x%FLAG_GET_PARAM% == xQ (
		set str2question=%arg%
		set FLAG_GET_PARAM=
		exit /b
	) else if /i x%FLAG_GET_PARAM% == xN (
		set str2question=%arg%
		set FLAG_GET_PARAM=
		exit /b
	) else if /i x%FLAG_GET_PARAM% == xC (
		echo "%arg%"|sed s/;/"\x22 \x22"/g >%tmp%\.tmp
		set /p str2question=<%tmp%\.tmp
		set FLAG_GET_PARAM=
		exit /b
	)

	if /i "%arg%" == "" (
		echo.>nul
		exit /b
	) else if /i %arg:~0,2% == -D (
		if "%arg:~2%" == "" (set FLAG_GET_PARAM=D) else set def_var=%arg:~2%
	) else if /i %arg:~0,2% == -F (
		if "%arg:~2%" == "" (set FLAG_GET_PARAM=F) else set str2found=%arg:~2%
	) else if /i %arg:~0,2% == -V (
		if "%arg:~2%" == "" (set FLAG_GET_PARAM=V) else set variable=%arg:~2%
	) else if /i %arg:~0,2% == -Q (
		set FLAG_QUERY=Q
		if "%arg:~2%" == "" (set FLAG_GET_PARAM=Q) else set str2question=%arg:~2%
	) else if /i %arg:~0,2% == -N (
		set FLAG_QUERY=N
		if "%arg:~2%" == "" (set FLAG_GET_PARAM=N) else set str2question=%arg:~2%
	) else if /i %arg:~0,2% == -C (
		set FLAG_QUERY=C
		if "%arg:~2%" == "" (set FLAG_GET_PARAM=C) else (
			echo "%arg:~2%"|sed s/;/"\x22 \x22"/g >%tmp%\.tmp
			set /p str2question=<%tmp%\.tmp
		)
	)

exit /b
:: =============================================================================
:get_param
	if defined FLAG_GUI (call :get_param_gui) else call :get_param_cli
exit /b
:: =============================================================================
:get_param_cli
:: запрашиваем переменную в консоли
	Setlocal EnableDelayedExpansion
		if defined FLAG_QUERY (
			if %FLAG_QUERY% == Q (
				echo.
				set /p var="%str2question%[ %var% ]: "
				set var=!var:"=!
				call debug_lvl 4 %~n0 "into: var=!var!"
			) else if %FLAG_QUERY% == N (
				call get_num.cmd "%str2question%[ %var% ]: " %def_var%
				if not !errorlevel! == 0 (set var=!errorlevel!)
				call debug_lvl 4 %~n0 "into: var=!var!"
			) else if %FLAG_QUERY% == C (
				call choice_cli.cmd %str2question%
				sed -i s/" *"//g %tmp%\.tmp
				set /p var=<%tmp%\.tmp
				call debug_lvl 4 %~n0 "into: var=!var!"
			)
		) else call logging.cmd %fCONS% %fLOG% -cr -te -m"{get_var} - Bad options"
	EndLocal & (set var="%var%")
	set var=%var:"=%
	call debug_lvl 4 %~n0 "out: var=%var%"
exit /b
:: =============================================================================
:: =============================================================================
:get_param_gui
	set %variable%=0
:: запрашиваем переменную в Zenity
	if defined FLAG_QUERY (
		if %FLAG_QUERY% == Q (
			%PATH_ZENITY_BIN%\zenity --entry --text="%str2question%" --width=200 --height=100 >%tmp%\.tmp
			set /p %variable%=<%tmp%\.tmp
		) else if %FLAG_QUERY% == N (
			%PATH_ZENITY_BIN%\zenity --scale --text="%str2question%" --max-value=%def_var% --width=200 --height=100 >%tmp%\.tmp
			set /p %variable%=<%tmp%\.tmp
		) else if %FLAG_QUERY% == C (
			Setlocal EnableDelayedExpansion
				set /a count=0
				for %%i in (%str2question%) do (
					set arr.!count!=%%i
					set /a count+=1
				)
				set /a count-=1
				set str=--text^=!arr.0! --column^=N --column^=type
				for /l %%i in (1;1;!count!) do set str=!str! %%i !arr.%%i!
				%PATH_ZENITY_BIN%\zenity --list !str! --width=200 --height=300>%tmp%\.tmp
			Endlocal & set /p %variable%=<%tmp%\.tmp
		)
	) else call logging.cmd %fCONS% %fLOG% -cr -te -m"{get_var} - Bad options"
exit /b
:: =============================================================================

:: функция возврацант значение в переменной заданной в параметре "-V" и файле %tmp%\.tmp
:: -D - задаёт значение по умолчанию (для параметра "-N" определяет максимальное значение при вызове функции get_num)
:: -F - задаёт строку поиска в файле сценарии ответов
:: -V - задаёт имя возвращаемой переменной
:: -Q - задаёт информационную строку запроса для функции set /p
:: -N - задаёт информационную строку запроса для функции get_num
:: -C - задаёт информационную строку запроса для функции choice_cli
