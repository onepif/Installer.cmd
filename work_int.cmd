:: ./work_int

@echo off
cd /d %~dp0
color 17

call del_var.cmd

start cmd /k "call logging.cmd -s %fLOG% -tw -cr -m"Work interrupted by the user""

exit 0
