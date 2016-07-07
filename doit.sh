#!/bin/sh
# Feb 2014 by Tugrul Ozbay
# CJC Ltd v1.0
# doit_tug.sh to make it easier
#
id=`whoami`; export $id
echo "username is $id "
if [ ! -f ./ads.dump ] || [ `id | grep radmin| wc -l` -ne 1 ]
then
clear
echo " >>>> ERROR <<<< "
echo " either ads.dump doesn't exist.  first dump it then try again "
echo " also, check that you are logged in as >> radmin "
exit 1
fi
cat ./ads.dump | grep "Ac St" | wc -l
echo " you should see pnac stales - break out now if you please "
sleep 10
cat ./ads.dump | grep "Ac St" | awk '{print $7}'> ./ActStale.rics
for i in `cat ActStale.rics`
        do
        echo $i
        echo "ConsumerService.SinkDist hEDD dropItem $i" >>ActStale.rics.dropItems
        done
cp ./ActStale.rics.dropItems /tmp/dropitems
ls -lart /tmp/dropitems
sleep 5
./adsmon -setfile /tmp/dropitems
