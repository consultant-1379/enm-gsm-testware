#!/bin/bash
### VERSION HISTORY
#####################################################################################
#     Version     : 1.2
#
#     Revision    : CXP 903 6542-1-8
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-34293
#
#     Description : Changing BSC and MSC Node names
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
########################################################################
simName=$1
SIMNUM="${simName:(-2)}"
simNum=`expr $SIMNUM + 0`
Path=`pwd`

echo "$0 started running at" $(date +%T)
#######################################################################
#Extracting nodenames#
#######################################################################

#$Path/../bin/extractNeNames.pl $simName
#neNames=( $( cat $Path/dumpNeName.txt ) )

########################################################################
#Making MO script#
########################################################################
#for nodeName in ${neNames[@]}
#do
nodeName="M"$SIMNUM
MOSCRIPT=$nodeName".mo"
if [ -e $MOSCRIPT ]
then
   rm $MOSCRIPT
fi
cat >> $nodeName.mo << DEF

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1"
    identity "1.2.0.4"
    moType AxeEquipment:Shelf
    exception none
    nrOfAttributes 1
    "shelfId" String "1.2.0.4"
)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=1.2.0.4"
    identity "12"
    moType AxeEquipment:ApBlade
    exception none
    nrOfAttributes 4
    "apBladeId" String "12"
    "systemNumber" Uint16 0
    "side" Integer -1
    "functionalBoardName" Integer 300
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=1.2.0.4,AxeEquipment:ApBlade=12,AxeEquipment:ApBladeInfo=1"
    exception none
    nrOfAttributes 13
    "apBladeInfoId" String "1"
    "temperatureStatus" Integer "null"
    "biosRunningMode" Integer "null"
    "storageStatus" Integer "null"
    "boardStatus" Integer "null"
    "alarmInterfaceStatus" Integer "null"
    "biosVersion" String ""
    "nicInfo" Array Struct 0
    "productInfo" Struct
        nrOfElements 6
        "productRevision" String ""
        "productName" String ""
        "manufacturingDate" String ""
        "productVendor" String ""
        "productNumber" String ""
        "serialNumber" String ""

    "operationalLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "faultLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "maintenanceLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "statusLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=1.2.0.4"
    identity "14"
    moType AxeEquipment:ApBlade
    exception none
    nrOfAttributes 4
    "apBladeId" String "14"
    "systemNumber" Uint16 0
    "side" Integer -1
    "functionalBoardName" Integer 300
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=1.2.0.4,AxeEquipment:ApBlade=14,AxeEquipment:ApBladeInfo=1"
    exception none
    nrOfAttributes 13
    "apBladeInfoId" String "1"
    "temperatureStatus" Integer "null"
    "biosRunningMode" Integer "null"
    "storageStatus" Integer "null"
    "boardStatus" Integer "null"
    "alarmInterfaceStatus" Integer "null"
    "biosVersion" String ""
    "nicInfo" Array Struct 0
    "productInfo" Struct
        nrOfElements 6
        "productRevision" String ""
        "productName" String ""
        "manufacturingDate" String ""
        "productVendor" String ""
        "productNumber" String ""
        "serialNumber" String ""

    "operationalLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "faultLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "maintenanceLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "statusLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=1.2.0.4"
    identity "16"
    moType AxeEquipment:ApBlade
    exception none
    nrOfAttributes 4
    "apBladeId" String "16"
    "systemNumber" Uint16 0
    "side" Integer -1
    "functionalBoardName" Integer 300
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=1.2.0.4,AxeEquipment:ApBlade=16,AxeEquipment:ApBladeInfo=1"
    exception none
    nrOfAttributes 13
    "apBladeInfoId" String "1"
    "temperatureStatus" Integer "null"
    "biosRunningMode" Integer "null"
    "storageStatus" Integer "null"
    "boardStatus" Integer "null"
    "alarmInterfaceStatus" Integer "null"
    "biosVersion" String ""
    "nicInfo" Array Struct 0
    "productInfo" Struct
        nrOfElements 6
        "productRevision" String ""
        "productName" String ""
        "manufacturingDate" String ""
        "productVendor" String ""
        "productNumber" String ""
        "serialNumber" String ""

    "operationalLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "faultLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "maintenanceLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "statusLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=1.2.0.4"
    identity "2"
    moType AxeEquipment:ApBlade
    exception none
    nrOfAttributes 4
    "apBladeId" String "2"
    "systemNumber" Uint16 0
    "side" Integer -1
    "functionalBoardName" Integer 300
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=1.2.0.4,AxeEquipment:ApBlade=2,AxeEquipment:ApBladeInfo=1"
    exception none
    nrOfAttributes 13
    "apBladeInfoId" String "1"
    "temperatureStatus" Integer "null"
    "biosRunningMode" Integer "null"
    "storageStatus" Integer "null"
    "boardStatus" Integer "null"
    "alarmInterfaceStatus" Integer "null"
    "biosVersion" String ""
    "nicInfo" Array Struct 0
    "productInfo" Struct
        nrOfElements 6
        "productRevision" String ""
        "productName" String ""
        "manufacturingDate" String ""
        "productVendor" String ""
        "productNumber" String ""
        "serialNumber" String ""

    "operationalLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "faultLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "maintenanceLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "statusLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=1.2.0.4"
    identity "20"
    moType AxeEquipment:ApBlade
    exception none
    nrOfAttributes 4
    "apBladeId" String "20"
    "systemNumber" Uint16 0
    "side" Integer -1
    "functionalBoardName" Integer 300
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=1.2.0.4,AxeEquipment:ApBlade=20,AxeEquipment:ApBladeInfo=1"
    exception none
    nrOfAttributes 13
    "apBladeInfoId" String "1"
    "temperatureStatus" Integer "null"
    "biosRunningMode" Integer "null"
    "storageStatus" Integer "null"
    "boardStatus" Integer "null"
    "alarmInterfaceStatus" Integer "null"
    "biosVersion" String ""
    "nicInfo" Array Struct 0
    "productInfo" Struct
        nrOfElements 6
        "productRevision" String ""
        "productName" String ""
        "manufacturingDate" String ""
        "productVendor" String ""
        "productNumber" String ""
        "serialNumber" String ""

    "operationalLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "faultLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "maintenanceLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "statusLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=1.2.0.4"
    identity "22"
    moType AxeEquipment:ApBlade
    exception none
    nrOfAttributes 4
    "apBladeId" String "22"
    "systemNumber" Uint16 0
    "side" Integer -1
    "functionalBoardName" Integer 300
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=1.2.0.4,AxeEquipment:ApBlade=22,AxeEquipment:ApBladeInfo=1"
    exception none
    nrOfAttributes 13
    "apBladeInfoId" String "1"
    "temperatureStatus" Integer "null"
    "biosRunningMode" Integer "null"
    "storageStatus" Integer "null"
    "boardStatus" Integer "null"
    "alarmInterfaceStatus" Integer "null"
    "biosVersion" String ""
    "nicInfo" Array Struct 0
    "productInfo" Struct
        nrOfElements 6
        "productRevision" String ""
        "productName" String ""
        "manufacturingDate" String ""
        "productVendor" String ""
        "productNumber" String ""
        "serialNumber" String ""

    "operationalLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "faultLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "maintenanceLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "statusLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1"
    identity "15.2.0.4"
    moType AxeEquipment:Shelf
    exception none
    nrOfAttributes 1
    "shelfId" String "15.2.0.4"
)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=15.2.0.4"
    identity "12"
    moType AxeEquipment:ApBlade
    exception none
    nrOfAttributes 4
    "apBladeId" String "12"
    "systemNumber" Uint16 0
    "side" Integer -1
    "functionalBoardName" Integer 300
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=15.2.0.4,AxeEquipment:ApBlade=12,AxeEquipment:ApBladeInfo=1"
    exception none
    nrOfAttributes 13
    "apBladeInfoId" String "1"
    "temperatureStatus" Integer "null"
    "biosRunningMode" Integer "null"
    "storageStatus" Integer "null"
    "boardStatus" Integer "null"
    "alarmInterfaceStatus" Integer "null"
    "biosVersion" String ""
    "nicInfo" Array Struct 0
    "productInfo" Struct
        nrOfElements 6
        "productRevision" String ""
        "productName" String ""
        "manufacturingDate" String ""
        "productVendor" String ""
        "productNumber" String ""
        "serialNumber" String ""

    "operationalLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "faultLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "maintenanceLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "statusLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=15.2.0.4"
    identity "14"
    moType AxeEquipment:ApBlade
    exception none
    nrOfAttributes 4
    "apBladeId" String "14"
    "systemNumber" Uint16 0
    "side" Integer -1
    "functionalBoardName" Integer 300
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=15.2.0.4,AxeEquipment:ApBlade=14,AxeEquipment:ApBladeInfo=1"
    exception none
    nrOfAttributes 13
    "apBladeInfoId" String "1"
    "temperatureStatus" Integer "null"
    "biosRunningMode" Integer "null"
    "storageStatus" Integer "null"
    "boardStatus" Integer "null"
    "alarmInterfaceStatus" Integer "null"
    "biosVersion" String ""
    "nicInfo" Array Struct 0
    "productInfo" Struct
        nrOfElements 6
        "productRevision" String ""
        "productName" String ""
        "manufacturingDate" String ""
        "productVendor" String ""
        "productNumber" String ""
        "serialNumber" String ""

    "operationalLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "faultLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "maintenanceLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "statusLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=15.2.0.4"
    identity "20"
    moType AxeEquipment:ApBlade
    exception none
    nrOfAttributes 4
    "apBladeId" String "20"
    "systemNumber" Uint16 0
    "side" Integer -1
    "functionalBoardName" Integer 300
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=15.2.0.4,AxeEquipment:ApBlade=20,AxeEquipment:ApBladeInfo=1"
    exception none
    nrOfAttributes 13
    "apBladeInfoId" String "1"
    "temperatureStatus" Integer "null"
    "biosRunningMode" Integer "null"
    "storageStatus" Integer "null"
    "boardStatus" Integer "null"
    "alarmInterfaceStatus" Integer "null"
    "biosVersion" String ""
    "nicInfo" Array Struct 0
    "productInfo" Struct
        nrOfElements 6
        "productRevision" String ""
        "productName" String ""
        "manufacturingDate" String ""
        "productVendor" String ""
        "productNumber" String ""
        "serialNumber" String ""

    "operationalLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "faultLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "maintenanceLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "statusLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=15.2.0.4"
    identity "22"
    moType AxeEquipment:ApBlade
    exception none
    nrOfAttributes 4
    "apBladeId" String "22"
    "systemNumber" Uint16 0
    "side" Integer -1
    "functionalBoardName" Integer 300
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=15.2.0.4,AxeEquipment:ApBlade=22,AxeEquipment:ApBladeInfo=1"
    exception none
    nrOfAttributes 13
    "apBladeInfoId" String "1"
    "temperatureStatus" Integer "null"
    "biosRunningMode" Integer "null"
    "storageStatus" Integer "null"
    "boardStatus" Integer "null"
    "alarmInterfaceStatus" Integer "null"
    "biosVersion" String ""
    "nicInfo" Array Struct 0
    "productInfo" Struct
        nrOfElements 6
        "productRevision" String ""
        "productName" String ""
        "manufacturingDate" String ""
        "productVendor" String ""
        "productNumber" String ""
        "serialNumber" String ""

    "operationalLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "faultLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "maintenanceLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

    "statusLed" Struct
        nrOfElements 3
        "colour" Integer 0
        "status" Integer 1
        "supported" Boolean true

)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=1.2.0.4"
    identity "3"
    moType AxeEquipment:CpBlade
    exception none
    nrOfAttributes 13
    "cpBladeId" String "3"
    "cpArchitecture" Integer 0
    "systemNumber" Uint16 0
    "side" Integer -1
    "sequenceNumber" Int32 -1
    "ipAliasEthB" String "0.0.0.0"
    "ipAliasEthA" String "0.0.0.0"
    "ipAddressEthB" String "0.0.0.0"
    "ipAddressEthA" String "0.0.0.0"
    "functionalBoardName" Integer 200
    "aliasNetmaskEthB" String "0.0.0.0"
    "productInfo" Struct
        nrOfElements 6
        "productRevision" String ""
        "productName" String ""
        "manufacturingDate" String ""
        "productVendor" String ""
        "productNumber" String ""
        "serialNumber" String ""

    "aliasNetmaskEthA" String "0.0.0.0"
)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=1.2.0.4"
    identity "7"
    moType AxeEquipment:CpBlade
    exception none
    nrOfAttributes 13
    "cpBladeId" String "7"
    "cpArchitecture" Integer 0
    "systemNumber" Uint16 0
    "side" Integer -1
    "sequenceNumber" Int32 -1
    "ipAliasEthB" String "0.0.0.0"
    "ipAliasEthA" String "0.0.0.0"
    "ipAddressEthB" String "0.0.0.0"
    "ipAddressEthA" String "0.0.0.0"
    "functionalBoardName" Integer 200
    "aliasNetmaskEthB" String "0.0.0.0"
    "productInfo" Struct
        nrOfElements 6
        "productRevision" String ""
        "productName" String ""
        "manufacturingDate" String ""
        "productVendor" String ""
        "productNumber" String ""
        "serialNumber" String ""

    "aliasNetmaskEthA" String "0.0.0.0"
)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=1.2.0.4"
    identity "8"
    moType AxeEquipment:CpBlade
    exception none
    nrOfAttributes 13
    "cpBladeId" String "8"
    "cpArchitecture" Integer 0
    "systemNumber" Uint16 0
    "side" Integer -1
    "sequenceNumber" Int32 -1
    "ipAliasEthB" String "0.0.0.0"
    "ipAliasEthA" String "0.0.0.0"
    "ipAddressEthB" String "0.0.0.0"
    "ipAddressEthA" String "0.0.0.0"
    "functionalBoardName" Integer 200
    "aliasNetmaskEthB" String "0.0.0.0"
    "productInfo" Struct
        nrOfElements 6
        "productRevision" String ""
        "productName" String ""
        "manufacturingDate" String ""
        "productVendor" String ""
        "productNumber" String ""
        "serialNumber" String ""

    "aliasNetmaskEthA" String "0.0.0.0"
)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=15.2.0.4"
    identity "3"
    moType AxeEquipment:CpBlade
    exception none
    nrOfAttributes 13
    "cpBladeId" String "3"
    "cpArchitecture" Integer 0
    "systemNumber" Uint16 0
    "side" Integer -1
    "sequenceNumber" Int32 -1
    "ipAliasEthB" String "0.0.0.0"
    "ipAliasEthA" String "0.0.0.0"
    "ipAddressEthB" String "0.0.0.0"
    "ipAddressEthA" String "0.0.0.0"
    "functionalBoardName" Integer 200
    "aliasNetmaskEthB" String "0.0.0.0"
    "productInfo" Struct
        nrOfElements 6
        "productRevision" String ""
        "productName" String ""
        "manufacturingDate" String ""
        "productVendor" String ""
        "productNumber" String ""
        "serialNumber" String ""

    "aliasNetmaskEthA" String "0.0.0.0"
)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=15.2.0.4"
    identity "7"
    moType AxeEquipment:CpBlade
    exception none
    nrOfAttributes 13
    "cpBladeId" String "7"
    "cpArchitecture" Integer 0
    "systemNumber" Uint16 0
    "side" Integer -1
    "sequenceNumber" Int32 -1
    "ipAliasEthB" String "0.0.0.0"
    "ipAliasEthA" String "0.0.0.0"
    "ipAddressEthB" String "0.0.0.0"
    "ipAddressEthA" String "0.0.0.0"
    "functionalBoardName" Integer 200
    "aliasNetmaskEthB" String "0.0.0.0"
    "productInfo" Struct
        nrOfElements 6
        "productRevision" String ""
        "productName" String ""
        "manufacturingDate" String ""
        "productVendor" String ""
        "productNumber" String ""
        "serialNumber" String ""

    "aliasNetmaskEthA" String "0.0.0.0"
)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=15.2.0.4"
    identity "8"
    moType AxeEquipment:CpBlade
    exception none
    nrOfAttributes 13
    "cpBladeId" String "8"
    "cpArchitecture" Integer 0
    "systemNumber" Uint16 0
    "side" Integer -1
    "sequenceNumber" Int32 -1
    "ipAliasEthB" String "0.0.0.0"
    "ipAliasEthA" String "0.0.0.0"
    "ipAddressEthB" String "0.0.0.0"
    "ipAddressEthA" String "0.0.0.0"
    "functionalBoardName" Integer 200
    "aliasNetmaskEthB" String "0.0.0.0"
    "productInfo" Struct
        nrOfElements 6
        "productRevision" String ""
        "productName" String ""
        "manufacturingDate" String ""
        "productVendor" String ""
        "productNumber" String ""
        "serialNumber" String ""

    "aliasNetmaskEthA" String "0.0.0.0"
)


CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1"
    identity "0.0.0.0"
    moType AxeEquipment:Shelf
    exception none
    nrOfAttributes 1
    "shelfId" String "0.0.0.0"
)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=0.0.0.0"
    identity "9"
    moType AxeEquipment:CpBlade
    exception none
    nrOfAttributes 13
    "cpBladeId" String "9"
    "cpArchitecture" Integer 0
    "systemNumber" Uint16 0
    "side" Integer -1
    "sequenceNumber" Int32 -1
    "ipAliasEthB" String "0.0.0.0"
    "ipAliasEthA" String "0.0.0.0"
    "ipAddressEthB" String "0.0.0.0"
    "ipAddressEthA" String "0.0.0.0"
    "functionalBoardName" Integer 200
    "aliasNetmaskEthB" String "0.0.0.0"
    "productInfo" Struct
        nrOfElements 6
        "productRevision" String ""
        "productName" String ""
        "manufacturingDate" String ""
        "productVendor" String ""
        "productNumber" String ""
        "serialNumber" String ""

    "aliasNetmaskEthA" String "0.0.0.0"
)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=0.0.0.0"
    identity "11"
    moType AxeEquipment:CpBlade
    exception none
    nrOfAttributes 13
    "cpBladeId" String "11"
    "cpArchitecture" Integer 0
    "systemNumber" Uint16 0
    "side" Integer -1
    "sequenceNumber" Int32 -1
    "ipAliasEthB" String "0.0.0.0"
    "ipAliasEthA" String "0.0.0.0"
    "ipAddressEthB" String "0.0.0.0"
    "ipAddressEthA" String "0.0.0.0"
    "functionalBoardName" Integer 200
    "aliasNetmaskEthB" String "0.0.0.0"
    "productInfo" Struct
        nrOfElements 6
        "productRevision" String ""
        "productName" String ""
        "manufacturingDate" String ""
        "productVendor" String ""
        "productNumber" String ""
        "serialNumber" String ""

    "aliasNetmaskEthA" String "0.0.0.0"
)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=0.0.0.0"
    identity "17"
    moType AxeEquipment:CpBlade
    exception none
    nrOfAttributes 13
    "cpBladeId" String "17"
    "cpArchitecture" Integer 0
    "systemNumber" Uint16 0
    "side" Integer -1
    "sequenceNumber" Int32 -1
    "ipAliasEthB" String "0.0.0.0"
    "ipAliasEthA" String "0.0.0.0"
    "ipAddressEthB" String "0.0.0.0"
    "ipAddressEthA" String "0.0.0.0"
    "functionalBoardName" Integer 200
    "aliasNetmaskEthB" String "0.0.0.0"
    "productInfo" Struct
        nrOfElements 6
        "productRevision" String ""
        "productName" String ""
        "manufacturingDate" String ""
        "productVendor" String ""
        "productNumber" String ""
        "serialNumber" String ""

    "aliasNetmaskEthA" String "0.0.0.0"
)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:HardwareMgmt=1,AxeEquipment:Shelf=0.0.0.0"
    identity "21"
    moType AxeEquipment:CpBlade
    exception none
    nrOfAttributes 13
    "cpBladeId" String "21"
    "cpArchitecture" Integer 0
    "systemNumber" Uint16 0
    "side" Integer -1
    "sequenceNumber" Int32 -1
    "ipAliasEthB" String "0.0.0.0"
    "ipAliasEthA" String "0.0.0.0"
    "ipAddressEthB" String "0.0.0.0"
    "ipAddressEthA" String "0.0.0.0"
    "functionalBoardName" Integer 200
    "aliasNetmaskEthB" String "0.0.0.0"
    "productInfo" Struct
        nrOfElements 6
        "productRevision" String ""
        "productName" String ""
        "manufacturingDate" String ""
        "productVendor" String ""
        "productNumber" String ""
        "serialNumber" String ""

    "aliasNetmaskEthA" String "0.0.0.0"
)

