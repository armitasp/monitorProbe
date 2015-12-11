#!/bin/bash
## This script can be used to scan a predetermined list of TCP/UDP ports, to be used with eduprobe
## Dependencies:
# -requires a corresponding listening process for every port to run on the target server.
#  These can be provided with '/usr/local/bin/lcontrol [start|stop]' + local firewall permissions
# -expects to find the probe ID and salt in /etc/eduroam_monitor/probeId and /etc/eduroam_monitor/salt respectively
# -the salt stored on the probe has to match the one stored on the target server

# Configure monitored ports
protocols=('tcp' 'udp')
#monitored_tcp=(21 22 80 110 143 220 389 406 443 465 587 636 993 995 1194 1494 3128 3389 5900 8080)
#monitored_udp=(123 1194 4500 5000-5110 7000-7007)
monitored_tcp=(110 143 220 389 406 465 587 636 993 995 1194 1494 3128 3389 5900 8080)
#monitored_udp=(1194 4500)
target='193.63.63.194'				# ip of the target server hosting the listening processes
id=$(cat /etc/eduroam_monitor/probeId)
salt=$(cat /etc/eduroam_monitor/salt |sed '{s/[: -]//g}' |awk '{print tolower($0)}')	# this should take : and - separated MACs

## settings used for testing			#
#monitored_tcp=(21 80 110)			#
#monitored_udp=(1194 7005-7012)			#
#target='127.0.0.1'				# 
#id='1045'					# 
#salt='c04a00cc8406'				# 


function scan {
  for port in ${arr[@]}
  do
    # check for ranges in array and expand them before testing
    if [[ $port =~ ([0-9]+)-([0-9]+) ]] ;
    then
      range_start="${BASH_REMATCH[1]}"
      range_end="${BASH_REMATCH[2]}"
      if [[ $range_start -lt $range_end ]] ;
      then
        for ((i=$range_start; i <= $range_end; i++))
        do
	  rhash=$(echo $id |$cmd $i 2> /dev/null & sleep 1 ; kill $! 2> /dev/null)
	  #lhash=`echo "$id:$proto:$i:$salt" |sha1sum |awk '{print $1}'`
	  lhash=`echo "$id:$proto:$i" |sha1sum |awk '{print $1}'`
	  if [[ $rhash == $lhash ]]
	  then
	    echo "test=$proto:$i&result=true&message=target_$target&time=$(date +%Y%m%d)_$(date +%H%M%S)"
	  else
	    echo "test=$proto:$i&result=false&message=target_$target&time=$(date +%Y%m%d)_$(date +%H%M%S)"
	  fi
	done
      else
        echo "Range starts with value larger than the one it ends with"
        exit 1
      fi
    # if not a range just test it
    elif [[ $port =~ ^[0-9]+$ ]]
    then
      rhash=$(echo $id |$cmd $port 2> /dev/null & sleep 1 ; kill $! 2> /dev/null)
      #lhash=`echo "$id:$proto:$port:$salt" |sha1sum |awk '{print $1}'`
      lhash=`echo "$id:$proto:$port" |sha1sum |awk '{print $1}'` 
     if [[ $rhash == $lhash ]]
      then
	echo "test=$proto:$port&result=true&message=target_$target&time=$(date +%Y%m%d)_$(date +%H%M%S)"
      else
	echo "test=$proto:$port&result=false&message=target_$target&time=$(date +%Y%m%d)_$(date +%H%M%S)"
      fi
    else 
      echo "Please check monitored ports configuration, failed to parse $port"
      exit 1
    fi
  done
}

for proto in ${protocols[@]}
do
  if [[ $proto == 'udp' ]]
  then
    #echo "scanning $proto"
    arr=${monitored_udp[@]}
    cmd="ncat -u -n $target"		# -n = don't look for (r)DNS | -u = UDP | -w 1 = close connection after 1 sec (if still open)
    scan
  elif [[ $proto == 'tcp' ]]
  then
    #echo "scanning $proto"
    arr=${monitored_tcp[@]}
    cmd="ncat -w 1 -n $target"
    timeout=''
    scan
  fi
done

# Ports/services requiring full application implementation for accurate detection
#45.5. PPTP:                                    IP protocol 47 (GRE) egress and established; 
#                                               TCP/1723 egress and established.
#45.26. ESP:                                    IP protocol 50 egress and established
#45.27. AH:                                     IP protocol 51 egress and established
#45.28. ISAKMP: and IKE:                        UDP/500 egress
#45.1. IPv6 Tunnel Broker NAT traversal:        UDP/3653;TCP/3653 egress and established.                                                   
#45.2. IPv6 Tunnel Broker Service:              IP protocol 41 egress and established.  
