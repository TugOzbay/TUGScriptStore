#!/usr/bin/perl
# Author        : Tugrul Ozbay CJCit Ltd
# Date          : 23rd June 2014 (day 173)
# Reason        : Engineering Dept. Coffee Rota
# Version       : 1
# Strict        : Extremely
# Warnings      : None.
#
#
# Note: A variable is defined by the ($) symbol (scalar), 
#       the (@) symbol (arrays), or the (%) symbol (hashes). 
#

use strict;
use warnings;

use Path::Class;
my $dir = dir('foo','bar'); # foo/bar

# Iterate over the content of foo/bar
while (my $file = $dir->next) {

   # See if it is a directory and skip
    next if $file->is_dir();

   # Print out the file name and path
    print $file->stringify . "\n";

}
