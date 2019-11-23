:: настройка меню "Открыть с помощью..."
reg add HKEY_CLASSES_ROOT\Applications\Notepad++.exe\shell\open\command /v "" /d "%PROGRAMFILES%\Notepad++\Notepad++.exe %%1" /f >nul
for %%i in (bat cmd gdb ini htm html log pst txt xml) do (
	reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.%%i\OpenWithList /v a /d Notepad++.exe /f >nul
	reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.%%i\OpenWithList /v MRUList /d a /f >nul
)

:: настройка контекстного меню Notepad++
set CMD_REG=reg add

set BRANCH=HKEY_LOCAL_MACHINE\SOFTWARE\Classes\*\shellex\ContextMenuHandlers
%CMD_REG% %BRANCH%\ANotepad++ /v "" /d "{00F3C2EC-A6EE-11DE-A03A-EF8F55D89593}" /f >nul

set BRANCH=HKEY_LOCAL_MACHINE\SOFTWARE\Classes\CLSID\{00F3C2EC-A6EE-11DE-A03A-EF8F55D89593}
%CMD_REG% %BRANCH% /v "" /d "ANotepad++" /f >nul
%CMD_REG% %BRANCH%\InprocServer32 /v "" /d "C:\Program Files\Notepad++\NppShell_06.dll" /f >nul
%CMD_REG% %BRANCH%\InprocServer32 /v "ThreadingModel" /d "Apartment" /f >nul
%CMD_REG% %BRANCH%\Settings /v "Title" /d "Edit with &Notepad++" /f >nul
%CMD_REG% %BRANCH%\Settings /v "Path" /d "C:\Program Files\Notepad++\notepad++.exe" /f >nul
%CMD_REG% %BRANCH%\Settings /v "Custom" /d "" /f >nul
%CMD_REG% %BRANCH%\Settings /v "ShowIcon" /t REG_DWORD /d 1 /f >nul
%CMD_REG% %BRANCH%\Settings /v "Dynamic" /t REG_DWORD /d 1 /f >nul
%CMD_REG% %BRANCH%\Settings /v "Maxtext" /t REG_DWORD /d 25 /f >nul

set BRANCH=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\notepad++.exe
%CMD_REG% "%BRANCH%" /v "" /d "C:\Program Files\Notepad++\notepad++.exe" /f >nul
set BRANCH=HKEY_LOCAL_MACHINE\SOFTWARE\Notepad++
%CMD_REG% %BRANCH% /v "" /d "C:\Program Files\Notepad++" /f >nul

:: запуск суматры для ручного конфигурирования
if not defined FLAG_WOQUERY (
	call "%PROGRAMFILES%\SumatraPDF.exe"
)

exit /b
