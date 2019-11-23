:: ./logging.cmd

:: The script to automate the logging process

:: Developer Dmitriy L. Ivanov aka onepif
:: JSC PELENG 2019
:: All rights reserved

@echo off
cd /d %~dp0
color 17

set POUCH_LGG=%var%

Setlocal EnableDelayedExpansion
for %%i in (FLAG_STDIO FLAG_CR FLAG_OK FLAG_ERR FLAG_EMPTY FLAG_SKIP FLAG_GET_PARAM mTYPE MSG FILE) do (
	set %%i=
)

for %%i in (%*) do call :arg_parsing %%i

::echo ^<DEBUG [0]^> - mTYPE=%mTYPE%, msg=%MSG%, file=%FILE%,
::echo fSTDIO=%FLAG_STDIO%, fCR=%FLAG_CR%, fOK=%FLAG_OK%, fEMPTY=%FLAG_EMPTY%, fSKIP=%FLAG_SKIP%, fGPARAM=%FLAG_GET_PARAM%

if "%mTYPE%" == "" set mTYPE=INFO
if not x%FLAG_EMPTY% == xNULL (if "%MSG%" == "" set FLAG_EMPTY=TRUE)
if "%FILE%" == "" set FILE=NULL

if x%FLAG_EMPTY% == xTRUE (
	set CMD_LOG="echo."
) else if x%FLAG_OK% == xTRUE (
	if x%FLAG_CR% == xTRUE (set CMD_LOG="echo [ OK ]") else set CMD_LOG="<nul set /p var=[ OK ]"
) else if x%FLAG_ERR% == xTRUE (
	if x%FLAG_CR% == xTRUE (set CMD_LOG="echo [ ERR ]") else set CMD_LOG="<nul set /p var=[ ERR ]"
) else if x%FLAG_SKIP% == xTRUE (
	if x%FLAG_CR% == xTRUE (set CMD_LOG="echo [ SKIP ]") else set CMD_LOG="<nul set /p var=[ SKIP ]"
) else (
	set FULL_STR=%date% - %time% [ %mTYPE% ] - %MSG%
	if x%FLAG_CR% == xTRUE (set CMD_LOG="echo !FULL_STR!") else set CMD_LOG="<nul set /p var=!FULL_STR!"
)

if not x%FILE% == xNULL (%CMD_LOG:~1,-1%>>%FILE%)
if x%FLAG_STDIO% == xTRUE (%CMD_LOG:~1,-1%)
EndLocal

set var=%POUCH_LGG%

exit /b
:: =============================================================================
:: =============================================================================
:: =============================================================================
:arg_parsing
	set var=%1
	set var="%var:"=%"
	set var=%var:(=%
	set var=%var:)=%

	if x%FLAG_GET_PARAM% == xT (
		if /i "%var:~1,1%" == NULL (
			echo.>nul
		) else if /i "%var:~1,-1%" == "D" (
			set mTYPE=DEBUG
		) else if /i "%var:~1,-1%" == "E" (
			set mTYPE=ERROR
		) else if /i "%var:~1,-1%" == "I" (
			set mTYPE=INFO
		) else if /i "%var:~1,-1%" == "W" (
			set mTYPE=WARNING
		) else set mTYPE=%var:"=%
		set FLAG_GET_PARAM=
		exit /b
	) else if /i x%FLAG_GET_PARAM% == xM (
		set MSG=%var:"=%
		set FLAG_GET_PARAM=
		exit /b
	) else if /i x%FLAG_GET_PARAM% == xO (
		set FILE=%var:"=%
		set FLAG_GET_PARAM=
		exit /b
	)

	if /i %var% == NULL (
		echo.>nul
	) else if /i %var% == "-S" (
		set FLAG_STDIO=TRUE
	) else if /i %var% == "-CR" (
		set FLAG_CR=TRUE
		set FLAG_EMPTY=NULL
	) else if /i %var% == "-OK" (
		set FLAG_OK=TRUE
		set FLAG_EMPTY=NULL
	) else if /i %var% == "-ERR" (
		set FLAG_ERR=TRUE
		set FLAG_EMPTY=NULL
	) else if /i %var% == "-EMPTY" (
		set FLAG_EMPTY=TRUE
	) else if /i %var% == "-SKIP" (
		set FLAG_SKIP=TRUE
		set FLAG_EMPTY=NULL
	) else if /i %var:~1,2% == -T (
		if "%var:~3,-1%" == "" (set FLAG_GET_PARAM=T) else (
			if /i "%var:~3,-1%" == NULL (
				echo.>nul
			) else if /i "%var:~3,-1%" == "D" (
				set mTYPE=DEBUG
			) else if /i "%var:~3,-1%" == "E" (
				set mTYPE=ERROR
			) else if /i "%var:~3,-1%" == "I" (
				set mTYPE=INFO
			) else if /i "%var:~3,-1%" == "W" (
				set mTYPE=WARNING
			) else set mTYPE=%var:~3,-1%
		)
	) else if /i %var:~1,2% == -M (
		if "%var:~3,-1%" == "" (set FLAG_GET_PARAM=M) else set MSG=%var:~3,-1%
	) else if /i %var:~1,2% == -O (
		if "%var:~3,-1%" == "" (set FLAG_GET_PARAM=O) else set FILE=%var:~3,-1%
	)
exit /b
:: =============================================================================
:: d - DEBUG, e - ERROR, i - INFO, w - WARNING
