#!/usr/bin/perl
# Author        : Tugrul Ozbay CJCit Ltd
# Date          : 25th June 2014
# Reason        : Engineering Department Coffee Rota script
# Version       : 1.0004+1 Prod
# Strict        : Extremely loving it
# Warnings      : None.
#
#
# Note: A variable is defined by the ($) symbol (scalar),d
#       the (@) symbol (arrays), or the (%) symbol (hashes).
#
use strict;
#
#
# my $clear = `clear`;    # clear the crap in unix
# print $clear;
#
#
#
#
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
#
# Calculate number of full weeks this year
my $week = int(($yday+1-$wday)/7);
#
chomp $week;
#
# TUG TEST'ings
# $week = 28;
# $week = 51;
# $week = 0;
# $week = 5555555555555555555555555555555555555552;
#
# print $week;
# Add 1 if today isn't Saturday
if ($wday < 6) {$week +=1;}
# print "This Weeks Core & Coffee Rota (CCR) is $week\n";
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
                print "\n Surely its a week off ;-)\n\n";
}

#
# Logging to File
#
my $log = "coreRota_plusAjay.$week.log";     	# write out to $log (or LOG)
unlink "$log" if -f "$log";             		# removes the log file if exits
#
#
# Tugs testing bits below
print LOG "\n\n $year $wday $yday \n\n";
print LOG "\n\n the day of year is $yday \n\n";
#
if ($week == 1||$week == 8||$week == 14||$week == 20||$week == 26||$week == 32||$week == 38||$week == 44||$week ==50) {         # works best [1]
#
# WEEK 1
#
# define my Strings
my $Daystring1 = "Monday-Tuesday-Wednesday-Thursday-Friday-\n***** OFF week *****\n";
my $Engnames1 = "PaulK,TugO,BrianD,SamG,FlynnG,AjayP,DaveW";
#
# transform above strings into arrays with a little cleanup.
my @string1 = split('-', $Daystring1);
my @names1  = split(',', $Engnames1);
#
#
# my loop execution WEEK 1
open(LOG, ">> $log") or die "cannot create $log $!";
#
print LOG " \n\n ==== Ths Weeks Core & Coffee Rota (CCR) ==== \n\n";
print " \n\n ==== Ths Weeks Core & Coffee Rota (CCR) ==== \n\n";
#
for( $a = 0; $a < 7; $a = $a + 1 ){
        print LOG "$string1[$a]\n";  	# This will print LOG selected field
        print LOG "$names1[$a]\n\n";   	# This will print LOG ...
        print "$string1[$a]\n";  		# This will print to screen
        print "$names1[$a]\n\n";   		# This will print to screen
        }
#
send_mail();

exit
        }
#
#
#
if ($week == 2||$week == 9||$week == 15||$week == 21||$week == 27||$week == 33||$week == 39||$week == 45||$week ==51) {         # works best [2]
#
# WEEK 2
#
my $Daystring2 = "Monday-Tuesday-Wednesday-Thursday-Friday-\n***** OFF week *****\n";
my $Engnames2 = "DaveW,PaulK,TugO,BrianD,SamG,FlynnG,AjayP";
#
#transform above strings into arrays with a little cleanup.
my @string2 = split('-', $Daystring2);
my @names2  = split(',', $Engnames2);

# my loop execution WEEK 2
open(LOG, ">> $log") or die "cannot create $log $!";
print LOG " \n\n ==== Ths Weeks Core & Coffee Rota (CCR) ==== \n\n\n";
print " \n\n ==== Ths Weeks Core & Coffee Rota (CCR) ==== \n\n\n";
#
for( $a = 0; $a < 7; $a = $a + 1 ){
        print LOG "$string2[$a]\n";  	# This will print LOG selected field
        print LOG "$names2[$a]\n\n";   	# This will print LOG ...
        print "$string2[$a]\n";  		# This will print to screen
        print "$names2[$a]\n\n";   		# This will print to screen
        }
#
send_mail();
#
exit
        }
#
if ($week == 3||$week == 10||$week == 16||$week == 22||$week == 28||$week == 34||$week == 40||$week == 46||$week ==52) {         # works best [3]
#
#       if ($week =~ /(8||24||6)/) {            # works well in some cases
#
#
# WEEK 3
#
my $Daystring3 = "Monday-Tuesday-Wednesday-Thursday-Friday-\n***** OFF week *****\n";
my $Engnames3 = "AjayP,DaveW,PaulK,TugO,BrianD,SamG,FlynnG";
#
#transform above strings into arrays with a little cleanup.
my @string3 = split('-', $Daystring3);
my @names3  = split(',', $Engnames3);

# my loop execution WEEK 3
open(LOG, ">> $log") or die "cannot create $log $!";
print LOG " \n\n ==== Ths Weeks Core & Coffee Rota (CCR) ==== \n\n\n";
print " \n\n ==== Ths Weeks Core & Coffee Rota (CCR) ==== \n\n\n";
#
for( $a = 0; $a < 7; $a = $a + 1 ){
        print LOG "$string3[$a]\n";  # This will print LOG selected field
        print LOG "$names3[$a]\n\n";   # This will print LOG ...
        print "$string3[$a]\n";  # This will print LOG selected field
        print "$names3[$a]\n\n";   # This will print LOG ...

        }
#
send_mail();
#
exit
        }
