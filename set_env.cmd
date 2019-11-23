::@echo off

if not defined CMD_DBG call header.cmd

%CMD_DBG% "=== Script %~n0 started ==="

call del_var.cmd tmp

call setxx.cmd tmp c:\tmp
if not exist %tmp% ( mkdir %tmp% >nul 2>nul )

call setxx.cmd TRUE		1
call setxx.cmd FALSE	0

call setxx.cmd stop		0
call setxx.cmd start	1
call setxx.cmd restart	2
call setxx.cmd status	3

call setxx.cmd SMART	1
call setxx.cmd MASTER	2
call setxx.cmd RTS		3
call setxx.cmd TACHYON	4
call setxx.cmd IS		5
call setxx.cmd PS		6
call setxx.cmd TRS		7

%CMD_DBG% "=== Script %~n0 comleted ==="

exit /b
