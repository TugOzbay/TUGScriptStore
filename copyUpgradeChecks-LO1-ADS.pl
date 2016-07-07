#!/usr/bin/perl
#
# Perhaps use distribution list from upgrade instead of local.nodes ?
#open NODES, "< /reuters/SOFTWARE/config/local.nodes";
open NODES, "< ./week4";
my $file = do { local $/; <NODES> };
close NODES;

my @nodeArray = (split /\n/, $file);
@nodeArray = grep !/\#|^$/, @nodeArray;

open NODEID, "> ./UpgradeChecks_results.txt";

foreach $host (@nodeArray) {
        print "$host\n";
        `scp ./upgradeChecks.sh $host:/tmp`;
        `scp ./getADSServiceInfo.pl $host:/tmp`;
        `scp ./getADSUserInfo.pl $host:/tmp`;
        `scp ./getADHServiceInfo.pl $host:/tmp`;
        my $output = `ssh $host \"/tmp/upgradeChecks.sh\"`;
        print NODEID "$output\n";
}
#
#
#
#
#
# REFERENCES
#
#
# week4
# trhlo1slsd01a02
# trhlo1slsp01a02
# trhlo1slsp02a02
# trhlo1slsp03a02
# trhlo1slsp03b03
# trhlo1slsp04b03
# trhlo1slssd003a
# trhlo1slssd003b
#
#
# All other references scripts are in
#
# cjcadmin@trhlo1susbd001a# pwd
#/data01/home/cjcadmin/scripts/perl/postUpgradeChecks
#
#
#
