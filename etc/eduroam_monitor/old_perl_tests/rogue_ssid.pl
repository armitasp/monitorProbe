#!/usr/bin/perl

use strict;
use Time::Stamp;
use Time::Stamp  -stamps => { format => 'compact' };


my $result = "true";
my $error = "";

                my @scanlist = `/usr/sbin/wpa_cli scan_results`;

                foreach (@scanlist) {


                        if($_ =~ /eduroam/i) {

                                my @tokens = split(/\s/);

                                my $ssid = $tokens[4];
                                if($tokens[5]) {
                                        $result = "false";
					$error = "$error#BSSID#$tokens[0]#SSID#$ssid $tokens[5]";	
                                }
                                elsif($ssid !~ /^eduroam$/) {
                                        $result = "false";
					$error = "$error#BSSID#$tokens[0]#SSID#$ssid";
                                }


                        }
                }
my $time_stamp = localstamp();
print ("test=rogue_ssid&result=$result&message=$error&time=$time_stamp");
