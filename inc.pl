#!/usr/bin/perl
#
# lookinc - where to look for modules

$"="\n";

print "@INC\n";

###############################################
ENVIRONMENT TEST BELOW
###############################################
# $ENV{'PATH'} = '/';		# unix
$ENV{'PATH'} = 'C:/Users';
print 'PATH=\n';