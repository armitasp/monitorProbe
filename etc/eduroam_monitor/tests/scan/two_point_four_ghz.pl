#!/usr/bin/perl

use strict;


my $result = "false";
my $error = "";
use Time::Stamp;
use Time::Stamp  -stamps => { format => 'compact' };

                my @scanlist = `/usr/sbin/wpa_cli scan_results`;

                foreach (@scanlist) {

                        if($_ =~ /eduroam$/) {
                                my @tokens = split(/\s/);

                                if($tokens[1] =~ /^2/)
                                {
                                        $result = "true";
                                        $error = "$error#BSSID#$tokens[0]#CHANNEL#$tokens[1]";
                                }

                        }
                }

my $time_stamp = localstamp();
print ("test=two_point_four_ghz&result=$result&message=$error&time=$time_stamp");
