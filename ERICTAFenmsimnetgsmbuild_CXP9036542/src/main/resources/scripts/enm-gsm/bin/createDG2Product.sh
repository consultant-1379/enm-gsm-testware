#!/bin/sh
# VERSION HISTORY
####################################################################################
#     Version     : 1.8
#
#     Revision    : CXP 903 6542-1-26
#
#     Author      : znrvbia
#
#     JIRA        : NSS-44314
#
#     Description : Adding fileLocation attribute value under CcpdService MO in GSM RadioNodes
#
#     Date        : 23rd JUNE 2023
####################################################################################
#     Version     : 1.7
#
#     Revision    : CXP 903 6542-1-24
#
#     Author      : zmogsiv
#
#     JIRA        : NSS-41425
#
#     Description : Adding enrollmentSupport attribute in GSM RadioNodes
#
#     Date        : 15th NOV 2022
#
####################################################################################
#     Version     : 1.6
#
#     Revision    : CXP 903 6542-1-23
#
#     Author      : znrvbia
#
#     JIRA        : NSS-41461
#
#     Description : Adding correct MO structure and there values for RcsRem fragment
#
#     Date        : 22nd Nov 2022
#
####################################################################################
####################################################################################
#     Version     : 1.5
#
#     Revision    : CXP 903 6542-1-20
#
#     Author      : znrvbia
#
#     JIRA        : NSS-37802
#
#     Description : creates RfPort MOs in GSM RadioNodes
#
#     Date        : 20th Jan 2022
#
####################################################################################
####################################################################################
#     Version     : 1.4
#
#     Revision    : CXP 903 6542-1-18
#
#     Author      : zhainic
#
#     JIRA        : NSS-37850
#
#     Description : creates UL Spectrum Analyzer MO in GSM RadioNodes
#
#     Date        : 17th Dec 2021
#
####################################################################################
####################################################################################
#     Version     : 1.3
#
#     Revision    : CXP 903 6542-1-17
#
#     Author      : znrvbia
#
#     JIRA        : NSS-37802
#
#     Description : creates UL Spectrum Analyzer MO in GSM RadioNodes
#
#     Date        : 06th Dec 2021
#
####################################################################################
#####################################################################################
#     Version     : 1.2
#
#     Revision    : CXP 903 6542-1-2
#
#     Author      : zyamkan
#
#     JIRA        : NSS-27634
#
#     Description : creates OAMAccesspoint MO in GSM RadioNodes
#
#     Date        : 06th Nov 2019
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

echo "#####################################################################"
echo "# $0 script Started Execution"
echo "---------------------------------------------------------------------"

if [ "$#" -ne 4  ]
then
 echo
 echo "Usage: $0 <sim name> <node name> <numOfradioNodes>"
 echo
 echo "Example: RNCV71569x1-FT-PRBS17Ax2-RNC01 CONFIG.env 1"
 echo
 echo "------------ERROR: Please give inputs correctly---------------------"
 echo
 echo " $0 script ended ERRONEOUSLY !!!!"
 echo "####################################################################"
 exit 1
fi

SIMNAME=$1
BASENAME=$2
NUMOFMSRBS=$3
NODEMIM=$4

. $PWD/../dat/Product.env
PWD=`pwd`
NOW=`date +"%Y_%m_%d_%T:%N"`
TIME=`date '+%FT04:04:04.666%:z'`

