:: /set_pwr.cmd
:: <charset=cp866/>

for /f "usebackq tokens=4" %%i in (`"powercfg -l|findstr "Высокая производительность""`) do set my_guid=%%i
call debug_lvl.cmd 2 "%~n0" "High performance GUID: %my_guid%"

call logging.cmd %fCONS% %fLOG% -m"Power Setup... "

if defined my_guid (
	Setlocal EnableDelayedExpansion
	powercfg -setactive %my_guid%
	if !errorlevel! == 0 (%CMD_Ok%) else %CMD_Err%
	EndLocal
) else %CMD_Skip%


powercfg -change monitor-timeout-ac 0
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%
powercfg -change monitor-timeout-dc 0
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%
powercfg -change disk-timeout-ac 0
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%
powercfg -change disk-timeout-dc 0
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%
powercfg -change standby-timeout-ac 0
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%
powercfg -change standby-timeout-dc 0
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%
powercfg -change hibernate-timeout-ac 0
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%
powercfg -change hibernate-timeout-dc 0
if %errorlevel% == 0 (%CMD_OkCr%) else %CMD_ErrCr%

exit /b
