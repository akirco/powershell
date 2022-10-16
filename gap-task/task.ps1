function waitsec{
    $step=10800 #设置间隔
    $add=0  #设置延时
    $t=(get-date)
    $step-(($t.Hour*3600+$t.Minute*60+$t.Second)%$step)+$add
}
 
function startFn {
    write-host "running...... please wait" (waitsec)"S" -f Blue -NoNewline
    Start-Sleep -s (waitsec)
    while(1){
    #执行代码
    scoop.ps1 update *
    Start-Sleep -s (waitsec)
    }   
}

startFn
