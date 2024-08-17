# $spinner = [char]0x2588,[char]0x258F,[char]0x258E,[char]0x258D,[char]0x258C,[char]0x258B,[char]0x258A,[char]0x2589
# $delay = 100

# function Show-LoadingAnimation {
#     param(
#         [int]$duration
#     )

#     $startTime = Get-Date

#     while ((Get-Date) -lt ($startTime.AddSeconds($duration))) {
#         foreach ($char in $spinner) {
#             Write-Host -NoNewline "`r$char"
#             Start-Sleep -Milliseconds $delay
#         }
#     }

#     Write-Host "`r"
# }

# # 使用示例：显示加载动画10秒钟
# Show-LoadingAnimation -duration 10


# function Show-LoadingAnimation {
#     param (
#         [int]$Delay = 100,
#         [int]$Iterations = 10
#     )

#     $spinner = @("⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏")

#     for ($i = 0; $i -lt $Iterations; $i++) {
#         $currentChar = $spinner[$i % $spinner.Length]
#         Write-Host -NoNewline $currentChar -ForegroundColor Red

#         Start-Sleep -Milliseconds $Delay

#         for ($j = 0; $j -lt $currentChar.Length; $j++) {
#             Write-Host -NoNewline "`b"
#         }
#     }
# }

# # 使用示例
# Show-LoadingAnimation -Delay 200 -Iterations 20

function Load {
    param([scriptblock]$function,
        [string]$Label)
    $job = Start-Job  -ScriptBlock $function

    $symbols = @("⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏")
    $i = 0;
    while ($job.State -eq "Running") {
        $symbol = $symbols[$i]
        Write-Host -NoNewLine "`r$symbol $Label" -ForegroundColor Green
        Start-Sleep -Milliseconds 100
        $i++
        if ($i -eq $symbols.Count) {
            $i = 0;
        }
    }
    Write-Host -NoNewLine "`r"
}
Load -function { systeminfo | find '"System Type"' } -Label "Searching..."