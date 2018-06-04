###
# The following command is required for testing:
#
# [System.Diagnostics.EventLog]::CreateEventSource("New Relic","Application")
###


###
# Parameters (a.k.a. Command Line Arguments)
# Usage: -LogName "LogName"
###

param (
    [string]$LogName=$(throw "-LogName is mandatory")
)


###
# Logic to handle getting new log entries by saving current date to file
# to use as -After argument of Get-Date in next pull. On first run we use current date.
# On subsequent runs it will use last date written to file.
#
# The Infrastructure Integration pulls must occur over 1 minute apart as
# the Date object is only one minute granularity.
###

$LAST_PULL_TIMESTAMP_FILE = "./last-pull-timestamp-$LogName.txt"

if(Test-Path $LAST_PULL_TIMESTAMP_FILE -PathType Leaf) {

    $timestamp = Get-Content -Path $LAST_PULL_TIMESTAMP_FILE -Encoding String | Out-String;
    $timestamp = [DateTime] $timestamp.ToString();

}else{

    $timestamp = (Get-Date).AddMinutes(-15);

}

Set-Content -Path $LAST_PULL_TIMESTAMP_FILE -Value (Get-Date -Format o)

$events = Get-EventLog -LogName $LogName -After $timestamp;


$events.ForEach({

    Add-Member -NotePropertyName 'event_type' -NotePropertyValue 'Windows Event Logs' -InputObject $_;
    Add-Member -NotePropertyName 'log_name' -NotePropertyValue $LogName -InputObject $_;

});

$payload = @{
    name = "com.newrelic.windows.eventlog"
    integration_version = "0.1.0"
    protocol_version = 1
    metrics = @($events)
    inventory = @{}
    events = @()
}

Write-Output $payload | ConvertTo-Json -Compress
