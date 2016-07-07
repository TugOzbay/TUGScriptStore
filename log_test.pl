#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 24th Feb 2014
# Reason        : log_test.pl script
# Version       : 1.0
# Strict        : Suppose so
# Warnings      : None.
#
#
#
# use strict;
# use warnings;
#
# =========================================================
# PRINT the CURRENT DATE
# =========================================================
#
my $timeData = localtime(time);
print "\n\n  $timeData  \n\n";
#
#
# =========================================================
# VARIABLES SECTION
# =========================================================
# my $clear = `clear`;                     			# clear in unix
my $clear    = `cls`;                  				# clear in windows
#
print $clear;
#
my $log = 'data_log.txt';							# write out to $log (or LOG)
#
unlink "$log" if -f "$log";          				# removes the log file if exits
#
my $read = 'data_read.txt';							# read in from $read
#
#
open (READ, "$read") or die "Cannot open it: $!";       #"READ_FILE" is File Handle
#
unless (-e $read) {										# Regardless the if statement which executes a block of code if a condition is true, 
    print $log "\n Read File Doesn't Exist!!! : "  . $read;    # .... the 'unless' statement executes a block of code if the condition is false. 
    exit;
}
#
#
#
#
# =========================================================
# OUT TO FILE & SCREEN SECTION
# =========================================================
#
foreach my $line (<READ>) {
     print "\n Each Line: : $line \n";					# print each line to screen
	 
	 open (LOG, ">> $log");                  			# use the ">"  symbol to write to new file (Write mode) OR use the ">>" to append to the file (Append mode)
	 
	 print LOG " \n\n";
	 print LOG " Each Line : $line \n";					# print each line to LOG file ($log which is data_log.txt)
	 print LOG "\n Testing Writing into Perl file";
	 print LOG "\n Writing more content 111";
	 print LOG "\n Writing more content 222";
	 print LOG " \n\n";
}
#
#
close (READ);
close (LOG);
#
