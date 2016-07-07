#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 2nd Feb 2014
# Reason        : playing
# Version       : 3.0
# Strict        : Suppose so
# Warnings      : None.
#
#
use strict;
use warnings;
#
#
my (@list);                                 # declare my array list
open FILE_IN, "<./animals.txt" or die $!;   # open my file and read in
open FILE_OUT, ">./animals.out.log";
chomp (my @fileIn = <FILE_IN>);				# the whole files goes into array @fileIn
#
close FILE_IN;								# close FILE_IN 
#
#
#
#
print "\n\n";
print "Enter a word to search for in list of animals : ";
#
chomp (my $word = (<STDIN>));               # read in word/animal
#
my @dummyArray = (grep /$word/i, @fileIn);
#
if (@dummyArray) 
{
	print FILE_OUT "@dummyArray";		# print to output FILE_OUT
    my $timesFound = @dummyArray;	
	print " The ..$word.. was found : $timesFound  times in the file.\n";
}
#
close FILE_OUT;