#!/usr/bin/perl
# Author        : Tugrul Ozbay CJCit Ltd
# Date             : 28th Sept 2015
# Reason        : Engineering Department Core Rota script
# Version       : 1.1008 Prod
# Strict            : Extremely loving it
# Warnings    : None.
# Comments  : Just designed for 5 Engineers only.
#
#
# Note: A variable is defined by the ($) symbol (scalar),
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
# $week = 52;
#
# print $week;
# Add 1 if today isn't Saturday
if ($wday < 6) {$week +=1;}
# print "This Week is $week\n";
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
my $log = "coreRota.$week.log";     # write out to $log (or LOG)
unlink "$log" if -f "$log";         # removes the log file if exits
#
#
# Tugs testing bits below
print LOG "\n\n $year $wday $yday \n\n";
print LOG "\n\n the day of year is $yday \n\n";
#
if ($week == 1||$week == 6||$week == 11||$week == 16||$week == 21||$week == 26||$week == 31||$week == 36||$week == 41||$week == 46 ||$week == 51) {         # works best [1]
#
# WEEK 1
#
# define my Strings
my $Daystring1 = "Monday-Tuesday-Wednesday-Thursday-Friday-";
my $Engnames1 = "TugO,BrianD,SamG,DaveW,PaulK";
#
# transform above strings into arrays with a little cleanup.
my @string1 = split('-', $Daystring1);
my @names1  = split(',', $Engnames1);
#
#
# my loop execution WEEK 1
open(LOG, ">> $log") or die "cannot create $log $!";
#
print LOG " \n\n ==== THIS WEEK ==== \n\n";
print " \n\n ==== THIS WEEK ==== \n\n";
#
for( $a = 0; $a < 6; $a = $a + 1 ){
    #print LOG "value of a: $a\n";
        print LOG "$string1[$a]\n";  # This will print LOG selected field
        print LOG "$names1[$a]\n\n";   # This will print LOG ...
        print "$string1[$a]\n";  # This will print LOG selected field
        print "$names1[$a]\n\n";   # This will print LOG ...
        }
#
send_mail();

exit
        }
#
#
#
if ($week == 2||$week == 7||$week == 12||$week == 17||$week == 22||$week == 27||$week == 32||$week == 37||$week == 42||$week == 47) {         # works best [2]
#
# WEEK 2
#
my $Daystring2 = "Monday-Tuesday-Wednesday-Thursday-Friday-";
my $Engnames2 = "PaulK,TugO,BrianD,SamG,DaveW";
#
#transform above strings into arrays with a little cleanup.
my @string2 = split('-', $Daystring2);
my @names2  = split(',', $Engnames2);

# my loop execution WEEK 2
open(LOG, ">> $log") or die "cannot create $log $!";
print LOG " \n\n ==== THIS WEEK ==== \n\n\n";
print " \n\n ==== THIS WEEK ==== \n\n\n";
#
for( $a = 0; $a < 6; $a = $a + 1 ){
        print LOG "$string2[$a]\n";  # This will print LOG selected field
        print LOG "$names2[$a]\n\n";   # This will print LOG ...
        print "$string2[$a]\n";  # This will print LOG selected field
        print "$names2[$a]\n\n";   # This will print LOG ...
        }
#
send_mail();
#
exit
        }
#
if ($week == 3||$week == 8||$week == 13||$week == 18||$week == 23||$week == 28||$week == 33||$week == 38||$week == 43 ||$week == 48) {         # works best [3]
#
# if ($week =~ /(3||9||15||21||27||33||39||45||52)/) { # issues
#
#       if ($week =~ /(8||24||6)/) {            # works well
#
#
# WEEK 3
#
my $Daystring3 = "Monday-Tuesday-Wednesday-Thursday-Friday-";
my $Engnames3 = "DaveW,PaulK,TugO,BrianD,SamG";
#
#transform above strings into arrays with a little cleanup.
my @string3 = split('-', $Daystring3);
my @names3  = split(',', $Engnames3);

# my loop execution WEEK 3
open(LOG, ">> $log") or die "cannot create $log $!";
print LOG " \n\n ==== THIS WEEK ==== \n\n\n";
print " \n\n ==== THIS WEEK ==== \n\n\n";
#
for( $a = 0; $a < 6; $a = $a + 1 ){
    #print LOG "value of a: $a\n";
        print LOG "$string3[$a]\n";  # This will print LOG selected field
        print LOG "$names3[$a]\n\n";   # This will print LOG ...
        print "$string3[$a]\n";  # This will print LOG selected field
        print "$names3[$a]\n\n";   # This will print LOG ...

        }
#print LOG "$string3[$a]\n";  # This will print LOG selected field
# print LOG " >>        $names3[$a]     <--- ROTA Week off \n";   # This will print LOG ...
# print  " >>   $names3[$a]     <--- ROTA Week off \n";   # This will print LOG ...
#
send_mail();
#
exit
        }
