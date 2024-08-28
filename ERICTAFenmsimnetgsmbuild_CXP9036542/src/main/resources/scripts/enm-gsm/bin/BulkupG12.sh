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
NUMOFCELLS=$3
STARTCELL=$4
ENDCELL=$5
NUMOFBTS=$6
MOSCRIPT=$NODENAME"_BulkupG12.mo"
## Creating File Group Mos #############
GROUPNUM=`expr $NUMOFCELLS / 2`
COUNT=1
BTSCOUNT=1
while [[ "$BTSCOUNT" -le "$NUMOFBTS" ]]
do
TRXID=0
while [[ "$TRXID" -lt "16" ]]
do
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$BTSCOUNT"
    identity "$TRXID"
    moType BscM:G12Trxc
    exception none
    nrOfAttributes 22
    "dcp1Cap" Uint16 "0"
    "dcp2Cap" Array Uint16 0
    "dcpGroupNum" Uint8 "0"
    "dcpSignalling" Uint16 0
    "dcpSpeechDataBegin" Uint16 "0"
    "dedicateToGeranCell" Ref "ManagedElement=$NODENAME,BscFunction=1,BscM=1,GeranCellM=1,GeranCell=$STARTCELL"
    "g12TrxcId" String "$TRXID"
    "g12TrxcIndividual" Uint32 "$TRXID"
    "mctrNotSupCap" String "NO"
    "omlF1Cap" Array String 0
    "omlF2Cap" Array String 0
    "rslF1Cap" Array String 0
    "rslF2Cap" Array String 0
    "sig" Integer "0"
    "tcfModeCap" Array String "0000000000000000"
    "tchModeCap" Array String "0000000000000000"
    "tei" Uint8 0
    "teiCap" Uint8 "0"
    "trTypeCap" String "0"
    "traff" Integer 0
    "tsCap" Integer "0"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$BTSCOUNT,BscM:G12Trxc=$TRXID"
    identity "$TRXID"
    moType BscM:G12Rx
    exception none
    nrOfAttributes 4
    "arfcnMaxCap" Array Uint16 0
    "arfcnMinCap" Array Uint16 0
    "g12RxId" String "$TRXID"
    "g12RxIndividual" Uint32 "$TRXID"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$BTSCOUNT,BscM:G12Trxc=$TRXID"
    identity "$TRXID"
    moType BscM:G12Tx
    exception none
    nrOfAttributes 5
    "arfcnMaxCap" Array Uint16 0
    "arfcnMinCap" Array Uint16 0
    "g12TxId" String "$TRXID"
    "g12TxIndividual" Uint32 "$TRXID"
    "mPwr" Uint8 40
)
MOSC
TSID=0
while [[ "$TSID" -le "7" ]]
do
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$BTSCOUNT,BscM:G12Trxc=$TRXID"
    identity "$TSID"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 2
    "g12TsId" String "$TSID"
    "g12TsIndividual" Uint32 "$TSID"
)
MOSC
TSID=`expr $TSID + 1`
done
TRXID=`expr $TRXID + 1`
done
TRXID=1
while [[ "$TRXID" -le "14" ]]
do
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$BTSCOUNT"
    identity "$TRXID"
    moType BscM:G12SubscrPrioLevel
    exception none
    nrOfAttributes 7
    "dAmrRedAbisThr" Uint8 "100"
    "dHraAbisThr" Uint8 "100"
    "dHraAbisThrWb" Uint8 "100"
    "g12SubscrPrioLevelId" String "$TRXID"
    "sdAmrRedAbisThr" Uint8 "100"
    "sdHraAbisThr" Uint8 "100"
    "sdHraAbisThrWb" Uint8 "100"
)
MOSC
TRXID=`expr $TRXID + 1`
done
BTSCOUNT=`expr $BTSCOUNT + 1`
done
MMLSCRIPT=$NODENAME"_BulkupG12.mml"
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
  NODENAME=${Nodes[$NODECOUNT]}
  CELLRANGE=`cat "$PWD/../customdata/GsmTopology.csv" | grep -i "SIM:$SIMNUM;NODE:$NODENAME" | awk -F"INTRARANGE:" '{print $2}' | awk -F";" '{print $1}'| head -n+1`
  STARTCELL=$(echo $CELLRANGE | awk -F"-" '{print $1}')
  ENDCELL=$(echo $CELLRANGE | awk -F"-" '{print $2}')
  CellsPerNode=`expr $ENDCELL - $STARTCELL + 1`
  STARTCELL=`expr 1000000 + $STARTCELL`
  ENDCELL=`expr 1000000 + $ENDCELL`
  NUMOFBTS=`expr $CellsPerNode / 6`
  echo "createNodeData $SIM $NODENAME $CellsPerNode $STARTCELL $ENDCELL $NUMOFBTS"
  `createNodeData $SIM $NODENAME $CellsPerNode $STARTCELL $ENDCELL $NUMOFBTS`
  MOSCRIPT=$NODENAME"_BulkupG12.mo"
  MMLSCRIPT=$NODENAME"_BulkupG12.mml"
  ~/inst/netsim_shell < $MMLSCRIPT
  rm $MMLSCRIPT
  rm $MOSCRIPT
  NODECOUNT=`expr $NODECOUNT + 1`
done
