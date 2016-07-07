#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 31st Jan 2014
# Reason        : Practical day 2 in flynns document
# Version       : 1.0
# Strict        : Suppose so
# Warnings      : None.
#
use strict;
use warnings;
#
#
#
#
# ===================================================================================
#
# Practical 2 
# Read in ADS.log 
# Make 3 arrays; when "failed" is seen, "login" is seen, "RRCP" is seen.
# print lines which say "Login accepted by host"
# 
# ===================================================================================
#
#
#
print "\n\n";
print "--------------------------------------------------- \n\n\n";
print "  Practical day 2 - Checking ads log now & outputting \n";
print "--------------------------------------------------- \n\n\n";
#
#
my (@errorlist);
open ADS_LOG_IN, "< C:/Users/tugrul.ozbay.CJCIT/Documents/WORK/Perl/ads.log";
open ADS_LOG_OUT,"> C:/Users/tugrul.ozbay.CJCIT/Documents/WORK/Perl/practical-2-results.txt";

while (<ADS_LOG_IN>) 
{
	if (grep /error|failed|login|rrcp/i, $_)  # greps for error|failed|login|rrcp & ignores case and sticks it into $_
	{
		push (@errorlist, $_);			# pushes each error into end of @error array as $_
		print ADS_LOG_OUT "$_"; 		# This will force the output to the file day2-results.txt
	}
}
close ADS_LOG_IN;
close ADS_LOG_OUT;

# reference metacharacters
# Dirty Dozen \ | ( ) [ { ^ $ * + ? .


foreach my $error (@errorlist) 
{
	print "$error \n";
}

print "$#errorlist errors seen in the logfile\n";

my $CorrectErrorCount = @errorlist;
print " Correct amount of Errors seen in logfile are :",$CorrectErrorCount,"\n";
print " \n";

# print "@errors errors seen in logfile\n";
#
print "\n";
print "\n";
print "---------------------------------------------------------------------------\n";
print "------------ Check LOGIN stats below --------------------------------------\n";
print "---------------------------------------------------------------------------\n";
print "---------------------------------------------------------------------------\n";
print "\n";
print "\n";
#
#
# ==========================================
# PRINT the CURRENT DATE 
# ==========================================
# 
print " TIME OF LOGIN STATS TAKEN SHOWN BELOW \n";
my $timeData = localtime(time);
print " *** ", $timeData, " *** ",    "\n";
print " \n";
print " \n";
print " \n";
#
# ==========================================
# MKDIR 
# ==========================================
#
# mkdir "./testdir" if ! -d "./testdir";		# makes a ./testdir if it doesn't exist already (works)
#
# ==========================================
#
#
#
# ==========================================
#
# Here I open and check for LOGIN only
#
# ==========================================
my (@loginlist);
open LOGIN_IN, "< C:/Users/tugrul.ozbay.CJCIT/Documents/WORK/Perl/ads.log";
open LOGIN_OUT,"> C:/Users/tugrul.ozbay.CJCIT/Documents/WORK/Perl/login-results.txt";
#
while (<LOGIN_IN>) 
{
	if (grep /login/i, $_)  	# greps for 'login' & ignores case and sticks it into $_
	{
		push (@loginlist, $_);	# pushes each "login" into end of @loginlist array as $_
		print LOGIN_OUT "$_"; 	# This will force the output to the file login-results.txt
	}
}
close LOGIN_IN;
close LOGIN_OUT;

# reference metacharacters
# Dirty Dozen \ | ( ) [ { ^ $ * + ? .


foreach my $login (@loginlist) 
{
	print "$login \n";
}
#
print " About $#loginlist logins seen in the logfile\n";
#
my $CorrectLoginCount = @loginlist;
print " Correct amount of Logins seen in logfile are :",$CorrectLoginCount,"\n";
print " \n";
#
#
# ==========================================
#
#  Printing ARRAY SIZE
#
# ==========================================
# 

my @array = @loginlist;
my $arraySize = scalar (@array);
$arraySize = $#array + 1;
#
# print it
#
print "Array size = $arraySize\n";
# print "Array contents are as follows :-", @array, "\n";
print "@array";

