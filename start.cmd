@echo off
for /f "tokens=3" %%i in ('sc query w32time^|findstr "STOPPED RUNNING"') do if %%i==4 (net stop w32time)
ping -n 4 localhost >nul
net start w32time

rmdir /s /q %tmp% >nul 2>nul
mkdir %tmp% >nul 2>nul
