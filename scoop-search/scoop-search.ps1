  $config_path = Join-Path $env:USERPROFILE ".config\scoop\config.json"

  if(!(Test-Path $config_path)){
    Write-Host "Please notice: $env:USERPROFILE\.config\scoop\config.json is available!" -ForegroundColor DarkYellow
    return
  }

$JSON = Get-Content $config_path | ConvertFrom-Json

$root_path = $JSON.root_path

function getBuckets(){

  $buckets = Join-Path $root_path "\buckets\*\bucket"


  $bucketsDirs = Get-ChildItem -Path $buckets -Directory | Select-Object -ExpandProperty FullName

  return $bucketsDirs
}


function scoopSearch {
    param(
        [string]$searchTerm
    )
  getBuckets | ForEach-Object {
    $bucketPath = $_
    $manifestFiles = Get-ChildItem -Path $bucketPath -Recurse -Include *$searchTerm*.json
    $manifestFiles | ForEach-Object -Parallel {
          $currentFile = $_
          $packageJson = Get-Content $currentFile.FullName -Raw | ConvertFrom-Json
          $appName = $currentFile.Name.Split(".")[0]
          $bucketName = (Split-Path $currentFile.Directory -Parent).Substring((Split-Path $currentFile.Directory -Parent).LastIndexOf("\")+1)
          [PSCustomObject]@{
              Version = $packageJson.version
              App = $appName
              Bucket = $bucketName
          }
      } | Select-Object Bucket,App,Version -Unique | Format-Table -AutoSize
  }
}

function scoop {
    param(
        [Parameter(Mandatory=$true, Position=0)][string]$Command,
        [Parameter(Mandatory=$false, Position=1)][string]$Args
    )

    $shims = Join-Path $root_path "shims\scoop.ps1"

    switch($Command) {
        "search" {
            # Call our custom search function instead
            scoopSearch -searchTerm $Args
        }
        default {
            # Execute the Scoop command with the given arguments
            $commandLine = "$shims $Command $Args"
            Invoke-Expression $commandLine
        }
    }
}




