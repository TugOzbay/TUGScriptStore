#!/usr/bin/perl
# Author        : Tugrul Ozbay CJCit Ltd
# Date          : 25th June 2014
# Reason        : Engineering Department Core Rota script
# Version       : 1.0006 Prod
# comment       : Added Jonas to Rota (on 19th Apr 2015 T Ozbay)
# Strict        : Extremely loving it
# Warnings      : None.
#
#
# Note: A variable is defined by the ($) symbol (scalar),
#       the (@) symbol (arrays), or the (%) symbol (hashes).
#
use Sys::Hostname;
use strict;
#
#
my $box = hostname;

# my $clear = `clear`;    # clear the crap in unix
# print $clear;
#
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
#
# Calculate number of full weeks this year
my $week = int(($yday+1-$wday)/7);
#
chomp $week;
#
# print $week;
# Add 1 if today isn't Saturday
if ($wday < 6) {$week +=1;}
#

# (another way to do it) # my $box = `hostname`;
print " \n\n BOX is  :  $box \n\n\n";

#
#
my $timeData = localtime(time);
print " \n\n FULL DATE :  $timeData \n\n\n";
my @timeDataArray = split (' ', $timeData);
#

my @onlyDay = split ( ':' ,$timeDataArray[0]);
foreach my $justDaySplit (@onlyDay)
{
        print "\n TODAY :=> -> $justDaySplit [day: $yday] [wk: $week] \n\n";
}

#
#
#
my $log = "/tmp/FScheck.log";     # write out to $log (or LOG)
#

# send_mail($box, $week);
send_mail($box);
#
#
sub send_mail {

        #my $box,$week =@_;
        my $box =@_;
        my $mailDir = "/data01/home/cjcadmin/scripts/mailAlert";
        my $sender = 'diskSpace@trhlo4susbd001a.com';
        my $recipient = 'tugrul.ozbay@cjcit.com';
		# my $recipient = '"cjcengineering_cjcit@cjcit.com';
		
        open LOG, "< $log";             # opens my log file
        chomp (my @output = <LOG>);     # cleans my output log
        close LOG;                      # closes it

        my $lineOut = join '<br>', @output;


        system "$mailDir/sendEmail -s smtp:25 -o message-content-type=html -f $sender -t $recipient -u \"DiskSpace \" -m \"$lineOut\"";

}

#
#
# ################# END ########################
