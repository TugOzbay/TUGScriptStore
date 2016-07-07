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
# sample :(($i > 123) && ($i < 456)) 
# 
#
use strict;
use warnings;
#
#
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
#
# Calculate number of full weeks this year
# my $yday = int(($yday+1-$wday)/7);
#
print "\n\n >>>The week no $yday before tugs test - esasi yani<<<\n\n";
#
# TUG TEST PATCH - by setting different numbers below we choose different procedures below
# $yday = 14;
$yday = 101;
# $yday = 99;
# $yday = 13;
#
#
print "\n\n Tugs test yday : $yday\n\n";
#
# print "\n\n Tugs test week : $yday\n\n";
# print "This is dollar week $yday\n";
# my @weekArray = split (' ', $yday); 
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
        print "\n TODAY :=> -> $justDaySplit [day: $yday] [wk: $yday] \n\n"
}
#
print "\n\n ---> This is a print outside of the loop $yday\n\n"; 
#
 	if ($yday == 1 || $yday == 4 ||$yday == 7||$yday == 10) {		# works best		
		print "\n inside loop 1 : $yday \n\n";
		print "\n inside loop 1 \n";
		exit 0

}
#
	print "\n\n ---> This is the $yday loop outside loop 2\n\n";
	if ($yday == 2 || $yday == 5 ||$yday == 8||$yday==11) {		# works best
		print "\n inside loop 2 : $yday \n\n";

		print "\n inside loop 2 \n";
		exit 0
}
#
	print "\n\n---> This is the $yday outside of loop 3\n\n";
	if ($yday == 3 || $yday == 6 ||$yday == 9||$yday==12) {		# works best
		print "\n inside loop 3 : $yday \n\n";
		print "\n inside loop 3 \n";
		exit 0
}
#
	print "\n\n---> This is $yday outside of loop 4\n\n";
#	 if ($yday => [13..99]) {     				# out of range and works perfect
	 #if ($yday == [13..99]) { 
	 if ($yday >= 13 .. $yday <= 99) { 		# works perfect
		print "\n range of 13-99 - inside loop 4 : $yday \n\n";

		print "\n inside loop 4 \n";
		exit 0
}
#
	print "\n\n---> This is $yday outside of loop 5\n\n";
		 if ($yday => 100 .. $yday <= 999) { 	#  works perfect
	 # if ($yday => [100 .. 999]) {     			# out of range a
	# if ($yday == [100..999] || $yday => [1000..9999999]) {
		print "\n range is 100-999 -> inside loop 5 : $yday \n\n";
	#	print "\n range is 100-999 -> inside loop 5 : $yday \n\n";
	#	print "\n OR, 2nd range is 1000-999999999 -> inside loop 5 : $yday \n\n";
		print "\n inside loop 5 \n";
		#exit 0
}
# print "\n\n\n END \n\n\n";
#