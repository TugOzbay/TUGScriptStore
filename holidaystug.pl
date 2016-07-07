#!/usr/bin/perl

use strict;

my %countryBankHolidays = (
        GB => ['25th December', '1st Jan'],
        USA => ['25th December']
        );

foreach my $country (keys %countryBankHolidays) {
    print "The holidays for $country are\n";
    foreach my $holiday (@{$countryBankHolidays{$country}}) {
        print "\t$holiday\n";
    }
}
