#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 2nd Feb 2014
# Reason        : playing
# Version       : 3.0
# Strict        : Suppose so
# Warnings      : None.
#

use strict;
use warnings;


my (@list);                                # declare my array list
open FILE_IN, "<./animals.txt" or die $!;  # open my file and read in
open FILE_OUT,">./animals.out.log";

print "\n\n";
print "Enter a word to search for in list of animals : ";
#
my $word = (<STDIN>);
my $string = findit();		# run sub findit using the word entered - if its in the file animals.txt its true, else false

if ($string) 
{
   print "\n";
   print ' true ',"\n\n";
}
else 
{
   print "\n";
   print ' false ',"\n\n";
}

sub findit 
{
   while (<FILE_IN>) 
		{
        if (grep /$word/i, $_)
			{
			push (@list, $_);
			print FILE_OUT "$_";
			}
			return(1) if index($_,$word) > -1;
			foreach my $word (@list)
			{
			print $word "\n";
			}
			print "$#list found in animals list\n";

		}
}

