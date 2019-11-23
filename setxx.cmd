
if x%2==xtmp (set /p var= <%tmp%\.tmp) else set var=%~2
set %1=%var%
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v %1 /d "%var%" /f >nul

call debug_lvl.cmd 4 "%~n0" "%1=%var% to HKLM/Environment"

exit /b