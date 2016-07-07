#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 10th Feb 2013
# Reason        : play10.01 
# Version       : 0.1
# Strict        : Suppose so
# Warnings      : None.
#
#
use strict;
use warnings;
#
#
print "\n\n";
print " Hello Tug - checking arrays outputting \n";
print " ----------------------------------------- \n\n\n";
#


my $element = "Tugrul";

my @array = ( "find", "if", "you", "can", "or", "not", "tug" );

if ( my @found = grep { $_ eq $element } @array )
{
      my $found = join ",", @found;
      print "Here's what we found: $found\n";
}
else
{
      print "Sorry, \"$element\" not found in \@array\n";
}
