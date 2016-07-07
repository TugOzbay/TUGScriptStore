#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 29th Jan 2014
# Reason        : Reading Flynns perl doc excercise - checks in ads.log
# Version       : 3.0
# Strict        : Suppose so
# Warnings      : None.
#
use strict;
use warnings;
#
#====== Checks ADS LOGS ====================
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
my $file="ads.log";
my $count = 0;
my @errors;
print $clear;
#
# Open a log file
#
open (FILE, "ads.log") or die "can't open ads.log: $!";
print " \n\n\n";
print " Showing the   >>  ads.log  <<   errors below now :- \n\n\n";
#
while (<FILE>)
{
         chomp $_;                      # clear up the result of each line before we begin
#        print $_;                      # prints all errors without a new line

        if (grep /error/i, $_)          # grep for /error/i   ignore case from each line $_
        {
                print $_;               # prints both errors in one long line - one after the other
                print " ERROR FOUND\n"; # This line causes it to hit return on an Error for good formatting
                push(@errors, $_);      # push each line which has error into array @errors
##
#               print $_;               # prints both errors in one long line - one after the other

        }
}
close FILE;

my $error_count = $#errors;                     # starts at 0
# my $error_count2 = length (@errors);            # starts at 0
my $error_count2 = scalar (@errors);
my $error_count3 = @errors;                     # normal count
#
print " \n" ;
print " \n" ;
print " \n" ;
print " error count 1 :",$error_count, "\n";   # starts at 0
print " error count 2 :",$error_count2, "\n";  # starts at 0
print " error count 3 :",$error_count3, "\n";   # normal count
print " \n" ;
print " \n" ;
###
###
#open (FILE, "ads.log") or die "can't open ads.log for a second time: $!";
print " ================== showing  ads.log  errors only ==================\n";

for (my $c = 0; $c <=$error_count2; $c++)               # FOR LOOP for better ERROR output
{
        print "Error line ===>>> $errors[$c]\n";
}

print " ================== showing  ads.log  errors only ==================\n";
###
###
my $errlist;
###
#foreach $errlist (@errors)
for (@errors)
{
print $_ ."\n";
}
