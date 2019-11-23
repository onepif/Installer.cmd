@echo off

set count=0

echo.
for %%i in (%*) do (
	echo %%~i
	set /a count+=1
)
choice /c 123456789q /n /m "?: "

if %errorlevel% GEQ %count% call work_int.cmd

echo %errorlevel% >%tmp%\.tmp

exit /b %errorlevel%
