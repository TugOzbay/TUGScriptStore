#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 17th Feb 2014
# Reason        : playing
# Version       : 1.0
# Strict        : Suppose so
# Warnings      : None.
#
#
#
use strict;
use warnings;
#
#
# my $clear = `clear`;			# clear in unix
my $clear	= `cls`;			# clear in windows
#
# ==========================================
# PRINT the CURRENT DATE
# ==========================================
#
my $timeData = localtime(time);
print $timeData;
#
# ==========================================
#
print $clear;
print "\n\n";
#
##############################################
# 		BEST TYPE
##############################################

print "Please Enter any number or word or anything  : ";
chomp (my $num3 = <STDIN>);

if ($num3 =~ m/^-?\d+$/) {
    print "It's an integer \n\n\n";
}
elsif ($num3 =~ m/^-?\d+[\/|\.]\d+$/) {
    print "It's a real number! \n\n\n";
}
else {
    print " $num3 is certainly not a number \n\n\n\n\n";
}
