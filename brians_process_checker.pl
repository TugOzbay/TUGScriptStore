#!/usr/bin/perl
# Author     |      Brian Daly
# Created    |      6 March 2014
# Reason     |      Count the number of processes running for billing purposes
# Version    |      Development release 1.00
#
# Description
# Generate output to be read by ITRS and thereafter Inxite to produce a billing report to Thomson Reuters.
# Billing is based on server count. Server count is defined as:
#      1-3 processes = 1 server,  4-6 processes = 2 servers, 7-9 processes = 3 servers, etc..
# Processes to be monitored are defined in the product hash. DACS servers and dacs.snkds are excluded.


use warnings;
use strict;
use POSIX qw(ceil);


BEGIN {   # Create header. Columns must be comma separated for ITRS Geneos netprobe parsing
          # Determine Operating system
            if ( ($^O =~ /linux/i) || ($^O =~ /solaris/i) ){
                open(FILE, "ps -ef|") or die "Cannot run command ps -ef $!";
                our $report = "./billing_server_count";
                                                                open (OUTPUT, ">$report") or die "Cannot open $report $!";
                print OUTPUT "PROCESS NAME,INSTANCE COUNT,SERVER COUNT,SERVER_TYPE\n";
            }
            elsif ( $^O =~ /MSWin/i ) {
                open(FILE, "tasklist|") or die "Cannot run command taskset $!";
                our $report = "./billing_server_count";
                open (OUTPUT, ">$report") or die "Cannot open $report $!";
                print OUTPUT "PROCESS NAME,INSTANCE COUNT,SERVER COUNT,SERVER_TYPE\n";
            }

}

# Initial
my $total_process_count = 0;
my $server_count = 0;
my %process;
my $server_type;

# Product hash
my %product = (
   'adh -instance' => 'ADH',
   'ads -instance' => 'ADS',
   'ANSLauncher' => 'ANS',
   'ats -' => 'ATS',
   'dacs.stnd ' => 'DACS Station',
   'dbunit' => 'DBU',
   'RTRmlip' => 'Marketlink IP contributions',
   'ids.isis' => 'IDS',
   'p2ps -instance' => 'P2PS',
   'rwds' => 'RWDS',
   'src_dist -instance' => 'Source Distributor',
   'upx' => 'Update Proxy',
   'RMDSIHand.exe' => 'Contex contributions',
   );

# Environment hash
my %environment = (
   '^[TRHtrh]' => 'TREP STANDARD',
   '^[Ss]\d+' => 'DEDICATED ATTACHED',
   '^[NBIMnbim]' => 'Bespoke NBIM Velocity Analytics',
   );

foreach my $type ( keys %environment ) {
    if ( `hostname` =~ /$type/ ){
        $server_type="$environment{$type}";
    }
}


# Generate Thomson Reuters products REGEX search string from the product hash, %product
my $re;
foreach my $k (keys %product) {
    $re .= "|$k"
}
my $RE = "\'$re\'";


# Determine the operating system. Capture the running processes


while (<FILE>)
{
    if ( /($RE)/ ) {
        my $match = $1;
        if ( ($match =~ /upx/) || ($match =~ /rwds/) || ($match =~ /mlip/) ){
            $process{$match} = 1;
        } else {
            $process{$match}++;
        }
    }
}

# Produce output file for ITRS parsing
# If 4 or more Thomson Reuters processes run on a server then the server is counted twice
foreach my $key (keys %process)
{
    $total_process_count = $total_process_count + $process{$key};
    $server_count = ceil ( $total_process_count/3 );
    print OUTPUT "$product{$key},$process{$key},$server_count,$server_type\n";

}
