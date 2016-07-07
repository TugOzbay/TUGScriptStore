#!/usr/bin/perl

#   Author        |    Brian Daly 
#   Created       |    5-Jan-2015 
#   Version       |    v1.02
#   Reason        |    Provide a quick comparison of 2 files
#                 |   

#!/usr/bin/perl

sub Usage{
  if ( $ARGV[2] ) { print STDERR "\n\tOnly two files please";}
  print STDERR "\n\tUsage: $0 <file1> <file2>\n\n";
  exit(1);
}

if (! ($ARGV[0] && $ARGV[1]) or $ARGV[2] ) {
  &Usage();	#does the above procedure if not 3 args
}

# open the 2 files below argv0 into CNF1 and argv1 into CNF2
open (CNF1, "$ARGV[0]") or die "Cannot open $ARGV[0] file $!";
open (CNF2, "$ARGV[1]") or die "Cannot open $ARGV[1] file $!";

# Create hashes from input files
my $i=1;
my $j=1;
my %first  = map { $_ => $i++ } <CNF1>;	# map key to data in CNF1
my %second = map { $_ => $j++ } <CNF2>; # map key to data in CNF2

# Create a union
my %union = (%first,%second); # two sections with cnf1 and cnf2 side by side

for my $key2 ( keys %union ) { # for each key line in the %union joined hash
    if ( ! exists $first{$key2} ){ # if not exist 1st file first line in %union
        print "\t$ARGV[1]\tLine No: $second{$key2}\t $key2"; # print line no
    }														 # print 2nd & key
    if ( ! exists $second{$key2} ){ # if not exist on 2nd file line in %union 
        print "\t$ARGV[0]\tLine No: $first{$key2}\t $key2"; # print it
    }
}
