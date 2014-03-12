#!/usr/bin/perl

use strict;

# not required as test harness makes connection
#my @wpa = `/usr/sbin/wpa_supplicant -Dwext -iwlan0 -c /etc/eduroam_monitor/wpa_conf/scan.conf -B`;
#sleep  20;

my $result = "false";
my $error = "";
use Time::Stamp;
use Time::Stamp  -stamps => { format => 'compact' };

#######
# Do Stuff
#######

my @scan = `iw dev wlan0 scan ssid eduroam`;
my $rawData = join("",@scan);

my @bss;
my $ht = 0;
my $bssFlag = 0;

foreach (@scan) {

        if ($_ =~ /BSS\s([0-9a-fA-F][0-9a-fA-F]:){5}([0-9a-fA-F][0-9a-fA-F])\s\(on\swlan0\)/) {
                @bss = $_ =~ m/((?:[0-9a-f]{2}[:-]){5}[0-9a-f]{2})/;
		$bssFlag = 0;
        }

        if ($ht eq "1") {

		if($bssFlag == 0) {
			$error = "$error#BSSID#@bss[0]";
			$bssFlag = 1;
		}

                if($_ =~ /^\s*\*/ ) {
                        
			if ($_ =~  /secondary\schannel\soffset\:\sabove/) {
				$error = "$error#CHANNEL_WIDTH#40 Above";
			} elsif ($_ =~  /secondary\schannel\soffset\:\sbelow/) {
				$error = "$error#CHANNEL_WIDTH#40 Below";
			} elsif ($_ =~  /secondary\schannel\soffset\:\sno\ssecondary/) {
                                $error = "$error#CHANNEL_WIDTH#20";
                        }

                } else {
                        $ht = 0;
                }
        } 

	if ($_ =~ /HT\soperation\:/) {
                $ht = 1;
		$result = "true";
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
print ("test=11n&result=$result&message=$error&time=$time_stamp");