MSRBSVERSION=`cat ../dat/Build.env | grep ^"NODEVERSION" | cut -d "=" -f 2 | cut -d "\"" -f 2`
NodeVersionInNumbers=`cat ../dat/Build.env | grep ^"NODEVERSION" | cut -d "=" -f 2 | cut -d "\"" -f 2 | sed 's/[A-Z]//g' | sed 's/-//g'`
MSRBSNode="MSRBS"
STR1=${MSRBSNode}".*V2.*"
vals1=(${MSRBSVERSION//-/ })
for i in "${vals1[@]}"
do
STR1=$STR1$i".*"
done
echo $STR1
MSRBS_Link=`cat /netsim/simdepContents/nodeTemplate.content | grep -o '.*' | grep $STR1 | cut -d "\"" -f 2`
echo  "node templates is  ${MSRBS_Link} "
MSRBS_Template=`echo $MSRBS_Link | awk -F '/' '{print $NF}'`
MSRBS_Template_WithoutZIP=`echo $MSRBS_Template | cut -d "." -f1`

echo $MSRBS_Template_WithoutZIP is the node Template folder.

etcmcucp=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "etcm_cucp" | awk -F "cucp_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`
etcmcuup=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "etcm_cuup" | awk -F "cuup_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`
etcmdu=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "etcm_du" | awk -F "du_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`

ftemcucp=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "ftem_cucp" | awk -F "cucp_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`
ftemcuup=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "ftem_cuup" | awk -F "cuup_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`
ftemdu=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "ftem_du" | awk -F "du_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`

pmcucp=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "pm_event_package_cucp" | awk -F "cucp_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`
pmcuup=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "pm_event_package_cuup" | awk -F "cuup_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`
pmdu=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "pm_event_package_du" | awk -F "du_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`

#NODEMIM=`getMimType $RNCCOUNT $DG2VERSIONARRAY`
IFS=";"
for x in $DG2PRODUCTARRAY
do
  MIMVERSION=$(echo $x | awk -F"," '{print $1}')
  if [ "$MIMVERSION" == "$NODEMIM" ]
  then
     productNumber=$(echo $x | awk -F"," '{print $2}' | awk -F":" '{print $1}')
     productRevision=$(echo $x | awk -F":" '{print $2}')
     break
  fi
done

echo "Prod Number: $productNumber"
echo "Prod version: $productRevision"

MOSCRIPT=$0".mo"
MMLSCRIPT=$0".mml"

if [ -f $PWD/$MOSCRIPT ]
then
rm -r  $PWD/$MOSCRIPT
echo "old "$PWD/$MOSCRIPT " removed"
fi

if [ -f $PWD/$MMLSCRIPT ]
then
rm -r  $PWD/$MMLSCRIPT
echo "old "$PWD/$MMLSCRIPT " removed"
fi

COUNT=1

while [ "$COUNT" -le "$NUMOFMSRBS"  ]
do
if [ $COUNT -le 9 ]
then
NODENAME=$BASENAME'MSRBS-V20'$COUNT
else
NODENAME=$BASENAME'MSRBS-V2'$COUNT
fi
#NodeVersion=`echo -e ".open $SIM \n .show simnes" | /netsim/inst/netsim_shell | grep "LTE MSRBS-V2" | grep "$NODE"  | awk -F 'LTE MSRBS-V2 ' '{print $2}' | cut -d " " -f1 | sed 's/[A-Z]//g' | sed 's/-//g'`


MOSCRIPT=$NODENAME"_radioProductNode.mo"
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ManagedElement=$NODENAME,SystemFunctions=1,HwInventory=1"
    identity 1
    moType HwItem
    exception none
    nrOfAttributes 18
    "hwItemId" String "1"
    "vendorName" String "Ericsson"
    "hwModel" String "RadioNode"
    "hwType" String "Blade"
    "hwName" String "GEP3-24GB"
    "hwCapability" String ""
    "equipmentMoRef" Array Ref 0
    "additionalInformation" String ""
    "hwUnitLocation" String ""
    "manualDataEntry" Integer 1
    "serialNumber" String ""
    "swInvMoRef" Array Ref 0
    "licMgmtMoRef" Array Ref 0
    "additionalAttributes" Array Struct 0
    "productIdentity" Struct
        nrOfElements 3
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productDesignation" String ""

    "productData" Struct
        nrOfElements 6
        "productName" String "$NODENAME"
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productionDate" String "$NOW"
        "description" String ""
        "type" String "1"

)


CREATE
(
    parent "ManagedElement=$NODENAME,SystemFunctions=1,HwInventory=1,HwItem=1"
    identity 1
    moType HwItem
    exception none
    nrOfAttributes 18
    "hwItemId" String "1"
    "vendorName" String "Ericsson"
    "hwModel" String "RadioNode"
    "hwType" String "Blade"
    "hwName" String "GEP3-24GB"
    "hwCapability" String ""
    "equipmentMoRef" Array Ref 0
    "additionalInformation" String ""
    "hwUnitLocation" String ""
    "manualDataEntry" Integer 1
    "serialNumber" String ""
    "swInvMoRef" Array Ref 0
    "licMgmtMoRef" Array Ref 0
    "additionalAttributes" Array Struct 0
    "productIdentity" Struct
        nrOfElements 3
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productDesignation" String ""

    "productData" Struct
        nrOfElements 6
        "productName" String "$NODENAME"
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productionDate" String "$NOW"
        "description" String ""
        "type" String "1"

)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsBrM:BrM=1,RcsBrM:BrmBackupManager=1"
    exception none
    nrOfAttributes 2
    "backupType" String "Systemdata"
    "backupDomain" String "System"
)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsBrM:BrM=1,RcsBrM:BrmBackupManager=1,RcsBrM:BrmBackupLabelStore=1"
    exception none
    nrOfAttributes 4
    "lastRestoredBackup" String "${NODENAME}_Restored"
    "lastImportedBackup" String "${NODENAME}_Imported"
    "lastExportedBackup" String "${NODENAME}_Exported"
    "lastCreatedBackup" String "${NODENAME}_Created"
)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsBrM:BrM=1,RcsBrM:BrmBackupManager=1,RcsBrM:BrmBackup=1"
    exception none
    nrOfAttributes 3
    "backupName" String "1"
    "creationType" Integer 3
    "creationTime" String "$TIME"
    "swVersion" Array Struct 1
        nrOfElements 6
        "productName" String "$NODENAME"
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productionDate" String "$NOW"
        "description" String "RadioNode"
        "type" String "RadioNode"

)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsHwIM:HwInventory=1,RcsHwIM:HwItem=1,RcsHwIM:HwItem=1"
    exception none
    nrOfAttributes 1
    "productIdentity" Struct
        nrOfElements 3
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productDesignation" String ""

)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsHwIM:HwInventory=1,RcsHwIM:HwItem=1,RcsHwIM:HwItem=1"
    exception none
    nrOfAttributes 1
    "productData" Struct
        nrOfElements 6
        "productName" String "$NODENAME"
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productionDate" String "$NOW"
        "description" String ""
        "type" String "1"

)

