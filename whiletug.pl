use strict;
use warnings;
#
my $time = localtime(time);
print $time;
#

my @names = qw(Dan Jan Tug Jen);
while (@names) 
  {
	my $element = pop @names;
	print $element,“\n”;
  }