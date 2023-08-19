# install scoop 

function Answer_Prompt() {
    param
    (
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [string]$msg,
        [string]$BackgroundColor = "Black",
        [string]$ForegroundColor = "DarkGreen"
    )

    Write-Host -ForegroundColor $ForegroundColor -NoNewline $msg;
    return Read-Host
}

function checkInstallerCache(){
    
}

$choice = Answer_Prompt 'Do you want to install scoop ? [Y/N]'

if($choice -eq 'y'){
    Write-Host "Yeah, will download installer..."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri get.scoop.sh -OutFile 'installer.ps1'
    $hash = (Get-FileHash -Path "./installer.ps1").Hash
    Write-Host "Download success! Hash: $hash " -f Blue 
    $startInstall = Answer_Prompt 'start install... ? [Y/N]'
    if($startInstall -eq 'y'){
        Invoke-Expression "./installer.ps1" 
    }else{

    }
}else {
    Exit-PSHostProcess
}