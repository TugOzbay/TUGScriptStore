#!/usr/bin/perl
# Author        : Tugrul Ozbay 
# Date          : 7th Jan 2015
# Reason        : archiving LTC jukka when reaches 100k size and rotates until 10 then it archives
# Version       : 1
# Strict        : Extremely
# Warnings      : None.
#
use strict;
#
my $bizim_dir = "/data01/home/Desktop";  # Jukka yeri
my $bizim_jukka = "tug.wal";        	 # Jukka adi
my $maxsize = 1_00000;                   # 100k Max buyukluk rotasyon icin
my $maxjukka = 10;                       # 10 tane rotasyon
my $tot_arsiv = 10;                      # 10 tane jukka sonra arsivlemek
my ($s, $m, $h, $dayOfMonth, $month, $yearOffset, $dow, $doy, $dst) = localtime();  # Create date from local time
my ($local) = localtime();  # date from local time
#
my $year = 1900 + $yearOffset;
my $date = $year * 1000 + ($month + 1) * 100 + $dayOfMonth;    # Format Date
my $mytar;    # Name of dosya to be archived
#
## print "$local\n\n\n";
## print "s, m, h, dayOfMonth, month, yearOffset, dow, doy, dst\n\n";
## print "$s, $m, $h, $dayOfMonth, $month, $yearOffset, $dow, $doy, $dst\n\n";
#
### Switch directory where log is located
chdir $bizim_dir;
#
### Check Size of Jukka
if(-s $bizim_jukka > $maxsize)
{
    ### for do to rotate bizim jukka
    for(my $i = $maxjukka - 1;$i > 0;$i--)
    {
        if(-e "${bizim_jukka}.$i")
        {
            my $j = $i + 1;
            rename "${bizim_jukka}.$i", "${bizim_jukka}.$j";
        }
    }
    rename "$bizim_jukka", "${bizim_jukka}.1";
    `echo "" >> $bizim_jukka`;

    ### Arsivle bizim jukka'yi
    if(-e "${bizim_jukka}.$maxjukka")
    {
        for(my $i = $maxjukka - ($tot_arsiv - 1), my $j = 1;$i <= $maxjukka;$i++, $j++)
        {
            rename "${bizim_jukka}.$i", "${bizim_jukka}.${date}.$j";
            $mytar .= "${bizim_jukka}.${date}.$j ";
        }

        my $i = 1;
        my $tarfile = "${bizim_jukka}.${date}.tar";
        while ( (-e $tarfile) || (-e "${tarfile}.gz") )
        {
            $tarfile = "${bizim_jukka}.${date}.tar.$i";
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
    print "JUKKA file $bizim_jukka  in  $bizim_dir  is far too small to rotate.\n\n";
    print " *Needs to get to a file size of 100K - then it will rotate it.\n\n";
}
