#!/bin/sh
### VERSION HISTORY
#####################################################################################
#     Version     : 1.5
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
#     Version     : 1.4
#
#     Revision    : CXP 903 6542-1-15
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-37155,37186
#
#     Description : correcting the code for fddArfcn attribute value
#                   Creating InterRanMobility attribbutes
#
#     Date        : 09th Sept 2021
#
####################################################################################
#####################################################################################
#     Version     : 1.3
#
#     Revision    : CXP 903 6542-1-12
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-35472
#
#     Description : Adding code for ExternalUtranCell.mrsl attribute
#                   And Updating MNC value from 6 to 06 in Build.env 
#
#     Date        : 08th Jun 2021
#
####################################################################################
#####################################################################################
#     Version     : 1.2
#
#     Revision    : CXP 903 6542-1-8
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-30602,NSS-34065
#
#     Description : Adding Code for GSM and WRAN Consistencies
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
if [ "$#" -ne 3  ]
then
 echo
 echo "Usage: $0 <sim name> <node name> <mo file>"
 echo
 echo "Example: $0 GSM-FT-MSC-BC-IS-500cell_BSC_18-Q2_V4x7-GSM08 BSC02 BSC02_GeranRelations.mo"
 echo
 exit 1
fi

. $PWD/../dat/Build.env
SIMNAME=$1
NODENAME=$2
MOSCRIPT=$3
SIMNUM="${SIMNAME:(-2)}"
NODENUM="${NODENAME:(-2)}"
simNum=`expr $SIMNUM + 0`
wranHandOverFile=$PWD/../customdata/$WRANHANDOVERFILE

if [ -e UtranCellData.csv ]
then
   rm UtranCellData.csv
fi

CELLRANGE=`cat "$PWD/../customdata/GsmTopology.csv" | grep -i "SIM:$simNum;NODE:$NODENAME" | awk -F"INTRARANGE:" '{print $2}' | awk -F";" '{print $1}' | head -n+1`
STARTCELL=$(echo $CELLRANGE | awk -F"-" '{print $1}')
ENDCELL=$(echo $CELLRANGE | awk -F"-" '{print $2}')
NUMOFCELLS=`expr $ENDCELL - $STARTCELL + 1`

numOfrequiredUtranCells=`expr $NUMOFCELLS \* $EXTUTRANPERCELL`
numOfIrathomUtranCells=`cat $wranHandOverFile | wc -l`
UTRANCELL=1

if [ "$numOfIrathomUtranCells" -lt "$numOfrequiredUtranCells" ]
then
   echo "###.... Number of UtranCells are not sufficient to create External Utran network !!...###"
   exit 1
