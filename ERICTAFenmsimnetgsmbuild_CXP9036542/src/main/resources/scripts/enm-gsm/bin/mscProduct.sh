#!/bin/sh
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
date=`date`
echo "$0 started running at" $(date +%T)
nodeName="M"$SIMNUM
MOSCRIPT=$nodeName".mo"
if [ -e $MOSCRIPT ]
then
   rm $MOSCRIPT
fi
cat >> $nodeName.mo << DEF
SET
(
    mo "ComTop:ManagedElement=$nodeName"
    exception none
    nrOfAttributes 1
    "productIdentity" Array Struct 0
)
SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,CmwSwIM:SwInventory=1,CmwSwIM:SwItem=1"
    exception none
    nrOfAttributes 1
    "administrativeData" Struct
        nrOfElements 6
        "productName" String "BSC01"
        "productNumber" String "3.0.0"
        "productRevision" String "PA01"
        "productionDate" String "$date"
        "description" String ""
        "type" String "N/A"

)
SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,CmwSwIM:SwInventory=1,CmwSwIM:SwVersion=1"
    exception none
    nrOfAttributes 1
    "administrativeData" Struct
        nrOfElements 6
        "productName" String "BSC01"
        "productNumber" String "3.0.0"
        "productRevision" String "PA01"
        "productionDate" String "$date"
        "description" String ""
        "type" String "N/A"

)
 SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,CmwSwIM:SwInventory=1"
      exception none
    nrOfAttributes 1
    "active" Array Ref 1
     ManagedElement=$nodeName,SystemFunctions=1,SwInventory=1,SwVersion=1
)
SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,SecSecM:SecM=1,SEC_CertM:CertM=1,SEC_CertM:CertMCapabilities=1"
    exception none
    nrOfAttributes 2
    "fingerprintSupport" Integer 0
    "enrollmentSupport" Array Integer 4
         0
         1
         2
         3
)
SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,CmwPm:Pm=1,CmwPm:PmMeasurementCapabilities=1"
    exception none
    nrOfAttributes 1
    "fileLocation" String "/data_transfer/destinations/CDHDEFAULT/Ready"
)
SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,CmwSwIM:SwInventory=1,CmwSwIM:SwItem=1"
    exception none
    nrOfAttributes 1
    "consistsOf" Array Ref 1
        ManagedElement=$nodeName,SystemFunctions=1,SwInventory=1,SwVersion=1
)
SET
(
    mo "ComTop:ManagedElement=$nodeName,ComTop:SystemFunctions=1,CmwSwIM:SwInventory=1,CmwSwIM:SwVersion=1"
    exception none
    nrOfAttributes 1
    "consistsOf" Array Ref 1
        ManagedElement=$nodeName,SystemFunctions=1,SwInventory=1,SwItem=1
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
#rm $MOSCRIPT

/netsim/inst/netsim_pipe < msc.mml

rm $MOSCRIPT
rm msc.mml


