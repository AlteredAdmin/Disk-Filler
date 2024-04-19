#!/bin/bash

# Function to display a progress bar
progress_bar() {
    local duration=${1}
    local columns=$(tput cols)
    local progress=$((columns * duration / 100))
    local rest=$((columns - progress))
    printf "\n["
    printf "%${progress}s" | tr ' ' '='
    printf "%${rest}s" | tr ' ' ' '
    printf "] %d%%\n" "$duration"
}

# Function to create files
create_files() {
    local drive=$1
    local folder="$drive/Drive_Filler"
    mkdir -p "$folder"
    total_size=$(df -P "$drive" | awk 'NR==2 {print $3}')
    target_size=$((total_size * 92 / 100))

    current_size=0
    while [ "$current_size" -lt "$target_size" ]; do
        size=$((RANDOM % 401 + 100)) # Random size between 100MB and 500MB
        dd if=/dev/zero of="$folder/file_$current_size" bs=1M count=$size > /dev/null 2>&1
        current_size=$(du -s "$folder" | awk '{print $1}')
        percentage=$((current_size * 100 / target_size))
        clear
        echo "Filling drive $drive to 92%:"
        progress_bar "$percentage"
        sleep 1
    done
    clear
    echo "Drive $drive filled to 92%."
}

# Function to empty files
empty_files() {
    local drive=$1
    local folder="$drive/Drive_Filler"
    rm -rf "$folder"
    echo "Files removed from $folder."
}

# Main script
if [ "$1" == "-fill" ]; then
    echo "WARNING: This script will create files on the selected drive until it's 92% full."
    echo "Use at your own risk. Do not run this on important or production drives."
    echo

    # Prompt user to select a drive
    echo "List of available drives:"
    df -h | grep '^/dev/' | awk '{print $6}'
    read -p "Enter the drive to fill (e.g., /dev/sda1): " selected_drive

    create_files "$selected_drive"

elif [ "$1" == "-empty" ]; then
    read -p "Enter the drive to empty (e.g., /dev/sda1): " selected_drive
    empty_files "$selected_drive"

else
    echo "Usage: $0 [-fill | -empty]"
    exit 1
fi
