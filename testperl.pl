#!/usr/bin/perl
# Author        : Tugrul Ozbay CJCit Ltd
# Date          : 23rd June 2014 (was day 173)
# Reason        : Engineering Department Coffee Rota script
# Version       : 1.0002
# Strict        : Extremely loving it
# Warnings      : None.
#
#
# Note: A variable is defined by the ($) symbol (scalar), 
#       the (@) symbol (arrays), or the (%) symbol (hashes). 
#
use strict;
use warnings;
#
my $clear = `cls`;    # clear the crap in unix
#print LOG $clear;
#
#
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
#
my $timeData = localtime(time);
#print LOG " \n\n FULL DATE :  $timeData \n\n\n";
print " \n\n FULL DATE :  $timeData \n\n\n";
my @timeDataArray = split (' ', $timeData);  
#
my @onlyDay = split ( ':' ,$timeDataArray[0]);
foreach my $justDaySplit (@onlyDay)
{
	print "\n TODAY :=> -> $justDaySplit [$yday] \n\n"
}
#
# Logging to File
#
my $log = "coffeeRota.${yday}.log";     # write out to $log (or LOG)
unlink "$log" if -f "$log";          	# removes the log file if exits
#
#
# Tugs testing bits below
# print LOG "\n\n $year $wday $yday \n\n";
# print LOG "\n\n the day of year is $yday \n\n";
#
if (${yday} < [1..7]||[43..50]||[86..93]||[128..134]||[170..176]||[212..218]||[254..260]||[296..302]||[338..344]) {
#
# WEEK 1
#
# define my Strings
my $Daystring1 = "Monday-Tuesday-Wednesday-Thursday-Friday";
my $Engnames1 = "DaveW,PaulK,TugO,BrianD,SamG,FlynnG";

# transform above strings into arrays with a little cleanup.
my @string1 = split('-', $Daystring1);
my @names1  = split(',', $Engnames1);
#
#
# my loop execution WEEK 1
open(LOG, ">> $log") or die "cannot create $log $!";
#
print LOG " \n\n ==== WEEK 1 ==== \n\n";
print " \n\n ==== WEEK 1 ==== \n\n";
#
for( $a = 0; $a < 5; $a = $a + 1 ){
    #print LOG "value of a: $a\n";
	print LOG "$string1[$a]\n";  # This will print LOG selected field
	print LOG "$names1[$a]\n\n";   # This will print LOG ...	
	print "$string1[$a]\n";  # This will print LOG selected field
	print "$names1[$a]\n\n";   # This will print LOG ...	
	}
#print LOG "$string1[$a]\n";  # This will print LOG selected field
print LOG " >>  $names1[$a]	<--- ROTA Week off \n";   # This will print LOG ...
print " >>  $names1[$a]	<--- ROTA Week off \n";   # This will print LOG ...
#
exit
	}
#

if (${yday} < [8..14]||[51..57]||[94..101]||[135..141]||[177..183]||[219..225]||[261..267]||[303..309]||[345..351]) {
# WEEK 2
#
my $Daystring2 = "Monday-Tuesday-Wednesday-Thursday-Friday";
my $Engnames2 = "FlynnG,DaveW,PaulK,TugO,BrianD,SamG";
#
#transform above strings into arrays with a little cleanup.
my @string2 = split('-', $Daystring2);
my @names2  = split(',', $Engnames2);

# my loop execution WEEK 2
print LOG " \n\n ==== WEEK 2 ==== \n\n\n";
print " \n\n ==== WEEK 2 ==== \n\n\n";
#
for( $a = 0; $a < 5; $a = $a + 1 ){
    #print LOG "value of a: $a\n";
	print LOG "$string2[$a]\n";  # This will print LOG selected field
	print LOG "$names2[$a]\n\n";   # This will print LOG ...
	print "$string2[$a]\n";  # This will print LOG selected field
	print "$names2[$a]\n\n";   # This will print LOG ...
	}
#print LOG "$string2[$a]\n";  # This will print LOG selected field
print LOG "	>>	$names2[$a]	<--- ROTA Week off \n";   # This will print LOG ...
print  " >>	$names2[$a]	<--- ROTA Week off \n";   # This will print LOG ...

#
exit
	}
#
#
if (${yday} < [15..21]||[58..64]||[102..107]||[142..148]||[184..190]||[226..232]||[268..274]||[310..316]||[352..358]) {
#
# WEEK 3
#
my $Daystring3 = "Monday-Tuesday-Wednesday-Thursday-Friday";
my $Engnames3 = "SamG,FlynnG,DaveW,PaulK,TugO,BrianD";
#
#transform above strings into arrays with a little cleanup.
my @string3 = split('-', $Daystring3);
my @names3  = split(',', $Engnames3);

# my loop execution WEEK 3
print LOG " \n\n ==== WEEK 3 ==== \n\n\n";
print " \n\n ==== WEEK 3 ==== \n\n\n";
#
for( $a = 0; $a < 5; $a = $a + 1 ){
    #print LOG "value of a: $a\n";
	print LOG "$string3[$a]\n";  # This will print LOG selected field
	print LOG "$names3[$a]\n\n";   # This will print LOG ...
	print "$string3[$a]\n";  # This will print LOG selected field
	print "$names3[$a]\n\n";   # This will print LOG ...

	}
#print LOG "$string3[$a]\n";  # This will print LOG selected field
print LOG " >>	$names3[$a]	<--- ROTA Week off \n";   # This will print LOG ...
print  " >>	$names3[$a]	<--- ROTA Week off \n";   # This will print LOG ...
#
exit
	}
