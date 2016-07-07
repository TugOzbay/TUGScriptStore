#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 10th Feb 2013
# Reason        : interrogating the /proc/cpuinfo file 
# Version       : 0.1
# Strict        : Suppose so
# Warnings      : None.
#
use strict;
use warnings;
#
#
print "Please enter the name of the file\n";
my $c = <STDIN>;

open(NEW,$c) or die "The file cannot be opened";

my @d = <NEW>;
chomp @d;
my $e;
my $f;


print "Please enter the value within CPU you want to see\n";
my $aa = <STDIN>;

print "Please enter another value to see \n";
my $bb = <STDIN>;

chomp $aa;
chomp $bb;

my $pattern_a = quotemeta $aa;
my $pattern_b = quotemeta $bb;

foreach (@d){

    if ($_ =~ /$pattern_a/){
        $e = $aa;
    }
    elsif ($_ =~ /$pattern_b/){
        $f = $bb;
    }
}

close(NEW);


unless ($e){
    print "First value not mentionend\n";
}
unless ($f){
    print "Second value not mentioned\n";
}