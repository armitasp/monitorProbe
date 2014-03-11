#!/bin/bash

if [ -a /etc/eduroam_monitor/time ]
then           
        date -s "$(cat /etc/eduroam_monitor/time)"     
else           
        date -s "2013-11-07 13:00"
fi   



