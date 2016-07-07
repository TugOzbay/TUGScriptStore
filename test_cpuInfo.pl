#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 2nd Feb 2014
# Reason        : playing
# Version       : 1.0
# Strict        : Suppose so
# Warnings      : None.
#
#
use strict;
use warnings;
#
#
my (@list);                                 # declare my array list
open FILE_IN, "<./cpuinfo.txt" or die $!;   # open my file and read in
open FILE_OUT, ">./test_cpuinfo.log";
chomp (my @fileIn = <FILE_IN>);                         # the whole cpuinfo.txt files goes into array @fileIn
#
close FILE_IN;                                                          # close FILE_IN
#
#
#
#
print "\n\n";
print "Enter a word to search for in list of cpu : ";
#
chomp (my $word = (<STDIN>));               # read in word/animal
#
my @dummyArray = (grep /$word/i, @fileIn);
#
if (@dummyArray)
{
        print FILE_OUT "@dummyArray";           # print to output FILE_OUT
		my $timesFound = @dummyArray;
        print " The ..$word.. was found : $timesFound  times in the file.\n";
}
#
close FILE_OUT;