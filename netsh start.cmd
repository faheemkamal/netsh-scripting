@echo off
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit)

:loop
@echo off
netsh wlan stop hostednetwork
REM net stop sharedaccess
REM net start sharedaccess
netsh interface set interface name="Wi-Fi" admin=DISABLED
netsh interface set interface name="Wi-Fi" admin=ENABLED
netsh wlan set hostednetwork mode=allow ssid=faheemk key=12345678
netsh wlan start hostednetwork
@pause

goto loop
