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
use autodie; # die if problem reading or writing a file

my $dir = dir("/tmp"); # /tmp
my $file = $dir->file("file.txt");

# Read in the entire contents of a file
my $content = $file->slurp();

# openr() returns an IO::File object to read from
my $file_handle = $file->openr();

# Read in line at a time
while( my $line = $file_handle->getline() ) {

        print $line;

}
