#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 11th Feb 2014
# Reason        : playing
# Version       : 2.2
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
print "Enter a CPU number to search for in list of cpu list [0..7]: ";
chomp (my $cpu = (<STDIN>));               # read in number
$cpu=${cpu}+1;                             # adds one to CPU
#
 if ($cpu < 0) 
	{
		print $clear;
        print "Error: No CPU Less than zero [0] !\n";
		exit 0
    } elsif ($cpu >= 9) 
	{
		print "\n\n\n\n";
        print ">>> Error <<<  	There is No CPU greater than seven [7] \n";
		print ">>> Error <<< =========================================== \n";
		print "               (:-)) : Don't pee me off, so PLEASE TRY AGAIN!\n";
	} 
	else
	{
		my (@list);                                # declare my array list
		$/="processor";                            # split it by processor
		open FILE_IN, "<./cpuinfo.txt" or die $!;  # open my file and read in
		open FILE_OUT, ">./cpuinfo.out.log";		# open output file.
	
			while (my $linedata = <FILE_IN>) 
			{ 
			push 									# creates the next (n) slot(s) in an array
			@list
			, $linedata ;
			;
			}
			print $list[${cpu}];
			print FILE_OUT "$list[${cpu}]";			# logs output to output log
			print " ..$cpu.. .\n";
	}
    exit 0;



