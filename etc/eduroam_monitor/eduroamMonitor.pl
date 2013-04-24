#!/usr/bin/perl

# Created by: Scott Armitage
# Version:  0.1 

use strict;
use Time::Stamp;
use Time::Stamp  -stamps => { format => 'compact' };
use HTTP::Request;
use LWP::UserAgent;
use Digest::MD5 qw(md5_hex);
use Net::ARP;

#TODO: move from backticks to dbus for wpa_supplicant

######
# location of the test scripts
######
  ### Test which require eduroam disconnected e.g. auth test ###
my @no_connect_test_files = </etc/eduroam_monitor/tests/connectionless/*>;
 
  ### Test which require eduroam connection e.g. port tests ###
my @connect_test_files = </etc/eduroam_monitor/tests/connectionful/*>;

  ### Test which which require wpa_supplicant in scan mode e.g. ssid test ###
my @scan_test_files = </etc/eduroam_monitor/tests/scan/*>;


##############################################
# Run each test                              #
# Store result in array for reporting later  #
##############################################

my @results;
my $test_result = "";

###
# tests which require wpa_supplicant but no eduroam
###
my $hasScan = getScan();
if($hasScan eq "OK") {

        #
        # if connected run tests
        #
        foreach my $file (@scan_test_files) {

                $test_result = "";
                $test_result = run_test($file);

                if($test_result) {
                        push (@results, $test_result);
                }

        }

	# disconnect wpa_supplicant
	`killall wpa_supplicant`;	
}


####
# test which require eduroam is disconnected
####
foreach my $file (@no_connect_test_files) {

	$test_result = "";
	$test_result = run_test($file);

	if($test_result) {
		push (@results, $test_result);
	}
}

####
# test which require an eduroam connection
####

#####
# Connect to eduroam
#####
my $hasConnect = getConnection();
if($hasConnect eq "OK" ) {

	#
	# Sync time
	#
	`killall ntpd`;
	`/usr/sbin/ntpd -s /etc/ntpd.conf`;

	#
	# if connected run tests
	#
	foreach my $file (@connect_test_files) {

		$test_result = "";
		$test_result = run_test($file);

		if($test_result) {
			push (@results, $test_result);  	
		}

	}
}

########################
# process test results #
########################

#####
# salt for result hash is eth0 Mac Addr
#####
my $salt = Net::ARP::get_mac("eth0");

#####
# send results to server
#####

if($hasConnect eq "OK") {

	#
	# get results out of array
	# and send to server
	#	
	foreach my $tresult (@results) {

		my $testid;
		my $testresult;
		my $testmessage;
		my $testtime;
		my $tokenCounter = 4;
		my @tokens = split(/&/, $tresult);
		foreach my $token (@tokens) {
	
			if($token =~ /^test\=/) {
				my @testid = split(/test\=/, $token);
				$testid = @testid[1];
				$tokenCounter --;
			} elsif ($token =~ /^result\=/) {
				my @testresult = split(/result\=/, $token);
				$testresult = @testresult[1];
				$tokenCounter --;
			} elsif ($token =~ /^message\=/) {
                        	my @testmessage = split(/message\=/, $token);
                        	$testmessage = @testmessage[1];
				$tokenCounter --;
			} elsif ($token =~ /^time\=/) {
				my @testtime = split(/time\=/, $token);
                        	$testtime = @testtime[1];
				$tokenCounter --;
			}
		}			
		
		if ($tokenCounter == 0) {
			sendResult($salt, $testid, $testresult, $testmessage, $testtime);
		}
	} #end of foreach
} #end of if
else {
	print "No Has Connect :-( ! \n";
}	

####
# disconnect from eduroam
####
`killall wpa_supplicant`;


sub run_test {

        my $test_name = $_[0];
        my @testResult = `$test_name`;
        return pop(@testResult);

}

sub getConnection {

	#######
	# Kill any existing wpa_supplicant sessions
	# Then connect to eduroam with working credentials
	#######

	#TODO: Fix code so we don't fudge by sleeping waiting for wpa_supplicant
	sleep(2);	
	`killall wpa_supplicant`;
	`/usr/sbin/wpa_supplicant -Dnl80211 -iwlan0 -c /etc/eduroam_monitor/wpa_conf/eduroam-peap.conf -B`;

	#######
	# Ensure DHCP is running for wireless
	#######
	`/usr/sbin/dhcpcd -q -w wlan0`;

	#######
	# Wait for DHCP Addr 
	#######

	#TODO: replace with better checks

	my $count 	 = 0;
	my @ipaddress = `/sbin/ifconfig wlan0 | grep "inet "`;
	my $ipaddr = @ipaddress[0];

	
	while(!defined($ipaddr) && $count < 4) {
		sleep(5);
		$count += 1;

		@ipaddress = `/sbin/ifconfig wlan0 | grep "inet "`;
		$ipaddr = @ipaddress[0];
	}

	######
	# return 
	######
	
	if (!defined($ipaddr)) {
		return "ERROR";
	} else {
		return "OK";
	}
}

sub getScan {

        #######
        # Kill any existing wpa_supplicant sessions
        # Then connect to eduroam with working credentials
        #######

        `killall wpa_supplicant`;
        `/usr/sbin/wpa_supplicant -Dnl80211 -iwlan0 -c /etc/eduroam_monitor/wpa_conf/eduroam-peap.conf -B`;

	sleep(6);

	my @scan = `/usr/sbin/wpa_cli scan`;
	#wait for APs to beacon
	sleep(8);

	foreach (@scan) {
        	if ($_ =~ /OK/) {
			return "OK";	
		}
	}

	return "FAIL";
}

sub sendResult {

        my($salt, $test_id, $test_result, $test_info, $timestamp) = @_;

        #TODO: Check Variables are declared

        #TODO: Set Real probe id
        my $probe_id = "123";

	#####
	# generate hash of result using salt
	#####
        my $digest = md5_hex($probe_id, $test_id, $test_result, $test_info, $timestamp, $salt);

	#####
	# convert test results into html
	#####
	my $test_info_html = $test_info;

	$test_info_html =~ s/\#/%23/g;
	$test_info_html =~ s/\s/%20/g;

        #TODO: Check certificate is from correct CA and has correct CN
	#TODO: set up real server for receving results
	
	#######
	# Create reporting URL for test results
	#######
        my $get_string =  "https://drpepper.lboro.ac.uk/cgi-bin/probe?probe=$probe_id&test=$test_id&result=$test_result&message=$test_info_html&time=$timestamp&check=$digest";
        print "$get_string\n";

	######
	# send test result to server with HTTP GET
	######	
        my $ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 1, SSL_ca_file => '/etc/eduroam_monitor/ca.crt'});
        my $response = $ua->get($get_string);

 	#if ($response->is_success) {
        # 		print $response->decoded_content;  # or whatever
 	#}
 	#else {
        #		print $response->status_line;
 	#}
        #TODO: return result;
}
