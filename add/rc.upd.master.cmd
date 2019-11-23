if not defined FLAG_DEBUG set FLAG_DEBUG=1

call rc.SS.cmd 0
ping -n 2 localhost >nul
copy /y "\\tsclient\share\Мастер для тестирования\Master.exe" D:\Master
copy /y "\\tsclient\share\Мастер для тестирования\U_BaseClasses.dll" D:\Master
ping -n 2 localhost >nul
call rc.SS.cmd
echo All done. Bye bye :)
