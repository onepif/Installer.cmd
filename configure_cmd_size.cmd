@echo off

if not defined sid call %~dp0get_sid.cmd

reg add HKEY_USERS\%sid%\Console /v ScreenBufferSize /t reg_dword /d 13107320 /f >nul & ::19660940
reg add HKEY_USERS\%sid%\Console /v HistoryBufferSize /t reg_dword /d 300 /f >nul
reg add HKEY_USERS\%sid%\Console /v WindowSize /t reg_dword /d 2621560 /f >nul & ::3276940

reg add HKEY_USERS\%sid%\Console /v QuickEdit /t reg_dword /d 1 /f >nul
reg add HKEY_USERS\%sid%\Console /v FontFamily /t reg_dword /d 48 /f >nul
reg add HKEY_USERS\%sid%\Console /v FontSize /t reg_dword /d 1179658 /f >nul
reg add HKEY_USERS\%sid%\Console /v FontWeight /t reg_dword /d 400 /f >nul

reg add "HKEY_USERS\%sid%\Console\Command Prompt" /v ScreenBufferSize /t reg_dword /d 13107320 /f >nul
reg add "HKEY_USERS\%sid%\Console\Command Prompt" /v HistoryBufferSize /t reg_dword /d 300 /f >nul
reg add "HKEY_USERS\%sid%\Console\Command Prompt" /v WindowSize /t reg_dword /d 2621560 /f >nul

reg add "HKEY_USERS\%sid%\Console\Command Prompt" /v QuickEdit /t reg_dword /d 1 /f >nul
reg add "HKEY_USERS\%sid%\Console\Command Prompt" /v FontFamily /t reg_dword /d 48 /f >nul
reg add "HKEY_USERS\%sid%\Console\Command Prompt" /v FontSize /t reg_dword /d 1179658 /f >nul
reg add "HKEY_USERS\%sid%\Console\Command Prompt" /v FontWeight /t reg_dword /d 400 /f >nul
