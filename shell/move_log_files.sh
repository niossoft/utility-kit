#!/bin/bash
#
# move log to the folder with date format
# can use crontab job to invoke this script
# e.g. 2024-05-22

clear

echo "starting move logs.. "
echo

function move_log_files() {
	for x in $1/*;
	do
		if [ -f "$x" ]; 
		then
			d=$(date -r "$x" +%Y-%m-%d);
			mkdir -p "$1/$d";
			mv -f -- "$x" "$1/$d/";
		fi
	done
	
	#delete folder older than 7 days
	find $1 -type d -mtime +7 -exec rm -rf {} \;
}

# please put the configuration in this scope 
# e.g. move_log_files /path/to/your/directory/

echo "Done. moved logs!"