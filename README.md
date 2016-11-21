# Backup WordPress Linux
Backup WordPress database and files in a linux environment easily and get backups through email.

This shell script allows you to backup your WordPress installation on Linux in seconds, backing up the database and root files and compressing everything and sending it to your desired email.

## Installation

- `cd` into `/opt` dir ( `cd /opt` ) or any directory where you keep your custom files 
- Download this script to your server: `git clone https://github.com/elhardoum/backup-wordpress-linux.git`
- Set required permissions for the shell file: `chmod +x ./bwpl.sh`
- You're done!

## Usage

Basically run the shell script `bwpl.sh` in the terminal followed by the path to your WordPress installation (root) and followed by your email address:

- `backup-wordpress-linux/bwpl.sh PATH_TO_ROOT email@host.tld`

Here's an example; assuming we have cloned the script to `/opt` directory:

- `/opt/backup-wordpress-linux/bwpl.sh /srv/users/serverpilot/apps/tests/public/ spam@samelh.com`

_In the example, I have a WordPress test install on Digital Ocean droplet managed by serverpilot, so the root of tests app is within `/srv/users/serverpilot/apps/APP_NAME/public/`_

You'll get more information on the screen.

## Cron Jobs

You might as well run the backup repeatedly with a simple cron job, just make sure you run `backup-wordpress-linux/bwpl.sh PATH_TO_ROOT email@host.tld` in the task.

Add this to your `crontab`:

`backup-wordpress-linux/bwpl.sh PATH_TO_ROOT email@host.tld`

## How do I install a backup?

Normally when you receive a backup through email, you'll receive 2 compressed files, one for the database SQL file and the other for the root files.

Just download those 2 attachements to your local environment ... _writing in progress ;).._
