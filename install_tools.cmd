set SOFT_ENV=%~dp0..\soft_environment

:: Установка sed, iconv, 7z, Notepad++, Sumatra & clink
if /i %PROCESSOR_ARCHITECTURE%==amd64 (
	copy /Y %SOFT_ENV%\sys\sed\*.dll %WINDIR%\sysWOW64 >nul
) else copy /Y %SOFT_ENV%\sys\sed\*.dll %WINDIR%\system32 >nul
copy /Y %SOFT_ENV%\sys\sed\*.exe %WINDIR% >nul

if /i %PROCESSOR_ARCHITECTURE%==amd64 (
	copy /Y %SOFT_ENV%\sys\iconv\*.dll %WINDIR%\sysWOW64 >nul
) else copy /Y %SOFT_ENV%\sys\iconv\*.dll %WINDIR%\system32 >nul
copy /Y %SOFT_ENV%\sys\iconv\*.exe %WINDIR% >nul

copy /Y %SOFT_ENV%\sys\7z\%PROCESSOR_ARCHITECTURE%\* %WINDIR% >nul

set ver=7.7.1
if /i %PROCESSOR_ARCHITECTURE%==amd64 (
	7z e %SOFT_ENV%\npp.%ver%.bin.x64.zip -o"%PROGRAMFILES%"\Notepad++ -y >nul 2>nul
) else 7z e %SOFT_ENV%\npp.%ver%.bin.zip -o"%PROGRAMFILES%"\Notepad++ -y >nul 2>nul

if not exist "%PROGRAMFILES%"\clink* (
	7z e %SOFT_ENV%\sys\clink_0.4.9.zip -o"%PROGRAMFILES%"\clink -y >nul
	call "%PROGRAMFILES%"\clink\clink.bat autorun install >nul
)

if /i %PROCESSOR_ARCHITECTURE%==amd64 (
	7z x %SOFT_ENV%\SumatraPDF-3.1.2-64.zip -o"%PROGRAMFILES%" -y >nul
) else (
	7z x %SOFT_ENV%\SumatraPDF-3.1.2.zip -o"%PROGRAMFILES%" -y >nul
)

exit /b
