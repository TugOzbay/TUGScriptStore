#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 17th Feb 2014
# Reason        : playing with adh.log file
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
print $clear;
print "\n\n";
print "Enter a word search for the adh.log ";
print "e.g[datafeed/rrcp/error/license/INCOMPLT/MISSEDMSGS/gap/broadcast/Restarting]: ";
chomp (my $search = (<STDIN>));

# chomp (my $search = (<STDIN>));               # read in search
# $search=${search}+1;                          # only for numbers
#
 		my (@list);                            # declare my array list
		$/=$search;                            # split it by $search
		open FILE_IN, "<./adh.log" or die $!;  # open my file and read in
		open FILE_OUT, ">./adh.search.out.log";		# open output file.
	
			while (my $linedata = <FILE_IN>) 
			{ 
			push 									# creates the next (n) slot(s) in an array
			@list
			, $linedata ;
			;
			print $list[$search];
			print FILE_OUT "$list[$search]";			# logs output to output log
			}
			
			#print $list[${search}];
			#print FILE_OUT "$list[${search}]";			# logs output to output log
			print " ..$search.. .\n";
			exit 0;



