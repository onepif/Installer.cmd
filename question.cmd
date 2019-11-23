:: ./question.cmd

:: Initial configuration script.
:: For the correct operation of the script must be run with administrator privileges

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

call header.cmd

set listID=  SMAR-T   - 1;  Master   - 2;  ACK      - 3;  Tachyon  - 4;  IS       - 5;  PS       - 6;  TDK [BS] - 7
set lastID=7

set listBl1=  ARMZ    [BRI-1] - 1;          [BRI-2] - 2;          [BRI-3] - 3;          [BRI-4] - 4;  ARMV    [BVI]   - 5;          [BVI-2] - 6;          [BVI-3] - 7;          [BVI-4] - 8;  BVZ     [BVZ]  =- 9
set listBl2=  Master  [BOI-1] - 1;          [BOI-2] - 2;          [BOI-3] - 3
set listBl3=  RTS    [BKDI-1] - 1;         [BKDI-2] - 2;         [BKDI-3] - 3
set listBl4=  Tachyon [BHS-1] - 1;          [BHS-2] - 2;          [BHS-3] - 3;            [RMK] - 4
set listBl5=  IS      [BOI-1] - 1;          [BOI-2] - 2;          [BOI-3] - 3
set listBl6=  PS      [BOI-1] - 1;          [BOI-2] - 2;          [BOI-3] - 3;         [ARMO-1] - 4
set lastBl=32

%CMD_DBG% "=== Script %~n0 started ==="

if not defined ID (call :get_env %1 %2) else if not defined BLOCK (call :get_env %1 %2)

%CMD_DBG% "=== Script %~n0 completed ==="
exit /b
:: =============================================================================
:: =============================================================================
:: =============================================================================
:get_env
	call debug_lvl.cmd 2 "%~n0" "Section GET_ENV started with: arg1=%1, arg2=%2"
	cd /d %~dp0

	call set_env.cmd
	Setlocal EnableDelayedExpansion
		set ID=%1
		if not defined ID (
			call get_var.cmd -v ID -c "Select a product:;%listID%"
			call debug_lvl.cmd 2 "%~n0" "ID=!ID!"
			if !ID! EQU %TRS% (set BLOCK=0) else call :get_block
		) else (
			set BLOCK=%2
			if !ID! EQU %TRS% (if not defined BLOCK set BLOCK=0) else (if not defined BLOCK (call :get_block) )
		)
		call setxx.cmd ID !ID!
		call setxx.cmd BLOCK !BLOCK!
	Endlocal & (
		set ID=%ID%
		set BLOCK=%BLOCK%
	)
	call add_user.cmd
exit /b
:: =============================================================================
:get_block
	call get_var.cmd -v BLOCK -c "Select a block:;!listBl%ID%!"
	if !ID! EQU 1 if !BLOCK! EQU 9 (
		call get_num.cmd "specify block number [1..%lastBl%]: " %lastBl%
		set /a BLOCK=!errorlevel!+10
	)
	call debug_lvl.cmd 2 "%~n0" "BLOCK=!BLOCK!"
exit /b
:: =============================================================================
