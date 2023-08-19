function CreateCronTask {
    param (
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^(?:[0-9]|[1-5][0-9]|60|\*) (?:[0-9]|[1-1][0-9]|2[0-3]|\*) (?:[0-9]|[1-2][0-9]|3[0-1]|\*) (?:[0-9]|[1-9][0-2]|\*) (?:[0-7]|\*)$')]
        [string]$CronExpression,

        [Parameter(Mandatory = $true)]
        [scriptblock]$Method
    )

    $taskName = 'CronTask'

    # 创建任务
    $taskAction = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -Command `$Method.Invoke()"

    $taskTrigger = New-ScheduledTaskTrigger -Daily -At (Get-Date).Date.AddMinutes(1)

    $taskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

    $task = New-ScheduledTask -Action $taskAction -Trigger $taskTrigger -Settings $taskSettings

    Register-ScheduledTask -TaskName $taskName -TaskPath '\' -InputObject $task -User 'NT AUTHORITY\SYSTEM' -Force

    Write-Output "Cron task created successfully."
}



$myMethod = {
    Write-Host "This is my method."
}

CreateCronTask -CronExpression '0 8 * * *' -Method $myMethod