
#!/bin/bash
#
# By Tugrul Ozbay CJCIT June 2015
# Note: This script can be used to warn admin that
# the file system is getting full of shit
#
# By Tugrul Ozbay CJCIT June 2015
#
# set -x
#
DT=`date | awk '{print $2"-"$3 " "$4}'`
HOSTN=`hostname`;
SEND="stats@cjcit.com";
# RECV="cjcengineering_cjcit@cjcit.com";
RECV="tugrul.ozbay@cjcit.com";
SUBJ="Disk usage on $HOSTN";
MLDR="/data01/home/cjcadmin/scripts/mailAlert";
Pct=90
#
export DT
echo "Testing data $HOSTN $RECV $SUBJ $Pct $DT";
#
if [ -f /tmp/FScheck.log ]
then
        mv /tmp/FScheck.log /tmp/FScheck.log.1
fi
#

# for disk in `df -k|grep -v Filesystem|awk '{print $6}'`
# for disk in `df -k|grep -v Filesystem|awk '{print $1}'`
for disk in \/dev\/dsk\/c0t0d0s0  \/tmp  \/var  \/data01
do
        echo "checking ...      $disk"
        echo "checking ...      $disk" >>  /tmp/FScheck.log
        if [ `df -kl|grep "$disk"|awk '{print $5}'|grep -v Capacity|sed 's/.$//'` -lt ${Pct} ]
         then
                #echo "checking ...     $disk " >> /tmp/FScheck.log
                echo "All ok - There is less than $Pct % usage on $disk on $DT"
                echo "All ok - There is less than $Pct % usage on $disk on $DT" >> /tmp/FScheck.log
                echo "------------------------------------------------------------------------------------------  " >> /tmp/FScheck.log
                # $MLDR/sendEmail -s smtp:25 -o message-content-type=text -f $SEND -t $RECV -u \"$HOSTN disk space\" -m \"$output\"
         else
                diskSpace=`df -kl|grep "$disk "|awk '{print $5}'| grep -v Capacity`
                output=`echo "PLS CHECK ASAP more than $Pct % on $disk; This $disk with a $diskSpace needs clearing up a little on $DT"`;
                echo "checking ...      $disk " >> /tmp/FScheck.log
                echo "PLS CHECK ASAP - there is more than $Pct % disk usage on $disk - The $disk with a $diskSpace needs clearing up a little on $DT" >> /tmp/FScheck.log
                echo "------------------------------------------------------------------------------------------  " >> /tmp/FScheck.log
                output2="/tmp/FScheck.log";
                #$MLDR/sendEmail -s smtp:25 -o message-content-type=text -f $SEND -t $RECV -u \"$HOSTN disk space on $DT\" -m \"`cat $output2`\"
        fi
done
