@echo off
color 17

:: MaxAllowedPhaseOffset - максимально допустипое расхождение:
::		0x012c - 5 мин
::		0x0e10 - 1 час
if "%1" == "" (
	set s1=192.168.10.2
	set s2=192.168.10.3
) else (
	set s1=%1
	if "%2" == "" (set s2=192.168.10.3) else set s2=%2
)

reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Config" /v MaxAllowedPhaseOffset /t reg_dword /d 1 /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Config" /v MaxPosPhaseCorrection /t reg_dword /d 0xFFFFFFFF /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Config" /v MaxNegPhaseCorrection /t reg_dword /d 0xFFFFFFFF /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\W32Time\Config" /v SpikeWatchPeriod /t reg_dword /d 1 /f >nul

reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" /v "NtpServer" /d "%s1%,0x1 %s2%,0x1" /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" /v "Type" /d "NTP" /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient" /v Enabled /t reg_dword /d 1 /f >nul
:: 0x003c - 60 сек;
:: 0x0258 - 600 сек;
:: 0x0e10 - 3600 сек;
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpClient" /v SpecialPollInterval /t reg_dword /d 0x0e10 /f >nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\NtpServer" /v Enabled /t reg_dword /d 0 /f >nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers" /v "" /d "6" /f >nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers" /v "6" /d "%s1%" /f >nul

:: reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" /v "NtpServer" /d "192.168.10.2,0x1" /f
:: reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers" /v "" /d "6" /f
:: reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers" /v "6" /d "192.168.10.2" /f

::LargePhaseOffset	Specifies the time offset, in tenths of a microsecond (A tenth of a microsecond is equal to 10 to the power of -7). Times that are larger than or equal to this value are considered suspicious and possibly incorrect.
::SpikeWatchPeriod	Specifies how long, in seconds, that a suspicious time offset must persist before it is accepted as correct.
::EventLogFlags	Stores configuration data for the policy setting, Configure Windows NTP Client.
::Enabled	Indicates whether the NtpServer provider is enabled in the current Time Service.

::После настройки необходимо обновить конфигурацию сервиса. Сделать это можно командой w32tm /config /update.
::И еще несколько команд для настройки, мониторинга и диагностики службы времени:
::w32tm /monitor – при помощи этой опции можно узнать, насколько системное время данного компьютера отличается от времени на контроллере домена или других компьютерах. Например: w32tm /monitor /computers:time.nist.gov
::w32tm /resync – при помощи этой команды можно заставить компьютер синхронизироваться с используемым им сервером времени.
::w32tm /stripchart –  показывает разницу во времени между текущим и удаленным компьютером. Команда w32tm /stripchart /computer:time.nist.gov /samples:5 /dataonly произведет 5 сравнений с указанным источником и выдаст результат в текстовом виде.
::w32tm /config – это основная команда, используемая для настройки службы NTP. С ее помощью можно задать список используемых серверов времени, тип синхронизации и многое другое. Например, переопределить значения по умолчанию и настроить синхронизацию времени с внешним источником, можно командой w32tm /config /syncfromflags:manual /manualpeerlist:time.nist.gov /update
::w32tm /query — показывает текущие настройки службы. Например команда w32tm /query /source  покажет текущий источник времени, а w32tm /query /configuration  выведет все параметры службы.

::net stop w32time - останавливает службу времени, если запущена.
::w32tm /unregister — удаляет службу времени с компьютера.
::w32tm /register – регистрирует службу времени на компьютере.  При этом создается заново вся ветка параметров в реестре.
::net start w32time - запускает службу.
