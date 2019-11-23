@echo off
color 17

reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr /d 1 /f >nul
reg add HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoRecentDocsHistory /d 1 /f >nul
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v NoRecentDocsHistory /d 1 /f >nul
reg add HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v ClearRecentDocsOnExit /d 1 /f >nul
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer /v ClearRecentDocsOnExit /d 1 /f >nul
