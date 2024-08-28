#!/bin/sh
### VERSION HISTORY
#####################################################################################
#     Version     : 1.5
#
#     Revision    : CXP 903 6542-1-15
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-37156
#
#     Description : Setting GeranCell.userLabel attribute.
#
#     Date        : 06th Sep 2021
#
####################################################################################
#####################################################################################
##     Version      : 1.4
##
##     Revision     : CXP 903 6542-1-14
##
##     Author       : zyamkan
##
##     JIRA         : NSS-35602,35603
##
##     Description  : Removing hardcode attribute list of balistIdle & balistActive.
##
##     Date         : 26th July 2021
##
######################################################################################
#####################################################################################
#     Version     : 1.3
#
#     Revision    : CXP 903 6542-1-12
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-35471
#
#     Description : Creating SharedCarrier MO on BSC nodes
#
#     Date        : 18th May 2021
#
####################################################################################
#####################################################################################
#     Version     : 1.2
#
#     Revision    : CXP 903 6542-1-8
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-30601 & NSS-30603,NSS-34065
#
#     Description : Adding Code for GSM and LTE Consistencies
#                   Adding Support for Pre-Build Inspection
#
#     Date        : 26th Feb 2021
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
SIMNAME=$1
NODENAME=$2

SIMNUM="${SIMNAME:(-2)}"
NODENUM="${NODENAME:(-2)}"
simNum=`expr $SIMNUM + 0`
cellid=0
. $PWD/../dat/Build.env
LTEHandOverFile=$PWD/../customdata/$LRANHANDOVERFILE

MOSCRIPT=$NODENAME"_gcell.mo"
MMLSCRIPT=$NODENAME"_gcell.mml"
if [ -e $MOSCRIPT ]
then
  rm $MOSCRIPT
fi

if [ -e $MMLSCRIPT ]
then
  rm $MMLSCRIPT
fi

NODECELLSCSV="GSM"$SIMNUM$NODENAME"_cells.csv"
if [ -e $NODECELLSCSV ]
then
  rm $NODECELLSCSV
fi

cat $PWD/../customdata/GsmTopology.csv | grep -i "SIM:$simNum;NODE:$NODENAME" | awk -F"CELL:" '{print $2}' | awk -F";" '{print $1}' > "GSM"$SIMNUM$NODENAME"_cells.csv"
count=1
while read -r CELLVALUE
do
echo "NODENAME: $NODENAME; CELL : $CELLVALUE"
cellLocationData=`cat $PWD/../customdata/plmnNetworkData.csv | grep "CELL_NAME=$CELLVALUE"`
IdVALUE=$count
count=`expr $count + 1`
#echo "****$CELLVALUE and IdValue=$IdVALUE***"
if [[ $cellLocationData == "" ]]
then
   echo "ERROR: No PLMN Id is set for Geran Cell $CELL"
