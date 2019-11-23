:: https://habr.com/ru/post/267507/

Set-NetFirewallProfile -all

call logging.exe %fCONS% %fLOG% -m"Add firewall rules... "
netsh advfirewall firewall add rule name="telemetry_vortex.data.microsoft.com" dir=out action=block remoteip=191.232.139.254 enable=yes
netsh advfirewall firewall add rule name="telemetry_telecommand.telemetry.microsoft.com" dir=out action=block remoteip=65.55.252.92 enable=yes
netsh advfirewall firewall add rule name="telemetry_sqm.telemetry.microsoft.com" dir=out action=block remoteip=65.55.252.93 enable=yes
netsh advfirewall firewall add rule name="telemetry_watson.telemetry.microsoft.com" dir=out action=block remoteip=65.55.252.43,65.52.108.29 enable=yes
netsh advfirewall firewall add rule name="telemetry_redir.metaservices.microsoft.com" dir=out action=block remoteip=194.44.4.200,194.44.4.208 enable=yes
netsh advfirewall firewall add rule name="telemetry_choice.microsoft.com" dir=out action=block remoteip=157.56.91.77 enable=yes
netsh advfirewall firewall add rule name="telemetry_df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.7 enable=yes
netsh advfirewall firewall add rule name="telemetry_reports.wes.df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.91 enable=yes
netsh advfirewall firewall add rule name="telemetry_wes.df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.93 enable=yes
netsh advfirewall firewall add rule name="telemetry_services.wes.df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.92 enable=yes
netsh advfirewall firewall add rule name="telemetry_sqm.df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.94 enable=yes
netsh advfirewall firewall add rule name="telemetry_telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.9 enable=yes
netsh advfirewall firewall add rule name="telemetry_watson.ppe.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.11 enable=yes
netsh advfirewall firewall add rule name="telemetry_telemetry.appex.bing.net" dir=out action=block remoteip=168.63.108.233 enable=yes
netsh advfirewall firewall add rule name="telemetry_telemetry.urs.microsoft.com" dir=out action=block remoteip=157.56.74.250 enable=yes
netsh advfirewall firewall add rule name="telemetry_settings-sandbox.data.microsoft.com" dir=out action=block remoteip=111.221.29.177 enable=yes
netsh advfirewall firewall add rule name="telemetry_vortex-sandbox.data.microsoft.com" dir=out action=block remoteip=64.4.54.32 enable=yes
netsh advfirewall firewall add rule name="telemetry_survey.watson.microsoft.com" dir=out action=block remoteip=207.68.166.254 enable=yes
netsh advfirewall firewall add rule name="telemetry_watson.live.com" dir=out action=block remoteip=207.46.223.94 enable=yes
netsh advfirewall firewall add rule name="telemetry_watson.microsoft.com" dir=out action=block remoteip=65.55.252.71 enable=yes
netsh advfirewall firewall add rule name="telemetry_statsfe2.ws.microsoft.com" dir=out action=block remoteip=64.4.54.22 enable=yes
netsh advfirewall firewall add rule name="telemetry_corpext.msitadfs.glbdns2.microsoft.com" dir=out action=block remoteip=131.107.113.238 enable=yes
netsh advfirewall firewall add rule name="telemetry_compatexchange.cloudapp.net" dir=out action=block remoteip=23.99.10.11 enable=yes
netsh advfirewall firewall add rule name="telemetry_cs1.wpc.v0cdn.net" dir=out action=block remoteip=68.232.34.200 enable=yes
netsh advfirewall firewall add rule name="telemetry_a-0001.a-msedge.net" dir=out action=block remoteip=204.79.197.200 enable=yes
netsh advfirewall firewall add rule name="telemetry_statsfe2.update.microsoft.com.akadns.net" dir=out action=block remoteip=64.4.54.22 enable=yes
netsh advfirewall firewall add rule name="telemetry_sls.update.microsoft.com.akadns.net" dir=out action=block remoteip=157.56.77.139 enable=yes
netsh advfirewall firewall add rule name="telemetry_fe2.update.microsoft.com.akadns.net" dir=out action=block remoteip=134.170.58.121,134.170.58.123,134.170.53.29,66.119.144.190,134.170.58.189,134.170.58.118,134.170.53.30,134.170.51.190 enable=yes
netsh advfirewall firewall add rule name="telemetry_diagnostics.support.microsoft.com" dir=out action=block remoteip=157.56.121.89 enable=yes
netsh advfirewall firewall add rule name="telemetry_corp.sts.microsoft.com" dir=out action=block remoteip=131.107.113.238 enable=yes
netsh advfirewall firewall add rule name="telemetry_statsfe1.ws.microsoft.com" dir=out action=block remoteip=134.170.115.60 enable=yes
netsh advfirewall firewall add rule name="telemetry_pre.footprintpredict.com" dir=out action=block remoteip=204.79.197.200 enable=yes
netsh advfirewall firewall add rule name="telemetry_i1.services.social.microsoft.com" dir=out action=block remoteip=104.82.22.249 enable=yes
netsh advfirewall firewall add rule name="telemetry_feedback.windows.com" dir=out action=block remoteip=134.170.185.70 enable=yes
netsh advfirewall firewall add rule name="telemetry_feedback.microsoft-hohm.com" dir=out action=block remoteip=64.4.6.100,65.55.39.10 enable=yes
netsh advfirewall firewall add rule name="telemetry_feedback.search.microsoft.com" dir=out action=block remoteip=157.55.129.21 enable=yes
netsh advfirewall firewall add rule name="telemetry_rad.msn.com" dir=out action=block remoteip=207.46.194.25 enable=yes
netsh advfirewall firewall add rule name="telemetry_preview.msn.com" dir=out action=block remoteip=23.102.21.4 enable=yes
netsh advfirewall firewall add rule name="telemetry_dart.l.doubleclick.net" dir=out action=block remoteip=173.194.113.220,173.194.113.219,216.58.209.166 enable=yes
netsh advfirewall firewall add rule name="telemetry_ads.msn.com" dir=out action=block remoteip=157.56.91.82,157.56.23.91,104.82.14.146,207.123.56.252,185.13.160.61,8.254.209.254 enable=yes
netsh advfirewall firewall add rule name="telemetry_a.ads1.msn.com" dir=out action=block remoteip=198.78.208.254,185.13.160.61 enable=yes
netsh advfirewall firewall add rule name="telemetry_global.msads.net.c.footprint.net" dir=out action=block remoteip=185.13.160.61,8.254.209.254,207.123.56.252 enable=yes
netsh advfirewall firewall add rule name="telemetry_az361816.vo.msecnd.net" dir=out action=block remoteip=68.232.34.200 enable=yes
netsh advfirewall firewall add rule name="telemetry_oca.telemetry.microsoft.com.nsatc.net" dir=out action=block remoteip=65.55.252.63 enable=yes
netsh advfirewall firewall add rule name="telemetry_reports.wes.df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.91 enable=yes
netsh advfirewall firewall add rule name="telemetry_ssw.live.com" dir=out action=block remoteip=207.46.101.29 enable=yes
netsh advfirewall firewall add rule name="telemetry_msnbot-65-55-108-23.search.msn.com" dir=out action=block remoteip=65.55.108.23 enable=yes
netsh advfirewall firewall add rule name="telemetry_a23-218-212-69.deploy.static.akamaitechnologies.com" dir=out action=block remoteip=23.218.212.69 enable=yes
if %errorlevel% == 0 (%CMD_OkCr%) else %CMD_ErrCr%

