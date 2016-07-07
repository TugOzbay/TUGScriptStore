#!/usr/bin/perl
#
# Author        : Tugrul Ozbay
# Date          : 4th April 2014
# Reason        : Time testing
# Version       : 1.0
# Strict        : Suppose so
# Warnings      : None.
#
use strict;
use warnings;
use Time::Local;
#
# set -x
#
my ($dayName, $month, $dayNo, $hr, $year);
my $originalTime = localtime(time);
print " The Original Time is :: $originalTime\n\n\n";
#
#
print "\n\n\n";
print " Splitting original time and printing via foreach \n";
my @date1 =  split ( ' ', $originalTime );
#
foreach my $dateBits (@date1) {
	print "$dateBits \n";
	
}
print "\n\n\n";
print "Printing the array \@date1 below \n"; 
print " @date1 \n\n\n";
#
#
my $time2 = timelocal(0,0,0,'3','08','2000');
print " printing \$time2 here :  $time2 \n\n\n";
print "\n\n\n";
#
#
# Just the time bits below
#
print " Splitting original time section from \@date1 only and printing via foreach \n";
my @time1 =  split ( ' ', @date1 [3] );
#
foreach my $timeBits (@time1) {
	print " each section of time (via \@timeBits) : $timeBits \n";
	
}