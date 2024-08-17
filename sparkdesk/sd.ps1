$APIKey = "38812ef2a19aa0c49243a6d4f6015ff0"
$APISecret ="MDMxZWRmZWFiYTQ3NTU1OTc1OTdiZDJh"
$API_URL = "https://spark-api-open.xf-yun.com/v1/chat/completions"


function sparkdesk {
    $prompts = @()
    while ($true) {
        $sessionResponse = ""
        Write-Host "🐼: " -NoNewline
        $prompt = Read-Host
        if ($prompt -eq "q") {
            break
        }
        if ($prompt -eq "cls") {
            Clear-Host
            continue
        }
        if ($prompt -eq "" -or $prompt -eq "help") {
            Write-Host "
            _________ .__            __                 __
            \_   ___ \|  |__ _____ _/  |_  ____ _______/  |_
            /    \  \/|  |  \\__  \\   __\/ ___\\____ \   __\
            \     \___|   Y  \/ __ \|  | / /_/  >  |_> >  |
             \______  /___|  (____  /__| \___  /|   __/|__|
                    \/     \/     \/    /_____/ |__|
            " -ForegroundColor DarkRed
            Write-Host "`t Special Prompt: " -ForegroundColor Red
            Write-Host "`t ● q  = quit prompt`n`t ● cls = clear host`n`t ● n = new conversation" -ForegroundColor DarkBlue
        }
        elseif ($prompt -eq "n") {
            $prompts = @()
        }
        else {
            $prompts += @{
                role    = "user";
                content = $prompt
            }
            if ($prompts -ne @()) {
                Write-Host "🤖: " -NoNewline
                $request = [System.Net.WebRequest]::Create($API_URL)
                $request.Method = "POST"
                $request.ContentType = "application/json"
                $request.Headers.Add("Authorization", "Bearer"+$APIKey+":"+$APISecret)

                $data = @{
                    model       = "generalv3.5";
                    messages    = $prompts;
                    temperature = 0;
                    max_tokens  = 4096;
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
                                $sessionResponse += $content.choices[0].delta.content
                                Write-Host $content.choices[0].delta.content -NoNewline -ForegroundColor Magenta
                            }
                        }
                    }
                }
                $prompts += @{
                    role    = "assistant";
                    content = $sessionResponse
                }
                $reader.Close()
                $stream.Close()
                Write-Host "`n"
            }
        }
    }
}
sparkdesk