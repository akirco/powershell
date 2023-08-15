function GPT() {
    while ($true) {
        Write-Host "Q: " -BackgroundColor DarkCyan -NoNewline
        $Question = Read-Host
        Write-Host "A: " -NoNewline -BackgroundColor DarkYellow
        if ($Question -eq "exit") {
            break
        }
        $API_URL = "https://openai.extrameta.cn/v1/chat/completions"
        $API_KEY = ""
        $request = [System.Net.WebRequest]::Create($API_URL)
        $request.Method = "POST"
        $request.ContentType = "application/json"
        $request.Headers.Add("Authorization", "Bearer $API_KEY")
        $data = @{
            model       = "gpt-3.5-turbo";
            messages    = @(
                @{
                    role    = "user";
                    content = $Question
                }
            );
            temperature = 0;
            max_tokens  = 3000;
            stream      = $true;
        }
        $body = ConvertTo-Json $data
        $requestStream = $request.GetRequestStream()
        $writer = New-Object System.IO.StreamWriter($requestStream)
        $writer.Write($body)
        $writer.Flush()
        $response = $request.GetResponse()
        $stream = $response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($stream)
        while (!$reader.EndOfStream) {
            $line = $reader.ReadLine()
            if (![string]::IsNullOrWhiteSpace($line)) {
                if ($line -match '^data: (.+)$') {
                    $eventData = $Matches[1]
                    if ($eventData -ne "[DONE]") {
                        $content = ConvertFrom-Json $eventData
                        Write-Host $content.choices[0].delta.content -NoNewline -ForegroundColor Magenta
                    }
                }
            }
        }
        $reader.Close()
        $stream.Close()
        Write-Host "`n"
    }
}
GPT