DELETE
(
  mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:Apg=1"
)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1"
    identity "AP1"
    moType AxeEquipment:Apg
    exception none
    nrOfAttributes 2
    "apgId" String "AP1"
    "apBladesDn" Array Ref 0
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:Apg=AP1"
    exception none
    nrOfAttributes 1
    "apBladesDn" Array Ref 6
        ManagedElement=$nodeName,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,HardwareMgmt=1,Shelf=1.2.0.4,ApBlade=12
        ManagedElement=$nodeName,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,HardwareMgmt=1,Shelf=1.2.0.4,ApBlade=14
        ManagedElement=$nodeName,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,HardwareMgmt=1,Shelf=1.2.0.4,ApBlade=16
        ManagedElement=$nodeName,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,HardwareMgmt=1,Shelf=1.2.0.4,ApBlade=2
        ManagedElement=$nodeName,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,HardwareMgmt=1,Shelf=1.2.0.4,ApBlade=20
        ManagedElement=$nodeName,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,HardwareMgmt=1,Shelf=1.2.0.4,ApBlade=22
)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1"
    identity "AP2"
    moType AxeEquipment:Apg
    exception none
    nrOfAttributes 2
    "apgId" String "AP2"
    "apBladesDn" Array Ref 0
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:Apg=AP2"
    exception none
    nrOfAttributes 1
    "apBladesDn" Array Ref 4
        ManagedElement=$nodeName,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,HardwareMgmt=1,Shelf=15.2.0.4,ApBlade=12
        ManagedElement=$nodeName,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,HardwareMgmt=1,Shelf=15.2.0.4,ApBlade=14
        ManagedElement=$nodeName,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,HardwareMgmt=1,Shelf=15.2.0.4,ApBlade=20
        ManagedElement=$nodeName,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,HardwareMgmt=1,Shelf=15.2.0.4,ApBlade=22
)

