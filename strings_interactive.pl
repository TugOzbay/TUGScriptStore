#!/usr/bin/perl -w
#
# Tugs playing ground
# my interactive string sample
#
use strict;
use warnings;
#
my $timeData = localtime(time);
print $timeData;
#
my $clear =`cls`;								# windows clear
# my $clear = `clear`;                            # clear in unix
print $clear;
#
print " \n\n\n";
print "Enter a list of things or words as you like: ";
chomp (my $str = (<STDIN>));                    # read in words of whatever

my @words = split(' ', $str);                   # split my words using space into @words array . . and attach the $str string to each

foreach my $word (@words) {                     # for each of my $words within the @words array print each content.
    print "foreach loop $word\n";
}

print " \n\n\n";
print "All words in array: @words\n";             # print the whole array @words

print "Second word within array: $words[1]\n";    # print the slot [1] which is the second word in the @word array
# print "Second word: @words[1]\n";               # print the slot [1] which is the second word in the @word array

exit 0;
