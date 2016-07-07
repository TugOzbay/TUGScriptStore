#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 29th Jan 2014
# Reason        : Reading Flynns perl 2nd doc pg.19  FOR/WHILE LOOPS
# Version       : 1.0
# Strict        : Suppose so
# Warnings      : None.
#
use strict;
use warnings;
#
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
# ==========================================
# PRINT the CURRENT DATE 
# ==========================================
# 
my $timeData = localtime(time);
print $timeData;
#
# ==========================================
# MKDIR 
# ==========================================
#
mkdir "./testdir" if ! -d "./testdir";		# makes a ./testdir if it doesn't exist already (works)
#
#
# ==========================================
#  FOR LOOPS
# ==========================================
#
for (my $loop = 0; $loop <=10; $loop++)
	{
	print "$loop \n";
	}
	
foreach my $number (1..10)		# from 1 to 10 print the numbers (can do 100s 1000s etc)
	{
	print "$number \n";
	}
#
#
# ==========================================
#  WHILE LOOPS
# ==========================================
#
my @names = qw(Jack Celine Irem Bill bob steve Tim Jen Tug);
while (@names)
	{
	my $element = pop @names;
	print $element,"\n";
	}
#
# ==========================================
# UNTIL LOOP
# ==========================================
#
my $line;
until ($line = <STDIN>)
	{
	print "I am inside the main block\n";
	}
continue
	{
		print "I am inside the continue block\n";
	}
chomp $line;
print "I typed: $line\n";
#
# ==========================================