#!/usr/bin/perl
# Author        : Tugrul Ozbay & fixed by Sir.Brian Daly MBE of MDS
# Date          : 19th Feb 2014
# Reason        : playing ADH.log files for datafeed errors
# Version       : 1.0
# Strict        : Suppose so
# Warnings      : None.
#
#
#
use strict;
use warnings;
#
# =========================================================
# VARIABLES SECTION
# =========================================================
my $clear = `clear`;                                                    # clear in unix
# my $clear    = `cls`;                                                 # clear in windows
#
#
my $search_bgn = "datafeed links are bad";
my $search_end = "datafeed links are good";
my $file = "./adh.log";                                                 # file to open up
my $errors;
my %errorlist;
my $log = "./adh_DF_errs.log";
my $count;
#
#
# =========================================================
# CLEAR OUTPUT LOGS
# =========================================================
unlink "./$log" if -f "./$log";                                         ## removes the log file if exits
#
#
# =========================================================
# PRINT the CURRENT DATE
# =========================================================
#
my $timeData = localtime(time);
print $timeData;
#
# =========================================================
#
print $clear;
print "\n\n";
print " Checking ADH logfile for ' $search_bgn ' errors over the log file lifetime \n\n\n";
print " You should get an output in the file : $log ";
print "\n\n\n";
#
#
# =========================================================
# OPEN INPUT FILE
# =========================================================
#
open(FILE, "<./$file") or die "Cannot open: $!";      # opens input $file
#
while (<FILE>) {

        if ( /$search_bgn/ .. /$search_end/ ){
		if ( /$search_bgn/ ) {                      # why 2 if statements here ? (one of them purely for the count ?
		$count++;                               # add/append to count
        }
            $errorlist{$count} .= $_;
        }
}
#
#
# =========================================================
# Output section
# =========================================================
#
open (FILE_OUT, ">>$log") || die "Cannot open $log: $!";

foreach my $keys (0..10000){

        next unless $errorlist{$keys};
	
		print FILE_OUT " \n\n ***** OUTAGE KEY NO: $keys  ***** \n\n  $errorlist{$keys}";
		
}

# %INC;
# %ENV;
# 
#
#
# =========================================================
# reference of my keywords for parsing
# datafeed links are bad
# datafeed links are good
# =========================================================
#
#
