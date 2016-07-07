#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 29th Jan 2014
# Reason        : Reading Flynns perl 2nd doc pg.16 Loops / Control Structures
# Version       : 1.0
# Strict        : Suppose so
# Warnings      : None.
#
use strict;
use warnings;
#
print "\n";
print "\n";
print " -------------------------------------------------------\n";
print " Remember that this is string character 65 : ",chr(65),"\n";		# remember 65 is A.
print "\n";
print " * * *          Name : ",chr(84),chr(85),chr(71),"         * * * \n";
print "\n";
print " -------------------------------------------------------\n";
#
# LOOPS / CONTROL STRUCTURES
#
#

for (65..90)
{
	print chr($_)," ";		# This will print the whole alphabet 
}

print "\n";
print "\n";
print "\n";
#
# ==========================================
# Control Statements
# ==========================================
#
# testing 4 times below
# my $team = "Arsenal";		# results show the first choice
# my $team = "chelsea";		# results show else choice West Ham as lower case "c"
# my $team = "cChelsea";	# results show second choice below, as it sees the whole word "Chelsea" within $team
my $team = "Chelsea";		# results show second choice below, "Chelsea" as expected

if (grep /Arsenal/,$team)
	{
	print "It's about time $team wins the league!\n";
	}
elsif (grep /Chelsea/,$team)
	{
	print "well, $team are doing well due to the oil money!\n";
	}
else
	{
	print "can we play a team like West Ham every week?\n";
	}
#
#
#
#
#
# ==========================================
# Control Statements IF EXAMPLES
# ==========================================
#
mkdir "./testdir" if ! -d "./testdir";		# makes a testdir if it doesn't exist already
#
# testing
my $greatApe="YamYam";		# should print that Chimp is still a "primate"
#
#			
my $chimp = "primate"; 
if (grep /gorilla/,$greatApe)	
{
print "Chimp is currently a :, $chimp,/n";  # variable $chimp becomes 'primate' if 'gorilla' is in variable $greatApe
}
#
