#!/bin/sh
#####################################################################################
#     Version     : 1.3
#
#     Revision    : CXP 903 6542-1-15
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : No-Jira
#
#     Description : Setting IP address as per in Centos.
#
#     Date        : 06th Sep 2021
#
####################################################################################
#####################################################################################
#     Version     : 1.2
#
#     Revision    : CXP 903 6542-1-8
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-34293,NSS-34459
#
#     Description : Changing BSC and MSC Node names
#                   Adding support for 8000 cell BSC related to NRM5.1
#
#     Date        : 26th Feb 2021
#
####################################################################################
#####################################################################################
#     Version     : 1.2
#
#     Revision    : CXP 903 6542-1-7
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-33841
#
#     Description : Updating the codebase 
#
#     Date        : 23rd Dec 2020
#
####################################################################################
##########################################################################################################################
# Created by  : Harish Dunga
# Created on  : 9.1.2020
# Purpose     : Clones the RadioNodes first in the simulation
###########################################################################################################################

SIMNAME=$1
PWD=`pwd`
SIMNUM="${SIMNAME:(-2)}"
BSCBASENAME="M"$SIMNUM"B"
simNum=`expr $SIMNUM + 0`
cellFlag=0
################################################################################

. $PWD/../dat/Build.env

#################################################
## Subroutines
#################################################
getNumOfNodes() {
SIMNUM=$1
CELLARRAY=$2
IFS=";"
for x in $CELLARRAY
do
SIMPOS=$(echo $x | awk -F":" '{print $1}')
if [ "$SIMNUM" -eq "$SIMPOS" ]
then
  NODENUM=$(echo $x | awk -F":" '{print $2}' | awk -F"," '{print $1}')
  echo $NODENUM
  break
fi
done
}
################################################
MSRBSVERSION=`cat ../dat/Build.env | grep ^"NODEVERSION" | cut -d "=" -f 2 | cut -d "\"" -f 2`
MSRBSNode="MSRBS"
STR1=${MSRBSNode}".*V2.*"
vals1=(${MSRBSVERSION//-/ })
for i in "${vals1[@]}"
do
STR1=$STR1$i".*"
done
echo $STR1
MSRBS_Link=`cat /netsim/simdepContents/nodeTemplate.content | grep -o '.*' | grep $STR1 | cut -d "\"" -f 2`
DG2BaseSimName=`echo $MSRBS_Link | awk -F '/' '{print $NF}'`

MMLSCRIPT="create_RadioNode.mml"
if [ -e $MMLSCRIPT ]
then
    rm -rf $MMLSCRIPT
fi
lsof -nl >/tmp/lsof.log;rm -rf ~/freeIPs.log; for ip in `ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'`;do grep $ip /tmp/lsof.log > /dev/null; if [ $? != 0 ]; then echo $ip >> ~/freeIPs.log; fi; done; rm -rf /tmp/lsof.log;echo "Total IPs:`ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'|wc -l`"; echo "Free IPs:`wc -l ~/freeIPs.log`";

ipAddr=`cat "/netsim/freeIPs.log" | grep -vi ":" | head -n+1`

NETWORKLIST=(${CELLARRAY//;/ })
for elem in ${NETWORKLIST[@]}
do
cellDistribution=$(echo $elem | awk -F"," '{print $2}')
if [[ $cellDistribution = *"|8000"* ]]
then
# This attribute will set only for node 8000 cell
cellFlag=8000
fi
done

NUMOFBSCNODES=`getNumOfNodes $simNum $CELLARRAY`
BSCNODECOUNT=1
TOTALBTSCOUNT=0
DG2NODENUM=0
BTSNUMLIST=()
while [ "$BSCNODECOUNT" -le "$NUMOFBSCNODES"  ]
do
   BSCNODENUM=$(expr $(expr $simNum \* $NUMOFBSCNODES) - $NUMOFBSCNODES + $BSCNODECOUNT )
   if [ "$BSCNODENUM" -le 9 ]
   then
      BSCNODENAME=$BSCBASENAME'0'$BSCNODENUM
   else
      BSCNODENAME=$BSCBASENAME$BSCNODENUM
   fi

   NUMOFG2BTS=`cat $PWD/../customdata/GsmTopology.csv | grep -i "SIM:$simNum;NODE:$BSCNODENAME" | grep "BTS:G2" | wc -l`
   if [[ $simNum == "48" ]] && [[ $BSCNODECOUNT == "2" ]] && [[ $cellFlag == "8000" ]]
   then
       DG2COUNT=$NUMOFG2BTS
   else
       DG2COUNT=$(expr $NUMOFG2BTS / 3)
       DG2REM=$(expr $NUMOFG2BTS % 3)
       if [ $DG2REM -ne 0 ]
       then
           DG2COUNT=$(expr $DG2COUNT + 1)
       fi
   fi
   BTSNUMLIST+=($NUMOFG2BTS)
   DG2NODENUM=$(expr $DG2COUNT + $DG2NODENUM )
   echo "DG2NODENUM=$DG2NODENUM  BSCNODENAME=$BSCNODENAME"
   #TOTALBTSCOUNT=$(expr $NUMOFG2BTS + $TOTALBTSCOUNT )
   BSCNODECOUNT=$(expr $BSCNODECOUNT + 1)
done


NUMOFDG2NODES=$(expr $DG2NODENUM - 1)

tempSimName=${DG2BaseSimName//.zip}
cat >> $MMLSCRIPT << MML
.open $tempSimName
.saveasimul $SIMNAME
.open $SIMNAME
cmshell;
.createne checkport $dg2Port
.selectnocallback NE01
.clone $NUMOFDG2NODES NE 2
.selectnetype MSRBS-V2
.set port $dg2Port
.createne subaddr $ipAddr subaddr no_value
.set external $dg2Port
.set save
.rename -auto MSRBS-V2 01
.set save
MML
#cat >> $MMLSCRIPT << MML
#.open $tempSimName
#.saveasimul $SIMNAME
#.open $SIMNAME
#.set save
#MML

NODECOUNT=1
lsof -nl >/tmp/lsof.log;rm -rf ~/freeIPs.log; for ip in `ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'`;do grep $ip /tmp/lsof.log > /dev/null; if [ $? != 0 ]; then echo $ip >> ~/freeIPs.log; fi; done; rm -rf /tmp/lsof.log;echo "Total IPs:`ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'|wc -l`"; echo "Free IPs:`wc -l ~/freeIPs.log`";
while [ $NODECOUNT -le $DG2NODENUM ]
do
  if [ $NODECOUNT -le 9 ]
  then
     NODENAME="MSRBS-V20"$NODECOUNT
  else
     NODENAME="MSRBS-V2"$NODECOUNT
  fi
ipAddr=`cat "/netsim/freeIPs.log" | grep -vi ":" | head -n+1`
sed -i "/${ipAddr}/d" /netsim/freeIPs.log
  cat >> $MMLSCRIPT << MML
.select $NODENAME
.set taggedaddr subaddr $ipAddr 1
.set save
.start
MML
NODECOUNT=$(expr $NODECOUNT + 1)
done
~/inst/netsim_shell < $MMLSCRIPT
rm $MMLSCRIPT
