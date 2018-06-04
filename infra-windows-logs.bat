@ECHO OFF
set logname=%1
powershell.exe -ExecutionPolicy Unrestricted -file infra-windows-logs.ps1 -LogName %logname%
