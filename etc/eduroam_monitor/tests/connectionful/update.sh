#!/bin/bash

### Get Username and Password
USER="$(tail /etc/eduroam_monitor/probeId)"
PASS="$(tail /etc/eduroam_monitor/salt)"

function getScripts() {

	###
	# Get List of Scripts from support.ja.net
	###
	if [[ $line =~ ^$1 ]]
	then
		NAME="$(echo $line | awk -F" " '{print $2}')"
		URL="$(echo $line | awk -F" " '{print $3}')"
		HASH="$(echo $line | awk -F" " '{print $4}')"			

		### If script already exists compare the Hashes
		if [ -a /etc/eduroam_monitor/tests/$1/$NAME ]
		then
				
			## Compare Hashes download update if different
			if [[ "$(sha1sum /etc/eduroam_monitor/tests/$1/$NAME | awk -F" " '{print $1}')" != $HASH ]]
			then
				### Download script and overwrite existing
				curl --user $USER:$PASS --cacert /etc/eduroam_monitor/ca.crt -o /etc/eduroam_monitor/tests/$1/$NAME $URL 
				chmod +x /etc/eduroam_monitor/tests/$1/$NAME
	
			fi 	
		else
			### Download New Test
			curl --user $USER:$PASS --cacert /etc/eduroam_monitor/ca.crt -o /etc/eduroam_monitor/tests/$1/$NAME $URL			
			chmod +x /etc/eduroam_monitor/tests/$1/$NAME
		fi
	fi
	
}

###
# Get List of Scripts from support.ja.net
###
while read line
do
	getScripts connectionless 
	getScripts connectionful
	getScripts scan
	
done < <(curl --cacert /etc/eduroam_monitor/ca.crt https://support.roaming.ja.net/cgi-bin/probe/update)

