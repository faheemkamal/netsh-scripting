@echo off
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit)

:loop
@echo off
netsh wlan stop hostednetwork
#net stop sharedaccess
#net start sharedaccess
#netsh interface set interface name="WiFi" admin=DISABLED
#netsh interface set interface name="WiFi" admin=ENABLED
netsh wlan set hostednetwork mode=allow ssid=faheemk key=12345678
netsh wlan start hostednetwork
@pause

goto loop