CREATE
(
    parent "ManagedElement=$NODENAME,SystemFunctions=1,HwInventory=1"
    identity 2
    moType HwItem
    exception none
    nrOfAttributes 18
    "hwItemId" String "2"
    "vendorName" String "Ericsson"
    "hwModel" String "RadioNode"
    "hwType" String "Blade"
    "hwName" String "GEP3-HD300"
    "hwCapability" String ""
    "equipmentMoRef" Array Ref 0
    "additionalInformation" String ""
    "hwUnitLocation" String ""
    "manualDataEntry" Integer 1
    "serialNumber" String ""
    "swInvMoRef" Array Ref 0
    "licMgmtMoRef" Array Ref 0
    "additionalAttributes" Array Struct 0
    "productIdentity" Struct
        nrOfElements 3
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productDesignation" String ""

    "productData" Struct
        nrOfElements 6
        "productName" String "$NODENAME"
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productionDate" String "$NOW"
        "description" String ""
        "type" String "1"

)
CREATE
(
    parent "ManagedElement=$NODENAME,SystemFunctions=1,HwInventory=1,HwItem=2"
    identity 2
    moType HwItem
    exception none
    nrOfAttributes 18
    "hwItemId" String "2"
    "vendorName" String "Ericsson"
    "hwModel" String "RadioNode"
    "hwType" String "Blade"
    "hwName" String "GEP3-HD300"
    "hwCapability" String ""
    "equipmentMoRef" Array Ref 0
    "additionalInformation" String ""
    "hwUnitLocation" String ""
    "manualDataEntry" Integer 1
    "serialNumber" String ""
    "swInvMoRef" Array Ref 0
    "licMgmtMoRef" Array Ref 0
    "additionalAttributes" Array Struct 0
    "productIdentity" Struct
        nrOfElements 3
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productDesignation" String ""

    "productData" Struct
        nrOfElements 6
        "productName" String "$NODENAME"
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productionDate" String "$NOW"
        "description" String ""
        "type" String "1"

)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsHwIM:HwInventory=1,RcsHwIM:HwItem=2,RcsHwIM:HwItem=2"
    exception none
    nrOfAttributes 1
    "productIdentity" Struct
        nrOfElements 3
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productDesignation" String ""

)

SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsHwIM:HwInventory=1,RcsHwIM:HwItem=2,RcsHwIM:HwItem=2"
    // moid = 6007
    exception none
    nrOfAttributes 1
    "productData" Struct
        nrOfElements 6
        "productName" String "$NODENAME"
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productionDate" String "$NOW"
        "description" String ""
        "type" String "1"

)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSwIM:SwInventory=1,RcsSwIM:SwItem=1"
    exception none
    nrOfAttributes 1
    "administrativeData" Struct
        nrOfElements 6
        "productName" String "$NODENAME"
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productionDate" String "$NOW"
        "description" String ""
        "type" String "1"

)

SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSwIM:SwInventory=1,RcsSwIM:SwVersion=1"
    exception none
    nrOfAttributes 1
    "administrativeData" Struct
        nrOfElements 6
        "productName" String "$NODENAME"
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productionDate" String "$NOW"
        "description" String ""
        "type" String "1"

)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSwIM:SwInventory=1,RcsSwIM:SwItem=1"
    exception none
    nrOfAttributes 1
    "consistsOf" Array Ref 1
        ManagedElement=$NODENAME,SystemFunctions=1,SwInventory=1,SwVersion=1
)


SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSwIM:SwInventory=1,RcsSwIM:SwVersion=1"
    exception none
    nrOfAttributes 1
    "consistsOf" Array Ref 1
        ManagedElement=$NODENAME,SystemFunctions=1,SwInventory=1,SwItem=1
)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSwIM:SwInventory=1"
    exception none
    nrOfAttributes 1
    "active" Array Ref 1
        ManagedElement=$NODENAME,SystemFunctions=1,SwInventory=1,SwVersion=1
)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsPMEventM:PmEventM=1,RcsPMEventM:EventProducer=Lrat,RcsPMEventM:FilePullCapabilities=2"
    exception none
    nrOfAttributes 1
    "outputDirectory" String "/c/pm_data/"
)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsPm:Pm=1,RcsPm:PmMeasurementCapabilities=1"
    exception none
    nrOfAttributes 1
    "fileLocation" String "/c/pm_data/"
)
CREATE
(
parent "ComTop:ManagedElement=$NODENAME,RmeSupport:NodeSupport=1"
identity "1"
moType RmeUlSpectrumAnalyzer:UlSpectrumAnalyzer
exception none
nrOfAttributes 1
"ulSpectrumAnalyzerId" String "1"
)
MOSC

if [[ $NodeVersionInNumbers -eq 2333 ]]
then

cat >> $MOSCRIPT << MOSC

SET
 (
      mo "ComTop:ManagedElement=$NODENAME,RmeSupport:NodeSupport=1,RmeCcpdService:CcpdService=1"
      exception none
      nrOfAttributes 1
      "fileLocation" String "/productdata"
 )

MOSC
fi

cat >> $MOSCRIPT << MOSC

