#!/bin/bash
#
# By Tugrul Ozbay CJCIT June 2015
# Note: This script can be used to warn admin that
# the file system is getting full of shit
#
# By Tugrul Ozbay CJCIT June 2015
# Version 2 : Based on last 1GB left on disk
# set -x
#
DT=`date | awk '{print $2"-"$3 " "$4}'`
HOSTN=`hostname`;
SEND="stats@cjcit.com";
# RECV="cjcengineering_cjcit@cjcit.com";
RECV="tugrul.ozbay@cjcit.com";
SUBJ="Disk usage on $HOSTN";
MLDR="/data01/home/cjcadmin/scripts/mailAlert";
LOG=/tmp/FScheck.log; export LOG
Space=1067560   # thats 1GB
# Space=399
#
export DT
echo "Testing data $HOSTN $RECV $SUBJ $Space $DT";
#
if [ -f $LOG ]
then
        mv $LOG $LOG.1
fi
#

for disk in \/dev\/dsk\/c0t0d0s0  \/tmp  \/var  \/data01
do
        # echo "checking ...    $disk" >>  $LOG
#       if [ `df -klh|grep "$disk"|awk '{print $4}'|grep -v Capacity|sed 's/.$//'| head -1` -lt ${Space} ]
        if [ `df -kl|grep "$disk"|awk '{print $4}'| head -1` -lt ${Space} ]
         then
                echo "** Be AWARE ** -  less than $Space (1GB) disk space available for usage on $disk today $DT"
                echo "** Be AWARE ** -  less than $Space (1GB) disk space available for usage on $disk today $DT" >> $LOG
                echo "-------------------------------------------------------------------------------------------------------------------  " >> $LOG
                echo "-------------------------------------------------------------------------------------------------------------------  " >> $LOG
         fi
done

for disk in \/dev\/dsk\/c0t0d0s0  \/tmp  \/var  \/data01
do
#       echo "checking ...      $disk" >>  $LOG
        #if [ `df -klh|grep "$disk"|awk '{print $4}'|grep -v Capacity|sed 's/.$//'|head -1` -ge ${Space} ]
        if [ `df -kl|grep "$disk"|awk '{print $4}'|head -1` -ge ${Space} ]
         then
                # echo "-------------------------------------------------------------------------------------------------------------------  " >> $LOG
                echo " ALL FINE  - over $Space (1GB) disk space usage on ===>  $disk today $DT "
                # echo " ALL FINE  - over $Space (1GB) disk space usage on ===>  $disk today $DT " >> $LOG
                # echo "-------------------------------------------------------------------------------------------------------------------  " >> $LOG
        fi
done
         sleep 30
         ./mailz.pl
