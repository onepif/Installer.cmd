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

set ver=7.8.1
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

if not exist "%PROGRAMFILES%\OpenSSH" (
	if "%PROCESSOR_ARCHITECTURE%" == "x86" (
		7z x -y -o"%PROGRAMFILES%" -r %SOFT_ENV%\ssh\OpenSSH-Win32.zip >nul
		rename "%PROGRAMFILES%\OpenSSH-Win32" OpenSSH >nul
	) else (
		7z x -y -o"%PROGRAMFILES%" -r %SOFT_ENV%\ssh\OpenSSH-Win64.zip >nul
		rename "%PROGRAMFILES%\OpenSSH-Win64" OpenSSH >nul
	)
::	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH /t reg_expand_sz /d "%PROGRAMFILES%\OpenSSH;%PATH%" /f >nul
	cd /d "%PROGRAMFILES%\OpenSSH"
	powershell -executionpolicy bypass -file install-sshd.ps1
	ssh-keygen.exe
	net start sshd
	sc config sshd start= auto
	cd /d %~dp0
)
::ip_bri="131 132 133 134"
::ip_bvi="135 136"
::ip_bvz="141 142 143 144"
::for ix in $ip_bri $ip_bvi $ip_bvz; do ssh User@192.168.10.$ix "echo $(cat ~/.ssh/id_rsa.pub) >>c:/Users/User/.ssh/authorized_keys"; done

exit /b
