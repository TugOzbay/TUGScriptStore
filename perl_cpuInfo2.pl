#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 7th Feb 2013
# Reason        : interrogating the /proc/cpuinfo file 
# Version       : 0.1
# Strict        : Suppose so
# Warnings      : None.
#
use strict;
use warnings;
#
#
print "\n\n";
print " Hello Tug - checking /proc/cpuinfo and outputting \n";
print " ---------------------------------------------------- \n\n\n";
#
#
my (@processors);
open FILEHANDLE_IN, "< C:/Users/tugrul.ozbay.CJCIT/Documents/WORK/Perl/cpuinfo.txt";
open FILEHANDLE_OUT,"> C:/Users/tugrul.ozbay.CJCIT/Documents/WORK/Perl/cpuinfo.log";

while (<FILEHANDLE_IN>) 
{
	if (grep /processor/i,$_) 	# greps for processor ignores case and sticks it into $_
	{
		push (@processors,$_);	# pushes each processors into @processors array as $_
	}
}
close FILEHANDLE_IN;
close FILEHANDLE_OUT;

foreach my $processor (@processors) 
{
	print "$processor","\n";
}

#
# print "$#processors  seen in the cpuinfo file\n";
#

my $CORRECTprocessorCount = scalar(@processors);
print " Correct amount of Errors seen in logfile are :",$CORRECTprocessorCount,"\n";

# metacharacters
# Dirty Dozen \ | ( ) [ { ^ $ * + ? .