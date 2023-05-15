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

function searchRemote {
  param(
    [Parameter(Mandatory=$false, Position=0)][string]$searchTerm,
    [Parameter(Mandatory=$false, Position=1)][int]$searchCount=25
  )
  $APP_URL = "https://scoopsearch.search.windows.net/indexes/apps/docs/search?api-version=2020-06-30";
  $APP_KEY = "78CB5DCD0A7ABACE5B4DC3C34BC54C8F";
  $request = [System.Net.WebRequest]::Create($APP_URL)

  $request.Method = "POST"
  $request.ContentType = "application/json"
  $request.Headers.Add("api-key",$APP_KEY)

  $data = @{
    count = $true
    searchMode = "all"
    filter = ""
    orderby = "search.score() desc, Metadata/OfficialRepositoryNumber desc, NameSortable asc"
    skip = 0
    search = $searchTerm
    top = $searchCount
    select = @(
        "Id",
        "Name",
        "NamePartial",
        "NameSuffix",
        "Description",
        "Homepage",
        "License",
        "Version",
        "Metadata/Repository",
        "Metadata/FilePath",
        "Metadata/AuthorName",
        "Metadata/OfficialRepository",
        "Metadata/RepositoryStars",
        "Metadata/Committed",
        "Metadata/Sha"
    ) -join ","
    highlight = @(
        "Name",
        "NamePartial",
        "NameSuffix",
        "Description",
        "Version",
        "License",
        "Metadata/Repository",
        "Metadata/AuthorName"
    ) -join ","
    highlightPreTag = "<mark>"
    highlightPostTag = "</mark>"
  }


  $body = ConvertTo-Json $data


  $requestStream = $request.GetRequestStream()
  $writer = New-Object System.IO.StreamWriter($requestStream)
  $writer.Write($body)
  $writer.Flush()

  $response = $request.GetResponse()

  $stream = $response.GetResponseStream()
  $reader = New-Object System.IO.StreamReader($stream)
  $content = $reader.ReadToEnd()

  $object = ConvertFrom-Json $content

  $object.value | Format-Table @{Label="Remote Repository"; Expression={$_.Metadata.Repository + ".git"}},@{Label="App"; Expression={$_.Name}},Version -AutoSize

  $response.Close()
}

function scoop {
    param(
        [Parameter(Mandatory=$false, Position=0)][string]$Command,
        [Parameter(Mandatory=$false, Position=1)][string]$Args,
        [Parameter(Mandatory=$false, Position=2)][string]$OptionArg1,
        [Parameter(Mandatory=$false, Position=3)][string]$OptionArg2
    )

    $shims = Join-Path $root_path "shims\scoop.ps1"

    Write-Host $OptionArg1


    switch($Command) {
        "search" {
            # Call our custom search function instead
            scoopSearch -searchTerm $Args
            searchRemote $Args
        }
        default {
            # Execute the Scoop command with the given arguments

            $commandLine = "$shims $Command $Args $OptionArg1 $OptionArg2"

            Invoke-Expression $commandLine
        }
    }
}