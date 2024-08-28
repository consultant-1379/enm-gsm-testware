#!/bin/sh
#####################################################################################
#     Version     : 1.3
#
#     Revision    : CXP 903 6542-1-19
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NO-JIRA
#
#     Description : Updating code for Mobility Mo
#
#     Date        : 23rd Dec 2021
#####################################################################################
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
##########################################################################################################################
# Created by  : Harish Dunga
# Created on  : 9.1.2020
# Purpose     : Relates the RadioNodes with the parent BSC
###########################################################################################################################

SIMNAME=$1
PWD=`pwd`
SIMNUM="${SIMNAME:(-2)}"
BSCBASENAME="M"$SIMNUM"B"
simNum=`expr $SIMNUM + 0`
cellFlag=0
MMLSCRIPT="relate.mml"
if [ -e $MMLSCRIPT ]
then
   rm $MMLSCRIPT
fi
################################################################################

. $PWD/../dat/Build.env

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
NUMOFBSCNODES=`getNumOfNodes $simNum $CELLARRAY`
BSCNODECOUNT=1
TOTALBTSCOUNT=0
DG2NODENUM=0
DG2BASE="MSRBS-V2"
BTSNUMLIST=()
cat >> $MMLSCRIPT << MML
.open $SIMNAME
MML
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
   #DG2COUNT=$(expr $NUMOFG2BTS / 6)
   #DG2REM=$(expr $NUMOFG2BTS % 6)
   #if [ $DG2REM -ne 0 ]
   #then
   #    DG2COUNT=$(expr $DG2COUNT + 1)
   #fi
   
   BSCDG2=$BSCNODENAME":"$DG2COUNT
   BTSNUMLIST+=($BSCDG2)
   DG2NODENUM=$(expr $DG2COUNT + $DG2NODENUM )
   echo "DG2NODENUM=$DG2NODENUM  BSCNODENAME=$BSCNODENAME"
   #TOTALBTSCOUNT=$(expr $NUMOFG2BTS + $TOTALBTSCOUNT )
   BSCNODECOUNT=$(expr $BSCNODECOUNT + 1)
done
STARTDG2NUM=1
ENDDG2NUM=0
BSCNODECOUNT=1
while [ "$BSCNODECOUNT" -le "$NUMOFBSCNODES"  ]
do
   INDEX=$(expr $BSCNODECOUNT - 1)
   BSCDG2VALUE=${BTSNUMLIST[$INDEX]}
   BSCNODE=$(echo $BSCDG2VALUE | awk -F":" '{print $1}')
   BSCNUM=$(echo $BSCNODE | awk -F"B" '{print $2}')
   NUMOFDG2PERBSC=$(echo $BSCDG2VALUE | awk -F":" '{print $2}')
   if [ $NUMOFDG2PERBSC -eq "0" ]
   then
      continue;
   fi
   MMLCMD2=".select "$BSCNODE
   ENDDG2NUM=$(expr $NUMOFDG2PERBSC + $ENDDG2NUM )
   DG2COUNT=1
   if [ -e changeId.mml ]
   then
      rm changeId.mml
   fi
   if [ -e relateEach.mml ]
   then
      rm relateEach.mml
   fi
   while [ $STARTDG2NUM -le $ENDDG2NUM ]
   do
      if [ $STARTDG2NUM -le 9 ]
      then
         DG2VALUE="0"$STARTDG2NUM
      else
         DG2VALUE=$STARTDG2NUM
      fi
      if [ $DG2COUNT -le "9" ]
      then
         DG2COUNT="0"$DG2COUNT
      fi
      MMLCMD2=$MMLCMD2" MSRBS-V2"$DG2COUNT
      RADIONODE="MSRBS-V2"$DG2VALUE
      DG2NODE="B"$BSCNUM"MSRBS-V2"$DG2COUNT
      cat > relateEach.mml << MML
.open $SIMNAME
.select $RADIONODE
.stop
.rename -auto MSRBS-V2 $DG2COUNT
.set save
.start
MML
    /netsim/inst/netsim_pipe < relateEach.mml
    NODE="MSRBS-V2"$DG2COUNT
    LDN=`echo -e ".open $SIMNAME \n .select $NODE \n e: csmo:mo_id_to_ldn(null, 1)." | /netsim/inst/netsim_shell | sed -n '/csmo:mo_id_to_ldn/{n;p}' | sed 's/[][]//g' | sed 's/ComTop://g'`
      cat >> changeId.mml << MML
.select $DG2NODE
.start
setmoattribute:mo=$LDN, attributes = "managedElementId(string )=${DG2NODE}";
.restart
.stop
MML
      STARTDG2NUM=`expr $STARTDG2NUM + 1`
      DG2COUNT=`expr $DG2COUNT + 1`
   done
   #cat relateEach.mml >> $MMLSCRIPT
   echo ".open $SIMNAME" >> $MMLSCRIPT
   echo ".stop" >> $MMLSCRIPT
   echo "$MMLCMD2" >> $MMLSCRIPT
   echo ".stop" >> $MMLSCRIPT
   echo ".relate" >> $MMLSCRIPT
   echo ".set save" >> $MMLSCRIPT
   echo ".start" >> $MMLSCRIPT
   cat changeId.mml >> $MMLSCRIPT
   BSCNODECOUNT=$(expr $BSCNODECOUNT + 1)
   rm changeId.mml
   rm relateEach.mml
/netsim/inst/netsim_pipe < $MMLSCRIPT
rm $MMLSCRIPT
done

#/netsim/inst/netsim_pipe < $MMLSCRIPT
#rm $MMLSCRIPT
