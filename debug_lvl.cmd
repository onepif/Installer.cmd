@echo off
color 17

if defined FLAG_DEBUG (
	for /f %%z in ('set /a "%FLAG_DEBUG%&%1"') do if %%z == %1 echo %date% - %time% [ DEBUG LVL %1 ] - ^< %~2 ^> : "%~3";
	if defined fLOG for /f %%z in ('set /a "%FLAG_DEBUG%&%1"') do if %%z == %1 echo %date% - %time% [ DEBUG LVL %1 ] - ^< %~2 ^> : "%~3"; >>%fLOG:~3,-1%
)

exit /b
