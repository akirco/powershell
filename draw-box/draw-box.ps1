function Draw-Box {
    param(
        [Parameter(Position=0, Mandatory=$true)]
        [string]$Text,
        [Parameter(Position=1, Mandatory=$true)]
        [int]$Width,
        [Parameter(Position=2, Mandatory=$true)]
        [int]$Height
    )

    $horizontalLine = "+" + "-" * ($Width - 2) + "+"
    $verticalLine = "|" + " " * ($Width - 2) + "|"

    Write-Host $horizontalLine
    for ($i = 0; $i -lt ($Height - 2); $i++) {
        Write-Host $verticalLine
    }
    Write-Host $horizontalLine
    Write-Host $Text
    Write-Host $horizontalLine
}

Draw-Box -Text "This is a box" -Width 20 -Height 10
