#!/usr/bin/perl
# Author        : Tugrul Ozbay
# Date          : 4th April 2014
# Reason        : search/replace script (replaces Tug with tugrules in test*.txt)
# Version       : 0.1
# Strict        : Suppose so
# Warnings      : None.
#
#
use strict;
#  
  my @infiles = glob("test*.txt");
  
  my $search ='Tug';
  my $replace ='tugrules';
  
  # for do loops
  
  foreach my $file (@infiles){
    print "Processing my \$file : $file
";
    open(FH,$file) || die "Cannot load the \$file : $file";
    my @lines=<FH>;
    close(FH);
    my $match=0;
	#
	#
   foreach my $line (@lines){
      if($line =~ s/$search/$replace/g){
        $match=1;
      }
    }
  #
  #
    if($match){
      print "...Saving \$file : $file \n";
      open(FS,">$file") || die "Cannot save \$file: $file ";
      print FS @lines;
      close(FS);
    }
  } 
  