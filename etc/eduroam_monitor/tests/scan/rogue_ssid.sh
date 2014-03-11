#!/bin/bash

RESULT=true
ERROR=""


while read line
do
	shopt -s nocasematch
	if [[ $line =~ ^([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2} ]] && [[ $line =~ .*eduroam.* ]]
	then
		shopt -u nocasematch
		TOKENS=($line)
		SSID=${TOKENS[4]}
	
		if [[ ! -z "${TOKENS[5]}" ]]
		then
			RESULT=false
			ERROR="$ERROR#BSSID#${TOKENS[0]}#SSID#$SSID ${TOKENS[5]}"
		else
			if [[ ! $SSID =~ ^eduroam$ ]]
			then
				RESULT=false    
				ERROR="$ERROR#BSSID#${TOKENS[0]}#SSID#$SSID"
			fi		
		fi
	fi	

done < <(/usr/sbin/wpa_cli scan_results)

echo "test=rogue_ssid&result=$RESULT&message=$ERROR&time=$(date +%Y%m%d)_$(date +%H%M%S)"

