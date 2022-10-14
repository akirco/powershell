
$configPath = "$env:APPDATA\bob\"
$configPersist = "F:\\OS Scoop\\Scoop\\persist\\bob\\config"
$versionsPath = "F:\\OS Scoop\\Scoop\\persist\\bob\\versions"

if(!(Test-Path $configPath)){
    New-Item -ItemType Directory -Path $configPath | Out-Null
}
    New-Item -ItemType Junction -Path $configPath -Target $configPersist | Out-Null
    New-Item -ItemType File -Path $configPersist\config.json | Out-Null

$ConfigData = @"
{
  "enable_nightly_info": true, 
  "downloads_dir": "$versionsPath", 
  "installation_location": "$versionsPath"
}
"@ 



Write-Output $ConfigData | Set-Content -Encoding UTF8 -Path "$configPersist\config.json" 
