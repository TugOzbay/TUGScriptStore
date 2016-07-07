#!/usr/bin/perl
# Author        : Tugrul Ozbay CJC-it Ltd
# Date          : 8th Jan 2015
# Reason        : archiving coreRota
# Version       : 1
# Strict        : Extremely
# Warnings      : None.
# OS            : Solaris 5.10 / SunOS trhlo4susbd001a 5.10 Generic_148889-01 i86pc i386 i86pc
#
use strict;
#
my $here = "/opt/reuters/home/radmin";  # core dir
my $core = "coreRota";       # is my file t'rasta
my $maxCore = 52;            # 52 wks
my ($s, $m, $h, $dayOfMonth, $month, $yearOffset, $dow, $doy, $dst) = localtime();  # Create date use local time
my ($local) = localtime();  # date from local time
#
my $year = 1900 + $yearOffset;
my $date = $year * 1000 + ($month + 1) * 100 + $dayOfMonth;    # Format Date
my $benimtar;   # Store names of archived core rota files
#
### move to benim core location
chdir $here;
    ### Arc benim corelogs
    if(-e "${core}.$maxCore.log")
    {
        for(my $tugCount = $maxCore - ($maxCore - 1), my $singleCount = 1;$tugCount <= $maxCore;$tugCount++, $singleCount++)
        {
            rename "${core}.$tugCount.log", "${core}.${date}.$singleCount";
            $benimtar .= "${core}.${date}.$singleCount ";
        }
        my $tugCount = 1;
        my $tar = "${core}.${date}.tar";
        while ( (-e $tar) || (-e "${tar}.gz") )
        {
            $tar = "${core}.${date}.tar.$tugCount";
            $tugCount++;
        }

        `tar -cvlf $tar $benimtar`;
        `rm $benimtar`;
        `gzip $tar`;
    }
