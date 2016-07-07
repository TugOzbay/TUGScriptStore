#!/usr/bin/perl
# Author        : Tugrul Ozbay CJCit Ltd
# Date          : 24th June 2014 (was day 174)
# Reason        : Sendmail sample
# Version       : 0.0001
# Strict        : Extremely loving it
# Warnings      : None.
#
#
#!/reuters/test/perl5/5.8.4/bin/perl
#
#
use lib '/reuters/perl/perl5/site_perl/5.8.4/';                                 ##Only for LO4
use strict;
#
#
# ---------------READ contents of DIR rundir
#
# my $rundir = "/data01/home/cjcadmin/scripts/mailAlert";
my $rundir = '/data01/home/cjcadmin/eng/tug';
#
opendir (DIR, $rundir) or die $!;
#
while (my $file = readdir(DIR))
{
        print "$file\n";
}
#
# ---------------END of READ contents of DIR rundir
#
#
###########################################################
##      SendMail
###########################################################
#
# MANUAL MAIL WORKERS
#
open (MAIL, "$rundir/sendEmail -s 'smtp' -f 'Coffee\@cjcadmin.com' -t tugrul.ozbay\@cjcit.com -m `cat -e coffeeRota.174.log`")|| die "mail failed:$!\n";
#
#/data01/home/cjcadmin/scripts/mailAlert/sendEmail -s "smtp" -f "Coffee@cjcadmin.com" -t tugrul.ozbay@cjcit.com -m `cat -e coffeeRota.174.log`
#/data01/home/cjcadmin/scripts/mailAlert/sendEmail -s "smtp" -f "Coffee@cjcadmin.com" -t tugrul.ozbay@cjcit.com -m `cat -e coffeeRota.174.log`
#
# $listing $rundir/sendEmail
# $rundir/sendEmail '-s "smtp" -f "Coffee@cjcadmin.com" -t tugrul.ozbay@cjcit.com -m `cat -e coffeeRota.174.log`';
# $rundir/sendEmail -s \"smtp\:25" -f "Coffee\@cjcadmin.com" -t tugrul.ozbay\@cjcit.com -m `cat -e coffeeRota.174.log`;
#
#
#
# NON WORKERS BELOW
# my $sendMailApp='/data01/home/cjcadmin/scripts/mailAlert/sendEmail';
# $sendMailApp -s "smtp" -f "Coffee@cjcadmin.com" -t tugrul.ozbay@cjcit.com -m `cat -e coffeeRota.174.log`
#
#
#
# my $sendMailApp='sendEmail';
# $sendMailApp -s "smtp" -f "Coffee@cjcadmin.com" -t tugrul.ozbay@cjcit.com -m `cat -e coffeeRota.174.log`
# /data01/home/cjcadmin/eng/tug/sendEmail -s "smtp" -f "Coffee@cjcadmin.com" -t tugrul.ozbay@cjcit.com -m `cat -e coffeeRota.174.log`
#
# IN SCRIPT WORKERS SAMPLE
# $mailDir/sendEmail -s $mailServer:25 -f $sender -t $recipient -u \"$centre" \"$header\n\n\nAutomated Coffee email -  Do Not reply! \" -a $file $log;
#
#
