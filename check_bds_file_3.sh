#!/bin/sh
# v.02
#
clear
#
if [ $# -eq 2 ] && [ -f ./$1 ]
then
 lines="-$2"
 echo "TIME     Virt  User  CPU  MEM Processor "
 perl -lane '$/="";if ( /\btop\b/ ) {$tm=$F[2]} elsif ( /adh/ ) {print $tm," ",$F[17]," ",$F[14]," ",$F[21]," ",$F[22]," ",$F[24]}' $1 |sort -nr -k 2 | head $lines
else
 echo " "
 echo " "
 echo " Need a filename that exists - $1 your entry doesn't - try again !"
 echo " OR the file needs to be of top output statistical format"
 echo " "
 echo " "
 echo " * HINT * use like : ==>   $0 <filename> <number lines to show>"
 echo " "
 echo " "
 exit 1
fi
