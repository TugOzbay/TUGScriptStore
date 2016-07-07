#!/usr/bin/perl
#
#
use strict;
use warnings;

while (1 != 2) 
{
print "Enter numerical value for Diameter : ";
my $input = (<STDIN>);

if (is_a_number($input) == 1..3) 
    {
	do_pi($input);
    } 
else 
   {
	print "$input is not a true number!. Try again\n";
	my $dummy = (<STDIN>);
   }
}

## Work out pi and print
sub do_pi
{

	use Math::Trig;

	print "Pi = ", ($_[0]*pi), "\n";
	print "Press any key!\n";
	my $dummy = (<STDIN>);

}
##End do_pi


##Work ot if input is a number

sub is_a_number 
{ 
	##Is input a whole number
	return 1 if $_[0] =~ /^\d+$/;

	##Is number input a integer
	return 2 if $_[0] =~ /^[+-]?\d+$/;

	##Is number a float
	return 3 if $_[0] =~ /^[+-]?\d+\.?\d*$/;
}
##End is_a_number
