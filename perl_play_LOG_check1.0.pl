#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 17th Feb 2014
# Reason        : playing ADH.log files and searches
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
my $clear = `clear`;                    # clear in unix
# my $clear     = `cls`;                # clear in windows
#
unlink "./adh_LOG_checkout.log" if -f "./adh_LOG_checkout.log";               ## removes the file 
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
print "Enter a error keyword so I can check within adh.log :";
print "e.g[datafeed/rrcp/error/license/INCOMPLT/MISSEDMSGS/gap/broadcast/Restarting]: ";
#
chomp (my $search = (<STDIN>));                                                 # read in search

                my (@list);                                                     # declare my array list
                # $/="error|dismount|discourage|license|rrcp";                  # split it by various errors
                $/=$search;                                                     # split it by $search or various errors
                open FILE_IN, "<./adh.log" or die $!;                           # open my file and read in
                open FILE_OUT, ">>./adh_LOG_checkout.log";                      # open output file.

                        while (my $linedata = <FILE_IN>)
                        {
                        push                                                    # creates the next (n) slot(s) in an array
                        @list
                        , $linedata ;
                        ;
                        print @list[$search];
                        }
                        print FILE_OUT "$list[$search]";                        # logs output to output log
                        print " ..$/.. .\n";
#



