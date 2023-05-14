function getBuckets(){
  $root_path = Invoke-Expression "scoop config root_path"

  $buckets = $root_path +"\buckets\*\bucket"

  $bucketsDirs = Get-ChildItem -Path $buckets -Directory | Select-Object -ExpandProperty FullName

  return $bucketsDirs
}


function scoopSearch {
  param (
    [Parameter(Mandatory=$false, Position=0)]
    [string]$searchTerm = $args[0]
  )

  getBuckets | ForEach-Object {
    $bucketPath = $_
    Get-ChildItem -Path $bucketPath -Recurse -Include *$searchTerm*.json |
      ForEach-Object -Parallel {
          $filePath = $_.FullName
          $content = Get-Content $filePath -Raw
          $bucket = (Split-Path $_.Directory -Parent).Substring((Split-Path $_.Directory -Parent).LastIndexOf("\")+1)
          $packageName = $_.Name.Split(".")[0]
          $packageJson = $content | ConvertFrom-Json
          [PSCustomObject]@{
              Version = $packageJson.version
              App = $packageName
              Bucket = $bucket
          }
      } | Select-Object Bucket,App,Version -Unique | Format-Table -AutoSize
  }
}




