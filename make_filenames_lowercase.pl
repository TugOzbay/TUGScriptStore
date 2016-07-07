#!/usr/local/bin/perl -w
# Author        : Tugrul Ozbay
# Date          : 4th April 2014
# Reason        : Making filenames lowercase
# Version       : 0.1
# Strict        : Suppose so
# Warnings      : None.
#
    if(!@ARGV){
        print "Will make *.GIF/JPG to lowercase\n";
        exit 0;
    }
    while($x = <'*.GIF'>) {
        $tt =lc $x;
        `mv $x $tt`;
    }

    while($x = <'*.JPG'>) {
        $tt =lc $x;
        `mv $x $tt`;
    }
