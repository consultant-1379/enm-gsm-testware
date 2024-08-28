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
if [ $# -ne 1 ]
then
 echo
 echo "Usage : $0 <sim name> <node name> <numOfCells>"
 echo
 echo "Example: $0 GSM-FT-150cell_BSC_17-Q4_V4x9-GSM01 MSC01 1"
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
MOSCRIPT=$NODENAME"_HwBulkup.mo"
## Creating File Group Mos #############
GROUPNUM=`expr $NUMOFCELLS / 2`
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
FILENUM=$NUMOFCELLS
CELLCOUNT=$STARTCELL
echo "$CELLCOUNT , countsf= $ENDCELL"
while [ $CELLCOUNT -le $ENDCELL ]
do
HWCOUNT=1
while [[ "$HWCOUNT" -le "14" ]]
do
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLCOUNT,BscM:ChannelAllocAndOpt=1,BscM:DynamicHrAllocation=1"
    identity "$HWCOUNT"
    moType BscM:HrSubscrPrioLevel
    exception none
    nrOfAttributes 4
    "dtHAmr" Uint8 30
    "dtHAmrWb" Uint8 10
    "dtHNAmr" Uint8 15
    "hrSubscrPrioLevelId" String "$HWCOUNT"
)
MOSC
HWCOUNT=`expr $HWCOUNT + 1`
done
CELLCOUNT=`expr $CELLCOUNT + 1`
done
BTSCOUNT=`expr $FILENUM / 6`
BTS=1
while [[ "$BTS" -le "$BTSCOUNT" ]]
do
HWCOUNT=1
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$BTS"
    identity "1"
    moType BscM:G12Mctr
    exception none
    nrOfAttributes 24
    "air" Uint16 "0"
    "arfcnMaxCap" Array Uint16 0
    "arfcnMinCap" Array Uint16 0
    "ccId" Uint16 0
    "emDi" Uint16 "0"
    "emtp" Uint8 0
    "g12MctrId" String "1"
    "g12MctrIndividual" Uint32 "1"
    "maxFreq" Uint16 "0"
    "maxPwr" Uint16 430
    "maxPwrCap" Uint8 "0"
    "maxTrx" Uint8 0
    "maxTrxCap" Uint16 "0"
    "mcpaIdxCap" Uint8 "0"
    "mctrFCap" Array String 0
    "minFreq" Uint16 "0"
    "relatedMctrList" Array Ref 0
    "tpo" Integer 0
    "trxcPool" Uint8 "0"
    "trxcPoolSize" Uint8 "0"
    "usedByG12Trxc" Array Ref 0
)

MOSC
while [[ "$HWCOUNT" -le "31" ]]
do
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$BTS,BscM:G12Mctr=1"
    identity "$HWCOUNT"
    moType BscM:HwInventoryG12Mctr
    exception none
    nrOfAttributes 1
    "hwInventoryG12MctrId" String "$HWCOUNT"
)
MOSC
HWCOUNT=`expr $HWCOUNT + 1`
done
BTS=`expr $BTS + 1`
done
CELLCOUNT=$STARTCELL
ATRBNUM=`expr $ENDCELL - $STARTCELL + 23`
CELLNUM=`expr $ENDCELL - $STARTCELL + 1`
MMLSCRIPT=$NODENAME"_HwBulkup.mml"
## Creating MMLSCRIPT #################################
cat >> $MMLSCRIPT << MML
.open $SIM
.select $NODENAME
.start
useattributecharacteristics:switch="off";
kertayle:file="$PWD/$MOSCRIPT";
MML
}
#######################################################
## MAIN ###
#######################################################
NODELIST=`echo -e '.open '$SIM' \n .show simnes' | ~/inst/netsim_shell | grep "LTE BSC $BSCNODEVERSION"| cut -d' ' -f1`
Nodes=(${NODELIST// / })
NumOfNodes=${#Nodes[@]}
NODECOUNT=0
while [[ "$NODECOUNT" -lt "$NumOfNodes" ]]
do
  NODENAME=${Nodes[$NODECOUNT]}
  CELLRANGE=`cat "$PWD/../customdata/GsmTopology.csv" | grep -i "SIM:$SIMNUM;NODE:$NODENAME" | awk -F"INTRARANGE:" '{print $2}' | awk -F";" '{print $1}'| head -n+1`
  STARTCELL=$(echo $CELLRANGE | awk -F"-" '{print $1}')
  ENDCELL=$(echo $CELLRANGE | awk -F"-" '{print $2}')
  CellsPerNode=`expr $ENDCELL - $STARTCELL + 1`
  STARTCELL=`expr 1000000 + $STARTCELL`
  ENDCELL=`expr 1000000 + $ENDCELL`
  echo "NodeName: $NODENAME ; StartCell: $STARTCELL ; EndCell: $ENDCELL ; Cellspernode=$CellsPerNode"
  `createNodeData $SIM $NODENAME $STARTCELL $ENDCELL $CellsPerNode`
  MOSCRIPT=$NODENAME"_HwBulkup.mo"
  MMLSCRIPT=$NODENAME"_HwBulkup.mml"
  ~/inst/netsim_shell < $MMLSCRIPT
  rm $MMLSCRIPT
  rm $MOSCRIPT
  NODECOUNT=`expr $NODECOUNT + 1`
done
