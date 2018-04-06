#!/bin/bash
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$PATH

# Compress old conversations
#set -x

YEAR=$(date +%Y)

MONTH_AGO=$(date --date='1 month ago' '+%m')
YEAR_AGO=$(date --date='1 year ago' '+%Y')

SOURCE="/var/spool/asterisk/monitor"

# correct first run
#----------------------------------------------------------------------------------------
ls -l "$SOURCE" | grep "^d" > /dev/null 2>&1
if [ 0 -ne $? ]							# if not equal, not success
then
	mkdir -p "$SOURCE/$YEAR"
fi

# check conditions
#----------------------------------------------------------------------------------------
stat -t "$SOURCE"/*.wav > /dev/null 2>&1
if [ 0 -ne $? ]							# if not equal, not success
then
#	echo "There are no data to compress in $SOURCE" | mail -s "Compess old calls" root@example.com
	exit 113
fi

# the new year starts
#----------------------------------------------------------------------------------------
if [ ! -d "$SOURCE/$YEAR" ]					# if not equal, not success
then
	mkdir -p "$SOURCE/$YEAR"
	mkdir -p "$SOURCE/$YEAR_AGO/$MONTH_AGO"

	bzip2 "$SOURCE"/*.wav

	find "$SOURCE" -maxdepth 1 -type f -name "*.bz2" > /tmp/archive_old_wav

	while read -r line
	do
		mv "$SOURCE/$line" "$SOURCE/$YEAR_AGO/$MONTH_AGO"
	done < /tmp/archive_old_wav
	exit 0
fi

# during the year
#----------------------------------------------------------------------------------------
if [ ! -d  "$SOURCE/$YEAR/$MONTH_AGO" ]				# if not equal, not success
then
	mkdir -p "$SOURCE/$YEAR/$MONTH_AGO"

	bzip2 "$SOURCE"/*.wav

	find "$SOURCE" -maxdepth 1 -type f -name "*.bz2" > /tmp/archive_old_wav
	# find /var/spool/asterisk/monitor -maxdepth 1 -type f -name "*.bz2" | xargs -I {} mv {} /var/spool/asterisk/monitor/2016/02/

	while read -r archive_path
	do
		mv "$archive_path" "$SOURCE/$YEAR/$MONTH_AGO"
	done < /tmp/archive_old_wav
fi

# Delete calls from $SOURCE that older than 365 days
#----------------------------------------------------------------------------------------

find "$SOURCE"/* -maxdepth 1 -type d -mtime +1825 -exec rm -rf {} \;
