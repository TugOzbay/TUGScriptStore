#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 31st Jan 2014
# Reason        : Practical day 3 in flynns document
# Version       : 1.0
# Strict        : Suppose so
# Warnings      : None.
#
use strict;
use warnings;
#
#
#
#
# ===================================================================================
# 
#   MATHEMATICS  (General Operators)
# 
# ===================================================================================
#
# defaults below :-
# my $number1 = 3;
# my $numberz = 5;

my $number1 = 5;
my $numberz = 10;



print " This bit is in speech marks \n";
print " ------------------------------------ \n";
print " \n";
print ($number1 + $numberz);					#Addition    		Result 8 or   15
print " \n";
print ($number1 - $numberz);					#Subtraction    	Result -2 or  -5
print " \n";
print ($number1 * $numberz);					#Multiplication    	Result 15  or  50
print " \n";
print ($number1 / $numberz);					#Division    		Result  0.6  or  0.5
print " \n";
print ($number1 % $numberz);					#Modulus     		Result  3  or  5
print " \n";
print (($number1 * $numberz)*$numberz);   		#Complex    		Result 75  or  500
print " \n";
print " ------------------------------------ \n";

#
# DO's and DONT'S
#
# Supply header information.
# use strict.
# Use loop indentation.
# Write clean concise code.
# Comment often.
# If possible work out the parameters for your program.
#
#
