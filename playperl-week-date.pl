#!/usr/bin/perl
# Author        : Tugrul Ozbay CJCit Ltd
# Date          : 25th June 2014 (was day 175)
# Reason        : Engineering Department Coffee Rota script
# Version       : 1.0004 Prod
# Strict        : Extremely loving it
# Warnings      : None.
#
#
# Note: A variable is defined by the ($) symbol (scalar),
#       the (@) symbol (arrays), or the (%) symbol (hashes).
#
use strict;
use warnings;
#
#
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
#
# Calculate number of full weeks this year
my $week = int(($yday+1-$wday)/7);
#
print "\n\n >>>The week no $week before tugs test - esasi yani<<<\n\n";
#
# TUG TEST PATCH - by setting different numbers below we choose different procedures below
$week = 13;
#
#
print "\n\n Tugs test week : $week\n\n";
# print "This is dollar week $week\n";
# my @weekArray = split (' ', $week); 
#
#
# print " this is the week array @weekArray\n\n";
#
#
#
my $timeData = localtime(time);
print " \n\n FULL DATE :  $timeData \n\n\n";
my @timeDataArray = split (' ', $timeData);
#
my @onlyDay = split ( ':' ,$timeDataArray[0]);
foreach my $justDaySplit (@onlyDay)
{
        print "\n TODAY :=> -> $justDaySplit [day: $yday] [wk: $week] \n\n"
}
#
print "\n\n ---> This is a print outside of the loop $week\n\n"; 
#
 	if ($week == 1 || $week == 4 ||$week == 7||$week == 10) {		# works best		
		print "\n inside loop 1 : $week \n\n";
		print "\n inside loop 1 \n";
		exit 0

}
#
	print "\n\n ---> This is the $week loop outside loop 2\n\n";
	if ($week == 2 || $week == 5 ||$week == 8||$week==11) {		# works best
		print "\n inside loop 2 : $week \n\n";

		print "\n inside loop 2 \n";
		exit 0
}
#
	print "\n\n--->The week $week outside of loop 3\n\n";
	if ($week == 3 || $week == 6 ||$week == 9||$week==12) {		# works best
		print "\n inside loop 3 : $week \n\n";
		print "\n inside loop 3 \n";
		exit 0
}
#
	print "\n\n---> This is $week outside of loop 4\n\n";
#	 if ($week => [13..999]) {     				# out of range and works perfect
	 if ($week => [13..999]) { 
		print "\n out of range - inside loop 4 : $week \n\n";

		print "\n inside loop 4 \n";
		exit 0
}
#
print "\n\n\n END \n\n\n";
#