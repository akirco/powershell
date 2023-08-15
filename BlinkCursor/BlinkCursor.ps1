function BlinkCursor {
    param (
        [int]$duration = 500, 
        [int]$times = 5    
    )

    $visible = $true
    $originalCursorTop = [Console]::CursorTop
    $originalCursorLeft = [Console]::CursorLeft

    for ($i = 1; $i -le $times; $i++) {
        [Console]::CursorVisible = $visible
        Start-Sleep -Milliseconds $duration
        $visible = -not $visible
    }

    [Console]::CursorVisible = $true
    [Console]::SetCursorPosition($originalCursorLeft, $originalCursorTop)
}

