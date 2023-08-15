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


function Show-LoadingAnimation {
    param (
        [int]$Delay = 100,
        [int]$Iterations = 10
    )
    
    $spinner = @("⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏")
    
    for ($i = 0; $i -lt $Iterations; $i++) {
        $currentChar = $spinner[$i % $spinner.Length]
        Write-Host -NoNewline $currentChar
        Start-Sleep -Milliseconds $Delay
        
        # 清除上一帧的字符
        for ($j = 0; $j -lt $currentChar.Length; $j++) {
            Write-Host -NoNewline "`b"
        }
    }
}

# 使用示例
Show-LoadingAnimation -Delay 200 -Iterations 20

