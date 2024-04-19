param (
    [switch]$fill,
    [switch]$empty
)

function Create-Files {
    param (
        [string]$drive
    )

    $drivePath = "$drive\Drive_Filler"
    if (-not (Test-Path $drivePath)) {
        New-Item -Path $drivePath -ItemType Directory | Out-Null
    }

    $totalSize = (Get-Volume -DriveLetter $drive).Size
    $targetSize = [math]::Round($totalSize * 0.92)
    $currentSize = 0
    $fileCount = 0

    Write-Host "Filling drive $drive to 92% capacity..."
    Write-Progress -Activity "Filling Drive" -Status "Creating Files" -PercentComplete 0

    while ($currentSize -lt $targetSize) {
        $size = Get-Random -Minimum 100 -Maximum 501  # Random size between 100MB and 500MB
        $file = New-Object byte[] ($size * 1MB)
        $filePath = Join-Path -Path $drivePath -ChildPath ("File$fileCount.txt")
        [System.IO.File]::WriteAllBytes($filePath, $file)
        
        $currentSize += $size * 1MB
        $fileCount++

        $percentComplete = [math]::Round(($currentSize / $targetSize) * 100)
        Write-Progress -Activity "Filling Drive" -Status "Creating Files" -PercentComplete $percentComplete
    }

    Write-Host "Drive $drive filled to 92% capacity."
}

function Remove-Files {
    param (
        [string]$drive
    )

    $drivePath = "$drive\Drive_Filler"
    if (Test-Path $drivePath) {
        Remove-Item -Path $drivePath -Recurse -Force
        Write-Host "Files removed from drive $drive."
    } else {
        Write-Host "Drive $drive does not contain any files."
    }
}

if ($fill) {
    Write-Warning "WARNING: Running this script will fill the selected drive to 92% capacity. Use with caution."
    $driveLetter = Read-Host "Enter the drive letter to fill (e.g., C:)"
    Create-Files -drive $driveLetter
}

if ($empty) {
    $driveLetter = Read-Host "Enter the drive letter to empty (e.g., C:)"
    Remove-Files -drive $driveLetter
}
