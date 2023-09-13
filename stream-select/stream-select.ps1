# 读取大型JSON文件并搜索特定模式的示例代码（包含将结果保存到文件中）

# 引入命名空间
using namespace System.IO

# 设置文件路径和搜索模式
# $filePath = "C:\Users\Canary\Downloads\Telegram Desktop\ChatExport_2023-09-13\result.json"
$searchPattern = "telegra.ph/"

# 以流的方式读取JSON文件
$streamReader = [StreamReader]::new($filePath)

# 定义每个块的大小（根据实际情况进行调整）
$blockSize = 1000

# 定义一个数组用于存储搜索结果
$searchResults = @()

# 定义计数器变量
$totalLines = 0
$processedLines = 0

while (!$streamReader.EndOfStream) {
    $block = @()
    for ($i = 0; $i -lt $blockSize -and !$streamReader.EndOfStream; $i++) {
        $block += $streamReader.ReadLine()
        $totalLines++
    }

    # 在当前块中搜索模式
    $matchedLines = $block | Where-Object { $_ -match $searchPattern }

    # 将搜索结果添加到数组中
    $searchResults += $matchedLines

    # 更新已处理行数
    $processedLines += $matchedLines.Count

    # 计算处理进度
    $progress = [math]::Round($processedLines / $totalLines * 100, 2)

    # 打印处理进度
    Write-Host "处理进度：$progress% ($processedLines / $totalLines)"
}

# 关闭流
$streamReader.Close()

# 将搜索结果保存到文件
$outputFilePath = ".\searchResults.txt"
$searchResults | Out-File -FilePath $outputFilePath

# 打印保存结果的文件路径
Write-Host "搜索结果已保存到文件：$outputFilePath"