pause
:: сбор данных в компонентах Windows
sc stop DiagTrack

:: cлужба маршрутизации push-сообщений WAP
sc stop dmwappushservice

call logging.cmd %fCONS% %fLOG% -m"Scheduled telemetry off... "
REM *** Task that collects data for SmartScreen in Windows ***
schtasks /Change /TN "Microsoft\Windows\AppID\SmartScreenSpecific" /Disable >nul 2>nul
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%

REM *** Collects program telemetry information if opted-in to the Microsoft Customer Experience Improvement Program ***
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable >nul 2>nul
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%

REM *** Collects program telemetry information if opted-in to the Microsoft Customer Experience Improvement Program ***
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>nul
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%

REM *** Aggregates and uploads Application Telemetry information if opted-in to the Microsoft Customer Experience Improvement Program ***
schtasks /Change /TN "Microsoft\Windows\Application Experience\AitAgent" /Disable >nul 2>nul
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%

REM *** This task collects and uploads autochk SQM data if opted-in to the Microsoft Customer Experience Improvement Program ***
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable >nul 2>nul
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%

REM *** If the user has consented to participate in the Windows Customer Experience Improvement Program, this job collects and sends usage data to Microsoft ***
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>nul
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%

REM *** The Kernel CEIP (Customer Experience Improvement Program) task collects additional information about the system and sends this data to Microsoft. *** 
REM *** If the user has not consented to participate in Windows CEIP, this task does nothing ***
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /Disable >nul 2>nul
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%

REM *** The Bluetooth CEIP (Customer Experience Improvement Program) task collects Bluetooth related statistics and information about your machine and sends it to Microsoft ***
REM *** The information received is used to help improve the reliability, stability, and overall functionality of Bluetooth in Windows ***
REM *** If the user has not consented to participate in Windows CEIP, this task does not do anything.***
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\BthSQM" /Disable >nul >nul 2>nul
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%

REM *** Create Object Task ***
schtasks /Change /TN "Microsoft\Windows\CloudExperienceHost\CreateObjectTask" /Disable >nul 2>nul
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%

REM *** The Windows Disk Diagnostic reports general disk and system information to Microsoft for users participating in the Customer Experience Program ***
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable >nul 2>nul
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%

REM *** Measures a system's performance and capabilities ***
schtasks /Change /TN "Microsoft\Windows\Maintenance\WinSAT" /Disable >nul 2>nul
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%

REM *** Network information collector ***
schtasks /Change /TN "Microsoft\Windows\NetTrace\GatherNetworkInfo" /Disable >nul 2>nul
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%

REM *** Initializes Family Safety monitoring and enforcement ***
schtasks /Change /TN "Microsoft\Windows\Shell\FamilySafetyMonitor" /Disable >nul 2>nul
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%

REM *** Synchronizes the latest settings with the Family Safety website ***
schtasks /Change /TN "Microsoft\Windows\Shell\FamilySafetyRefresh" /Disable >nul 2>nul
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%

REM *** SQM (Software Quality Management) ***
schtasks /Change /TN "Microsoft\Windows\IME\SQM data sender" /Disable >nul 2>nul
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%

REM *** This task initiates the background task for Office Telemetry Agent, which scans and uploads usage and error information for Office solutions ***
schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentFallBack" /Disable >nul 2>nul
if %errorlevel% == 0 (%CMD_Ok%) else %CMD_Err%

REM *** This task initiates Office Telemetry Agent, which scans and uploads usage and error information for Office solutions when a user logs on to the computer ***
schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentLogOn" /Disable >nul 2>nul
if %errorlevel% == 0 (%CMD_OkCr%) else %CMD_ErrCr%

pause
