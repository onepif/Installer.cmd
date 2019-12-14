if defined FLAG_DEBUG (
	set SYNC_TIME=60
	set fLOG=C:\ProgramData\logfiles\resync.log
)

SetLocal EnableDelayedExpansion
	for /l %%i in (1;0;2) do (
		call logging.cmd -s %fLOG% -m "SYNC_TIME=%SYNC_TIME%, Run resync... " 
		w32tm /resync >nul 2>nul
		if !errorlevel! == 0 (call logging.cmd -s %fLOG% -cr -ok) else call logging.cmd %fCONS% %fLOG% -cr -err
::		for /f "usebackq tokens=3" %%y in (`reg query HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient /v SpecialPollInterval`) do set SYNC_TIME=%%y
		choice /c qn /n /t %SYNC_TIME% /d n >nul
		if !errorlevel! EQU 1 if defined FLAG_DEBUG (exit /b 100) else exit 100
	)
EndLocal
