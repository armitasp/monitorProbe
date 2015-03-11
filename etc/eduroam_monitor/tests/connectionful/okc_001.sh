#!/bin/bash

HASH="58be47fc57f667ed39768fb8250edf9f4e4d9147"

if [[ "$(sha1sum /etc/eduroam_monitor/generateCreds.sh | awk -F" " '{print $1}')" != $HASH ]]
then
        ### Get Password
        PASSWORD="$(grep 'password' /etc/eduroam_monitor/wpa_conf/eduroam-peap.conf | cut -d'"' -f 2)"

        ### Get ProbeID
        PROBEID="$(cat /etc/eduroam_monitor/probeId)"
        USERNAME="eduprobe$PROBEID"

        ### Get Username and Password for curl
        USER="$(tail /etc/eduroam_monitor/probeId)"
        PASS="$(tail /etc/eduroam_monitor/salt)"

	### Backup old config
	cp /etc/eduroam_monitor/generateCreds.sh /etc/eduroam_monitor/generateCreds.sh.old
	mkdir /etc/eduroam_monitor/wpa_conf/old
	cp /etc/eduroam_monitor/wpa_conf/* /etc/eduroam_monitor/wpa_conf/old


        ### Get new generateCreds script
        curl --user $USER:$PASS --cacert /etc/eduroam_monitor/ca.crt -o /etc/eduroam_monitor/generateCreds.sh https://support.roaming.ja.net/probe-scripts/generateCreds.sh


	### 
	chmod +x /etc/eduroam_monitor/generateCreds.sh
        ### run script
	/etc/eduroam_monitor/generateCreds.sh $USERNAME $PASSWORD

        ### Check configs are sane
	$PASS1="$(grep 'password' /etc/eduroam_monitor/wpa_conf/eduroam-peap.conf | cut -d'"' -f 2)"
	if [[ $PASS1 != $PASSWORD ]]
	then
		cp /etc/eduroam_monitor/wpa_conf/old/* /etc/eduroam_monitor/wpa_conf
		cp /etc/eduroam_monitor/generateCreds.sh.old /etc/eduroam_monitor/generateCreds.sh
		chmod +x /etc/eduroam_monitor/generateCreds.sh
	fi
fi
