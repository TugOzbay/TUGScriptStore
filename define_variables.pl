#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 25th Feb 2014
# Reason        : playing definition of variables "types"
# Version       : 1.1
# Strict        : Suppose so
# Warnings      : None.
#
# Note: A variable is defined by the ($) symbol (scalar), 
#       the (@) symbol (arrays), or the (%) symbol (hashes). 
#
use strict;
use warnings;
#
# =========================================================
# PRINT the CURRENT DATE via normal variable
# =========================================================
#
# my $timeData = localtime(time);
# print "$timeData \n\n\n";
#
#
# =========================================================
# PRINT the CURRENT DATE via an ARRAY
# =========================================================
# 
my $timeData = localtime(time);
# print "$timeData \n\n\n";
#
my @timeDataArray = split (' ', $timeData);  
#
foreach my $time_bit (@timeDataArray) 
{                		# for each of my $words within the @words array print each content.
    print " A. DATE/Time :=> foreach time_bit loop : $time_bit \n\n";
}
#
my @onlyTime = split ( ':' ,$timeDataArray[3]);
foreach my $justTimeSplit (@onlyTime)
{
	print "\n B. TIME ONLY :=> foreach bit of the time slice only (hr/min/sec):-> $justTimeSplit : \n"
}
#
#
print " \n\n\n";
print " All words in timeDataArray		: @timeDataArray \n";        			# print the whole array @words
#
print " Second word within timeDataArray	: $timeDataArray[1] \n";    		# print the slot [1] which is the second word in the @word array
print " Forth word within timeDataArray	: $timeDataArray[3] \n";    			# print the slot [3] which is the forth word in the @word array
print " Fifth word within timeDataArray (year)	: $timeDataArray[4] \n\n\n ";   # print the slot [4] which is the fifth word in the @word array for year
#
#
#
# 
#
#########################################################
#
# DEFINE VARIABLE TYPES
#
########################################################
#
# Playtime
#
my $somenumber = 4;
my $myname = "Tugrul Ozbay";
my @array = ("10","10","1970");
my %hash = ("Quarter", 25, "Dime", 10, "Nickle", 5);		# for my $keys section below prints it
## OR ##
my $somenumber2 = 40;
my $myname2 = "Tug Ozbay";
my @array2 = ("20", "10", "1973");
my %hash2 = ("Quid", 1.00, "Ta Pence", 10, "Shilling", 5);
#
#
#########################################################
#
# PRINT VARIABLE TYPES
#
########################################################
#
print "PRINTING VARIABLE TYPES \n";
print " 1. This is some number : $somenumber  OR,  .. $somenumber2 \n";
print "    This is my name : $myname  OR, .. $myname2 \n";
print "    This is my array variable : @array  OR, .. @array2 \n\n\n";
#
# %hash
for my $key (keys %hash)										# designed to print the %hash key and value pair.
{ 
	my $value = $hash{$key};
	print "       1a.  HASH: This is my hash variable : $key -===>>> $value \n\n";	# prints each key and value pairs within the hash value %hash
}
# %hash2
for my $key (keys %hash2)										# designed to print the %hash key and value pair.
{ 
	my $value = $hash2{$key};
	print "       1a.  HASH2: This is my hash2 variable : $key -===--===>>> $value \n\n";	# prints each key and value pairs within the hash value %hash2
}
#
#
#
########################################################
# 
# DEFINE SOME SCALAR VARIABLES
#
########################################################
#
my $number = 5;
my $exponent = "2 ** 8";
my $string = "Hello, Perl! - This is Tug on the case now! ";
my $stringpart_1 = "Hello, Do not fear Tug is here";
my $stringpart_2 = "....Perl! is King once you get to know it";
#
#
# PRINT THEM TO THE BROWSER
#
print " PRINTING SCALAR VARIABLE TYPES \n";
print " 2. Print number : $number \n" ;
print "    print exponent : $exponent \n";
print "    print string: $string \n";
print "    print string part 1, then part 2 : $stringpart_1.$stringpart_2 \n\n\n";
#
#
########################################################
# 
# DEFINE SOME ARRAYS
#
########################################################
#
#
#DEFINE SOME ARRAYS
# 
my @days = ("Monday", "Tuesday", "Wednesday");
my @months = ("April", "May", "June");
#
#
#PRINT MY ARRAYS TO THE BROWSER
#
print "  PRINTING MY ARRAYS \n";
print "3. Printing the array for days : @days \n";
print "   printing the array for months : @months \n";
#
########################################################
