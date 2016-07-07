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
chomp (my $search = (<STDIN>));			# read in search
#
#            
# $search=${search}+1;                          # only for numbers
#
		my (@errors);                                   # declare my array list
 		my (@list);                                     # declare my array list
#		$/=$search;                                     # split it by $search
		open FILE_IN, "<./adh.log" or die $!;           # open my file and read in
		open FILE_OUT, ">./adh.search2.out.log";		# open output file.
	
	while (<FILE_IN>)
{
        chomp $_;                         # clear up the result of each line before we begin
        #print $_;  print "\n\n";          # prints all errors without a new line

        if (grep /$search/, $_)          # grep for /error/i   ignore case from each line $_
		#   if (grep /$search/i, $_)          # grep for /error/i   ignore case from each line $_
        {
                print $_;                 # prints both errors in one long line - one after the other
                print " Search word FOUND \n"; # This line causes it to hit return on an Error for good formatting
                push(@errors, $_);        # push each line which has error into array @errors
##
				print FILE_OUT $errors[$search];			# logs output to output log
				# print FILE_OUT "$search[$errors]";		# logs output to output log
#               print $_;               					# prints both errors in one long line - one after the other

        }
}
close FILE_IN;
close FILE_OUT;
	
	
	
	