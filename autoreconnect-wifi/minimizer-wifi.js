var WindowStyle_Hidden = 0
var objShell = WScript.CreateObject("WScript.Shell")
var result = objShell.Run("cmd.exe /c start-wifi-autoconnect-looped.bat", WindowStyle_Hidden)