CREATE
(
parent "ComTop:ManagedElement=$NODENAME,ReqEquipment:Equipment=1"
identity "1"
moType ReqFieldReplaceableUnit:FieldReplaceableUnit
exception none
nrOfAttributes 1
"fieldReplaceableUnitId" String "1"
)
CREATE
(
parent "ComTop:ManagedElement=$NODENAME,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
identity "A"
moType ReqRfPort:RfPort
exception none
nrOfAttributes 1
"rfPortId" String "A"
"administrativeState" Integer 1
"ulFrequencyRanges" String "3550000-3700000 KHz"
)
CREATE
(
parent "ComTop:ManagedElement=$NODENAME,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
identity "B"
moType ReqRfPort:RfPort
exception none
nrOfAttributes 1
"rfPortId" String "B"
"administrativeState" Integer 1
"ulFrequencyRanges" String "3550000-3700000 KHz"
)
CREATE
(
parent "ComTop:ManagedElement=$NODENAME,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
identity "C"
moType ReqRfPort:RfPort
exception none
nrOfAttributes 1
"rfPortId" String "C"
"administrativeState" Integer 1
"ulFrequencyRanges" String "3550000-3700000 KHz"
)
CREATE
(
parent "ComTop:ManagedElement=$NODENAME,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
identity "D"
moType ReqRfPort:RfPort
exception none
nrOfAttributes 1
"rfPortId" String "D"
"administrativeState" Integer 1
"ulFrequencyRanges" String "3550000-3700000 KHz"
)
CREATE
(
parent "ManagedElement=$NODENAME,SystemFunctions=1,LogM=1"
moType RcsLogM:Log
identity AiLog
exception none
nrOfAttributes 1
"logId" String "AiLog"
)
CREATE
(
parent "ManagedElement=$NODENAME,SystemFunctions=1,LogM=1"
moType RcsLogM:Log
identity HcLog
exception none
nrOfAttributes 1
"logId" String "HcLog"
)
CREATE
(
parent "ManagedElement=$NODENAME,SystemFunctions=1,LogM=1"
moType RcsLogM:Log
identity HealthCheckLog
exception none
nrOfAttributes 1
"logId" String "HealthCheckLog"
)
CREATE
(
parent "ManagedElement=$NODENAME,SystemFunctions=1,LogM=1"
moType RcsLogM:Log
identity AlarmLog
exception none
nrOfAttributes 1
"logId" String "AlarmLog"
)

CREATE
(
parent "ManagedElement=$NODENAME,SystemFunctions=1,LogM=1"
moType RcsLogM:Log
identity AuditTrailLog
exception none
nrOfAttributes 1
"logId" String "AuditTrailLog"
 )

CREATE
(
parent "ManagedElement=$NODENAME,SystemFunctions=1,LogM=1"
moType RcsLogM:Log
identity SecurityLog
exception none
nrOfAttributes 1
"logId" String "SecurityLog"
)

CREATE
(
parent "ManagedElement=$NODENAME,SystemFunctions=1,LogM=1"
moType RcsLogM:Log
identity SwmLog
exception none
nrOfAttributes 1
"logId" String "SwmLog"
)

CREATE
(
parent "ManagedElement=$NODENAME,SystemFunctions=1,LogM=1"
moType RcsLogM:Log
identity TnApplicationLog
exception none
nrOfAttributes 1
"logId" String "TnApplicationLog"
)

