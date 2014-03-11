#!/bin/bash

RESULT=false
ERROR=""

while read cli_status
do
	if [[ $cli_status =~ ^ip_address=.* ]]
	then
		if [[ $cli_status =~ .*(127\.0\.0\.1)|(192\.168)|(10\.)|(172\.1[6-9])|(172\.2[0-9])|(172\.3[0-1]).* ]]
		then
			RESULT=true
		fi

		ERROR="$ERROR#IP Address $(echo $cli_status | awk -F"=" '{print $2}')"
	fi
	
done < <(/usr/sbin/wpa_cli status)

echo "test=rfc_1918&result=$RESULT&message=$ERROR&time=$(date +%Y%m%d)_$(date +%H%M%S)"
