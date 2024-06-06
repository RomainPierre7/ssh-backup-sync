#!/bin/bash

########## CONFIG ##########
# Load environment variables from config.sh file
if [[ -f config.sh ]]; then
    source config.sh
else
    echo "Error: config.sh file not found. Read the README.md file for instructions."
    exit 1
fi
############################


########## SCRIPT ##########
# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check dependencies
check_dependencies() {
    local missing=0
    for cmd in gum ssh scp rclone; do
        if ! command_exists "$cmd"; then
            echo "Error: $cmd is not installed."
            missing=1
        fi
    done
    if [ $missing -eq 1 ]; then
        echo "Please install the missing dependencies and try again."
        exit 1
    fi
}

# Check dependencies
check_dependencies

# Confirm with the user to proceed
echo "This script will:
    - copy a backup folder from a remote server (e.g. Unraid server) to a local machine (e.g. a computer).
    -> using ssh

    - and then sync it to a new remote location (e.g. google drive).
    -> using rclone.
    
This script assumes that you have already set up the rclone configuration for the remote destination,
and that you have configured the script according to the instructions (README.md).
"

if ! gum confirm "Do you want to continue ?"; then
    echo "Operation cancelled by user."
    exit 0
fi

# Function to check if the last command executed successfully
check_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# List the contents of the backup folder on the server and allow the user to select one
echo "Fetching the list of backups..."
backups=$(ssh $user@$server_ip "for item in $server_backup_folder/*; do size=\$(du -sh \"\$item\" | cut -f1); info=\$(ls -ld --time-style=long-iso \"\$item\"); echo \"\$info\" | awk -v size=\"\$size\" '{split(\$8, a, \"/\"); print a[length(a)], size, \$7, \$6}'; done")
check_success "SSH failed. Please check the connection and paths."

# Display the list with line numbers using gum
echo "Select a backup to sync:"
IFS=$'\n' backups=($backups)  # Convert to array
selected=$(for i in "${!backups[@]}"; do
    echo "$i) ${backups[$i]}"
done | gum choose)

# Extract the backup name from the selection
server_backup_name=$(echo "$selected" | awk '{print $2}' | tr -d ')')
echo "Selected backup: $server_backup_name"
remote_backup_destination="$remote_backup_folder/$server_backup_name"

# Securely copy the backup from the server to the local machine
echo "Starting SCP transfer..."
scp -r $user@$server_ip:$server_backup_folder/$server_backup_name $local_backup_destination
check_success "SCP failed. Please check the connection and paths."

# Sync the local backup to the remote Google Drive destination
echo "Starting rclone sync..."
rclone sync -P $local_backup_destination/$server_backup_name $remote:$remote_backup_destination
check_success "rclone sync failed. Please check the rclone configuration and paths."

echo "Backup completed successfully."