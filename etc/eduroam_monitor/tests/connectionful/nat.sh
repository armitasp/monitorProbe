#!/bin/bash

RESULT=false
ERROR=""
IP_ADDR=""

while read cli_status                         
do                                            
        if [[ $cli_status =~ ^ip_address=.* ]]                                                                              
        then                                                                                                                
 		IP_ADDR=$(echo $cli_status | awk -F"=" '{print $2}')                                                                                                                                                              
		ERROR="$ERROR#Global Address $IP_ADDR"   	
        fi                                                                                              
done < <(/usr/sbin/wpa_cli status)

while read echo_status
do
	if [[ $echo_status =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
	then
		if [[ $echo_status != $IP_ADDR ]]
		then
			RESULT=true
		fi

		ERROR="$ERROR#Inside Address $echo_status"
	fi
	
done < <(curl --cacert /etc/eduroam_monitor/ca.crt https://support.roaming.ja.net/cgi-bin/probe/ip_echo)

echo "test=nat&result=$RESULT&message=$ERROR&time=$(date +%Y%m%d)_$(date +%H%M%S)"
