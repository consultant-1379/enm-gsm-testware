#!/bin/sh
### VERSION HISTORY
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
 echo "Usage: $0 <sim name> <sim number>"
 echo
 echo "Example: $0 GSM-FT-150cell_BSC_17-Q4_V4x9-GSM01 1"
 echo
 exit 1
fi

SIM=$1
NODENAME=$2
NUMOFCELLS=$3

MOSCRIPT=$NODENAME"_Bulkup.mo"
## Creating File Group Mos #############
GROUPNUM=`expr $NUMOFCELLS / 2`
COUNT=1
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemHandling=1"
    identity "1"
    moType AxeLicenseManagement:LicenseM
    exception none
    nrOfAttributes 4
    "licenseMId" String "1"
    "emergencyActivationCount" Uint32 0
    "licenseMode" Integer 1
    "maintenanceMode" Integer 0
)
MOSC
while [ "$COUNT" -le "$GROUPNUM" ]
do
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,ComFileM:FileM=1,ComFileM:LogicalFs=1"
    identity "$COUNT"
    moType ComFileM:FileGroup
    exception none
    nrOfAttributes 4
    "files" Array Struct 0
    "fileGroupId" String "$COUNT"
    "reservedByPolicy" Ref "null"
    "internalHousekeeping" Boolean true
)
MOSC
Count=1
while [ "$Count" -le "$GROUPNUM" ]
do
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,ComFileM:FileM=1,ComFileM:LogicalFs=1,ComFileM:FileGroup=$COUNT"
    identity "$Count"
    moType ComFileM:FileGroup
    exception none
    nrOfAttributes 4
    "files" Array Struct 0
    "fileGroupId" String "$Count"
    "reservedByPolicy" Ref "null"
    "internalHousekeeping" Boolean true
)
MOSC
Count=`expr $Count + 1`
done
COUNT=`expr $COUNT + 1`
done
#############################################

## Creating Counters ########################
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:DataOutputHandling=1"
    identity "1"
    moType AxeStatisticalCounter:StatisticalCounterM
    exception none
    nrOfAttributes 4
    "useUtcTimeStamps" Boolean true
    "nmcForcesSuspectFlag" Boolean false
    "vendorName" String "Ericsson"
    "counterCollectionState" Boolean true
)

// Create Statement generated: 2018-02-12 05:52:01
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:DataOutputHandling=1,AxeStatisticalCounter:StatisticalCounterM=1,AxeStatisticalCounter:CapacityInfo=1"
    exception none
    nrOfAttributes 3
    "capacityInfoId" String "1"
    "totalNumberOfCounters" Int64 0
    "totalNumberOfDIDPositions" Int64 0
)

// Create Statement generated: 2018-02-12 05:53:17
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:DataOutputHandling=1,AxeStatisticalCounter:StatisticalCounterM=1"
    identity "1"
    moType AxeStatisticalCounter:ObjectTypes
    exception none
    nrOfAttributes 1
    "objectTypesId" String "1"
)
MOSC
COUNT=1
OFFSET="45"
DIVOFF="20"

if [ "$NUMOFCELLS" -ge "500" ]
then
OBJECT="0"
else
OBJECT=`expr $NUMOFCELLS \* $OFFSET`
fi

OBJECTNUM=`expr $OBJECT / $DIVOFF`
while [ "$COUNT" -le "$OBJECTNUM" ]
do
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:DataOutputHandling=1,AxeStatisticalCounter:StatisticalCounterM=1,AxeStatisticalCounter:ObjectTypes=1"
		identity "$COUNT"
		moType AxeStatisticalCounter:ObjectType
		exception none
)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:DataOutputHandling=1,AxeStatisticalCounter:StatisticalCounterM=1,AxeStatisticalCounter:ObjectTypes=1,AxeStatisticalCounter:ObjectType=$COUNT"
    exception none
    nrOfAttributes 4
    "objectTypeId" String "$COUNT"
    "isIncluded" Boolean false
    "brp" Integer 15
    "category" Array String 0
)
MOSC
Count=1
while [ "$Count" -le "12" ]
do
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:DataOutputHandling=1,AxeStatisticalCounter:StatisticalCounterM=1,AxeStatisticalCounter:ObjectTypes=1,AxeStatisticalCounter:ObjectType=$COUNT"
	identity "$Count"
    moType AxeStatisticalCounter:Counter
    exception none
)

SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:DataOutputHandling=1,AxeStatisticalCounter:StatisticalCounterM=1,AxeStatisticalCounter:ObjectTypes=1,AxeStatisticalCounter:ObjectType=$COUNT,AxeStatisticalCounter:Counter=$Count"
    exception none
    nrOfAttributes 1
    "counterId" String "1"
)
MOSC
Count=`expr $Count + 1`
done
COUNT=`expr $COUNT + 1`
done
#####################################################################

## Bulking Up Cell Internal Mos #####################################

#######################################################
## Creating Alarm MOs #################################
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SupervisionHandling=1"
    // moid = 22114
    identity "1"
    moType AxeAlarmDisplay:AlarmDisplayM
    exception none
    nrOfAttributes 1
    "alarmDisplayMId" String "1"
)

// Create Statement generated: 2018-02-26 14:21:29
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SupervisionHandling=1,AxeAlarmDisplay:AlarmDisplayM=1"
    // moid = 22115
    identity "1"
    moType AxeAlarmDisplay:LampProperty
    exception none
    nrOfAttributes 5
    "lampPropertyId" String "1"
    "apzLamp" String "null"
    "aptLamp" String "null"
    "powerLamp" String "null"
    "extLamp" String "null"
)
MOSC

if [ "$NUMOFCELLS" -ge "500" ]
then
   DISPLAYOFFSET=25
else
   DISPLAYOFFSET=50
fi

DISPLAYCOUNT=`expr $NUMOFCELLS \* $DISPLAYOFFSET`
#echo "NumOfcells : $NUMOFCELLS"
#echo "DisplayCount: $DISPLAYOFFSET"
INDEX=1

while [ "$INDEX" -le "$DISPLAYCOUNT" ]
do
cat >> $MOSCRIPT << MOSC
// Create Statement generated: 2018-02-26 14:23:36
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SupervisionHandling=1,AxeAlarmDisplay:AlarmDisplayM=1"
    // moid = 22116
    identity "$INDEX"
    moType AxeAlarmDisplay:LocalAlarmDisplay
    exception none
    nrOfAttributes 9
    "localAlarmDisplayId" String "$INDEX"
    "alarmDisplaySource" Integer 0
    "information" String "null"
    "soundProperty" String "1"
    "lampProperty" String "1"
    "operationalState" Integer "null"
    "lampPropertyDn" Ref "null"
    "soundPropertyDn" Ref "null"
    "administrativeState" Integer 0
)
MOSC
INDEX=`expr $INDEX + 1`
done
INDEX=1

while [ "$INDEX" -le "$DISPLAYCOUNT" ]
do
cat >> $MOSCRIPT << MOSC
// Create Statement generated: 2018-02-26 14:24:38
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SupervisionHandling=1,AxeAlarmDisplay:AlarmDisplayM=1"
    // moid = 22117
    identity "$INDEX"
    moType AxeAlarmDisplay:RemoteAlarmListener
    exception none
    nrOfAttributes 5
    "remoteAlarmListenerId" String "$INDEX"
    "port" Int32 0
    "information" String "null"
    "operationalState" Integer "null"
    "administrativeState" Integer 0
)

MOSC
INDEX=`expr $INDEX + 1`
done
#######################################################


MMLSCRIPT=$NODENAME"_Bulkup.mml"
## Creating MMLSCRIPT #################################
cat >> $MMLSCRIPT << MML
.open $SIM
.select $NODENAME
.start
cmshell;
useattributecharacteristics:switch="off";
kertayle:file="$PWD/$MOSCRIPT";
MML
~/inst/netsim_shell < $MMLSCRIPT
rm $MMLSCRIPT
rm $MOSCRIPT
echo "Script successfully Executed"
