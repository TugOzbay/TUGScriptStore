#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 29th Jan 2014
# Reason        : Reading Flynns perl 2nd doc pg.7 
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
open FILEHANDLE_IN, "< C:/Users/tugrul.ozbay.CJCIT/Documents/WORK/Perl/ads.log";
open FILEHANDLE_OUT,"> C:/Users/tugrul.ozbay.CJCIT/Documents/WORK/Perl/day2-results.txt";

while (<FILEHANDLE_IN>) 
{
	if (grep /error/i,$_) 		# greps for error ignores case and sticks it into $_
	{
		push (@errors,$_);		# pushes each error into @error array as $_
	}
}
close FILEHANDLE_IN;
close FILEHANDLE_OUT;

foreach my $error (@errors) 
{
	print "$error","\n";
}

print "$#errors errors seen in the logfile\n";

my $CORRECTerrorcount = scalar(@errors);
print " Correct amount of Errors seen in logfile are :",$CORRECTerrorcount,"\n";
#print "@errors errors seen in logfile\n";

# metacharacters
# Dirty Dozen \ | ( ) [ { ^ $ * + ? .