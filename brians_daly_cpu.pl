#!/usr/bin/perl
# Author        : Sir Brian Daly
# Date          : 11th Feb 2014
# Reason        : he loves it
# Version       : 1.0
# Strict        : Not so.
# Warnings      : None.
#
# What it does  :
# Takes in the /proc/cpuinfo and shows the range when you put in the CPU you want to look at 
# use as :  ./brians_daly_cpu.pl 0 1 6  (shows cpu 0, 1 and 6)
#  
#
use strict;
use warnings;

my $file = "cpuinfo.txt";			# reads in my file
my %cpu_info_store;					# creates an array to store
my $proc_num;						# processor number store variable
# my $clear_screen = `clear`;		# clear screen linux
my $clear_screen = `cls`;			# clear in windows


print $clear_screen;				# actions the clear

open(FILE, "<$file") || die "Cannot open $file: $!";	# opens $file

while ( <FILE> ) {								# while file is open
    if ( /processor/ ){							# if processor exists then..
        $proc_num = (split /:/,$_)[1];			# processor is 0 field, split by colon, the number is filed 1. 
    }											# close if
    #elsif ( /vendor_id/ .. /siblings/ ) {		# els if: sets a range from vendor_id to siblings, begin
	elsif ( /vendor_id/ .. /cpu cores/ ) {		# els if: sets a range from vendor_id to cpu cores, begin 
        $cpu_info_store{$proc_num} .= $_;		# creates HASH. Remember a HASH provides a key:value pair. Below $proc_num becomes the key, the value is the list captured by the elsif. .= appends to a hash.
    }											# close
}

foreach my $key (keys %cpu_info_store){			# for the input key I put in.  for each key, run against variable cpu_info_store  
    foreach my $cpu (@ARGV) {					# for each cpu number (With Perl, command-line arguments are stored in a special array named @ARGV)
        if ( $key == $cpu ){					# if $key matches $cpu then....
            print "\t\t\tPROCESSOR: $key\n$cpu_info_store{$key}\n";		# tab a few \ print PROCESSOR  then the $key and the $cpu_info_store variable contents
        }										# close brackets
    }
}
