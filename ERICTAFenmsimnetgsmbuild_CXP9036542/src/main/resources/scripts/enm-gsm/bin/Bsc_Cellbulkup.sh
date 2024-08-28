#!/bin/sh
### VERSION HISTORY
#####################################################################################
#     Version     : 1.5
#
#     Revision    : CXP 903 6542-1-21
#
#     Author      : zmogsiv
#
#     JIRA        : NSS-38490
#
#     Description : Making the below MOs set for vBSC type Cell also
#
#     Date        : 04th Feb 2022
#
####################################################################################
####################################################################################
#     Version     : 1.4
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
#     Version     : 1.3
#
#     Revision    : CXP 903 6542-1-11
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-34531
#
#     Description : Updating BSC HierarchicalCellStructure.layerThr attribute value is -75 
#
#     Date        : 05th Apr 2021
#
####################################################################################
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
 echo "Usage: $0 <sim name> <sim number>"
 echo
 echo "Example: $0 GSM-FT-150cell_BSC_17-Q4_V4x9-GSM01 1"
 echo
 exit 1
fi

SIM=$1
simNum="${SIM:(-2)}"
SIMNUM=`expr $simNum + 0`
PWD=`pwd`

. $PWD/../dat/Build.env
createNodeData() {
SIM=$1
NODENAME=$2
STARTCELL=$3
ENDCELL=$4
NUMOFCELLS=$5
MOSCRIPT=$NODENAME"_Bulkup.mo"
## Creating File Group Mos #############
GROUPNUM=`expr $NUMOFCELLS / 2`
COUNT=1
OFFSET="45"
DIVOFF="20"

if [[ "$NUMOFCELLS" -ge "500" ]]
then
OBJECT="0"
else
OBJECT=`expr $NUMOFCELLS \* $OFFSET`
fi

OBJECTNUM=`expr $OBJECT / $DIVOFF`
## Bulking Up Cell Internal Mos #####################################
CELLID=$STARTCELL
while [[ "$CELLID" -le "$ENDCELL" ]]
do
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLID"
    identity "1"
    moType BscM:OverlaidSubcell
    exception none
    nrOfAttributes 1
    "overlaidSubcellId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLID,BscM:OverlaidSubcell=1"
    identity "1"
    moType BscM:ChannelAllocAndOptOverlaid
    exception none
    nrOfAttributes 1
    "channelAllocAndOptOverlaidId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLID"
    identity "1"
    moType BscM:Gprs
    exception none
    nrOfAttributes 1
    "gprsId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLID"
    identity "1"
    moType BscM:HierarchicalCellStructure
    exception none
    nrOfAttributes 2
    "hierarchicalCellStructureId" String "1"
    "layerThr" Int16 "-75"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLID"
    identity "1"
    moType BscM:IdleModeAndPaging
    exception none
    nrOfAttributes 1
    "idleModeAndPagingId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLID"
    identity "1"
    moType BscM:LchAvailSupervision
    exception none
    nrOfAttributes 1
    "lchAvailSupervisionId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLID"
    identity "1"
    moType BscM:MsQueuing
    exception none
    nrOfAttributes 3
    "msQueuingId" String "1"
    "qLength" Uint8 5
    "resLimit" Uint8 25
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLID"
    identity "1"
    moType BscM:PowerControl
    exception none
    nrOfAttributes 3
    "powerControlId" String "1"
    "amrPcState" Integer 0
    "hpbState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLID"
    identity "1"
    moType BscM:PowerSavings
    exception none
    nrOfAttributes 1
    "powerSavingsId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLID"
    identity "1"
    moType BscM:SmsCellBroadcast
    exception none
    nrOfAttributes 4
    "smsCellBroadcastId" String "1"
    "drx" Integer 0
    "fSlots" Uint8 4
    "speriod" Uint8 40
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLID"
    identity "1"
    moType BscM:Son
    exception none
    nrOfAttributes 1
    "sonId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLID,BscM:Gprs=1"
    identity "1"
    moType BscM:LinkQualityControl
    exception none
    nrOfAttributes 1
    "linkQualityControlId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLID,BscM:Gprs=1"
    identity "1"
    moType BscM:TbfReservation
    exception none
    nrOfAttributes 1
    "tbfReservationId" String "1"
)


CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLID,BscM:Mobility=1"
    identity "1"
    moType BscM:LocatingFilter
    exception none
    nrOfAttributes 1
    "locatingFilterId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLID,BscM:Mobility=1"
    identity "1"
    moType BscM:LocatingIntraCellHandover
    exception none
    nrOfAttributes 1
    "locatingIntraCellHandoverId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLID,BscM:Mobility=1"
    identity "1"
    moType BscM:LocatingPenalty
    exception none
    nrOfAttributes 1
    "locatingPenaltyId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLID,BscM:Mobility=1"
    identity "1"
    moType BscM:LocatingUrgency
    exception none
    nrOfAttributes 1
    "locatingUrgencyId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLID,BscM:Mobility=1"
    identity "1"
    moType BscM:RadioLinkTimeout
    exception none
    nrOfAttributes 1
    "radioLinkTimeoutId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLID,BscM:PowerControl=1"
    identity "1"
    moType BscM:PowerControlDownlink
    exception none
    nrOfAttributes 1
    "powerControlDownlinkId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLID,BscM:PowerControl=1"
    identity "1"
    moType BscM:PowerControlUplink
    exception none
    nrOfAttributes 1
    "powerControlUplinkId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLID,BscM:OverlaidSubcell=1,BscM:ChannelAllocAndOptOverlaid=1"
    identity "1"
    moType BscM:DiffChannelAllocPrioOverlaid
    exception none
    nrOfAttributes 1
    "diffChannelAllocPrioOverlaidId" String "1"
)
MOSC
CELLID=`expr $CELLID + 1`
done
#######################################################
MMLSCRIPT=$NODENAME"_Bulkup.mml"
## Creating MMLSCRIPT #################################
cat >> $MMLSCRIPT << MML
.open $SIM
.select $NODENAME
.start
useattributecharacteristics:switch="off";
kertayle:file="$PWD/$MOSCRIPT";
MML
~/inst/netsim_shell < $MMLSCRIPT
rm $MMLSCRIPT
rm $MOSCRIPT
echo "BulkupScript successfully Executed on $NODENAME"
}

###### MAIN ###########

NODELIST=`echo -e '.open '$SIM' \n .show simnes' | ~/inst/netsim_shell | grep -e "LTE BSC $BSCNODEVERSION" -e "LTE vBSC $BSCNODEVERSION" | cut -d' ' -f1`
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
  echo "NodeName: $NODENAME ; StartCell: $STARTCELL ; EndCell: $ENDCELL"
  REPLY=`createNodeData $SIM $NODENAME $STARTCELL $ENDCELL $CellsPerNode`
  if [ "$REPLY" == "" ]
  then
     echo "Script Failed at $NODENAME ...!!! "
     exit 1
  else
     echo "$REPLY"
  fi
  NODECOUNT=`expr $NODECOUNT + 1`
done