#
#
if ($week == 4||$week == 9||$week == 14||$week == 19||$week == 24||$week == 29||$week == 34||$week == 39||$week == 44 ||$week == 49) {               # works best [4]
# if ($week =~ /(4||10||16||22||28||34||40||46)/) { # issues
#
#
# WEEK 4
#
my $Daystring4 = "Monday-Tuesday-Wednesday-Thursday-Friday-";
my $Engnames4 = "SamG,DaveW,PaulK,TugO,BrianD";
#
#transform above strings into arrays with a little cleanup.
my @string4 = split('-', $Daystring4);
my @names4  = split(',', $Engnames4);

# my loop execution WEEK 4
open(LOG, ">> $log") or die "cannot create $log $!";
print LOG " \n\n ==== THIS WEEK ==== \n\n\n";
print " \n\n ==== THIS WEEK ==== \n\n\n";
#
for( $a = 0; $a < 6; $a = $a + 1 ){
    #print LOG "value of a: $a\n";
        print LOG "$string4[$a]\n";  # This will print LOG selected field
        print LOG "$names4[$a]\n\n";   # This will print LOG ...
        print "$string4[$a]\n";  # This will print LOG selected field
        print "$names4[$a]\n\n";   # This will print LOG ...

        }
#print LOG "$string4[$a]\n";  # This will print LOG selected field
# print LOG " >>        $names4[$a]     <--- ROTA Week off \n";   # This will print LOG ...
# print " >>    $names4[$a]     <--- ROTA Week off \n";   # This will print LOG ...
#
send_mail();
#
#
exit
        }
#
#
if ($week == 5||$week == 10||$week == 15||$week == 20||$week == 25||$week == 30||$week == 35||$week == 40||$week == 45 ||$week == 50) {            # works best [5]
#
# WEEK 5
#
my $Daystring5 = "Monday-Tuesday-Wednesday-Thursday-Friday-";
my $Engnames5 = "BrianD,SamG,DaveW,PaulK,TugO";
#
#transform above strings into arrays with a little cleanup.
my @string5 = split('-', $Daystring5);
my @names5  = split(',', $Engnames5);

# my loop execution WEEK 5
open(LOG, ">> $log") or die "cannot create $log $!";
print LOG " \n\n ==== THIS WEEK ==== \n\n\n";
print " \n\n ==== THIS WEEK ==== \n\n\n";
#
for( $a = 0; $a < 6; $a = $a + 1 ){
    #print LOG "value of a: $a\n";
        print LOG "$string5[$a]\n";  # This will print LOG selected field
        print LOG "$names5[$a]\n\n";   # This will print LOG ...
        print "$string5[$a]\n";  # This will print LOG selected field
        print "$names5[$a]\n\n";   # This will print LOG ...

        }
#print LOG "$string5[$a]\n";  # This will print LOG selected field
# print LOG "   >>      $names5[$a]     <--- ROTA Week off \n";   # This will print LOG ...
# print "       >>      $names5[$a]     <--- ROTA Week off \n";   # This will print LOG ...
#
send_mail();
#
#
exit
        }
#
#
#
# OUT OF RANGE
#
#
if ($week => [52..999]) {               # out of range and works perfectly
#
# OUT OF RANGE HOLIDAY PERIOD
#
my $Daystring7 = "Monday-Tuesday-Wednesday-Thursday-Friday-";
my $Engnames7 = "***,***,Merry Xmas,***,***";
#
#transform above strings into arrays with a little cleanup.
my @string7 = split('-', $Daystring7);
my @names7  = split(',', $Engnames7);

# my loop execution OUT OF RANGE
open(LOG, ">> $log") or die "cannot create $log $!";
print LOG " \n\n ==== MERRY MERRY CHRISTMAS ==== \n\n\n";
print " \n\n ==== MERRY CHRISTMAS ==== \n\n\n";
#
for( $a = 0; $a < 6; $a = $a + 1 ){
    #print LOG "value of a: $a\n";
        print LOG "$string7[$a]\n";     # This will print LOG selected field
        print LOG "$names7[$a]\n\n";    # This will print LOG ...
        print "$string7[$a]\n";         # This will print LOG selected field
        print "$names7[$a]\n\n";        # This will print LOG ...

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
        my $sender = 'coreRota@cjcit.com';
          #  my $recipient = 'tugrul.ozbay@cjcit.com';
        my $recipient = 'tugrul.ozbay@cjcit.com brian.daly@cjcit.com paul.kossowski@cjcit.com dave.willis@cjcit.com sam.grayston@cjcit.com';
          # my $recipient = 'tugrul.ozbay@cjcit.com flynn.gardener@cjcit.com brian.daly@cjcit.com paul.kossowski@cjcit.com dave.willis@cjcit.com sam.grayston@cjcit.com';

        open LOG, "< $log";             # opens my log file
        chomp (my @output = <LOG>);     # cleans my output log
        close LOG;                      # closes it

        my $lineOut = join '<br>', @output;


        system "$mailDir/sendEmail -s smtp:25 -o message-content-type=html -f $sender -t $recipient -u \"Engineering Core Rota\" -m \"$lineOut\"";



}
#
#
#
# ################# END ########################
