#!/usr/bin/perl

use strict;

my @wpa = `/usr/sbin/wpa_supplicant -Dnl80211 -iwlan0 -c /etc/eduroam_monitor/wpa_conf/eduroam-ttls-mschap-anon.conf -B`;
sleep  20;

my $result = "false";
my $error = "";
use Time::Stamp;
use Time::Stamp  -stamps => { format => 'compact' };

#######
# Do Stuff
#######

my @wpa = `/usr/sbin/wpa_cli status`;
my $fail = 0;

foreach(@wpa) {

	if ($_ =~ /Supplicant PAE state/) {
		if( $_ =~ /AUTHENTICATED$/i ){
			$result = "true";
		} else {
			$fail = 1;
			my @tokens = split(/\=/);
			$error = "$error#PAE State#$tokens[1]";
		}
	} 
	if ($_ =~ /suppPortStatus/) {
		if( $_ =~ /Authorized$/i ){
                        $result = "true";
                } else {
                        $fail = 1;
                        my @tokens = split(/\=/);
                        $error = "$error#suppPortStatus#$tokens[1]";
                }
	}
	if ($_ =~ /EAP TLS cipher/) { 
		my @tokens = split(/\=/);
                $error = "$error#EAP_TLS_cipher#$tokens[1]";
	}
	if ($_ =~ /key_mgmt/) {
		if( $_ !~ /WPA2/i ){
                        $fail = 1;
                        my @tokens = split(/\=/);
                        $error = "$error#key_mgmt#$tokens[1]";
                }
	}
	if ($_ =~ /pairwise_cipher/) {
                if( $_ !~ /CCMP/i ){
                        $fail = 1;
                        my @tokens = split(/\=/);
                        $error = "$error#pairwise_cipher#$tokens[1]";
                }
        }
	if ($_ =~ /ip_address/) {
		my @tokens = split(/\=/);
		$error = "$error#IP_Address#$tokens[1]";

                if( $tokens[1] !~ /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/ ){
                        $fail = 1;
                } elsif ( $tokens[1] =~ /^169\./ ) {
			$fail = 1;
		} else {
			$result = "true";
		}
        }

}

if ($fail == 1) {
	$result = "false";
}

#
# remove cr
#
$error =~ s/\n//g;


######
# Output result
######

my $time_stamp = localstamp();
my @kill = `killall wpa_supplicant`;
print ("test=ttls_mschap_anon&result=$result&message=$error&time=$time_stamp");


