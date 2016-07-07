#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 29th Jan 2014
# Reason        : Reading Flynns perl 2nd doc pg.7 with printing to FILE_OUT
# Version       : 3.0
# Strict        : Suppose so
# Warnings      : None.
#
use strict;
use warnings;
#
#
print "\n\n";
print "  Hello Tug - checking ads log now and outputting \n";
print "--------------------------------------------------- \n\n\n";
#
#
my (@errors);
open FILE_IN, "< C:/Users/tugrul.ozbay.CJCIT/Documents/WORK/Perl/ads.log";
open FILE_OUT,"> C:/Users/tugrul.ozbay.CJCIT/Documents/WORK/Perl/day2-results.txt";

while (<FILE_IN>) 
{
	if (grep /error/i, $_) 			# greps for error ignores case and sticks it into $_
	{
		push (@errors, $_);			# pushes each error into @error array as $_
		print FILE_OUT "$_"; 	# This will force the output to the day2-results.txt
	}
}
close FILE_IN;
close FILE_OUT;

foreach my $error (@errors) 
{
	print "$error \n";
}

print "$#errors errors seen in the logfile\n";

my $CorrectErrorCount = @errors;
print " Correct amount of Errors seen in logfile are :",$CorrectErrorCount,"\n";
#print "@errors errors seen in logfile\n";
#
print "\n";
print "\n";
print "---------------------------------------------------------------------------\n";
print "------------Rest of the excercise is below---------------------------------\n";
print "---------------------------------------------------------------------------\n";
print "---------------------------------------------------------------------------\n";
print "\n";

#
#---------------- below here is excercises on strings and notes -------------------
#
# metacharacters
# Dirty Dozen \ | ( ) [ { ^ $ * + ? .

#strings
print " this is string character 65 : ",chr(65),"\n";
#
my $firstVar=substr("0123BBB789",4,3);
print(" firstVar = $firstVar\n"); 	#program should print firstVar = BBB
#
#
my $Var=substr("1234AAA7891",4,3); 
print(" Var = $Var\n");	#should print Var = AAA 
#
# my $Var=substr($firstVar,4,3 )="AAA"; 
# print("Updated Var = $Var\n");	#should print   firstVar = 0123AAA789   (so AAA replaced the BBB).
#
#
#
# my $SecondVar=substr("0123XXX789",4,3);
# substr($SecondVar,4,3)="YYY";
# print("SecondVar =", $SecondVar," \n");	#should print   SecondVar = 0123XXX789   (so XXX replaced the YYY).
#
#
# LOOPS & CONTROL STRUCTURES (NEXT SCRIPT)
#
