#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 24th Feb 2014
# Reason        : Clearing Special characters
# Version       : 1.0
# Strict        : Suppose so
# Warnings      : None.
#
#
#
use strict;
use warnings;
#
# =========================================================
# VARIABLES SECTION
# =========================================================
# my $clear = `clear`;                                                    # clear in unix
my $clear    = `cls`;                                                 # clear in windows
print $clear;
#
#
my $a = "abcdef^bbwk#kdbcd@";
$a =~ s/[^a-zA-Z0-9]*//g;		#clears the shit
#
# print section
print $a . "\n";