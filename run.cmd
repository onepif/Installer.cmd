@echo off

if exist z:\etc\script copy /y z:\etc\script\*.cmd c:\tmp\script >nul

cd /d %~dp0script
if "%*" == "" (
	powershell Start-Process 'main.cmd' -Verb RunAs
) else powershell Start-Process 'main.cmd' -Verb RunAs -ArgumentList '%*'