DELETE
(
  mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:DualSidedCp=1,AxeEquipment:SwMau=1"
)

DELETE
(
  mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:DualSidedCp=1"
)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1"
    identity "CP1"
    moType AxeEquipment:DualSidedCp
    exception none
    nrOfAttributes 6
    "dualSidedCpId" String "CP1"
    "apzSystem" String "0"
    "cpType" Uint16 "null"
    "cpBladesDn" Array Ref 0
    "cpAlias" String "-"
    "mauType" Integer 0
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:DualSidedCp=CP1,AxeEquipment:SwMau=1"
    exception none
    nrOfAttributes 3
    "swMauId" String "1"
    "administrativeState" Integer "null"
    "operationalState" Integer "null"
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:DualSidedCp=CP1"
    exception none
    nrOfAttributes 4
    "apzSystem" String "APZ21260"
    "cpType" Uint16 21260
    "cpBladesDn" Array Ref 3
        ManagedElement=$nodeName,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,HardwareMgmt=1,Shelf=1.2.0.4,CpBlade=3
        ManagedElement=$nodeName,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,HardwareMgmt=1,Shelf=1.2.0.4,CpBlade=7
        ManagedElement=$nodeName,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,HardwareMgmt=1,Shelf=1.2.0.4,CpBlade=8
    "mauType" Integer 1
    
)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1"
    identity "CP2"
    moType AxeEquipment:DualSidedCp
    exception none
    nrOfAttributes 6
    "dualSidedCpId" String "CP2"
    "apzSystem" String "0"
    "cpType" Uint16 "null"
    "cpBladesDn" Array Ref 0
    "cpAlias" String "-"
    "mauType" Integer 0
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:DualSidedCp=CP2,AxeEquipment:SwMau=1"
    exception none
    nrOfAttributes 3
    "swMauId" String "1"
    "administrativeState" Integer "null"
    "operationalState" Integer "null"
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:DualSidedCp=CP2"
    exception none
    nrOfAttributes 4
    "apzSystem" String "APZ21260"
    "cpType" Uint16 21260
    "cpBladesDn" Array Ref 3
        ManagedElement=$nodeName,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,HardwareMgmt=1,Shelf=15.2.0.4,CpBlade=3
        ManagedElement=$nodeName,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,HardwareMgmt=1,Shelf=15.2.0.4,CpBlade=7
        ManagedElement=$nodeName,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,HardwareMgmt=1,Shelf=15.2.0.4,CpBlade=8
    "mauType" Integer 1
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:CpCluster=1"
    exception none
    nrOfAttributes 6
    "clusterOpMode" Integer 2
    "reportProgress" Struct
        nrOfElements 5
        "state" Integer 2
        "reason" String ""
        "actionId" Integer 1
        "result" Integer 1
        "timeOfLastAction" String "2017-10-16 12:16:46"
    "clockMaster" Uint16 1001
    "alarmMaster" Uint16 1001
    "allBcGroup" Array String 4
        "BC1"
        "BC2"
        "BC3"
        "BC4"
    "operativeGroup" Array String 4
        "BC1"
        "BC2"
        "BC3"
        "BC4"
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:CpCluster=1,AxeEquipment:OmProfileManager=1"
    exception none
    nrOfAttributes 3
    "activeCcFile" String "1"
    "reportProgress" Struct
        nrOfElements 5
        "state" Integer 2
        "reason" String "APA Profile change request is ignored since requested profiles are same as current."
        "actionId" Integer 2
        "result" Integer 2
        "timeOfLastAction" String "2018-06-11 16:15:22"
    "omProfile" String "PROFILE 800"
)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:CpCluster=1,AxeEquipment:OmProfileManager=1,AxeEquipment:CcFileManager=1"
    identity "MmlCommandRules_100.xml"
    moType AxeEquipment:CandidateCcFile
    exception none
    nrOfAttributes 2
    "candidateCcFileId" String "MmlCommandRules_100.xml"
    "reportProgress" Struct
        nrOfElements 5
        "state" Integer 0
        "reason" String ""
        "actionId" Integer 0
        "result" Integer 3
        "timeOfLastAction" String ""

)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:CpCluster=1,AxeEquipment:OmProfileManager=1,AxeEquipment:CcFileManager=1,AxeEquipment:CandidateCcFile=MmlCommandRules_100.xml"
    exception none
    nrOfAttributes 1
    "reportProgress" Struct
        nrOfElements 5
        "state" Integer 2
        "reason" String ""
        "actionId" Integer 5
        "result" Integer 1
        "timeOfLastAction" String "2017-10-16 12:40:13"

)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:CpCluster=1,AxeEquipment:OmProfileManager=1,AxeEquipment:CcFileManager=1"
    identity "MmlCommandRules_800.xml"
    moType AxeEquipment:CandidateCcFile
    exception none
    nrOfAttributes 2
    "candidateCcFileId" String "MmlCommandRules_800.xml"
    "reportProgress" Struct
        nrOfElements 5
        "state" Integer 0
        "reason" String ""
        "actionId" Integer 0
        "result" Integer 3
        "timeOfLastAction" String ""

)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:CpCluster=1,AxeEquipment:OmProfileManager=1,AxeEquipment:CcFileManager=1,AxeEquipment:CandidateCcFile=MmlCommandRules_800.xml"
    exception none
    nrOfAttributes 1
    "reportProgress" Struct
        nrOfElements 5
        "state" Integer 2
        "reason" String ""
        "actionId" Integer 5
        "result" Integer 1
        "timeOfLastAction" String "2017-10-16 12:40:32"

)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:CpCluster=1,AxeEquipment:OmProfileManager=1"
    identity "100"
    moType AxeEquipment:OmProfile
    exception none
    nrOfAttributes 4
    "omProfileId" String "100"
    "apzProfile" String "-"
    "aptProfile" String "-"
    "state" Integer 0
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:CpCluster=1,AxeEquipment:OmProfileManager=1,AxeEquipment:OmProfile=100,AxeEquipment:CcFile=1"
    exception none
    nrOfAttributes 3
    "ccFileId" String "1"
    "state" Integer "null"
    "rulesVersion" String "null"
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:CpCluster=1,AxeEquipment:OmProfileManager=1,AxeEquipment:OmProfile=100"
    exception none
    nrOfAttributes 3
    "apzProfile" String "100"
    "aptProfile" String "100"
    "state" Integer 2
)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:CpCluster=1,AxeEquipment:OmProfileManager=1"
    identity "800"
    moType AxeEquipment:OmProfile
    exception none
    nrOfAttributes 4
    "omProfileId" String "800"
    "apzProfile" String "-"
    "aptProfile" String "-"
    "state" Integer 0
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:CpCluster=1,AxeEquipment:OmProfileManager=1,AxeEquipment:OmProfile=800,AxeEquipment:CcFile=1"
    exception none
    nrOfAttributes 3
    "ccFileId" String "1"
    "state" Integer "null"
    "rulesVersion" String "null"
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:CpCluster=1,AxeEquipment:OmProfileManager=1,AxeEquipment:OmProfile=800"
    exception none
    nrOfAttributes 3
    "apzProfile" String "100"
    "aptProfile" String "800"
    "state" Integer 1
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:CpCluster=1,AxeEquipment:OmProfileManager=1,AxeEquipment:OmProfile=800,AxeEquipment:CcFile=1"
    exception none
    nrOfAttributes 2
    "state" Integer 1
    "rulesVersion" String "MSC18_CM1739_MSC17A_CM1645_MSC17A_LSV1605_MSC14B_CM1419_MSC14B_LSV1325_APZ23.0FD1_LSV09_APZ23.0FD1_LSV0000_APZ23.0_CM003_APZ23.0_LSV0000_APZ22.0_CM003_APZ22.0_LSV0000_APZ21.0_LSV00_2017-09-25_150521"                                                        

)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:CpCluster=1"
    identity "BC1"
    moType AxeEquipment:ClusterCp
    exception none
    nrOfAttributes 5
    "clusterCpId" String "BC1"
    "cpBladesDn" Ref "null"
    "apzSystem" String "0"
    "cpType" Uint16 "null"
    "cpAlias" String "-"
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:CpCluster=1,AxeEquipment:ClusterCp=BC1"
    exception none
    nrOfAttributes 3
    "cpBladesDn" Ref "ManagedElement=$nodeName,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,HardwareMgmt=1,Shelf=0.0.0.0,CpBlade=9"
    "apzSystem" String "APZ21403"
    "cpType" Uint16 21260
)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:CpCluster=1"
    identity "BC2"
    moType AxeEquipment:ClusterCp
    exception none
    nrOfAttributes 5
    "clusterCpId" String "BC2"
    "cpBladesDn" Ref "null"
    "apzSystem" String "0"
    "cpType" Uint16 "null"
    "cpAlias" String "-"
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:CpCluster=1,AxeEquipment:ClusterCp=BC2"
    exception none
    nrOfAttributes 3
    "cpBladesDn" Ref "ManagedElement=$nodeName,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,HardwareMgmt=1,Shelf=0.0.0.0,CpBlade=11"
    "apzSystem" String "APZ21403"
    "cpType" Uint16 21260
)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:CpCluster=1"
    identity "BC3"
    moType AxeEquipment:ClusterCp
    exception none
    nrOfAttributes 5
    "clusterCpId" String "BC3"
    "cpBladesDn" Ref "null"
    "apzSystem" String "0"
    "cpType" Uint16 "null"
    "cpAlias" String "-"
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:CpCluster=1,AxeEquipment:ClusterCp=BC3"
    exception none
    nrOfAttributes 3
    "cpBladesDn" Ref "ManagedElement=$nodeName,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,HardwareMgmt=1,Shelf=0.0.0.0,CpBlade=17"
    "cpType" Uint16 21260
    "apzSystem" String "APZ21403"
)

