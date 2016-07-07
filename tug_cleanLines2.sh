#!/bin/sh
#
# By Tugrul Ozbay
# CJC on 24th Feb 2014
#
OUT1="./output1.txt"; export OUT1
OUT2="./output2.txt"; export OUT2
DIFF="./differences.txt"; export DIFF
dff=/usr/bin/diff; export dff
rmm=/bin/rm; export rmm
#
clear
#
echo " "
echo " Please enter the OLD file : ";
read file1
#
echo " Please enter the NEW file to compare : ";
read file2
#
if [ ! -f ./$file1 ] || [ ! -f ./$file2 ]
then
        clear
        echo " ERROR : "
        echo " "
        echo " Your file called $file1 or $file2 does not exist here - try again"
        echo " "
        echo " "
exit 1
fi
#
if [ -f $OUT1 ]
then
        rm $OUT1 >/dev/null 2>&1
fi
#
if [ -f $OUT2 ]
then
        rm $OUT2 >/dev/null 2>&1
fi
#
#
while read LINE
do
        echo $LINE | tr -d '=;:`"<>,./?!@#$%^&(){}[]'|tr -d "-"|tr -d "'" | tr -d "_"
done < $file1 > $OUT1
echo " "
echo "your output file1 is now ready and is called : $OUT1 ";
#
#
while read LINE
do
        echo $LINE | tr -d '=;:`"<>,./?!@#$%^&(){}[]'|tr -d "-"|tr -d "'" | tr -d "_"
done < $file2 > $OUT2
echo " "
echo "your output file2 is now ready and is called : $OUT2 ";
#
# $dff ./$OUT1 ./$OUT2 | grep ">" >$DIFF
$dff ./$OUT1 ./$OUT2 >$DIFF
echo "your $DIFF file is now ready ";
#
## clearup
##
$rmm $OUT1 $OUT2
##