#
#
if (${yday} < [22..28]||[65..71]||[108..114]||[149..155]||[191..197]||[233..239]||[275..281]||[317..323]||[359..365]) {
#
# WEEK 4
#
my $Daystring4 = "Monday-Tuesday-Wednesday-Thursday-Friday";
my $Engnames4 = "BrianD,SamG,FlynnG,DaveW,PaulK,TugO";
#
#transform above strings into arrays with a little cleanup.
my @string4 = split('-', $Daystring4);
my @names4  = split(',', $Engnames4);

# my loop execution WEEK 4
print LOG " \n\n ==== WEEK 4 ==== \n\n\n";
print " \n\n ==== WEEK 4 ==== \n\n\n";
#
for( $a = 0; $a < 5; $a = $a + 1 ){
    #print LOG "value of a: $a\n";
	print LOG "$string4[$a]\n";  # This will print LOG selected field
	print LOG "$names4[$a]\n\n";   # This will print LOG ...
	print "$string4[$a]\n";  # This will print LOG selected field
	print "$names4[$a]\n\n";   # This will print LOG ...

	}
#print LOG "$string4[$a]\n";  # This will print LOG selected field
print LOG " >>	$names4[$a]	<--- ROTA Week off \n";   # This will print LOG ...
print " >>	$names4[$a]	<--- ROTA Week off \n";   # This will print LOG ...
#
#
exit
	}
#
#
if (${yday} < [29..35]||[72..78]||[115..121]||[156..162]||[198..204]||[240..246]||[282..288]||[324..330]||[366..367]) {
#
# WEEK 5
#
my $Daystring5 = "Monday-Tuesday-Wednesday-Thursday-Friday";
my $Engnames5 = "TugO,BrianD,SamG,FlynnG,DaveW,PaulK";
#
#transform above strings into arrays with a little cleanup.
my @string5 = split('-', $Daystring5);
my @names5  = split(',', $Engnames5);

# my loop execution WEEK 5
print LOG " \n\n ==== WEEK 5 ==== \n\n\n";
print " \n\n ==== WEEK 5 ==== \n\n\n";
#
for( $a = 0; $a < 5; $a = $a + 1 ){
    #print LOG "value of a: $a\n";
	print LOG "$string5[$a]\n";  # This will print LOG selected field
	print LOG "$names5[$a]\n\n";   # This will print LOG ...
	print "$string5[$a]\n";  # This will print LOG selected field
	print "$names5[$a]\n\n";   # This will print LOG ...

	}
#print LOG "$string5[$a]\n";  # This will print LOG selected field
print LOG "	>>	$names5[$a]	<--- ROTA Week off \n";   # This will print LOG ...
print "	>>	$names5[$a]	<--- ROTA Week off \n";   # This will print LOG ...
#
#
exit
	}
#
#	
if (${yday} < [36..42]||[79..85]||[121..127]||[163..169]||[205..211]||[247..253]||[289..295]||[331..337]) {	
#
# WEEK 6
#
my $Daystring6 = "Monday-Tuesday-Wednesday-Thursday-Friday";
my $Engnames6 = "PaulK,TugO,BrianD,SamG,FlynnG,DaveW";
#
#transform above strings into arrays with a little cleanup.
my @string6 = split('-', $Daystring6);
my @names6  = split(',', $Engnames6);

# my loop execution WEEK 6
print LOG " \n\n ==== WEEK 6 ==== \n\n\n";
print " \n\n ==== WEEK 6 ==== \n\n\n";
#
for( $a = 0; $a < 5; $a = $a + 1 ){
    #print LOG "value of a: $a\n";
	print LOG "$string6[$a]\n";  # This will print LOG selected field
	print LOG "$names6[$a]\n\n";   # This will print LOG ...
	print "$string6[$a]\n";  # This will print LOG selected field
	print "$names6[$a]\n\n";   # This will print LOG ...

	}
#print LOG "$string6[$a]\n";  # This will print LOG selected field
print LOG "	>>	$names6[$a]	<--- ROTA Week off \n";   # This will print LOG ...
print "	>>	$names6[$a]	<--- ROTA Week off \n";   # This will print LOG ...
#
#
#
exit
}
#
#
# OUT OF RANGE
#
#
if (${yday} = [367..999]) {	# out of range and test
#
# OUT OF RANGE
#
my $Daystring7 = "Monday-Tuesday-Wednesday-Thursday-Friday";
my $Engnames7 = "blah,blah,blah,blah,blah,blah";
#
#transform above strings into arrays with a little cleanup.
my @string7 = split('-', $Daystring7);
my @names7  = split(',', $Engnames7);

# my loop execution OUT OF RANGE
print LOG " \n\n ==== OUT OF RANGE ==== \n\n\n";
print " \n\n ==== OUT OF RANGE ==== \n\n\n";
#
for( $a = 0; $a < 5; $a = $a + 1 ){
    #print LOG "value of a: $a\n";
	print LOG "$string7[$a]\n";  	# This will print LOG selected field
	print LOG "$names7[$a]\n\n";   	# This will print LOG ...
	print "$string7[$a]\n";  	# This will print LOG selected field
	print "$names7[$a]\n\n";   	# This will print LOG ...

	}
#print LOG "$string7[$a]\n";  # This will print LOG selected field
print LOG "	>>	$names7[$a]	<--- ROTA Week off \n";   # This will print LOG ...
print "	>>	$names7[$a]	<--- ROTA Week off \n";   # This will print LOG ...
#
#
exit
}
#	
# END