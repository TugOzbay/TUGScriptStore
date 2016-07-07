#!/usr/bin/perl
# Author        : Play
#
#
#
my (@local_array_plus_rev, @local_rmds_array, @local_rev, @plusRmds, @plusGold, @badHosts);
my ($localhostCnf, $localRevisionNum);
# 
# $localRevisionNum = 111111111111;
@local_rev = grep /cnf Revision Number/, @local_array_plus_rev;
#
$localRevisionNum = (split /\!/, ((split /\s+/, $local_rev[0])[0]))[1];
#
print $localRevisionNum;