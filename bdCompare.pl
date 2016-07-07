
#!/usr/bin/perl

#   Author        |    Brian Daly
#   Created       |    5-Jan-2015
#   Version       |    v1.01
#   Reason        |    Provide a quick comparison of 2 files
#                 |

sub Usage{
  if ( $ARGV[2] ) { print STDERR "\n\tOnly two files please";}
  print STDERR "\n\tUsage: $0 file1 file2\n\n";
  exit(1);
}

if (! ($ARGV[0] && $ARGV[1]) or $ARGV[2] ) {
  &Usage();
}

open (CNF1, "$ARGV[0]") or die "Cannot open $ARGV[0] file $!";
open (CNF2, "$ARGV[1]") or die "Cannot open $ARGV[1] file $!";

# Create hashes from input files
my $i=1;
my $j=1;
my %first  = map { $_ => $i++ } <CNF1>;
my %second = map { $_ => $j++ } <CNF2>;

# Create a union
my %union = (%first,%second);

for my $key2 ( keys %union ) {
    if ( ! exists $first{$key2} ){
        print "\t$ARGV[1]\tLine No: $second{$key2}\t $key2";
    }
    if ( ! exists $second{$key2} ){
        print "\t$ARGV[0]\tLine No: $first{$key2}\t $key2";
    }
}
