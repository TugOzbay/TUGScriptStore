#!/usr/bin/perl

#   Author        |    Brian Daly
#   Created       |    13-Mar-2015
#   Version       |    v1.00
#   Reason        |    Determine if specified mount Id's are connected to ADS

# Variables
my $REUTERS_BASE = "/opt/reuters";
my $RMDS_CONFIG = "$REUTERS_BASE/SOFTWARE/globalconfig/triarch.cnf";
my $ADSMON = "$REUTERS_BASE/ads/bin/adsmon";

# If config not in triarch.cnf, try rmds.cnf
unless (-e $RMDS_CONFIG) { $RMDS_CONFIG = "$REUTERS_BASE/SOFTWARE/globalconfig/rmds.cnf"; }

# Print heading for ITRS
print "Variable, Value\n";

# Create hash of mount Id's you wish to test are mounted. Initialise these Id's to zero. They will be set to 1 if successfully found to be connected.
my %mount_ids = (
    "TWMDPUB01" => 0,
    "TWMDPUB02" => 0,
    "TWMDPUB03" => 0,
);

# Create the regular expression from %mount_ids. Chop the final pipe character otherwise the regex will fail in while loop below.
foreach my $reg (keys %mount_ids) {
    $regex .= "$reg|";
}
chop $regex;

# Run adsmon and read all the mounts.
open (FILE, "$ADSMON -c $RMDS_CONFIG -instance 1 -print MOUNTS |") or die "Cannot run adsmon $!";

# Check for the values of $regex and set the value to 1 if found.
while (<FILE>) {
    if ( /$regex/ ) {
        $mount_ids{$&} = 1;
    }
}

# Return status of mounts
foreach my $key (sort keys %mount_ids) {
    print "$key, $mount_ids{$key}\n";
}
