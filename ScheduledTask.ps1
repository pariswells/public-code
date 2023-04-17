$events = get-scheduledtask | where {$_.State -ne "Disabled"} | where {((Get-ScheduledTaskInfo $_).LastTaskResult -ne "0") -and ((Get-ScheduledTaskInfo $_).LastTaskResult -ne "267009") -and ((Get-ScheduledTaskInfo $_).LastRunTime -ge ((Get-Date).AddHours(-48)) -and ((Get-ScheduledTaskInfo $_).TaskPath -notlike "\Microsoft\*" ))} | Select TaskName

$eventcounnt = ($events.TaskName).Count

if ($eventcounnt) {return 1} else {return 0} 