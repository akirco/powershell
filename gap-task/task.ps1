function waitsec {
    $step = 10 #设置间隔
    $add = 0  #设置延时
    $t = (get-date)
    $c = $step - (($t.Hour * 3600 + $t.Minute * 60 + $t.Second) % $step) + $add
    Write-Host $c
    return $c
}
 
function startFn {
    write-host "running...... please wait" (waitsec)"S" -f Blue -NoNewline
    Start-Sleep -s (waitsec)
    while ($true) {
        Write-Host "gap task"    
        Start-Sleep -s (waitsec)
    }   
}

startFn
