:: This script create static ARP routes
@echo off

:: IP addresses
set "IP_ADDRS=192.168.1.21 192.168.1.22"

for %%i in (%IP_ADDRS%) do (
	ping -n 1 %%i >nul
)

:: Iterate through ARP table
for %%i in (%IP_ADDRS%) do (
  echo Searching for address: %%i
  for /f "delims=" %%a in ('arp -a') do (
    for %%s in (%%a) do (
      if [%%i] == [%%s] (
        for /f "tokens=2" %%m in ("%%a") do (
          echo Found MAC address for IP %%i: %%m
          echo Adding static route...
          @netsh interface ip add neighbors "LAN1" "%%i" "%%m"
        )
      )
    )
  )
)

echo done!

pause
