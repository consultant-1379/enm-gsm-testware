#!/bin/sh
### VERSION HISTORY
#####################################################################################
#     Version     : 1.2
#
#     Revision    : CXP 903 6542-1-8
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : No Jira
#
#     Description : Correcting Code
#
#     Date        : 2nd Mar 2021
#
####################################################################################
#####################################################################################
#     Version     : 1.1
#
#     Revision    : CXP 903 6542-1-1
#
#     Author      : <xid> or <name>
#
#     JIRA        : JIRA no. ( example: NSS-23250)
#
#     Description : Updating any file 
#
#     Date        : 26th july 2019
#
####################################################################################
if [ "$#" -ne 1  ]
then
 echo
 echo "Usage: $0 <sim name> <node name>"
 echo
 echo "Example: $0 GSM-FT-150cell_BSC_17-Q4_V4x9-GSM01 1"
 echo
 exit 1
fi

SIM=$1
simNum="${SIM:(-2)}"
SIMNUM=`expr $simNum + 0`
PWD=`pwd`

createNodeData() {
SIM=$1
NODENAME=$2
STARTCELL=$3
ENDCELL=$4
NUMOFCELLS=$5
NUMOFBTS=$6
MOSCRIPT=$NODENAME"_Infinite.mo"
## Creating File Group Mos #############
GROUPNUM=`expr $NUMOFCELLS / 2`
FILENUM=$NUMOFCELLS
#FILENUM=$GROUPNUM
COUNT=1
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemHandling=1"
    identity "1"
    moType AxeCpFileSystem:CpFileSystemM
    exception none
    nrOfAttributes 1
    "cpFileSystemMId" String "1"
)
MOSC
while [[ "$COUNT" -le "70" ]]
do
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemHandling=1,AxeCpFileSystem:CpFileSystemM=1"
    identity "$COUNT"
    moType AxeCpFileSystem:CpVolume
    exception none
    nrOfAttributes 1
    "cpVolumeId" String "$COUNT"
)
MOSC
Count=1
while [[ "$Count" -le "$FILENUM" ]]
do
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemHandling=1,AxeCpFileSystem:CpFileSystemM=1,AxeCpFileSystem:CpVolume=$COUNT"
    identity "$Count"
    moType AxeCpFileSystem:InfiniteFile
    exception none
    nrOfAttributes 15
    "activeSubFile" Uint32 "1"
    "activeSubfileExclusiveAccess" Boolean "false"
    "activeSubfileNumOfReaders" Uint8 "0"
    "activeSubfileNumOfWriters" Uint8 "0"
    "activeSubfileSize" Uint32 "0"
    "exclusiveAccess" Boolean "false"
    "infiniteFileId" String "$Count"
    "lastSubfileSent" Uint32 "0"
    "maxSize" Uint32 0
    "maxTime" Uint32 0
    "numOfReaders" Uint8 "0"
    "numOfWriters" Uint8 "0"
    "overrideSubfileClosure" Boolean false
    "recordLength" Uint16 512
    "transferQueue" String "$Count"
)
MOSC
Count=`expr $Count + 1`
done
COUNT=`expr $COUNT + 1`
done
MMLSCRIPT=$NODENAME"_BulkupInfinite.mml"
## Creating MMLSCRIPT #################################
cat >> $MMLSCRIPT << MML
.open $SIM
.select $NODENAME
.start
useattributecharacteristics:switch="off";
kertayle:file="$PWD/$MOSCRIPT";
MML
}

NODELIST=`echo -e '.open '$SIM' \n .show simnes' | ~/inst/netsim_shell | grep "LTE BSC $BSCNODEVERSION"| cut -d' ' -f1`
Nodes=(${NODELIST// / })
NumOfNodes=${#Nodes[@]}
NODECOUNT=0
while [[ "$NODECOUNT" -lt "$NumOfNodes" ]]
do
# NODECOUNT=1
 NODENAME=${Nodes[$NODECOUNT]}
  CELLRANGE=`cat "$PWD/../customdata/GsmTopology.csv" | grep -i "SIM:$SIMNUM;NODE:$NODENAME" | awk -F"INTRARANGE:" '{print $2}' | awk -F";" '{print $1}'| head -n+1`
  STARTCELL=$(echo $CELLRANGE | awk -F"-" '{print $1}')
  ENDCELL=$(echo $CELLRANGE | awk -F"-" '{print $2}')
  CellsPerNode=`expr $ENDCELL - $STARTCELL + 1`
  STARTCELL=`expr 1000000 + $STARTCELL`
  ENDCELL=`expr 1000000 + $ENDCELL`
  echo "NodeName: $NODENAME ; StartCell: $STARTCELL ; EndCell: $ENDCELL"
  `createNodeData $SIM $NODENAME $STARTCELL $ENDCELL $CellsPerNode`
  MOSCRIPT=$NODENAME"_Infinite.mo"
  MMLSCRIPT=$NODENAME"_BulkupInfinite.mml" 
  ~/inst/netsim_shell < $MMLSCRIPT
  rm $MMLSCRIPT
  rm $MOSCRIPT
  NODECOUNT=`expr $NODECOUNT + 1`
done