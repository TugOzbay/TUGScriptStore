#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 2nd Feb 2014
# Reason        : Opens rmds.cnf and searchs for you input param
# Version       : 3.0
# Strict        : Suppose so
# Warnings      : None.
#
#
use strict;
use warnings;
#
# 
my $time = localtime(time);
print $time;
#
#
my (@list);                             # declare my array @list
open FILE_IN, "<./rmds.cnf" or die $!;  # open my file and read in
open FILE_OUT, ">./rmds.out.log";
(my @fileIn = <FILE_IN>);				# this fixes it so that all lines are in a row.  
# chomp (my @fileIn = <FILE_IN>);       # with chomp the whole files goes into array @fileIn (with this line its all in a long string)
#
close FILE_IN;
#
#
#
#
print "\n\n";
print "Enter a param to search for in rmds.cnf : ";
#
chomp (my $param = (<STDIN>));             # read in param from user keyboard input
#
#
my @Array = (grep /$param/i, @fileIn);
if (@Array)
{
        print FILE_OUT "@Array";            # print to output FILE_OUT
        my $timesFound = @Array;
        print " The ..$param.. was found : $timesFound  times in the file.\n";
		print " The contents of the search have been output to ./rmds.out.log .\n";
}
#
close FILE_OUT;
