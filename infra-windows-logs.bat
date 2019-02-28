@ECHO OFF
set logName=%1
set eventIds=%2

IF DEFINED eventIds (
    powershell.exe -ExecutionPolicy Unrestricted -file infra-windows-logs.ps1 -LogName %logName% -EventIds %eventIds%
) ELSE (
    powershell.exe -ExecutionPolicy Unrestricted -file infra-windows-logs.ps1 -LogName %logName%
)
