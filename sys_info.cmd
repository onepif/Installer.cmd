@echo off
color 17

cd /d %~dp0
%CMD_DBG% "=== Script %~n0 started ==="
echo ���� ᡮ� ᢥ����� � ��⥬�. �������� ��������...
systeminfo >%computername%.sysinfo.log
echo.
type %computername%.sysinfo.log|findstr /b /i /c:�������� >.tmp
for /f "usebackq tokens=3*" %%i in (`type .tmp`) do echo ������������  ��: %%i %%j
echo ����來����: %PROCESSOR_ARCHITECTURE%
del .tmp 2>nul >nul
%CMD_DBG% "=== Script %~n0 completed ==="
ping -n 5 localhost >nul

exit 0
