set POUCH_GN=%var%

call header.cmd
set var=NULL
:loop
	echo.
	set /p var=%1
	if %var% == NULL (
		call debug_lvl.cmd 4 "%~n0" "choice 0"
		echo NULL>%tmp%\.tmp
		set var=%POUCH_GN%
		exit /b 0
	) else (
		if /i %var% == q (call work_int.cmd)
		for /l %%i in (0,1,%2) do if %%i == %var% (
			call debug_lvl.cmd 4 "%~n0" "choice %%i"
			echo %%i>%tmp%\.tmp
			set var=%POUCH_GN%
			exit /b %%i
		)
	)
	echo.
	echo Enter a value from 1 to %2
	echo.
goto :loop
