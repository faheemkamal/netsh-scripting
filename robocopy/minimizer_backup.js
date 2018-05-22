var WindowStyle_Hidden = 0
var objShell = WScript.CreateObject("WScript.Shell")
var result = objShell.Run("cmd.exe /c incremental_backup.bat", WindowStyle_Hidden)
