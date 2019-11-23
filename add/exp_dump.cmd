@echo off
powershell Start-Process 'exp master/master file=d:\master.dmp' -Verb RunAs
if %errorlevel% EQU 0 (echo "Dump Master Succesfully") else echo "Dump Master Error"
powershell Start-Process 'exp aero/aero file=d:\aero.dmp' -Verb RunAs
if %errorlevel% EQU 0 (echo "Dump Aero Succesfully") else echo "Dump Aero Error"
