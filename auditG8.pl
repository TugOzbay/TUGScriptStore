#!/usr/bin/perl
#
# Author        : Tugrul Ozbay
# Date          : 19th Mar 2014
# Reason        : Library check script
# Version       : 1.0
# Strict        : Suppose so
# Warnings      : None.
#
use strict;
use warnings;
#
my $timeData = localtime(time);
print "\n\n  $timeData  \n\n\n";
#
chomp (my $host = `hostname`);                  # host
chomp (my $uid = `/usr/bin/whoami`);            # user check
my $log = "$host.lib-versions.log";             # write out to $log (or LOG)
unlink "$log" if -f "$log";                     # removes the log file if exits
#
#
if ( grep !/root/, $uid )
{
print " Error: Please make sure you are ROOT user while running this - try again \n\n";
exit;
}
#
    my $dir1 = '/usr/lib';
    my $dir2 = '/lib';
#
    opendir(DIR1, $dir1) or die "cannot find the directory $dir1 $!";
    opendir(DIR2, $dir2) or die "cannot find the directory $dir2 $!";
    open(LOG, ">> $log") or die "cannot create $log $!";
#

###     directory 1     ###
###     directory 1     ###
###     directory 1     ###

print "$host ";
print "$dir1 \n";
print LOG "$host ";
print LOG "$dir1 \n\n";

    my @libfiles
        = grep {
            "/^\>/"             # Begins with a more than arrow
            && -f "$dir1/$_"    # and is a file
        } readdir(DIR1);

# Loop through the array printing out the filenames
#
    foreach my $file (@libfiles) {
        print "$file\n";
        print LOG "$file\n";
    }

print "\n\n";
print LOG "\n\n";

###     directory 2     ###
###     directory 2     ###
###     directory 2     ###

print "$host ";
print "$dir2 \n";
print LOG "$host ";
print LOG "$dir2 \n\n";

   @libfiles
        = grep {
            "/^\>/"             # Begins with a more than arrow
            && -f "$dir2/$_"    # and is a file
        } readdir(DIR2);

# Loop through the array printing out the filenames
#
    foreach my $file (@libfiles) {
        print "$file\n";
        print LOG "$file\n";
    }


    closedir(DIR1);
    closedir(DIR2);
    exit 0;
#
