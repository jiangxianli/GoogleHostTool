powershell -noprofile Set-ExecutionPolicy Unrestricted
set SHEEL_PATH=%cd%\google-hosts.ps1
PowerShell -file %SHEEL_PATH%
ipconfig/flushdns
start  https://www.google.com.hk
pause
