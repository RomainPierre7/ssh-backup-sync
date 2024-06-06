user="root" #User to connect to the server by ssh (e.g. root)
server_ip="10.0.0.2" #IP of the server where the backups are stored (e.g. 10.0.0.2)
server_backup_folder="/mnt/user/backup" #Folder in the server where the backups are stored (e.g. /mnt/user/backup)

local_backup_destination="$HOME/System/Backups/Unraid" #Local folder where the backups will be stored (e.g. $HOME/System/Backups/Unraid)

remote="google-drive" #Remote device name in rclone (e.g. google-drive, dropbox, etc.)
remote_backup_folder="Backups/Unraid" #Remote folder name in your remote location (e.g. Backups/Unraid)