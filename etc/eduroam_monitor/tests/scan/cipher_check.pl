#!/usr/bin/perl

use strict;
# not required testHarness runs wpa_sup
#my @wpa = `/usr/sbin/wpa_supplicant -Dwext -iwlan0 -c /etc/eduroam_monitor/wpa_conf/scan.conf -B`;
#sleep  5;

#my @scan = `/usr/sbin/wpa_cli scan`;
my $result = "false";
my $error = "";
my $fail = 0;
my $pass = 0;
my $eduroam = 0;	
use Time::Stamp;
use Time::Stamp  -stamps => { format => 'compact' };

#foreach (@scan) {
#        if ($_ =~ /OK/) {
#                sleep 5;
                my @scanlist = `/usr/sbin/wpa_cli scan_results`;
		foreach (@scanlist) {

			if($_ =~ /eduroam$/) {	
				my @tokens = split(/\s/);
				$eduroam += 1;
				$pass += 1;				

				if($tokens[3] =~ /\[WPA2-EAP-CCMP\]/) {
					$pass -= 1;
				} 
				if($tokens[3] =~ /TKIP/) {
					$fail = 1;
				}
				if($tokens[3] =~ /WPA-/) {
				        $fail = 1;
				}
				if($tokens[3] =~ /WEP/) {
					$fail = 1;
				}
				if($tokens[3] =~ /PSK/) {
					$fail = 1;
				}

				#if($fail == 1) {
					$error = "$error#BSSID#$tokens[0]#CIPHER#$tokens[3]";
				#}
			}
		}
	#}
#}

if ($eduroam > 0) {
	if($fail == 1) {
		$result = "false";
	} elsif ($pass == 0) {
		$result = "true";
	}
}

my $time_stamp = localstamp();
#my @kill = `/usr/bin/killall wpa_supplicant`;
print ("test=cipher_check&result=$result&message=$error&time=$time_stamp");