#
#
if ($week == 4||$week == 11||$week == 17||$week == 23||$week == 29||$week == 35||$week == 41||$week == 47) {               # works best [4]
#
# WEEK 4
#
my $Daystring4 = "Monday-Tuesday-Wednesday-Thursday-Friday-\n***** OFF week *****\n";
my $Engnames4 = "FlynnG,AjayP,DaveW,PaulK,TugO,BrianD,SamG";
#
#transform above strings into arrays with a little cleanup.
my @string4 = split('-', $Daystring4);
my @names4  = split(',', $Engnames4);

# my loop execution WEEK 4
open(LOG, ">> $log") or die "cannot create $log $!";
print LOG " \n\n ==== Ths Weeks Core & Coffee Rota (CCR) ==== \n\n\n";
print " \n\n ==== Ths Weeks Core & Coffee Rota (CCR) ==== \n\n\n";
#
for( $a = 0; $a < 7; $a = $a + 1 ){
        print LOG "$string4[$a]\n";  # This will print LOG selected field
        print LOG "$names4[$a]\n\n";   # This will print LOG ...
        print "$string4[$a]\n";  # This will print LOG selected field
        print "$names4[$a]\n\n";   # This will print LOG ...

        }
#
#
send_mail();
#
#
exit
        }
#
#
if ($week == 5||$week == 12||$week == 18||$week == 24||$week == 30||$week == 36||$week == 42||$week == 48) {            # works best [5]
# if ($week =~ /(5||11||17||23||29||35||41||47)/) { # issues
#
# WEEK 5
#
my $Daystring5 = "Monday-Tuesday-Wednesday-Thursday-Friday-\n***** OFF week *****\n";
my $Engnames5 = "SamG,FlynnG,AjayP,DaveW,PaulK,TugO,BrianD";
#
#transform above strings into arrays with a little cleanup.
my @string5 = split('-', $Daystring5);
my @names5  = split(',', $Engnames5);

# my loop execution WEEK 5
open(LOG, ">> $log") or die "cannot create $log $!";
print LOG " \n\n ==== Ths Weeks Core & Coffee Rota (CCR) ==== \n\n\n";
print " \n\n ==== Ths Weeks Core & Coffee Rota (CCR) ==== \n\n\n";
#
for( $a = 0; $a < 7; $a = $a + 1 ){
    #print LOG "value of a: $a\n";
        print LOG "$string5[$a]\n";  # This will print LOG selected field
        print LOG "$names5[$a]\n\n";   # This will print LOG ...
        print "$string5[$a]\n";  # This will print LOG selected field
        print "$names5[$a]\n\n";   # This will print LOG ...

        }
#
#
send_mail();
#
#
exit
        }
