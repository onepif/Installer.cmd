:: ./getLocale.cmd

@echo off
color 17
cd /d %~dp0

for /f "usebackq skip=2 tokens=3" %%i in (`reg query "HKEY_CURRENT_USER\Control Panel\International" /v Locale`) do call setxx.cmd LOCALE_ID %%i

call logging.cmd %fCONS% %fLOG% -cr -m"You Locale ID: %LOCALE_ID%"

exit /b %LOCALE_ID%