$currentPath = $PSScriptRoot

$sudo = Join-Path $currentPath "sudo.ps1"

Import-Module $sudo

$localhosts = "$env:windir\System32\drivers\etc\hosts"

$localhostsBackup = Join-Path $currentPath "hosts"

$localhostsBackupHash = Get-FileHash -Path $localhostsBackup

$remoteHosts = "https://ghproxy.com/https://raw.githubusercontent.com/521xueweihan/GitHub520/main/hosts"



function hosts {
  [CmdletBinding(DefaultParameterSetName = 'cat')]
  param(
    [Parameter(ParameterSetName = 'cat')]
    [Switch]$cat,

    [Parameter(ParameterSetName = 'up')]
    [Switch]$up,

    [Parameter(ParameterSetName = 'add')]
    [Switch]$add,

    [Parameter(Mandatory = $true, Position = 1)][string]$domain
  )

  if ($cat) {
    catHosts
  }
  elseif ($up) {
    upHosts
  }
  elseif ($add) {
    Write-Host "Feching domain:"$domain
    addHosts -domain $domain
  }
}



function catHosts() {
  $hostsContent = Get-Content $localhosts | ForEach-Object {
    $line = $_.Trim()
    if ($line -match '^(?<ip>[0-9\.]+)\s+(?<hostname>.+)$') {
      [PSCustomObject]@{
        IP        = $Matches['Ip']
        Hostname  = $Matches['Hostname']
        Commented = $false
      }
    }
    elseif ($line -match '^\s*#') {
      [PSCustomObject]@{
        Line      = $line
        Commented = $true
      }
    }
    else {
      [PSCustomObject]@{
        Line = $line
      }
    }
  }

  $hostsContent | Where-Object { !$_.Commented } | Select-Object IP, Hostname
}

function upHosts() {

  Write-Host "Updating hosts file..."

  # 检查目标文件是否存在
  if (Test-Path -Path $localhosts) {
    # 获取目标文件的哈希值
    $localhostsHash = Get-FileHash -Path $localhosts

    # 比较两个哈希值是否相同
    if ($localhostsHash.Hash -eq $localhostsBackupHash.Hash) {
      break
    }
    else {
      sudo.ps1 Copy-Item -Path $localhostsBackup -Destination $localhosts -Force
    }
  }

  # 打印成功消息
  Write-Host "Hosts copied successfully." -ForegroundColor DarkCyan

  Write-Host "Downloading remote hosts file..."

  $response = Invoke-WebRequest $remoteHosts -UseBasicParsing

  $hostsContent = $response.Content

  Write-Host "Writing to hosts file..."

  sudo.ps1 Add-Content $localhosts "$([Environment]::NewLine)"
  sudo.ps1 Add-Content $localhosts $hostsContent

  Write-Host "Hosts file updated successfully." -ForegroundColor DarkCyan

  Invoke-Expression "ipconfig /flushdns"

  $reader = New-Object System.IO.StringReader($hostsContent)

  while ($true) {
    $line = $reader.ReadLine()
    if ($line -eq $null) {
      break
    }
    if ($line.Contains("# Update time:")) {
      $updateDate = $line.Replace("# Update time: ", "")
      $time = Get-Date $updateDate
      Write-Host "Update time: $($time.ToString('yyyy-MM-dd HH:mm:ss'))" -ForegroundColor DarkMagenta
    }
  }
}


function addHosts {
  param ( 
    [Parameter(Mandatory = $true, Position = 0)][string]$domain
  )
  Import-Module PowerHTML
  $url = "https://sites.ipaddress.com/$domain"
  $response = Invoke-WebRequest -Uri $url
  $HTMLTable = ConvertFrom-Html $response

  $table = $HTMLTable.SelectNodes("//pre")

  try {
    foreach ($row in $table.SelectNodes('a')) {
      $ipAddress = $row.innerText.Trim()
      $isIpAddress = [System.Net.IPAddress]::TryParse($ipAddress, [ref]$null)
      if ($isIpAddress) {
        Write-Host "Adding iP address:"$ipAddress
        sudo.ps1 Add-Content $localhosts "# $domain start"
        sudo.ps1 Add-Content $localhosts "$ipAddress $domain"
        sudo.ps1 Add-Content $localhosts "# $domain end"
        Invoke-Expression "ipconfig /flushdns"
      }
      else {
        return
      }
    }
  }
  catch {
    return
  }
}
