# unraid-ssh-backup-sync

This is a simple script to copy a backup from a remote server (e.g. Unraid) to a local machine (e.g. your laptop) using SSH. Then it will sync the backup to a remote server (e.g. google drive) using rclone.

The script is intended to be run on the local machine. That way your backup will be stored on 3 different locations: the remote server, the local machine and the cloud.

This script was originally created to backup an Unraid server to a laptop and then sync the backup to Google Drive. But it can be used to backup any server to any other server.

## Requirements

To use this script you need:

- ssh installed on the local machine
- [gum](https://github.com/charmbracelet/gum) installed on the local machine
- [rclone](https://rclone.org/) installed on the local machine

## Configuration

### Get the script

You can download the script from this repository or clone it using git:

```bash
git clone https://github.com/RomainPierre7/unraid-ssh-backup-sync
```

### Configure the script

Copy the `config.example.sh` file to `config.sh`:

```bash
cp config.example.sh config.sh
```

Edit the `config.sh` file according to your needs:

```bash
user="root" #User to connect to the server by ssh (e.g. root)
server_ip="10.0.0.2" #IP of the server where the backups are stored (e.g. 10.0.0.2)
server_backup_folder="/mnt/user/backup" #Folder in the server where the backups are stored (e.g. /mnt/user/backup)

local_backup_destination="$HOME/System/Backups/Unraid" #Local folder where the backups will be stored (e.g. $HOME/System/Backups/Unraid)

remote="google-drive" #Remote device name in rclone (e.g. google-drive, dropbox, etc.)
remote_backup_folder="Backups/Unraid" #Remote folder name in your remote location (e.g. Backups/Unraid)
```

### Set the correct permission to the script

Make the script executable:

```bash
chmod +x backup_sync.sh
```

### SSH

You need to have ssh access to the server where the backups are stored.

### Rclone

You need to have rclone configured on your local machine. You can configure rclone by running:

```bash
rclone config
```

## Usage

To run the script, simply execute it:

```bash
./backup_sync.sh
```