#
#
if ($week == 6||$week == 13||$week == 19||$week == 25||$week == 31||$week == 37||$week == 43||$week == 49) {            # works best [6]
# if ($week =~ /(6||12||18||24||30||36||42||48)/) {     # issues
#
#       if ($week =~ /(8||24||6)/) {            #
#
# WEEK 6
#
my $Daystring6 = "Monday-Tuesday-Wednesday-Thursday-Friday-\n***** OFF week *****\n";
my $Engnames6 = "BrianD,SamG,FlynnG,AjayP,DaveW,PaulK,TugO";
#
#transform above strings into arrays with a little cleanup.
my @string6 = split('-', $Daystring6);
my @names6  = split(',', $Engnames6);

# my loop execution WEEK 6
open(LOG, ">> $log") or die "cannot create $log $!";
print LOG " \n\n ==== Ths Weeks Core & Coffee Rota (CCR) ==== \n\n\n";
print " \n\n ==== Ths Weeks Core & Coffee Rota (CCR) ==== \n\n\n";
#
for( $a = 0; $a < 7; $a = $a + 1 ){
        print LOG "$string6[$a]\n";  # This will print LOG selected field
        print LOG "$names6[$a]\n\n";   # This will print LOG ...
        print "$string6[$a]\n";  # This will print LOG selected field
        print "$names6[$a]\n\n";   # This will print LOG ...

        }
#
#
send_mail();
#
#
exit
}
#
#
if ($week == 7||$week == 14||$week == 20||$week == 26||$week == 32||$week == 38||$week == 44||$week == 50) {            # works best [7]
#
# WEEK 7
#
my $Daystring7 = "Monday-Tuesday-Wednesday-Thursday-Friday-\n***** OFF week *****\n";
my $Engnames7 = "TugO,BrianD,SamG,FlynnG,AjayP,DaveW,PaulK";
#
#transform above strings into arrays with a little cleanup.
my @string7 = split('-', $Daystring7);
my @names7  = split(',', $Engnames7);

# my loop execution WEEK 7
open(LOG, ">> $log") or die "cannot create $log $!";
print LOG " \n\n ==== Ths Weeks Core & Coffee Rota (CCR) ==== \n\n\n";
print " \n\n ==== Ths Weeks Core & Coffee Rota (CCR) ==== \n\n\n";
#
for( $a = 0; $a < 7; $a = $a + 1 ){
        print LOG "$string7[$a]\n";  	# This will print LOG selected field
        print LOG "$names7[$a]\n\n";   	# This will print LOG ...
        print "$string7[$a]\n";  		# This will print to screen
        print "$names7[$a]\n\n";   		# This will print to screen

        }
#
#
send_mail();
#
#
exit
}
#
#
#
#
# OUT OF RANGE
#
#
if ($week => [53..999]) {               # out of range and works perfectly
#
# OUT OF RANGE HOLIDAY PERIOD
#
my $Daystring8 = "Monday-Tuesday-Wednesday-Thursday-Friday-\n***** OFF week *****\n";
my $Engnames8 = "blah,blah,blah,blah,blah,Merry Xmas";
#
#transform above strings into arrays with a little cleanup.
my @string8 = split('-', $Daystring8);
my @names8  = split(',', $Engnames8);

# my loop execution OUT OF RANGE
open(LOG, ">> $log") or die "cannot create $log $!";
print LOG " \n\n ==== MERRY MERRY CHRISTMAS ==== \n\n\n";
print " \n\n ==== MERRY CHRISTMAS ==== \n\n\n";
#
for( $a = 0; $a < 7; $a = $a + 1 ){
        print LOG "$string8[$a]\n";     # This will print LOG selected field
        print LOG "$names8[$a]\n\n";    # This will print LOG ...
        print "$string8[$a]\n";         # This will print LOG selected field
        print "$names8[$a]\n\n";        # This will print LOG ...

        }
#
send_mail();
#
#
exit
}
#
# END of Main Program
#
#
# sub procedure send_mail
sub send_mail {

        my $mailDir = "/data01/home/cjcadmin/scripts/mailAlert";
        my $sender = 'coffeeRota@cjcit.com';
        my $recipient = 'tugrul.ozbay@cjcit.com';
      # my $recipient = 'tugrul.ozbay@cjcit.com flynn.gardener@cjcit.com brian.daly@cjcit.com paul.kossowski@cjcit.com dave.willis@cjcit.com sam.grayston@cjcit.com ajay.patel@cjcit.com';

        open LOG, "< $log";             # opens my log file
        chomp (my @output = <LOG>);     # cleans my output log
        close LOG;                      # closes it

        my $lineOut = join '<br>', @output;


        system "$mailDir/sendEmail -s smtp:25 -o message-content-type=html -f $sender -t $recipient -u \"Engineering Coffee Time\" -m \"$lineOut\"";



}
#
#
#
#
# ################# END ########################
#
#
# Below is reference
#
# radmin@trhlo4susbd001a# crontab -l
# 30 4 * * 1 /opt/reuters/home/radmin/scripts/mailAlert/dacs_perms/dacs_email.pl >/dev/null
# 30 4 * * * /opt/reuters/home/radmin/scripts/mailAlert/dacs_perms/dom_email.pl >/dev/null
# 30 19 * * * /opt/reuters/home/radmin/scripts/mailAlert/dacs_perms/cache_email.pl >/dev/null
# 00 7-19 * * * /opt/reuters/home/radmin/scripts/mailAlert/dacs_perms/cache2_email.pl >/dev/null
# 0 07-17 * * 1-5 cd /opt/reuters/home/radmin/scripts/mailAlert/usage;./usage_email.pl
# 05,35 7-17 * * 1-5 cd /opt/reuters/home/radmin/scripts/mailAlert/usage;./usage_email.pl
# 44 09 * * 1-5 /opt/reuters/home/radmin/scripts/mailAlert/dacs_perms/coreRota.pl >/dev/null
#
#