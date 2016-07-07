#!/usr/bin/perl
# Author        : Tugrul Ozbay CJCit Ltd
# Date          : 18th June 2015
# Reason        : KFW Backup script (ATS)
# Version       : 1
# Strict        : Extremely
# Warnings      : None.
#
# Note : Copies to s619818fr5sl001:/reuters/ats/config/ats/ directory from the local
#
use strict;
use warnings;
use File::Copy;
#
#
my $clear = `clear`;    # clear the crap in unix
#
#
my $date = `date +"%m/%d/%Y"`;
my $day = `date +"%d"`;
my $yr = `date +"%Y"`;
print "\n\n  $day $yr  \n\n\n";
#
#
my $timeData = localtime(time);
print "\n\n  $timeData  \n\n\n";
#
#
# VARIABLES
#
# my $atsFiles = 'ats.*'; print "$atsFiles\n\n";
my $atsFiles = 'ats.*'; print "$atsFiles\n\n";
# system("mkdir -p /tmp/.ats");
# my $TMP = '/tmp/.ats/';

 my $remoteFilesDIR = '/tmp/.ats/';
 my $LocalDIR = '/reuters/ats/config/ats/';      ### LIVE PRODUCTION DIR
 my $BACKUPDIR = '/data01/home/radmin/eng/BKP2/'; ### BACKUP FOR RADMIN ready for LIVE


#
# Logging to File
sub logging
{
my $log = "/tmp/copyAtsConf.log";     # write out to $log (or LOG)
unlink "$log" if -f "$log";           # removes the log file if exits
}


### check you're under the right user
sub check_radmin
{
       chomp (my $username = `/usr/bin/whoami`);
#
       if (grep !/radmin/, $username) {           ##Run script as radmin
               logging (2, "You are logged in as $username --- not radmin. Exiting.");
               print "\n\tError::You are logged in as $username --- not radmin. Exiting!\n\n";
               exit;
       }
}
#
#
#
  #
     #
        # function Copy_ats_files
        {
        print " \n\n\n local copying from current dir to working live dir \n\n\n\n\n ";
        print " \n\n ok ..... ..... doing the copying it now .....  ..... ..... \n\n";
#
        system("cp -p $remoteFilesDIR$atsFiles $BACKUPDIR");
        system("chown radmin:tis $BACKUPDIR$atsFiles");
        system("chmod 644 $BACKUPDIR$atsFiles");
        system("cp $BACKUPDIR$atsFiles $LocalDIR"); ## or die "SUCCESS: PLS DOUBLE CHECK PROD FILES are in /reuters/ats/config/ats/                             $!";

        # my $prodDIR = `ls -alrt /reuters/ats/config/ats/ats.dico`;
        # print "\n\n  $prodDIR  \n\n\n";

        print " \n\n below is the list of files after the copy \n\n";
           my @list = `ls -lart /reuters/ats/config/ats/ats.*`;
           #my @list = `ls -lart /reuters/ats/config/ats/ats* | grep $day`;
            foreach (@list)
                 {
                 print;
                 }
         }

# MAIN BODY
       check_radmin();
       logging();
