#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 28th Feb 2014
# Reason        : ADS.log files for Various errors e.g RRCP_BC_MISSEDMSGS/RRCP_INCMPLT_MSG/RRCP/RRCP_INCMPLT_MSG/system error/RSSL disconnect etc
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
#
# =========================================================
# VARIABLES SECTION
# =========================================================
my $clear = `clear`;                                                    # clear in unix
# my $clear    = `cls`;                                                 # clear in windows
#
#
my $search_bgn = "RRCP_INCMPLT_MSG:";
my $search_end = "RRCP_INCMPLT_MSG:";
my $file = "./ads.log";                                                 # file to open up
my $errors;
my %errorlist;															# Hash array
my $log = "./ads_errs.log";
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
print " Checking ADS logfile for ' $search_bgn ' errors over the log file lifetime \n\n\n";
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
		$count++;                               	# add/append to count of $search_bgn's in there
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
#
foreach my $keys (0..10000){

        next unless $errorlist{$keys};					
	
		print FILE_OUT " \n\n ***** ERROR KEY NO: $keys  ***** \n\n  $errorlist{$keys}";
		
}

#
#
# %INC;
# %ENV;
# 
#
#
# =========================================================
# reference of my keywords for parsing
#
# my $search_bgn = "RRCP_INCMPLT_MSG:";
# my $search_end = "RRCP_BC_MISSEDMSGS:";
# 
# =========================================================
#
#