CREATE
(
parent "ManagedElement=$NODENAME,SystemFunctions=1,LogM=1"
moType RcsLogM:Log
identity TnNetworkLog
exception none
nrOfAttributes 1
"logId" String "TnNetworkLog"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:Transport=1"
    identity "OAM"
    moType RtnL3Router:Router
    exception none
    nrOfAttributes 1
    "routerId" String "OAM" 
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:Transport=1,RtnL3Router:Router=OAM"
    identity "1"
    moType RtnL3InterfaceIPv4:InterfaceIPv4
    exception none
    nrOfAttributes 1
    "interfaceIPv4Id" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:Transport=1,RtnL3Router:Router=OAM,RtnL3InterfaceIPv4:InterfaceIPv4=1"
    identity "1"
    moType RtnL3InterfaceIPv4:AddressIPv4
    exception none
    nrOfAttributes 1
    "addressIPv4Id" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSysM:SysM=1,RcsRem:RuntimeExportM=1,RcsRem:PmEventSpecification=1"
    identity "1"
    moType RcsRem:LtePmEvents
    exception none
    nrOfAttributes 4
    "ltePmEventsId" String "1"
    "documentNumber" String "null"
    "ffv" String "null"
    "revision" String "null"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSysM:SysM=1,RcsRem:RuntimeExportM=1,RcsRem:PmEventSpecification=1"
    identity "1"
    moType RcsRem:NrPmEvents
    exception none
    nrOfAttributes 3
    "nrPmEventsId" String "1"
    "managedFunction" String "CUCP"
    "version" String "$pmcucp"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSysM:SysM=1,RcsRem:RuntimeExportM=1,RcsRem:PmEventSpecification=1"
    identity "2"
    moType RcsRem:NrPmEvents
    exception none
    nrOfAttributes 3
    "nrPmEventsId" String "2"
    "managedFunction" String "CUUP"
    "version" String "$pmcuup"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSysM:SysM=1,RcsRem:RuntimeExportM=1,RcsRem:PmEventSpecification=1"
    identity "3"
    moType RcsRem:NrPmEvents
    exception none
    nrOfAttributes 3
    "nrPmEventsId" String "3"
    "managedFunction" String "DU"
    "version" String "$pmdu"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSysM:SysM=1,RcsRem:RuntimeExportM=1,RcsRem:EbsCounterSpecification=1"
    identity "2"
    moType RcsRem:NrEtcm
    exception none
    nrOfAttributes 3
    "nrEtcmId" String "2"
    "version" String "$etcmcuup"
    "managedFunction" String "CUUP"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSysM:SysM=1,RcsRem:RuntimeExportM=1,RcsRem:EbsCounterSpecification=1"
    identity "3"
    moType RcsRem:NrEtcm
    exception none
    nrOfAttributes 3
    "nrEtcmId" String "3"
    "version" String "$etcmdu"
    "managedFunction" String "DU"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSysM:SysM=1,RcsRem:RuntimeExportM=1,RcsRem:EbsCounterSpecification=1"
    identity "2"
    moType RcsRem:NrFtem
    exception none
    nrOfAttributes 3
    "nrFtemId" String "2"
    "version" String "$ftemcuup"
    "managedFunction" String "CUUP"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSysM:SysM=1,RcsRem:RuntimeExportM=1,RcsRem:EbsCounterSpecification=1"
    identity "3"
    moType RcsRem:NrFtem
    exception none
    nrOfAttributes 3
    "nrFtemId" String "3"
    "version" String "$ftemdu"
    "managedFunction" String "DU"
)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSysM:SysM=1,RcsRem:RuntimeExportM=1,RcsRem:EbsCounterSpecification=1,RcsRem:NrFtem=1"
    exception none
    nrOfAttributes 2
    "version" String "$ftemcucp"
    "managedFunction" String "CUCP"
)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSysM:SysM=1,RcsRem:RuntimeExportM=1,RcsRem:EbsCounterSpecification=1,RcsRem:NrEtcm=1"
    exception none
    nrOfAttributes 2
    "version" String "$etcmcucp"
    "managedFunction" String "CUCP"
)

SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSecM:SecM=1,RcsCertM:CertM=1,RcsCertM:CertMCapabilities=1"
    exception none
    nrOfAttributes 1
    "enrollmentSupport" Array Integer 3
         0
         1
         3
)


MOSC
echo '.open '$SIMNAME >> $MMLSCRIPT
echo '.select '$NODENAME >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT
/netsim/inst/netsim_shell < $MMLSCRIPT
rm -rf $MMLSCRIPT
rm -rf $MOSCRIPT
COUNT=`expr $COUNT + 1`
done

echo "-------------------------------------------------------------------"
echo "# $0 script ended Execution"
echo "###################################################################"
