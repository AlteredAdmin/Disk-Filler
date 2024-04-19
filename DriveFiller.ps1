param(
    [switch]$Fill,
    [switch]$Empty
)

# Function to create a file of specified size
function Create-File {
    param(
        [string]$filePath,
        [int]$fileSizeMB
    )
    $fileStream = New-Object IO.FileStream $filePath, Create, Write
    $fileStream.SetLength($fileSizeMB * 1MB)
    $fileStream.Close()
}

# Function to remove files created by the script
function Remove-Files {
    param(
        [string]$folderPath
    )
    Get-ChildItem -Path $folderPath | Remove-Item -Force
}

# Display a warning about the dangers of running the script
Write-Host "WARNING: This script will create files on the selected drive to fill it up to 92% capacity. Use with caution!"
Write-Host

# Prompt the user to select a drive if -Fill is specified
if ($Fill) {
    # Prompt the user to select a drive
    $drives = Get-WmiObject Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3} | Select-Object -ExpandProperty DeviceID
    $driveIndex = 1
    Write-Host "Select a drive to fill:"
    foreach ($drive in $drives) {
        Write-Host "$driveIndex. $drive"
        $driveIndex++
    }
    $selectedDriveIndex = Read-Host "Enter the number of the drive (1-$($drives.Count))"

    # Validate user input
    if ($selectedDriveIndex -lt 1 -or $selectedDriveIndex -gt $drives.Count) {
        Write-Host "Invalid selection. Exiting script."
        exit
    }

    # Calculate 92% of the drive capacity
    $selectedDrive = $drives[$selectedDriveIndex - 1]
    $disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='$selectedDrive'"
    $driveSize = $disk.Size
    $targetSize = [math]::Ceiling($driveSize * 0.92)

    # Create a folder on the selected drive
    $folderPath = "$selectedDrive\Drive_Filler"
    New-Item -ItemType Directory -Path $folderPath | Out-Null

    # Initialize variables for progress tracking
    $currentSize = 0
    $progressBarWidth = 50

    # Loop to create files until the drive is filled to 92%
    while ($currentSize -lt $targetSize) {
        # Generate a random file size between 100MB and 500MB
        $fileSizeMB = Get-Random -Minimum 100 -Maximum 501
        $fileName = "$folderPath\File_$([guid]::NewGuid().ToString()).txt"
        Create-File -filePath $fileName -fileSizeMB $fileSizeMB
        $currentSize += $fileSizeMB

        # Display progress
        $progressPercentage = [math]::Min([int]($currentSize / $targetSize * 100), 100)
        $progressBarLength = [math]::Min([int]($progressPercentage / 2), $progressBarWidth)
        $progressBar = "[" + "-" * $progressBarLength + (" " * ($progressBarWidth - $progressBarLength)) + "]"
        Write-Progress -Activity "Filling drive $selectedDrive" -Status "$progressPercentage% complete" -PercentComplete $progressPercentage
    }

    Write-Host "Drive $selectedDrive filled to 92% capacity."
}

# Remove files if -Empty is specified
if ($Empty) {
    if ($folderPath) {
        Write-Host "Removing files from $folderPath"
        Remove-Files -folderPath $folderPath
        Write-Host "Files removed."
    } else {
        Write-Host "No files to remove."
    }
}
