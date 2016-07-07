#!/usr/bin/perl
# Author        : Tugrul Ozbay CJCit Ltd
# Date          : 23rd June 2014 (day 173)
# Reason        : Engineering Dept. Coffee Rota
# Version       : 1
# Strict        : Extremely
# Warnings      : None.
#
#
# Note: A variable is defined by the ($) symbol (scalar), 
#       the (@) symbol (arrays), or the (%) symbol (hashes). 
#
# use Net::DNS::Resolver;
use strict;
use warnings;


my $hostname = 'perl.org';
my $res = Net::DNS::Resolver->new(
  nameservers => [qw(10.5.0.1)],
);

my $query = $res->search($hostname);

if ($query) {
  foreach my $ab ($query->answer) {
    next unless $ab->type eq "A";
    say "Found an A record: ".$ab->address;
  }

}