fi
#### Creating External UtraNetwork ############
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1"
    identity "1"
    moType BscM:UtraNetwork
    exception none
    nrOfAttributes 2
    "utraNetworkId" String "1"
    "coexUmtstInt" Uint16 1000
)
MOSC
#### Creating External Utran Cells ############
utranCellCount=1
while [ "$STARTCELL" -le "$ENDCELL" ]
do
  geranCellValue=`expr 1000000 + $STARTCELL`
  utranDataStartPointer=$(expr $(expr $STARTCELL \* $EXTUTRANPERCELL) - $EXTUTRANPERCELL + 1)
  utranDataEndPointer=$(expr $STARTCELL \* $EXTUTRANPERCELL)
  while [ "$utranDataStartPointer" -le "$utranDataEndPointer" ]
  do
    utranDataPointer=`expr $utranDataStartPointer % $numOfIrathomUtranCells`
    if [ $utranDataPointer -eq 0 ]
    then
       utranDataPointer=$numOfIrathomUtranCells
    fi
    utranData=`awk 'NR=='$utranDataPointer $wranHandOverFile`
    lacId=`echo $utranData | awk -F"LAC=" '{print $2}' | awk -F";" '{print $1}'`
    rncId=`echo $utranData | awk -F"RNCID=" '{print $2}' | awk -F";" '{print $1}'`
    rncId=`expr $rncId + 0`
    cellId=`echo $utranData | awk -F";CID=" '{print $2}' | awk -F";" '{print $1}'`
    fddArfcn=`echo $utranData | awk -F";ARFCNVDL=" '{print $2}' | awk -F";" '{print $1}'`
    scrCode=`echo $utranData | awk -F";SCR=" '{print $2}' | awk -F";" '{print $1}'`
    uarfiList=$fddArfcn"-"$scrCode"-NODIV"
    utranId=$MCC"-"$MNC"-"$lacId"-"$cellId"-"$rncId
    echo "SIM:$simNum;NODENAME:$NODENAME;CELL:$STARTCELL;UtranCellId=$utranCellCount;UTRANID=$utranId" >> UtranCellData.csv
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:UtraNetwork=1"
    identity "$utranCellCount"
    moType BscM:ExternalUtranCell
    exception none
    nrOfAttributes 6
    "externalUtranCellId" String "$utranCellCount"
    "fddArfcn" Uint16 $fddArfcn
    "externalUtranCellIndividual" Uint16 $utranCellCount
    "scrCode" Uint16 "$scrCode"
    "utranId" String "$utranId"
    "mrsl" Uint8 2
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$geranCellValue"
    identity "1"
    moType BscM:Mobility
    exception none
    nrOfAttributes 1
    "mobilityId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$geranCellValue,BscM:Mobility=1"
    identity "1"
    moType BscM:InterRanMobility
    exception none
    nrOfAttributes 1
    "interRanMobilityId" String "1"
)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$geranCellValue,BscM:Mobility=1,BscM:InterRanMobility=1"
    exception none
    nrOfAttributes 2
    "umfiIdleList" Array String 1
        $uarfiList
    "umfiActiveList" Array String 1
        $uarfiList
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$geranCellValue,BscM:Mobility=1,BscM:InterRanMobility=1"
    identity "$fddArfcn"
    moType BscM:UtranFddFrequency
    exception none
    nrOfAttributes 6
    "utranFddFrequencyId" String "$fddArfcn"
    "coverageU" Integer 0
    "ratPrioU" Uint8 "null"
    "hPrioThrU" Uint8 9
    "lPrioThrU" Uint8 9
    "qRxLevMinU" Uint8 0
)
MOSC
    utranDataStartPointer=`expr $utranDataStartPointer + 1`
    utranCellCount=`expr $utranCellCount + 1`
  done
 STARTCELL=`expr $STARTCELL + 1`
done
### Creating UtranRelations #######
numOfExtUtranCells=`cat UtranCellData.csv | wc -l`
STARTCELL=$(echo $CELLRANGE | awk -F"-" '{print $1}')
CELLCOUNT=$STARTCELL
utranRelationCount=1
while [ "$CELLCOUNT" -le "$ENDCELL" ]
do
  filePointer=`expr $CELLCOUNT - $STARTCELL + 1`
  relationCount=1
  while [ "$relationCount" -le "$NUMOFUTRANRELPERCELL" ]
  do
    if [ "$filePointer" -gt "$numOfExtUtranCells" ]
    then
       filePointer=1
    fi
    utranData=`awk 'NR=='$filePointer UtranCellData.csv`
    cellId=`expr $CELLCOUNT + 1000000`
    utranRelation=$(echo $utranData | awk -F"UtranCellId=" '{print $2}' | awk -F";" '{print $1}')
    echo "CELL:$cellId;UTRANRELATION:$utranRelation"
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$cellId"
    identity "$utranRelationCount"
    moType BscM:UtranCellRelation
    exception none
    nrOfAttributes 2
    "utranCellRelationId" String "$utranRelation"
    "utranCellRelationIndividual" Uint16 $utranRelationCount
)
MOSC

    filePointer=`expr $filePointer + 1`
    relationCount=`expr $relationCount + 1`
    utranRelationCount=`expr $utranRelationCount + 1`
  done
  CELLCOUNT=`expr $CELLCOUNT + 1`
done
rm UtranCellData.csv
utranRelationCount=`expr $utranRelationCount - 1`
utranCellCount=`expr $utranCellCount - 1`
echo "NodeName=$NODENAME;ExternalUtranCells=$utranCellCount" >> $PWD/../customdata/NetworkStats.csv
#echo "NodeName=$NODENAME;ExternalUtranCells=$utranCellCount" >> preBuildGSMCounts.csv
echo "NodeName=$NODENAME;UtranRelations=$utranRelationCount" >> $PWD/../customdata/NetworkStats.csv
#echo "NodeName=$NODENAME;UtranRelations=$utranRelationCount" >> preBuildGSMCounts.csv
