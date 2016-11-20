# backup-wordpress-linux
Backup WordPress database and files in a linux environment easily and get backups through email.

This shell script allows you to backup your WordPress installation on Linux in seconds, backing up the database and root files and compressing everything and sending it to your desired email.

## Installation:

- `cd` into `/opt` dir ( `cd /opt` ) or any directory where you keep your custom files 
- Download this script to your server: `git clone https://github.com/elhardoum/backup-wordpress-linux.git`
- Set required permissions for the shell file: `chmod +x ./bwpl.sh`
- You're done!

## Usage:

Basically run the shell script `bwpl.sh` in the terminal followed by the path to your WordPress installation (root) and followed by your email address:

- `backup-wordpress-linux/bwpl.sh PATH_TO_ROOT email@host.tld`

Here's an example; assuming we have cloned the script to `/opt` directory:

- `/opt/backup-wordpress-linux/bwpl.sh /srv/users/serverpilot/apps/tests/public/ spam@samelh.com`

You'll get more information on the screen.

## Cron Jobs

You might as well run the backup repeatedly with a simple cron job, just make sure you run `backup-wordpress-linux/bwpl.sh PATH_TO_ROOT email@host.tld` in the task.

You can copy `backup-wordpress-linux/bwpl.sh` to one of these folders:

- `/etc/cron.hourly` to run each hour
- `/etc/cron.daily` to run daily
- `/etc/cron.weekly` to once a week
- `/etc/cron.monthly` to run once a month
