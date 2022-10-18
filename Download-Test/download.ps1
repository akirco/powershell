$fileUrl = "https://download.fastgit.org/akirco/dim/releases/download/0.1.0/dim-win.7z";
$fileName = "dim-win.7z"

# 1. WebClient对象

# $webClient  = [System.Net.WebClient]::new()  
# echo $webClient 
# $webClient.DownloadFile($fileUrl,$fileName)


# 2. Invork-WebRequest
# alias: [iwr, wget, curl]

# Invoke-WebRequest -Uri $fileUrl -OutFile $fileName

# 3. Invoke-RestMethod
# Invoke-RestMethod -Uri $fileUrl -OutFile $fileName

# 4. BitsTransfer 

Start-BitsTransfer -Source $fileUrl -Destination $fileName   # -Asynchronous

