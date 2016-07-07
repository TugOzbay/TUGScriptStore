#!/usr/bin/perl
# numbers
    use strict;
    use warnings;

    my $num1 = 4;

    if ($num1 < 1) {
        print "Less than one!\n";
    } elsif ($num1 <= 2) {
        print "Less than or equal to two!\n";
    } elsif ($num1 == 3) {
        print "Equals three\n";
    } elsif ($num1 > 5) {
        print "Greater than five!\n";
    } elsif ($num1 >= 4) {
        print "Greater than or equal to four!\n";
    }

    exit 0;
