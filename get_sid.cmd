reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" /f S-1-5-21-*|findstr /i /b /c:hkey >%tmp%\.tmp
for /f "tokens=*" %%i in (%tmp%\.tmp) do for /f "usebackq tokens=3" %%j in (`reg query "%%i" /v ProfileImagePath`) do if %%j==%userprofile% (set sid=%%i)
set sid=%sid:~76%

exit /b
:: =============================================================================
