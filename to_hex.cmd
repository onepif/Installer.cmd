@echo off
::Первый параметр - число в десятичное системе счисления.
::Второй параметр - основание выходной системы счисления (от 2 до 16)
setlocal enabledelayedexpansion
::chcp 1251>nul

set dec=%~1
::if not "%~2"=="" (set osn=%~2) else (set osn=2)
set osn=16
if !dec! LSS 0 (set /a dec=0 - !dec!&set mn=1)
set tempr=!dec!
set bin=
set H=set HEX.
!H!10=A&!H!11=B&!H!12=C&!H!13=D&!H!14=E&!H!15=F
::if !osn! GTR 16 (echo.Слишком большое основание. Максимум 16&exit /b)
::if !osn! LSS 2 (echo.Слишком маленькое основание. Минимум 2&exit /b)
:again
if !tempr! LSS 2 (goto :out)
set /a tbin=!tempr! %% !osn!
set /a tmchs=!tempr! - !tbin!
set /a tempr=!tmchs! / !osn!
if !tbin! GEQ 10 (set tbin=!HEX.%tbin%!)
set bin=!tbin!!bin!
goto :again
:out
if "!bin!"=="" (set bin=0)
if not !tempr!==0 (set bin=!tempr!!bin!)
if "!mn!"=="1" (set bin=-!bin!)
if !dec! GEQ !osn! (echo.!bin!) else echo.0!bin!

::chcp 866>nul
endlocal

exit /b
