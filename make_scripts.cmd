:: Embedding Management Scripts

@echo off
color 17

copy /y start.cmd %WINDIR% >nul 2>nul
copy /y reboot.ico %WINDIR% >nul 2>nul
copy /y coverPeleng.jpg %WINDIR%\Web\Wallpaper\Windows\img0.jpg >nul 2>nul

echo shutdown /r /t 0 >%WINDIR%\reboot.cmd
echo shutdown /s /t 0 >%WINDIR%\poweroff.cmd
echo "%PROGRAMFILES%\Intel\Intel(R) Rapid Storage Technology"\IAStorUI.exe >%WINDIR%\rst.cmd
echo rc.SS.cmd 0 >%WINDIR%\stopSS.cmd
echo rc.SS.cmd 2 >%WINDIR%\restartSS.cmd

echo choiceShell.cmd 1 >%WINDIR%\run_as_desktop.cmd
echo choiceShell.cmd 2 >%WINDIR%\run_as_programm.cmd