CREATE
(
    parent "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:CpCluster=1"
    identity "BC4"
    moType AxeEquipment:ClusterCp
    exception none
    nrOfAttributes 5
    "clusterCpId" String "BC4"
    "cpBladesDn" Ref "null"
    "apzSystem" String "0"
    "cpType" Uint16 "null"
    "cpAlias" String "-"
)

SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemComponentHandling=1,AxeEquipment:EquipmentM=1,AxeEquipment:LogicalMgmt=1,AxeEquipment:CpCluster=1,AxeEquipment:ClusterCp=BC4"
    exception none
    nrOfAttributes 3
    "cpBladesDn" Ref "ManagedElement=$nodeName,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,HardwareMgmt=1,Shelf=0.0.0.0,CpBlade=21"
    "cpType" Uint16 21260
    "apzSystem" String "APZ21403"
)


DEF
########################################################################
#Making MML script#
########################################################################
if [ -e msc.mml ]
then
   rm msc.mml
fi
cat >> msc.mml << ABC
.open $simName
.select $nodeName
.start
cmshell;
kertayle:file="$Path/$nodeName.mo";
ABC
########################################################################
#moFiles+=($nodeName.mo)
#done

/netsim/inst/netsim_pipe < msc.mml
#for filenum in ${moFiles[@]}
#do
#rm $filenum
#done
rm msc.mml
#echo "$0 ended at" $( date +%T );

rm $nodeName.mo
