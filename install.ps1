

function check_partitions {
        $partitions = Get-WmiObject -Class Win32_LogicalDisk
        foreach ($partition in $partitions) {
                $sizeGB = [math]::Round($partition.Size / 1GB, 2)
                $freeSpaceGB = [math]::Round($partition.FreeSpace / 1GB, 2)

                Write-Host "DeviceID: $($partition.DeviceID)"
                Write-Host "VolumeName: $($partition.VolumeName)"
                Write-Host "FileSystem: $($partition.FileSystem)"
                Write-Host "Size: $sizeGB GB"
                Write-Host "FreeSpace: $freeSpaceGB GB"
                Write-Host "--------------------------"
        }
}