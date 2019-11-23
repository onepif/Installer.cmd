@echo off
color 17
chcp 65001 >nul

set tmp=c:\tmp
if not exist %tmp% mkdir %tmp%
set MAX_NUM_HDD=20
cd /d %~d0

if x%1==x (call :choice_letter) else set DISK_LETTER=%1
for /f "usebackq tokens=1,*" %%i in (`fsutil fsinfo drives`) do set disk_list=%%j
:loop
	set /a var=0
	for %%i in (%disk_list%) do if x%%i==x%DISK_LETTER%:\ set /a var+=1
	if not %var%==0 (
		call :choice_letter
		goto :loop
	)

set /a arh_num=0
for /l %%i in (1,1,%MAX_NUM_HDD%) do call :main

call :quit 0

:choice_letter
	choice /c efghij /n /m "Укажите букву диска архивного накопителя [E, F, G, H, I, J]: "
	if %errorlevel%==1 (
		set DISK_LETTER=E
	) else if %errorlevel%==2 (
		set DISK_LETTER=F
	) else if %errorlevel%==3 (
		set DISK_LETTER=G
	) else if %errorlevel%==4 (
		set DISK_LETTER=H
	) else if %errorlevel%==5 (
		set DISK_LETTER=I
	) else if %errorlevel%==6 (
		set DISK_LETTER=J
	)
exit /b

:main
	set /a arh_num+=1
	if exist %DISK_LETTER%:\Signals\.arch.id (
		echo Вы выбрали уже размеченный архивный накопитель.
		choice /c yYnN /n /m "Продолжить [Y/N]?: "
	)
	if %errorlevel% GEQ 3 call :quit 1
	echo list disk|diskpart.exe
	choice /c 0123456 /n /m "Укажите номер диска: "
	set /a disk_num=%errorlevel%-1

	echo Внимание! Все данные на жестком диске будут уничтожены!
	choice /c yn /n /m "Продолжить [Y/N]: "
	if %errorlevel% GEQ 2 call :quit 2
	echo select disk %disk_num% >%tmp%\dp.sc
	echo clean >>%tmp%\dp.sc
	diskpart.exe /s %tmp%\dp.sc

	echo select disk %disk_num% >%tmp%\dp.sc
	echo create partition primary >>%tmp%\dp.sc
	diskpart.exe /s %tmp%\dp.sc

	echo list volume|diskpart.exe

	call :get_num "Укажите номер тома" 0 9
	set /a volume_num=%errorlevel%
	echo select disk %disk_num% >%tmp%\dp.sc
	echo select volume %volume_num% >>%tmp%\dp.sc
	echo format fs=ntfs quick >>%tmp%\dp.sc
	echo assign letter=%DISK_LETTER% >>%tmp%\dp.sc
	diskpart.exe /s %tmp%\dp.sc

	call :get_num "Укажите номер архивного накопителя" %arh_num% %MAX_NUM_HDD%
	set arh_num=%errorlevel%
	if %arh_num% LEQ 9 (label %DISK_LETTER%:arch0%arh_num% >nul) else label %DISK_LETTER%:arch%arh_num% >nul
	mkdir %DISK_LETTER%:\Signals >nul
	for /f "usebackq tokens=3 delims=\" %%i in (`mountvol.exe %DISK_LETTER%:\ /L`) do set var=%%i >nul
	echo %var:~7,-2%>%DISK_LETTER%:\Signals\.arch.id

	icacls %DISK_LETTER%:\Signals /inheritance:d /t
	icacls %DISK_LETTER%:\ /restore _DACL_Signals.dacl

	echo select disk %disk_num% >%tmp%\dp.sc
	echo select volume %volume_num% >>%tmp%\dp.sc
	echo remove letter=%DISK_LETTER% >>%tmp%\dp.sc
	echo offline volume >>%tmp%\dp.sc
	diskpart.exe /s %tmp%\dp.sc
	echo Извлеките архивный жесткий диск и затем нажмите любую клавишу для продолжения.
	pause >nul
	set /p var="созать следующий архивный жесткий диск [y/N]?: "
	if x%var%==x (call :quit 3) else if /i x%var%==xN (call :quit 3)
exit /b

:get_num
	set var=
	set /p var="%1 [%2] :"
	if x%var%==x (
		exit /b %2
	) else (
		if not x%var%==xq (if x%var%==xQ (call :quit 4)) else (call :quit 4)
		for /l %%j in (0,1,%3) do if %%j == %var% ( echo.&exit /b %%j )
	)
	echo.
	echo "введите значение от 0 до %3."
	echo.
goto :get_num

:quit
	del %tmp%\dp.sc
	chcp 866
	exit %1
::	exit /b %1
