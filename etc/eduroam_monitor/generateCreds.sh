#!/bin/bash

user=("${@:1}")
pass=("${@:2}")

echo ctrl_interface=/var/run/wpa_supplicant > /etc/eduroam_monitor/wpa_conf/scan.conf
echo ctrl_interface_group=wheel >> /etc/eduroam_monitor/wpa_conf/scan.conf

echo ctrl_interface=/var/run/wpa_supplicant > /etc/eduroam_monitor/wpa_conf/11u.conf
echo cred={ >> /etc/eduroam_monitor/wpa_conf/11u.conf     
echo realm=\"eduroam.ac.uk\" >> /etc/eduroam_monitor/wpa_conf/11u.conf  
echo password=\"$pass\" >> /etc/eduroam_monitor/wpa_conf/11u.conf                    
echo eap=TTLS >> /etc/eduroam_monitor/wpa_conf/11u.conf                              
echo roaming_consortium=001bc50460 >> /etc/eduroam_monitor/wpa_conf/11u.conf 
echo ca_cert=\"/etc/eduroam_monitor/certs/ca.pem\" >> /etc/eduroam_monitor/wpa_conf/11u.conf  
echo #client_cert=\"/path/to/client-crt.pem\" >> /etc/eduroam_monitor/wpa_conf/11u.conf      
echo identity=\"$user@eduroam.ac.uk\" >> /etc/eduroam_monitor/wpa_conf/11u.conf              
echo phase2=\"auth=EAP-MSCHAPV2\" >> /etc/eduroam_monitor/wpa_conf/11u.conf
echo } >> /etc/eduroam_monitor/wpa_conf/11u.conf

echo ctrl_interface=/var/run/wpa_supplicant > /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-anon.conf
echo network={ >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-anon.conf
echo ssid=\"eduroam\" >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-anon.conf   
echo scan_ssid=0 >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-anon.conf   
echo key_mgmt=WPA-EAP >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-anon.conf   
echo password=\"$pass\" >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-anon.conf   
echo eap=PEAP >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-anon.conf   
echo ca_cert=\"/etc/eduroam_monitor/certs/ca.pem\" >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-anon.conf   
echo #client_cert=\"/path/to/client-crt.pem\" >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-anon.conf   
echo identity=\"$user@eduroam.ac.uk\" >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-anon.conf   
echo anonymous_identity=\"anonymous@eduroam.ac.uk\" >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-anon.conf
echo phase2=\"auth=MSCHAPV2\" >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-anon.conf
echo } >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-anon.conf

echo ctrl_interface=/var/run/wpa_supplicant > /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-rfc.conf
echo network={ >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-rfc.conf
echo ssid=\"eduroam\" >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-rfc.conf
echo scan_ssid=0 >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-rfc.conf
echo key_mgmt=WPA-EAP >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-rfc.conf
echo password=\"$pass\" >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-rfc.conf
echo eap=PEAP >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-rfc.conf
echo ca_cert=\"/etc/eduroam_monitor/certs/ca.pem\" >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-rfc.conf
echo #client_cert=\"/path/to/client-crt.pem\" >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-rfc.conf
echo identity=\"$user@eduroam.ac.uk\" >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-rfc.conf
echo anonymous_identity=\"@eduroam.ac.uk\" >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-rfc.conf
echo phase2=\"auth=MSCHAPV2\" >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-rfc.conf
echo } >> /etc/eduroam_monitor/wpa_conf/eduroam-peap-mschap-rfc.conf 

