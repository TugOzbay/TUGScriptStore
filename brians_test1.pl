#!/usr/bin/perl
#
# brians_test1.pl
# my $count++ if ( /$search_bgn/ );
# 
#!/usr/bin/perl -w
use strict;

my $string = q<ABCDABDIDAOFOOFAA>;
my %count;
for (split(//, $string)){$count{$_}++;}	# splits the string into its constituent parts A  B  C. $_ takes the value of each constituent in turn.
print(q<Matches >, $count{A}, "\n");	# then, it uses  $_  as the key and counts how many times that key occurs

my $string2 = q<ArsenalArsenalArsenalArsArsArsArsArsUpTheArsArsenal>;
my %count;
for (split(//, $string2)){$count{$_}++;}	# splits the string into its constituent parts A  B  C. $_ takes the value of each constituent in turn.
print(q<Matches >, $count{T}, "\n");		# then, it uses  $_  as the key and counts how many times that key occurs