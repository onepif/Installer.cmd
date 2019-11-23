:: Uninstall heap soft
@echo off
color 17

call debug_lvl.cmd 2 "%~n0" "WINVER=%WINVER%"

if %WINVER% == 7 (
	call logging.cmd %fCONS% %fLOG% -m"Uninstall: InboxGames, MediaCenter, OpticalMediaDisc, WindowsGadgetPlatform, TabletPCOC... "
	for %%i in (InboxGames MediaCenter OpticalMediaDisc WindowsGadgetPlatform TabletPCOC) do (
		<nul set /p var=.
		start /w ocsetup %%i /uninstall /passive /norestart
	)
) else if %WINVER% == 10 (
:: SolitaireCollection, XBoxLive, Погода, Советы, Улучшите_свой_офис
	for %%i in (
		Microsoft.BingWeather
		Microsoft.Messaging
		Microsoft.MixedReality.Portal
		Microsoft.Microsoft3DViewer
		Microsoft.MicrosoftOfficeHub
		Microsoft.MicrosoftSolitaireCollection
		Microsoft.MicrosoftStickyNotes
		Microsoft.Office.OneNote
		Microsoft.People
		Microsoft.Print3D
		Microsoft.ScreenSketch
		Microsoft.SkypeApp
		Microsoft.WindowsFeedbackHub
		Microsoft.WindowsSoundRecorder
		Microsoft.Xbox.TCUI
		Microsoft.XboxApp
		Microsoft.XboxGameOverlay
		Microsoft.XboxGamingOverlay
		Microsoft.XboxIdentityProvider
		Microsoft.XboxSpeechToTextOverlay
		Microsoft.YandexMusic
		Microsoft.YourPhone
		Microsoft.ZuneMusic
		Microsoft.ZuneVideo
	) do call :sub_uninst
)
:: =============================================================================
:sub_uninst
	call logging.cmd %fCONS% %fLOG% -m "Uninstall %%i... "
	powershell "Get-AppxPackage -allusers %%i* | Remove-AppxPackage" 2>nul 1>nul
	if %errorlevel% == 0 (%CMD_OkCr%) else %CMD_ErrCr%
exit /b
:: =============================================================================
:: =============================================================================
:: =============================================================================
