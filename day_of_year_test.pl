#!/usr/bin/perl
# Author        : Tugrul Ozbay CJCit Ltd
# Date          : 23rd June 2014 (day 173)
# Reason        : Engineering Dept. Coffee Rota
# Version       : 1
# Strict        : Extremely
# Warnings      : None.
#
#
# Note: A variable is defined by the ($) symbol (scalar), 
#       the (@) symbol (arrays), or the (%) symbol (hashes). 
#
use strict;
use warnings;
#
my $timeData = localtime(time);
print " \n\n FULL DATE :  $timeData \n\n\n";
my @timeDataArray = split (' ', $timeData);  
#
my @onlyDay = split ( ':' ,$timeDataArray[0]);
foreach my $justDaySplit (@onlyDay)
{
	print "\n TODAY :=> -> $justDaySplit  \n\n"
}
#
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
#
print "\n\n $year $wday $yday \n\n";
#
