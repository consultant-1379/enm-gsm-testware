#!/bin/sh
### VERSION HISTORY
#####################################################################################
#     Version     : 1.1
#
#     Revision    : CXP 903 6542-1-8
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-34223
#
#     Description : Creating 3% of FileM Mos for BSC nodes
#
#     Date        : 26th Feb 2021
#
####################################################################################

if [ "$#" -ne 1  ]
then
 echo
 echo "Usage: $0 <sim name>"
 echo
 echo "Example: $0 GSM-FT-150cell_BSC_17-Q4_V4x9-GSM01"
 echo
 exit 1
fi
####################################################################################

SIMNAME=$1
SIMNUM="${SIMNAME:(-2)}"
simNum=`expr $SIMNUM + 0`
. $PWD/../dat/Build.env
Date=`date '+%FT%T'`

cells=`awk 'BEGIN{print gsub(ARGV[2],"",ARGV[1])}' "$SIMNAME" "cell"`

cellType=`echo $SIMNAME | awk -F"cell" '{print $1}' | rev | cut -d'-' -f1 | rev`
moCount=`expr $cellType \* 250`
FileMCOUNT=`expr 3 \* $moCount / 100` 

NODELIST=`echo -e '.open '$SIMNAME' \n .show simnes' | ~/inst/netsim_shell | grep "LTE BSC $BSCNODEVERSION"| cut -d' ' -f1`
Nodes=(${NODELIST// / })
NumOfNodes=${#Nodes[@]}
NODECOUNT=0
while [ "$NODECOUNT" -lt "$NumOfNodes" ]
do
   NODENAME=${Nodes[$NODECOUNT]}
   NODECOUNT=`expr $NODECOUNT + 1`
   count=1
   if [[ $cells == "2" ]] && [[ $NODECOUNT == "2" ]]
   then
       cellType=`echo $SIMNAME | awk -F"cell" '{print $2}' | cut -d'_' -f2`
       if [[ $cellType == "8000" ]]
       then
          moCount=1300000
       else
          moCount=`expr $cellType \* 250`
       fi
       FileMCOUNT=`expr 3 \* $moCount / 100`
   fi
while [[ "$count" -le "$FileMCOUNT" ]]
do
cat >> $NODENAME.mo << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,ComFileM:FileM=1,ComFileM:LogicalFs=1"
    identity "$count"
    moType ComFileM:FileGroup
    exception none
    nrOfAttributes 4
    "files" Array Struct 1
        nrOfElements 4
        "size" Uint64 108
        "fileType" String "cfg"
        "modificationTime" String "$Date"
        "fileName" String "FmAlarmLog.cfg"
    "fileGroupId" String "$count"
    "reservedByPolicy" Ref "null"
    "internalHousekeeping" Boolean true
)
MOSC
count=`expr $count + 1`
done
cat >> fileM.mml << MML
.open $SIMNAME
.select $NODENAME
.start
useattributecharacteristics:switch="off";
kertayle:file="$PWD/$NODENAME.mo";
MML

~/inst/netsim_shell < "$PWD/fileM.mml"
rm $PWD/$NODENAME.mo
rm $PWD/fileM.mml

done
