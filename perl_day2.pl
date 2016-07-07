#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 29th Jan 2014
# Reason        : Reading Flynns perl doc 
# Version       : 3.0
# Strict        : Suppose so
# Warnings      : None.
#
use strict;
use warnings;
#
#
print "hello world - checking ads log now and outputting";
#
#
my (@errors);
open FILEHANDLE_IN, "< C:/Users/tugrul.ozbay.CJCIT/Documents/WORK/Perl/ads.log";
open FILEHANDLE_OUT, "> C:/Users/tugrul.ozbay.CJCIT/Documents/WORK/Perl/practical-1-results.txt";

while (<FILEHANDLE_IN>) 
{
	if (grep /error/i, $_) 		# greps for error ignores case and sticks it into $_
	{
		push (@errors, $_);		# pushes each error into @error array
		print " ERROR FOUND\n"; # This line causes it to hit return on an Error for good formatting
	}
}
close FILEHANDLE_IN;
close FILEHANDLE_OUT;

# my $error_count = $#errors;                     # starts at 0
# my $error_count2 = length (@errors);            # starts at 0
# my $error_count3 = @errors;                     # normal count


foreach my $error (@errors) 
{
	print "$error \n";
}

print "$#errors errors seen in logfile\n";
# print "@errors errors seen in logfile\n";
