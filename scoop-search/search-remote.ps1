function searchRemote {
  param(
    [Parameter(Mandatory=$false, Position=0)][string]$searchTerm,
    [Parameter(Mandatory=$false, Position=1)][string]$searchCount="20"
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

  Write-Host $body

  $requestStream = $request.GetRequestStream()
  $writer = New-Object System.IO.StreamWriter($requestStream)
  $writer.Write($body)
  $writer.Flush()

  $response = $request.GetResponse()

  $stream = $response.GetResponseStream()
  $reader = New-Object System.IO.StreamReader($stream)
  $content = $reader.ReadToEnd()

  $object = ConvertFrom-Json $content

  $object.value | Format-Table @{Label="Repository"; Expression={$_.Metadata.Repository + ".git"}},Name,Version -AutoSize

  $response.Close()
}
searchRemote wechat 10