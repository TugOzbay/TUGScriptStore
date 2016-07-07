#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 29th Jan 2014
# Reason        : Reading Flynns perl 2nd doc pg.18  IF/ ELSIF / ELSE
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

# ==========================================
# Control Statements IF EXAMPLES
# ==========================================
#
mkdir "./testdir" if ! -d "./testdir";		# makes a ./testdir if it doesn't exist already (works)
#
# testing
#
my $chimp = "primate";
my $greatApe="YamYam";		# should print that Chimp is still a "primate"
#my $greatApe="gorilla";		# should print that Chimp is still a "gorilla"

#
#			
#
if (grep /gorilla/, $greatApe)	
{
print "Chimp is a fully grown $greatApe now, no longer a $chimp \n";  # variable $chimp becomes 'gorilla' is in variable $greatApe
}
elsif (grep /YamYam/, $greatApe)
{
print "Chimp is still a  $chimp, nicknamed $greatApe \n";  # variable $chimp stays as a 'primate' 
}
#
#
