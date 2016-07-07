#!/usr/bin/perl
# Author        : Tugrul Ozbay CJC-it Ltd
# Date          : 5th Jan 2015
# Reason        : archiving tug.log when it reaches 1MB size and rotates until 10 then it will archive gzip
# Version       : 1
# Strict        : Extremely
# Warnings      : None.
#
use strict;
#
my $benim_dir = "/data01/home/tozbay";  # Location of the Log files
my $benim_log = "tug.log";        # Name of the Log file
my $maxsize = 1_000000;                  # 1 MB Max size before rotating
my $maxlogs = 10;                        # 10 is the number of rotates before archive
my $tot_archive = 10;                    # 10 is the number of logs to archive
my ($s, $m, $h, $dayOfMonth, $month, $yearOffset, $dow, $doy, $dst) = localtime();  # Create date from local time
#
my $year = 1900 + $yearOffset;
my $date = $year * 1000 + ($month + 1) * 100 + $dayOfMonth;    # Format Date
my $mytar;    # Store names of files to be archived
#
### Switch to my directory where log file is located
chdir $benim_dir;
#
### Check Size of tug.log yani benim
if(-s $benim_log > $maxsize)
{
    ### for do to rotate old benim logs
    for(my $i = $maxlogs - 1;$i > 0;$i--)
    {
        if(-e "${benim_log}.$i")
        {
            my $j = $i + 1;
            rename "${benim_log}.$i", "${benim_log}.$j";
        }
    }
    rename "$benim_log", "${benim_log}.1";
    `echo "" >> $benim_log`;

    ### Archive benim tug.logs
    if(-e "${benim_log}.$maxlogs")
    {
        for(my $i = $maxlogs - ($tot_archive - 1), my $j = 1;$i <= $maxlogs;$i++, $j++)
        {
            rename "${benim_log}.$i", "${benim_log}.${date}.$j";
            $mytar .= "${benim_log}.${date}.$j ";
        }

        my $i = 1;
        my $tarfile = "${benim_log}.${date}.tar";
        while ( (-e $tarfile) || (-e "${tarfile}.gz") )
        {
            $tarfile = "${benim_log}.${date}.tar.$i";
            $i++;
        }

        `tar -czf $tarfile $mytar`;
        `rm $mytar`;
        `gzip $tarfile`;
    }
}
else
{
    print " \n\n";
    print "Log file called  $benim_log  in  $benim_dir  is far too small to rotate.\n\n";
    print " *Needs to get to a file size of 1MB - then it will rotate.\n\n";
}
