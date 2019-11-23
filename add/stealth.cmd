@echo off
echo "C:\Program Files\Wireshark\Dumpcap.exe" -i LAN1>log.txt>wait.cmd
echo Set WshShell = CreateObject("WScript.Shell") >start.vbs
echo WshShell.Run "cmd.exe /c wait.cmd", 0, false>>start.vbs
cscript.exe //b //nologo start.vbs
ping localhost -n 6 >nul
del /f /q start.vbs
del /f /q wait.cmd
pause