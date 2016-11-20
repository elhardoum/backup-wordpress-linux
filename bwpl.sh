#!/bin/bash

__location="$1"
__email_address="$2"

checkForPackage(){
	if ! [ `which $1` ] && [ ! -z $2 ]
	then
		echo -e "\n"
		echo "Please install '$1' package and run this process again."
		echo "$3"
		exit
	fi
}

echo -e "\n"
echo "Checking for required packages.."
echo -e "\n"
# check if mysqldump package is there
checkForPackage 'mysqldump' true
# check if mysqldump package is there
checkForPackage 'mutt' true "'mutt' is required to email you the backups."

location="$__location"

getConstant(){
	path_to_cfg="$location/wp-config.php"

	if [ ! -f $path_to_cfg ]; then
		echo "ERROR: We could not find your wp-config.php file ($path_to_cfg).."
		exit
	fi

	constant_value=$(cat "$path_to_cfg" | grep "$1" |tr '(' '\n' |tr ')' '\n'|tr -d "'" | grep "$1" | cut -d ',' -f 2|tr -d ' ')

	if [ -z $constant_value ]
	then
		echo "ERROR: We could not extract the '$1' constant from your config file."
		echo -e "\n"
		echo "Please enter $1 value:"
		read customValue

		if [ -z $customValue ]
		then
			echo "ERROR: No value was set for $1 property. Please run this process again.."
			exit
		else
			constant_value="$customValue"
		fi
	fi
}

echo -e "\n"
# database name
echo "Extracting database name.."
getConstant 'DB_NAME'
DB_NAME="$constant_value"
echo -e "\n"
# database user
echo "Extracting database credentials: user.."
getConstant 'DB_USER'
DB_USER="$constant_value"
echo -e "\n"
# database password
echo "Extracting database credentials: password.."
getConstant 'DB_PASSWORD'
DB_PASSWORD="$constant_value"

echo -e "\n"
echo -e "All database credentials set.\n"
echo -e "Backing up database in process..\n"

# generate a suffix for this update from date
_suffix="`date +%Y-%m-%d`"

if (mysqldump --databases --user="$DB_USER" --password="$DB_PASSWORD" "$DB_NAME" | gzip > "/tmp/database_backup_$_suffix.sql.gz"); then
	echo -e "\n"
	echo "Database backup succeeded!"
else
	echo -e "\n"
	echo "ERROR: Database backup failed!"
	exit
fi

echo -e "\n"
echo -e "Backing up your app root directory in progress..\n"

thisDir=$(pwd)
# remember this directory
pushd $thisDir
cd $location
# get the parent directory name
tarDir=${PWD##*/}
# saving all in a folder with parent dir name, instead of a dot for (./)
tar -czf "/tmp/root_backup_$_suffix.tar.gz" "../$tarDir"
# cd to remembered directory
popd

echo -e "\n"
echo "Root back up done."
echo -e "\n"

email_address="$__email_address"

if [ -z $email_address ]; then
	echo "Please provide a valid email address. Run this process again."
	exit
fi

# get full path for target dir
appname=`realpath $location`

# compose an email
echo -e "Dear developer,\n\nWe have attached the backup files for \"$appname\" WordPress application:\n\nDatabase: database_backup_$_suffix.sql.gz\nFiles: root_backup_$_suffix.tar.gz\n\nThanks!" >> /tmp/backup_mail_content.txt
# send the mail
if (mutt -s "Your backup for \"$appname\" app ($_suffix)" -a "/tmp/database_backup_$_suffix.sql.gz" -a "/tmp/root_backup_$_suffix.tar.gz" -- $email_address < /tmp/backup_mail_content.txt); then
	echo -e "\n"
	echo "We have emailed you the backup ($email_address)."
	echo -e "\n"
	echo "Removing the temporary backup files.."
	# delete the backup files
	rm "/tmp/root_backup_$_suffix.tar.gz"	
	rm "/tmp/database_backup_$_suffix.sql.gz"
else
	echo "ERROR: We could not send you the email to the provided address. We are keeping the backup files in this archive (/tmp/$app_backup_filename.tar) in case you needed to download them manually."
	echo -e "\n"
fi
# remove email file
rm /tmp/backup_mail_content.txt
# done
echo -e "\n"
echo "All done. Thank you!"