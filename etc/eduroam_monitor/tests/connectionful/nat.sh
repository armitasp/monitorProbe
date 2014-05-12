#!/bin/bash

RESULT=false
ERROR=""
END=2
i=0

while [[ $i -le $END ]] 
do
	while read ntp_status
	do
		if [[ $ntp_status =~ .*adjust\ time\ server.* ]]
		then
			RESULT=true
			END=$i
			ERROR="$ERROR#offset $(echo $ntp_status | awk -F"offset" '{print $2}')"
		elif [[ $ntp_status =~ .*step\ time\ server.* ]]
		then
			RESULT=true
			END=$i
			ERROR="$ERROR#offset $(echo $ntp_status | awk -F"offset" '{print $2}')"
		else
			ERROR="$ERROR#$ntp_status"
		fi
	done < <(/usr/sbin/ntpdate uk.pool.ntp.org)
	
	((i = i + 1))
done

echo "test=ntp&result=$RESULT&message=$ERROR&time=$(date +%Y%m%d)_$(date +%H%M%S)"