else
   cellData=(${cellLocationData//;/ })
   PLMNID=${cellData[1]}"-"${cellData[2]}"-"${cellData[3]}"-"${cellData[4]}
fi
csvLine=`cat $LTEHandOverFile | grep "CELL_NAME=${CELLVALUE};"`
csvItem=(${csvLine//;/ })
CELL_NAME=$(echo ${csvItem[0]} | cut -d"=" -f2)
MCC=$(echo ${csvItem[1]} | cut -d"=" -f2)
MNC=$(echo ${csvItem[2]} | cut -d"=" -f2)
LAC=$(echo ${csvItem[4]} | cut -d"=" -f2)
CI=$(echo ${csvItem[5]} | cut -d"=" -f2)
NCC=$(echo ${csvItem[6]} | cut -d"=" -f2)
BCC=$(echo ${csvItem[7]} | cut -d"=" -f2)
BCCHNO=$(echo ${csvItem[8]} | cut -d"=" -f2)
C_SYS_TYPE=$(echo ${csvItem[9]} | cut -d"=" -f2)
CGI="${MCC}-${MNC}-${LAC}-${CI}"
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1"
    identity "$CELLVALUE"
    moType BscM:GeranCell
    exception none
    nrOfAttributes 9
    "cgi" String "${CGI}"
    "bcc" Uint32 "${BCC}"
    "bcchNo" Uint16 "${BCCHNO}"
    "ncc" Uint8 "${NCC}"
    "cSysType" Integer 0
    "geranCellId" String "$CELLVALUE"
    "geranCellIndividual" Uint16 $IdVALUE
    "userLabel" String "$CELLVALUE"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLVALUE"
    identity "1"
    moType BscM:CapacityLock
    exception none
    nrOfAttributes 1
    "capacityLockId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLVALUE"
    identity "1"
    moType BscM:ChannelAllocAndOpt
    exception none
    nrOfAttributes 1
    "channelAllocAndOptId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLVALUE"
    identity "1"
    moType BscM:SharedCarrier
    exception none
    nrOfAttributes 14
    "sharedCarrierId" String "1"
    "ssBandwidth" Uint16 2
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLVALUE,BscM:ChannelAllocAndOpt=1"
    identity "1"
    moType BscM:CellLoadSharing
    exception none
    nrOfAttributes 1
    "cellLoadSharingId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLVALUE,BscM:ChannelAllocAndOpt=1"
    identity "1"
    moType BscM:DiffChannelAllocPrio
    exception none
    nrOfAttributes 1
    "diffChannelAllocPrioId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLVALUE,BscM:ChannelAllocAndOpt=1"
    identity "1"
    moType BscM:DynamicAllocationOnAbis
    exception none
    nrOfAttributes 1
    "dynamicAllocationOnAbisId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLVALUE,BscM:ChannelAllocAndOpt=1"
    identity "1"
    moType BscM:DynamicFrHrModeAdaption
    exception none
    nrOfAttributes 1
    "dynamicFrHrModeAdaptionId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLVALUE,BscM:ChannelAllocAndOpt=1"
    identity "1"
    moType BscM:DynamicHrAllocation
    exception none
    nrOfAttributes 1
    "dynamicHrAllocationId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLVALUE,BscM:ChannelAllocAndOpt=1"
    identity "1"
    moType BscM:IdleChannelMeasurement
    exception none
    nrOfAttributes 1
    "idleChannelMeasurementId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLVALUE,BscM:ChannelAllocAndOpt=1"
    identity "1"
    moType BscM:LchAdaptiveConf
    exception none
    nrOfAttributes 1
    "lchAdaptiveConfId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLVALUE,BscM:ChannelAllocAndOpt=1"
    identity "1"
    moType BscM:SubcellLoadDistribution
    exception none
    nrOfAttributes 1
    "subcellLoadDistributionId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLVALUE,BscM:ChannelAllocAndOpt=1"
    identity "1"
    moType BscM:Vamos
    exception none
    nrOfAttributes 1
    "vamosId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLVALUE"
    identity "0"
    moType BscM:ChannelGroup
    exception none
    nrOfAttributes 2
    "channelGroupId" String "0"
    "channelGroupIndividual" Uint16 19
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLVALUE"
    identity "1"
    moType BscM:ChannelGroup
    exception none
    nrOfAttributes 2
    "channelGroupId" String "1"
    "channelGroupIndividual" Uint16 51
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLVALUE"
    identity "1"
    moType BscM:Dtm
    exception none
    nrOfAttributes 1
    "dtmId" String "1"
)
MOSC
done < "GSM"$SIMNUM$NODENAME"_cells.csv"
totalNumberOfCells=`cat "GSM"$SIMNUM$NODENAME"_cells.csv" | wc -l`
echo "NodeName=$NODENAME;NumOfGsmCells=$totalNumberOfCells" >> $PWD/../customdata/NetworkStats.csv
#echo "NodeName=$NODENAME;NumOfGsmCells=$totalNumberOfCells" >> preBuildGSMCounts.csv
rm "GSM"$SIMNUM$NODENAME"_cells.csv"

cat >> $MMLSCRIPT << MML
.open $SIMNAME
.select $NODENAME
.start
useattributecharacteristics:switch="off";
kertayle:file="$PWD/$MOSCRIPT";
.save
MML
~/inst/netsim_shell < $MMLSCRIPT
rm $MOSCRIPT
rm $MMLSCRIPT
