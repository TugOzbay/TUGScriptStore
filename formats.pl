#!/usr/bin/perl
# Author        : Tugrul Ozbay 
# Date          : 24th Feb 2014
# Reason        : Formatting in perl 
# Version       : 1.0
# Strict        : Suppose so
# Warnings      : None.
#
#
#
use strict;
use warnings;
#
# =========================================================
# VARIABLES SECTION
# =========================================================
# my $clear = `clear`;                                                    # clear in unix
my $clear    = `cls`;
print $clear;                                                 # clear in windows
#
# =========================================================
# FIRST SECTION
# =========================================================
#
print "content-type: text/html \n\n"; #HTTP HEADER

# DEFINE SOME STRINGS
my $single = 'This string is Single quoted';
my $double = "This string is Double quoted";
my $userdefined = q^Carrot is now our quote^;

# PRINT THEM TO THE BROWSER
print $single."<br />";
print $double."<br />";
print $userdefined."<br />";


# =========================================================
# SECOND SECTION
# =========================================================
#
print "content-type: text/html \n\n"; #HTTP HEADER

# STRINGS TO BE FORMATTED
my $mystring = "welcome to tug.com!"; #String to be formatted
my $newline = "welcome to \tug.com!";
my $capital = "\uwelcome to tug.com!";
my $ALLCAPS = "\Uwelcome to tug.com!";

# PRINT THE NEWLY FORMATTED STRINGS
print $mystring."<br />";
print $newline."<br />";
print $capital."<br />";
print $ALLCAPS;

# =========================================================
# THIRD SECTION
# =========================================================
#
# DEFINE A STRING TO REPLACE
$mystring = "Hello, am I about to be manipulated?!";

# PRINT THE ORIGINAL STRING
print "Original String: $mystring<br />";

# STORE A SUB STRING OF $mystring, OFFSET OF 7
my $substringoffset = substr($mystring, 7);
print "Offset of 7: $substringoffset<br />";



