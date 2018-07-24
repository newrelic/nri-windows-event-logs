@ECHO OFF
set logname=%1
powershell.exe -noprofile -executionpolicy bypass -file infra-windows-logs.ps1 -LogName %logname%
