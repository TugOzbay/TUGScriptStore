#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 29th Jan 2014
# Reason        : Reading Flynns perl 2nd doc pg.19  FOR/WHILE LOOPS
# Version       : 1.0
# Strict        : Suppose so
# Warnings      : None.
#
use strict;
use warnings;
#
#
print "\n";
print "\n";
print " -------------------------------------------------------\n";
print " Remember that this is string character 65 : ",chr(65),"\n";		# remember 65 is A.
print "\n";
print " * * *          Name : ",chr(84),chr(85),chr(71),"         * * * \n";
print "\n";
print " -------------------------------------------------------\n";
#
# ==========================================
# PRINT the CURRENT DATE 
# ==========================================
# 
my $timeData = localtime(time);
print $timeData;
#
# ==========================================
# MKDIR 
# ==========================================
#
mkdir "./testdir" if ! -d "./testdir";		# makes a ./testdir if it doesn't exist already (works)
#
#
# ==========================================
#  FOR LOOPS
# ==========================================
#
for (my $loop = 0; $loop <=10; $loop++)
	{
	print "$loop \n";
	}
	
foreach my $number (1..10)		# from 1 to 10 print the numbers (can do 100s 1000s etc)
	{
	print "$number \n";
	}
#
#
# ==========================================
#  WHILE LOOPS
# ==========================================
#
my @names = qw(Jack Celine Irem Bill bob steve Tim Jen Tug);
while (@names)
	{
	my $element = pop @names;
	print $element,"\n";
	}
#
# ==========================================
# UNTIL LOOP
# ==========================================
#
my $line;
until ($line = <STDIN>)
	{
	print "I am inside the main block\n";
	}
continue
	{
		print "I am inside the continue block\n";
	}
chomp $line;
print "I typed: $line\n";
#
# ==========================================
# SUBROUTINES
# ==========================================
#
sub tugroutine
{
	print " not a very interesting routine called tugroutine...\n";
	print " But, boring enough it does the same thing every time\n";
}
#
# regardless of any parameters that we may want to pass to it. 
# All of the following will work to call this subroutine. 
# Notice that a subroutine is called with an & character in front of the name:

&tugroutine; 			# Calls my subroutine 
&tugroutine($_); 		# Calls it with a parameter 
tugroutine(1+2, $_); 	# Calls it with two parameters
#
#
#
# ==========================================
# DEEPER SUBROUTINES with WHILE
# ==========================================
#
while (1!=2)
	{
	print "Enter the numerical value for Diameter : ";
	my $input = (<STDIN>);
	
	if (is_a_number ($input) ==1..3)
		{
			do_pi($input);
		}
		else
		{
		print " input is not a true number! try again pezo\n";
		my $dummy = (<STDIN>);
		}
	}
#
#
# Work out the pi and print it
#
my $dummy;
#
	sub do_pi 								# Start of do_pi subroutine
	{
		use Math::Trig;
		
		print "Pi = ",($_[0] * pi),"\n";
		print "Press any key!\n";
		print $dummy = (<STDIN>);
	} 										# End of do_pi subroutine
#
# Now we work out if it is a number
#
sub is_a_number 					## Start of subroutine   is_a_number
	{
		## check if the number is a whole number
		return 1 
		if $_[0] =~/^\d+$/;
		
		## check if the number is an integer
		return 2
		if $_[0] =~/^[+-]?\d+$/;
		
		## is the number a float
		return 3
		if $_[0] =~/^[+-]?\d+\.?\d*$/; 
	}								## End of subroutine   is_a_number