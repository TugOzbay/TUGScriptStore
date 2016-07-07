#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 24th Mar 2014
# Reason        : file_compare.pl script
# Version       : 0.1
# Strict        : Suppose so
# Warnings      : None.
#
#
#
# use strict;
# use warnings;
# use &main::grepp;
use File::Compare;
use Text::ParseWords;
#
# =========================================================
# PRINT the CURRENT DATE
# =========================================================
#
my $timeData = localtime(time);
print "\n\n  $timeData  \n\n\n";
#
#
 printf " The current perl version is v%vd\n", $^V;     # Perl's version
# 
#
#
# =========================================================
# VARIABLES SECTION
# =========================================================
# my $clear = `clear`;                                 # clear in unix
my $clear    = `cls`;                                  # clear in windows
#
print "$clear \n\n ";
#
# 
# Logging to File
#
my $log = "fileCOMP.log";          # write out to $log (or LOG)
unlink "$log" if -f "$log";          # removes the log file if exits
#
#
# my $read1 = 'f1.txt';              # read in from $read1
# my $read2 = 'f2.txt';
#
   print " \n\n\n";
   print " \n\n\n We are about to compare two files \n\n\n\n\n ";
   #
   print " 1. Enter your FIRST FILE :   ";
   chomp (my $read1 = (<STDIN>));
   #
   print " 1. Enter your SECOND FILE : ";
   chomp (my $read2 = (<STDIN>));
#        
# print "hello\n";
if (compare("$read1","$read2") == 0) {
	print "\n\n ** Both these files are equal - we will quit here ** \n\n";
	exit
	}
##	else
##	{
##		compare_text ($read1,$read2)
		#compare_text ("$read1","$read2", sub {$_[0] ne $_[1]} )
##	}
#}

#
# =========================================================
# OUTPUT OF FILE1 & FILE2 & SCREEN SECTION
# =========================================================
#
#
#
open (READ1, "<$read1") or die "Cannot open it - does $read1 exist ?: $!";       #"READ1" is File Handle
open (READ2, "<$read2") or die "Cannot open it - does $read2 exist ?: $!";       #"READ2" is File Handle
##
## Put the read1 and 2 into a big array
##
chomp (my @read1 = <READ1>);	# clear up array @read1
@read1 = grep ! /^$/, @read1;	# ignore the blank lines
@read1 = grep ! /^!/, @read1;	# ignore the hased out or remarked lines
## 
chomp (my @read2 = <READ2>);	# clear up array @read2
@read2 = grep ! /^$/, @read2;	# ignore the blank lines
@read2 = grep ! /^!/, @read2;	# ignore the hased out or remarked lines
my (%hash1, %hash2); 			# create two Hashs with key values
##
close READ1; close READ2;		# close files
##
##
## @read1 =~ s{\Q@read1\E}{@read1};
##
##
# My @testarray = grep /bindMainThread/, @read1;
foreach my $value (@read1){		# for each of my values in array read1
	$hash1{$value} = 0;			# set hash value as zero 0.
	
} 
#
foreach my $value (@read2){		# for each of my values in array read2
	$hash2{$value} = 0;			# set hash values to zero 0.
	
} 
#
my @differ1 = grep { !defined $hash1{$_} } @read2;
my @differ2 = grep { !defined $hash2{$_} } @read1;
#
print "\n\n\n";
print LOG "\n\n\n";
# print "$_\n" for @differ1 ;
# print "$_\n" for @differ2 ;
#
print " ** Note: If the stats below show a blank its because contents are same ** \n\n";
#
open(LOG, ">> $log") or die "cannot create $log $!";
#
print " ** Comparing $read1 contents to $read2 ** \n";
print " ** ------------------------------------------------------------------------** \n\n";
print LOG " ** Comparing $read1 contents to $read2 ** \n";
print LOG " ** ------------------------------------------------------------------------** \n\n";
#
#
#
#
#
#
#
for  (my $loop = 0; $loop <= $#read1; $loop++) {		# loop to check differences

	if ($read1[$loop] ne $read2[$loop]){
		$grepread1 = grep ( ! /$read1[$loop]/, $read2[$loop] ) 
		if $grepread1 = 0;
		# print "grepREAD1 $grepread1 ";
		{
	
	printf "f1: $read1[$loop] \b  <= | =>  \b  f2: $read2[$loop]\n ";
	printf LOG "f1: $read1[$loop] \b  |  \b  f2: $read2[$loop]\n ";	
	# printf "$read1: $read1[$loop] \b  |  \b  $read2: $read2[$loop]\n ";
	# printf "$read1: $read1[$loop]  \t  |  \t  $read2: $read2[$loop]\n ";
	# print "sec $read1[$loop]\n";
		}
	}

}
#
print "\n\n\n";
print LOG "\n\n\n";
print " ** Comparing $read2 contents to $read1 ** \n";
print " ** ------------------------------------------------------------------------** \n\n";
print LOG " ** Comparing $read2 contents to $read1 ** \n";
print LOG " ** ------------------------------------------------------------------------** \n\n";
#
for  (my $loop = 0; $loop <= $#read2; $loop++) {		# loop to check differences

	if ($read2[$loop] ne $read1[$loop]) {
	$grepread2 = grep ( ! /$read2[$loop]/, $read1[$loop] ) 
		if $grepread2 = 0;
		# print "grepREAD2 $grepread2 ";
		{
		printf "f1: $read2[$loop] \b  <= | =>  \b  f2: $read1[$loop]\n ";
		printf LOG "f1: $read2[$loop] \b   |   \b  f2: $read1[$loop]\n ";
		# printf "$read2: $read2[$loop] \b  |  \b  $read1: $read1[$loop]\n ";
		# print "$read2: $read2[$loop]  \t  |  \t  $read1: $read1[$loop]\n ";
		}
	}

}

## END
