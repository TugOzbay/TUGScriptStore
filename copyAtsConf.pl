#!/usr/bin/perl
# Author        : Tugrul Ozbay CJCit Ltd
# Date          : 18th June 2015
# Reason        : KFW Backup script (ATS)
# Version       : 1 copyAtsConf.pl
# Strict        : Extremely
# Warnings      : None.
#
# Note : Copies to s619818fr5sl001:/reuters/ats/config/ats/ directory from the local
#
use strict;
use File::Copy;
#
#
my $clear = `clear`;    # clear the crap in unix
#
#
#
my $timeData = localtime(time);
print "\n\n  $timeData  \n\n\n";
#
# Logging to File
sub logging
{
my $log = "copyAtsConf.log";     # write out to $log (or LOG)
unlink "$log" if -f "$log";      # removes the log file if exits
}
#
### check you're under the right user
### check_rdm function definition is below
sub check_cjcops
{
       chomp (my $username = `/usr/bin/whoami`);
#
       if (grep !/cjcops/, $username) {           ##Run script as cjcops
               logging (2, "You are logged in as $username --- not cjcops. Exiting.");
               print "\n\tError::You are logged in as $username --- not cjcops. Exiting!\n\n";
               exit;
       }
}
#
#
# function call for user check and loggin is below
        check_cjcops();
        logging();

#
my $atsModel = './ats.model';
my $remoteModel = '/tmp/ats.model';
 system("sudo chown radmin:tis /tmp/ats.model");
 system("sudo chmod 644 /tmp/ats.model");
# my $remoteModel = '/reuters/ats/config/ats/ats.model';

my $atsContrib = './ats.contrib';
# my $remoteContrib = '/tmp/ats.contrib';
# my $remoteContrib = '/reuters/ats/config/ats/ats.contrib';

my $atsDico = './ats.dico';
# my $remoteDico = ' /tmp/ats.dico';
# my $remoteDico = ' /reuters/ats/config/ats/ats.dico';

my $atsUser = './ats.users';
# my $remoteUser = '/tmp/ats.users';
# my $remoteUser = '/reuters/ats/config/ats/ats.users';

my $atsArray = './ats.array';
# my $remoteArray = '/tmp/ats.array';
# my $remoteArray = '/reuters/ats/config/ats/ats.array';
#
   print " \n\n\n Copying from current ( /data01/home/cjcops/ats.XYZ )dir to working live dir \n\n\n\n\n ";
   #
        #
        # function Copy
        copy_ats();

sub copy_ats
        {
                print " \n\n ok doing the copying it now \n\n";
                copy("$atsModel","$remoteModel") or die "Copy has failed - please check make sure $atsModel exists $!";
#                copy("$atsContrib","$remoteContrib") or die "Copy has failed - please check make sure $atsContrib exists $!";
#                copy("$atsDico","$remoteDico") or die "Copy has failed - please check make sure $atsDico exists $!";
#                copy("$atsUser","$remoteUser") or die "Copy of ats.users has failed - please check $atsUser exists $!";
#                copy("$atsArray","$remoteArray") or die "Copy of ats.array has failed - please check $atsArray exists $!";

                print " \n\n below is the list of files after the copy \n\n";
                my @list = `ls -lart ats.*`;

                foreach (@list)
                {
                print;
                }
         }
