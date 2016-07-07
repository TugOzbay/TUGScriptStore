#!/usr/bin/perl
# Author        : Tugrul Ozbay 
# Date          : 24th Feb 2014
# Reason        : conversion script
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
my $clear    = `cls`;                                                 # clear in windows
#
print $clear;
#  
use Data::Dumper;   
  
my $input_dir  = "./";   
my $output_dir = "./";   
my $log_dir    = "./";   
  
my $str_to_replace = "Tug Oz";   
my $str_replace_with = "TUGRUL OZBAY";   
  
my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst);   
  
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);   
 $sec  = sprintf("%02d",$sec);   
 $min  = sprintf("%02d",$min);   
 $hour = sprintf("%02d",$hour);   
 $mday = sprintf("%02d",$mday);   
 $mon  = sprintf("%02d",$mon+1);   
 $year = sprintf("%04d",$year+1900);   
  
my $output_tag = $mday .'_'. $mon .'_'. $year .'_'. $hour .'_'. $min;   
  
opendir(IN_DIR, $input_dir)   or die $!;   
opendir(OUT_DIR, $output_dir) or die $!;   
opendir(LOG_DIR, $log_dir)    or die $!;   
  
open (LOG_FILE, ">> $log_dir $output_tag");   
  
print LOG_FILE "------------- START ------------ \n";   
  
#print LOG_FILE "Started Copying Files from Source: $srcdir   to Destination: $dest \n";   
#my $cmd = "cp -R $srcdir/* $dest/";   
#`$cmd`; #or die "Chk the command : " . $cmd;   
#print LOG_FILE "Finished Copying Files from Source: $srcdir   to Destination: $dest \n";   
  
my (%files_changed, %files_not_changed, @invalid_list_files);   
  
while (my $file = readdir(IN_DIR)) {   
  
    # Ignore if it is not file    
    unless (-f "$input_dir$file") {   
       print LOG_FILE "-W- Not a File, Ignoring : " . $file . "\n";   
       next;   
    }   
  
    print LOG_FILE "\n\nFile Name : " . $file . "\n";   
  
    open(IN_FILE, "<$input_dir$file") || warn "Cant open file for reading: " . "$input_dir$file";   
    my @lines = <IN_FILE>;   
    close(IN_FILE);   
  
    my @newlines;   
    foreach my $each_line (@lines) {   
        #chomp $each_line;   
        if($each_line =~ /$str_to_replace/) {   
            print LOG_FILE "Converting String From : " . $each_line;   
            $each_line =~ s/$str_to_replace/$str_replace_with/ig;   
            print LOG_FILE "Converting String To   : " . $each_line;   
            push(@newlines, $each_line);   
            $files_changed{$file} = 1;   
        } else {   
            push(@newlines, $each_line);   
            $files_not_changed{$file} = 1;   
        }      
    }   
  
    open(OUT_FILE, ">$output_dir$file") || warn "-W- Cant open file for writing: " . "$output_dir$file";   
    print OUT_FILE @newlines;   
    close(OUT_FILE);   
}   
  
my @f_changed     = keys %files_changed;   
my @f_not_changed = keys %files_not_changed;   
  
print LOG_FILE "\n\nOutput Summary as below ------------------------- : ";   
  
print LOG_FILE "\n List of all the Files changed     : " . Dumper(\@f_changed);   
print LOG_FILE "\n List of all the Files NOT changed : " . Dumper(\@f_not_changed);   
  
print LOG_FILE "\n\n Total No.of files changed   : " . scalar(@f_changed);   
print LOG_FILE "\n Total No.of files NOT changed : " . scalar(@f_not_changed);   
  
close (LOG_FILE);   
closedir(IN_DIR);   
closedir(OUT_DIR);   
closedir(LOG_DIR);   
  
1;    