echo ctrl_interface=/var/run/wpa_supplicant > /etc/eduroam_monitor/wpa_conf/eduroam-peap.conf
echo network={ >> /etc/eduroam_monitor/wpa_conf/eduroam-peap.conf
echo ssid=\"eduroam\" >> /etc/eduroam_monitor/wpa_conf/eduroam-peap.conf
echo scan_ssid=0 >> /etc/eduroam_monitor/wpa_conf/eduroam-peap.conf
echo key_mgmt=WPA-EAP >> /etc/eduroam_monitor/wpa_conf/eduroam-peap.conf
echo password=\"$pass\" >> /etc/eduroam_monitor/wpa_conf/eduroam-peap.conf
echo eap=PEAP >> /etc/eduroam_monitor/wpa_conf/eduroam-peap.conf
echo ca_cert=\"/etc/eduroam_monitor/certs/ca.pem\" >> /etc/eduroam_monitor/wpa_conf/eduroam-peap.conf
echo #client_cert=\"/path/to/client-crt.pem\" >> /etc/eduroam_monitor/wpa_conf/eduroam.conf
echo identity=\"$user@eduroam.ac.uk\" >> /etc/eduroam_monitor/wpa_conf/eduroam-peap.conf
echo anonymous_identity=\"$user@eduroam.ac.uk\" >> /etc/eduroam_monitor/wpa_conf/eduroam-peap.conf
echo phase2=\"auth=MSCHAPV2\" >> /etc/eduroam_monitor/wpa_conf/eduroam-peap.conf
echo } >> /etc/eduroam_monitor/wpa_conf/eduroam-peap.conf

echo ctrl_interface=/var/run/wpa_supplicant > /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-anon.conf
echo network={ >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-anon.conf
echo ssid=\"eduroam\" >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-anon.conf
echo scan_ssid=0 >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-anon.conf
echo key_mgmt=WPA-EAP >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-anon.conf
echo password=\"$pass\" >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-anon.conf
echo eap=TTLS >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-anon.conf
echo ca_cert=\"/etc/eduroam_monitor/certs/ca.pem\" >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-anon.conf
echo #client_cert=\"/path/to/client-crt.pem\" >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-anon.conf
echo identity=\"$user@eduroam.ac.uk\" >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-anon.conf
echo anonymous_identity=\"anonymous@eduroam.ac.uk\" >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-anon.conf
echo phase2=\"auth=EAP-MSCHAPV2\" >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-anon.conf
echo } >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-anon.conf
 
 echo ctrl_interface=/var/run/wpa_supplicant > /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-rfc.conf  
 echo network={ >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-rfc.conf 
 echo ssid=\"eduroam\" >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-rfc.conf 
 echo scan_ssid=0 >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-rfc.conf 
 echo key_mgmt=WPA-EAP >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-rfc.conf 
 echo password=\"$pass\" >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-rfc.conf 
 echo eap=TTLS >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-rfc.conf 
 echo ca_cert=\"/etc/eduroam_monitor/certs/ca.pem\" >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-rfc.conf 
 echo #client_cert=\"/path/to/client-crt.pem\" >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-rfc.conf 
 echo identity=\"$user@eduroam.ac.uk\" >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-rfc.conf 
 echo anonymous_identity=\"@eduroam.ac.uk\" >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-rfc.conf 
 echo phase2=\"auth=EAP-MSCHAPV2\" >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-rfc.conf 
 echo } >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-rfc.conf 
  
  echo ctrl_interface=/var/run/wpa_supplicant > /etc/eduroam_monitor/wpa_conf/eduroam-ttls.conf            
  echo network={ >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls.conf            
  echo ssid=\"eduroam\" >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls.conf            
  echo scan_ssid=0 >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls.conf            
  echo key_mgmt=WPA-EAP >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls.conf            
  echo password=\"$pass\" >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls.conf            
  echo eap=TTLS >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls.conf            
  echo ca_cert=\"/etc/eduroam_monitor/certs/ca.pem\" >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls.conf            
  echo #client_cert=\"/path/to/client-crt.pem\" >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls.conf                 
  echo identity=\"$user@eduroam.ac.uk\" >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls.conf            
  echo anonymous_identity=\"$user@eduroam.ac.uk\" >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls.conf       
  echo phase2=\"auth=EAP-MSCHAPV2\" >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls.conf            
  echo } >> /etc/eduroam_monitor/wpa_conf/eduroam-ttls.conf  
  
  
