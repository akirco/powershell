$ConfigData = @"
{
  "enable_nightly_info": true, 
  "downloads_dir": "$versionsPath", 
  "installation_location": "$versionsPath"
}
"@ 

Write-Output $ConfigData | Set-Content -Path "$env:USERPROFILE\Desktop\config.json" -Encoding UTF8