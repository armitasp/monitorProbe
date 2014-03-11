#!/bin/bash


/usr/sbin/wpa_cli logoff
/usr/sbin/wpa_cli terminate

###
# connect to eduroam using peap anon
###
/usr/sbin/wpa_supplicant -Dnl80211 -iwlan0 -c /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-rfc.conf -B

sleep 10

RESULT=false
ERROR=""
FAIL=0

udhcpc -p /var/run/udhcpc-wlan0.pid -q -t 0 -i wlan0 -s /etc/eduroam_monitor/scripts/udhcpc -C eduProbe

while read connection_status
do
	if [[ $connection_status =~ .*Supplicant\ PAE\ state=.* ]]
	then
		if [[ $connection_status =~ ^Supplicant\ PAE\ state=AUTHENTICATED.* ]]
		then
			RESULT=true
		else
			ERROR="$ERROR#PAE State#$(echo $connection_status | cut -d'=' -f2)"
			FAIL=1
		fi
	elif [[ $connection_status =~ .*suppPortStatus.* ]] 
	then
		if [[ $connection_status =~ .*Authorized$ ]]
		then
			RESULT=true
		else
			ERROR="$ERROR#suppPortStatus#$(echo $connection_status | cut -d'=' -f2)"
			FAIL=1
		fi
	elif [[ "$connection_status" =~ ^EAP\ TLS\ cipher=.* ]]         
	then
	  	ERROR="$ERROR#EAP_TLS_cipher#$(echo $connection_status | cut -d'=' -f2)"
	elif [[ $connection_status =~ key_mgmt ]]
	then
		if [[ ! $connection_status =~ WPA2 ]]
		then
			ERROR="$ERROR#key_mgmt#$(echo $connection_status | cut -d'=' -f2)"
			FAIL=1
		fi
	elif [[ $connection_status =~ ^pairwise_cipher.* ]]
	then
		if [[ ! $connection_status =~ CCMP ]]
		then
			ERROR="$ERROR#pairwise_cipher#$(echo $connection_status | cut -d'=' -f2)"
			FAIL=1
		fi
	elif [[ $connection_status =~ ^ip_address.* ]]
	then
		IPADDR=$(echo $connection_status | cut -d'=' -f2)
		ERROR="$ERROR#IP_Address#$IPADDR"	
		
		if [[ ! $IPADDR =~ [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} ]]
		then
			echo "IP ADDR FAIL"
			FAIL=1
		elif [[ $IPADDR =~ ^169\. ]]
		then
			FAIL=1
		else
			RESULT=true
		fi
	fi


done < <(/usr/sbin/wpa_cli status)


if [[ $FAIL == 1 ]]
then
	RESULT=false
fi

#ERROR=$(echo $ERROR | sed -e 's/\n//g')

/usr/sbin/wpa_cli logoff
/usr/sbin/wpa_cli terminate

echo "test=peap_mschap_rfc&result=$RESULT&message=$ERROR&time=$(date +%Y%m%d)_$(date +%H%M%S)"
