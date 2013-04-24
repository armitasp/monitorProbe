#!/usr/bin/perl

use strict;

# not required as test harness makes connection
#my @wpa = `/usr/sbin/wpa_supplicant -Dwext -iwlan0 -c /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-rfc.conf -B`;
#sleep  20;

my $result = "false";
my $error = "";
use Time::Stamp;
use Time::Stamp  -stamps => { format => 'compact' };

#######
# Do Stuff
#######

my @wpa = `/usr/sbin/wpa_cli status`;

foreach(@wpa) {

	if ($_ =~ /ip_address/) {
		my @tokens = split(/\=/);
		$error = "$error#IP Address#$tokens[1]";

               if ($tokens[1] =~ /(^127\.0\.0\.1)|(^192\.168)|(^10\.)|(^172\.1[6-9])|(^172\.2[0-9])|(^172\.3[0-1])/) {
			$result = "true";
		} else {
			$result = "false";
		}
        }

}


#
# remove cr
#
$error =~ s/\n//g;


######
# Output result
######

my $time_stamp = localstamp();
print ("test=rfc_1918&result=$result&message=$error&time=$time_stamp");

