#!/bin/bash

RESULT=false
ERROR=""


while read line
do
        shopt -s nocasematch
        if [[ $line =~ ^([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2} ]] && [[ $line =~ .*\[WPA2-EAP-CCMP.*eduroam.* ]] 
        then
                TOKENS=($line)
                CIPHER=${TOKENS[3]}

                RESULT=true
                ERROR="$ERROR#BSSID#${TOKENS[0]}#CIPHER#$CIPHER"
        else
                if [[ $line =~ ^([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2} ]] && [[ $line =~ .*eduroam.* ]] 
                then
                        TOKENS=($line)
                        CIPHER=${TOKENS[3]}

                        RESULT=false
                        ERROR="$ERROR#BSSID#${TOKENS[0]}#CIPHER#$CIPHER"

                fi
        fi

done < <(/usr/sbin/wpa_cli scan_results)

shopt -u nocasematch

TEST_INFO_HTML=$(echo "test=wpa2&result=$RESULT&message=$ERROR&time=$(date +%Y%m%d)_$(date +%H%M%S)" | sed -e 's/\[/ /g' -e 's/\]/ /g')
echo $TEST_INFO_HTML
