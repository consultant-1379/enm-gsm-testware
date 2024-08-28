#!/bin/sh
### VERSION HISTORY
#####################################################################################
#     Version     : 1.2
#
#     Revision    : CXP 903 6542-1-8
#
#     Author      : zsujmad
#
#     JIRA        : NSS-34293,NSS-34469,NSS-34459,NSS-34065
#
#     Description : Adding Support for Pre-Build Inspection
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
if [ "$#" -ne 2  ]
then
 echo
 echo "Usage: $0 <sim name> <Node name>"
 echo
 echo "Example: $0 GSM-FT-BSC-17-Q4x1-GSM01 MSC01BSC01"
 echo
 exit 1
fi

SIMNAME=$1
NODENAME=$2
simNum="${SIMNAME:(-2)}"
SIMNUM=`expr $simNum + 0`
MOSCRIPT=$NODENAME"_bts.mo"
G1BTSCOUNT=1
G2BTSCOUNT=1
MMLSCRIPT=$NODENAME"_bts.mml"
if [ -e $MMLSCRIPT ]
then
   rm $MMLSCRIPT
fi
if [ -e $MOSCRIPT ]
then
   rm $MOSCRIPT
fi
G1_BTSDATA=`cat $PWD/../customdata/GsmTopology.csv | grep -i "SIM:$SIMNUM;NODE:$NODENAME" | grep "BTS:G1" | tail -n-1`
NUMOFG1BTS=$(echo $G1_BTSDATA | awk -F"BTS:G1-" '{print $2}' | awk -F";" '{print $1}')
NUMOFG2BTS=`cat $PWD/../customdata/GsmTopology.csv | grep -i "SIM:$SIMNUM;NODE:$NODENAME" | grep "BTS:G2" | wc -l`
if [[ $NUMOFG1BTS == "" ]]
then
   NUMOFG1BTS=0
fi
if [[ $NUMOFG2BTS == "" ]]
then
   NUMOFG2BTS=0
fi
echo "NodeName=$NODENAME;NumOfG1Bts=$NUMOFG1BTS" >> $PWD/../customdata/NetworkStats.csv
#echo "NodeName=$NODENAME;NumOfG1Bts=$NUMOFG1BTS" >> preBuildGSMCounts.csv
echo "NodeName=$NODENAME;NumOfG2Bts=$NUMOFG2BTS" >> $PWD/../customdata/NetworkStats.csv
#echo "NodeName=$NODENAME;NumOfG2Bts=$NUMOFG2BTS" >> preBuildGSMCounts.csv
if [ "$NUMOFG1BTS" -ne "0" ]
then
while [ "$G1BTSCOUNT" -le "$NUMOFG1BTS"  ]
do
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1"
    identity "$G1BTSCOUNT"
    moType BscM:G12Tg
    exception none
    nrOfAttributes 49
    "aHop" Integer 0
    "abis64kThr" Uint8 "null"
    "abisAlloc" Integer 0
    "aisgRet" Integer 0
    "aisgTma" Integer 0
    "alCoTim" Uint16 90
    "blState" Integer 0
    "ccchCmd" Integer 0
    "changeSubordState" Integer 1
    "clTgInst" Uint16 "null"
    "clusterId" Uint16 "null"
    "comb" Integer 1
    "conFact" Uint8 1
    "confMd" Integer 2
    "connectedChannelGroup" Array Ref 0
    "csTma" Integer 1
    "dAmrCr" Integer 0
    "dAmrRedAbisThr" Uint8 "null"
    "dFrMaAbisThr" Uint8 "null"
    "dHrMaAbisThr" Uint8 "null"
    "dHraAbisThr" Uint8 "null"
    "dHraAbisThrWb" Uint8 "null"
    "exalTim" Uint16 30
    "fHop" Integer 0
    "g12TgId" String "$G1BTSCOUNT"
    "g12TgIndividual" Uint32 1893
    "jbPta" Int8 20
    "jbsDl" Uint8 20
    "moAdmState" Integer 0
    "packAlg" Integer 1
    "pal" Integer 1
    "psuPs" Integer 1
    "pta" Uint8 7
    "rCasc" Integer 0
    "rSite" String "B072_1005_0907"
    "sdAmrRedAbisThr" Uint8 70
    "sdFrMaAbisThr" Uint8 77
    "sdHrMaAbisThr" Uint8 0
    "sdHraAbisThr" Uint8 75
    "sdHraAbisThrWb" Uint8 90
    "sigDel" Integer 0
    "swVer" String "12"
    "swVerAct" String "null"
    "swVerDld" String "null"
    "tMode" Integer 1
    "tgCoord" Integer 1
    "traCo" Integer 1
    "tsPs" Integer 1
    "usesSuperChannelGroup" Ref "null"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "1"
    moType BscM:G12Cf
    exception none
    nrOfAttributes 8
    "blState" Integer 0
    "changeSubordState" Integer 1
    "forcedBlocking" Integer 1
    "g12CfId" String "1"
    "g12CfIndividual" Uint32 1893
    "moAdmState" Integer 0
    "sig" Integer 4
    "tei" Uint8 62
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "1"
    moType BscM:G12Con
    exception none
    nrOfAttributes 7
    "blState" Integer 0
    "dcpBegin" Uint16 350
    "dcpEnd" Uint16 581
    "forcedBlocking" Integer 1
    "g12ConId" String "1"
    "g12ConIndividual" Uint32 1893
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "0"
    moType BscM:G12Dp
    exception none
    nrOfAttributes 6
    "blState" Integer 0
    "dev" String "RXODPI-7572"
    "forcedBlocking" Integer 1
    "g12DpId" String "0"
    "g12DpIndividual" Uint32 7572
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "1"
    moType BscM:G12Dp
    exception none
    nrOfAttributes 6
    "blState" Integer 0
    "dev" String "RXODPI-7573"
    "forcedBlocking" Integer 1
    "g12DpId" String "1"
    "g12DpIndividual" Uint32 7573
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "1"
    moType BscM:G12Is
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12IsId" String "1"
    "g12IsIndividual" Uint32 1893
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "1"
    moType BscM:G12SubscrPrioLevel
    exception none
    nrOfAttributes 7
    "dAmrRedAbisThr" Uint8 "null"
    "dHraAbisThr" Uint8 "null"
    "dHraAbisThrWb" Uint8 "null"
    "g12SubscrPrioLevelId" String "1"
    "sdAmrRedAbisThr" Uint8 100
    "sdHraAbisThr" Uint8 100
    "sdHraAbisThrWb" Uint8 100
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "10"
    moType BscM:G12SubscrPrioLevel
    exception none
    nrOfAttributes 7
    "dAmrRedAbisThr" Uint8 "null"
    "dHraAbisThr" Uint8 "null"
    "dHraAbisThrWb" Uint8 "null"
    "g12SubscrPrioLevelId" String "10"
    "sdAmrRedAbisThr" Uint8 100
    "sdHraAbisThr" Uint8 100
    "sdHraAbisThrWb" Uint8 100
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "11"
    moType BscM:G12SubscrPrioLevel
    exception none
    nrOfAttributes 7
    "dAmrRedAbisThr" Uint8 "null"
    "dHraAbisThr" Uint8 "null"
    "dHraAbisThrWb" Uint8 "null"
    "g12SubscrPrioLevelId" String "11"
    "sdAmrRedAbisThr" Uint8 100
    "sdHraAbisThr" Uint8 100
    "sdHraAbisThrWb" Uint8 100
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "12"
    moType BscM:G12SubscrPrioLevel
    exception none
    nrOfAttributes 7
    "dAmrRedAbisThr" Uint8 "null"
    "dHraAbisThr" Uint8 "null"
    "dHraAbisThrWb" Uint8 "null"
    "g12SubscrPrioLevelId" String "12"
    "sdAmrRedAbisThr" Uint8 100
    "sdHraAbisThr" Uint8 100
    "sdHraAbisThrWb" Uint8 100
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "13"
    moType BscM:G12SubscrPrioLevel
    exception none
    nrOfAttributes 7
    "dAmrRedAbisThr" Uint8 "null"
    "dHraAbisThr" Uint8 "null"
    "dHraAbisThrWb" Uint8 "null"
    "g12SubscrPrioLevelId" String "13"
    "sdAmrRedAbisThr" Uint8 100
    "sdHraAbisThr" Uint8 100
    "sdHraAbisThrWb" Uint8 100
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "14"
    moType BscM:G12SubscrPrioLevel
    exception none
    nrOfAttributes 7
    "dAmrRedAbisThr" Uint8 "null"
    "dHraAbisThr" Uint8 "null"
    "dHraAbisThrWb" Uint8 "null"
    "g12SubscrPrioLevelId" String "14"
    "sdAmrRedAbisThr" Uint8 100
    "sdHraAbisThr" Uint8 100
    "sdHraAbisThrWb" Uint8 100
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "2"
    moType BscM:G12SubscrPrioLevel
    exception none
    nrOfAttributes 7
    "dAmrRedAbisThr" Uint8 "null"
    "dHraAbisThr" Uint8 "null"
    "dHraAbisThrWb" Uint8 "null"
    "g12SubscrPrioLevelId" String "2"
    "sdAmrRedAbisThr" Uint8 100
    "sdHraAbisThr" Uint8 100
    "sdHraAbisThrWb" Uint8 100
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "3"
    moType BscM:G12SubscrPrioLevel
    exception none
    nrOfAttributes 7
    "dAmrRedAbisThr" Uint8 "null"
    "dHraAbisThr" Uint8 "null"
    "dHraAbisThrWb" Uint8 "null"
    "g12SubscrPrioLevelId" String "3"
    "sdAmrRedAbisThr" Uint8 100
    "sdHraAbisThr" Uint8 100
    "sdHraAbisThrWb" Uint8 100
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "4"
    moType BscM:G12SubscrPrioLevel
    exception none
    nrOfAttributes 7
    "dAmrRedAbisThr" Uint8 "null"
    "dHraAbisThr" Uint8 "null"
    "dHraAbisThrWb" Uint8 "null"
    "g12SubscrPrioLevelId" String "4"
    "sdAmrRedAbisThr" Uint8 100
    "sdHraAbisThr" Uint8 100
    "sdHraAbisThrWb" Uint8 100
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "5"
    moType BscM:G12SubscrPrioLevel
    exception none
    nrOfAttributes 7
    "dAmrRedAbisThr" Uint8 "null"
    "dHraAbisThr" Uint8 "null"
    "dHraAbisThrWb" Uint8 "null"
    "g12SubscrPrioLevelId" String "5"
    "sdAmrRedAbisThr" Uint8 100
    "sdHraAbisThr" Uint8 100
    "sdHraAbisThrWb" Uint8 100
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "6"
    moType BscM:G12SubscrPrioLevel
    exception none
    nrOfAttributes 7
    "dAmrRedAbisThr" Uint8 "null"
    "dHraAbisThr" Uint8 "null"
    "dHraAbisThrWb" Uint8 "null"
    "g12SubscrPrioLevelId" String "6"
    "sdAmrRedAbisThr" Uint8 100
    "sdHraAbisThr" Uint8 100
    "sdHraAbisThrWb" Uint8 100
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "7"
    moType BscM:G12SubscrPrioLevel
    exception none
    nrOfAttributes 7
    "dAmrRedAbisThr" Uint8 "null"
    "dHraAbisThr" Uint8 "null"
    "dHraAbisThrWb" Uint8 "null"
    "g12SubscrPrioLevelId" String "7"
    "sdAmrRedAbisThr" Uint8 100
    "sdHraAbisThr" Uint8 100
    "sdHraAbisThrWb" Uint8 100
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "8"
    moType BscM:G12SubscrPrioLevel
    exception none
    nrOfAttributes 7
    "dAmrRedAbisThr" Uint8 "null"
    "dHraAbisThr" Uint8 "null"
    "dHraAbisThrWb" Uint8 "null"
    "g12SubscrPrioLevelId" String "8"
    "sdAmrRedAbisThr" Uint8 100
    "sdHraAbisThr" Uint8 100
    "sdHraAbisThrWb" Uint8 100
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "9"
    moType BscM:G12SubscrPrioLevel
    exception none
    nrOfAttributes 7
    "dAmrRedAbisThr" Uint8 "null"
    "dHraAbisThr" Uint8 "null"
    "dHraAbisThrWb" Uint8 "null"
    "g12SubscrPrioLevelId" String "9"
    "sdAmrRedAbisThr" Uint8 100
    "sdHraAbisThr" Uint8 100
    "sdHraAbisThrWb" Uint8 100
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "1"
    moType BscM:G12Tf
    exception none
    nrOfAttributes 10
    "blState" Integer 0
    "btsSoftSyncState" Integer 0
    "btsSoftSyncTimeAlignment" Integer 0
    "forcedBlocking" Integer 1
    "g12TfId" String "1"
    "g12TfIndividual" Uint32 1893
    "moAdmState" Integer 0
    "syncSrc" Integer 3
    "tfComp" Int16 0
    "tfMode" Integer 1
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "0"
    moType BscM:G12Trxc
    exception none
    nrOfAttributes 16
    "blState" Integer 0
    "changeSubordState" Integer 1
    "dcpSignalling" Uint16 178
    "dcpSpeechDataBegin" Uint16 179
    "dcpSpeechDataEnd" Uint32 186
    "dedicateToChannelGroup" Ref "null"
    "dedicateToGeranCell" Ref "null"
    "forcedBlocking" Integer 1
    "g12TrxcId" String "0"
    "g12TrxcIndividual" Uint32 30288
    "moAdmState" Integer 0
    "sig" Integer 4
    "tei" Uint8 0
    "traff" Integer 1
    "usesG12Mctr" Ref "null"
    "usesSuperChannel" Ref "null"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=0"
    identity "1"
    moType BscM:G12Rx
    exception none
    nrOfAttributes 10
    "antA" String "null"
    "antB" String "null"
    "band" Integer 0
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12RxId" String "1"
    "g12RxIndividual" Uint32 30288
    "imbVamos" Integer 1
    "moAdmState" Integer 0
    "rxd" Integer 2
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=0"
    identity "0"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "0"
    "g12TsIndividual" Uint32 242304
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=0"
    identity "1"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "1"
    "g12TsIndividual" Uint32 242305
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=0"
    identity "2"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "2"
    "g12TsIndividual" Uint32 242306
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=0"
    identity "3"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "3"
    "g12TsIndividual" Uint32 242307
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=0"
    identity "4"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "4"
    "g12TsIndividual" Uint32 242308
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=0"
    identity "5"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "5"
    "g12TsIndividual" Uint32 242309
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=0"
    identity "6"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "6"
    "g12TsIndividual" Uint32 242310
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=0"
    identity "7"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "7"
    "g12TsIndividual" Uint32 242311
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=0"
    identity "1"
    moType BscM:G12Tx
    exception none
    nrOfAttributes 10
    "ant" String "null"
    "band" Integer 0
    "blState" Integer 0
    "dedicateToChannelGroup" Ref "null"
    "dedicateToGeranCell" Ref "null"
    "forcedBlocking" Integer 1
    "g12TxId" String "1"
    "g12TxIndividual" Uint32 30288
    "mPwr" Uint8 35
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "1"
    moType BscM:G12Trxc
    exception none
    nrOfAttributes 16
    "blState" Integer 0
    "changeSubordState" Integer 1
    "dcpSignalling" Uint16 187
    "dcpSpeechDataBegin" Uint16 188
    "dcpSpeechDataEnd" Uint32 195
    "dedicateToChannelGroup" Ref "null"
    "dedicateToGeranCell" Ref "null"
    "forcedBlocking" Integer 1
    "g12TrxcId" String "1"
    "g12TrxcIndividual" Uint32 30289
    "moAdmState" Integer 0
    "sig" Integer 4
    "tei" Uint8 1
    "traff" Integer 1
    "usesG12Mctr" Ref "null"
    "usesSuperChannel" Ref "null"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=1"
    identity "1"
    moType BscM:G12Rx
    exception none
    nrOfAttributes 10
    "antA" String "null"
    "antB" String "null"
    "band" Integer 0
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12RxId" String "1"
    "g12RxIndividual" Uint32 30289
    "imbVamos" Integer 1
    "moAdmState" Integer 0
    "rxd" Integer 2
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=1"
    identity "0"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "0"
    "g12TsIndividual" Uint32 242312
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=1"
    identity "1"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "1"
    "g12TsIndividual" Uint32 242313
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=1"
    identity "2"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "2"
    "g12TsIndividual" Uint32 242314
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=1"
    identity "3"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "3"
    "g12TsIndividual" Uint32 242315
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=1"
    identity "4"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "4"
    "g12TsIndividual" Uint32 242316
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=1"
    identity "5"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "5"
    "g12TsIndividual" Uint32 242317
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=1"
    identity "6"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "6"
    "g12TsIndividual" Uint32 242318
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=1"
    identity "7"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "7"
    "g12TsIndividual" Uint32 242319
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=1"
    identity "1"
    moType BscM:G12Tx
    exception none
    nrOfAttributes 10
    "ant" String "null"
    "band" Integer 0
    "blState" Integer 0
    "dedicateToChannelGroup" Ref "null"
    "dedicateToGeranCell" Ref "null"
    "forcedBlocking" Integer 1
    "g12TxId" String "1"
    "g12TxIndividual" Uint32 30289
    "mPwr" Uint8 35
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "2"
    moType BscM:G12Trxc
    exception none
    nrOfAttributes 16
    "blState" Integer 0
    "changeSubordState" Integer 1
    "dcpSignalling" Uint16 196
    "dcpSpeechDataBegin" Uint16 197
    "dcpSpeechDataEnd" Uint32 204
    "dedicateToChannelGroup" Ref "null"
    "dedicateToGeranCell" Ref "null"
    "forcedBlocking" Integer 1
    "g12TrxcId" String "2"
    "g12TrxcIndividual" Uint32 30290
    "moAdmState" Integer 0
    "sig" Integer 4
    "tei" Uint8 2
    "traff" Integer 1
    "usesG12Mctr" Ref "null"
    "usesSuperChannel" Ref "null"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=2"
    identity "1"
    moType BscM:G12Rx
    exception none
    nrOfAttributes 10
    "antA" String "null"
    "antB" String "null"
    "band" Integer 0
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12RxId" String "1"
    "g12RxIndividual" Uint32 30290
    "imbVamos" Integer 1
    "moAdmState" Integer 0
    "rxd" Integer 2
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=2"
    identity "0"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "0"
    "g12TsIndividual" Uint32 242320
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=2"
    identity "1"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "1"
    "g12TsIndividual" Uint32 242321
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=2"
    identity "2"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "2"
    "g12TsIndividual" Uint32 242322
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=2"
    identity "3"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "3"
    "g12TsIndividual" Uint32 242323
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=2"
    identity "4"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "4"
    "g12TsIndividual" Uint32 242324
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=2"
    identity "5"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "5"
    "g12TsIndividual" Uint32 242325
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=2"
    identity "6"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "6"
    "g12TsIndividual" Uint32 242326
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=2"
    identity "7"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "7"
    "g12TsIndividual" Uint32 242327
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=2"
    identity "1"
    moType BscM:G12Tx
    exception none
    nrOfAttributes 10
    "ant" String "null"
    "band" Integer 0
    "blState" Integer 0
    "dedicateToChannelGroup" Ref "null"
    "dedicateToGeranCell" Ref "null"
    "forcedBlocking" Integer 1
    "g12TxId" String "1"
    "g12TxIndividual" Uint32 30290
    "mPwr" Uint8 35
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    identity "3"
    moType BscM:G12Trxc
    exception none
    nrOfAttributes 16
    "blState" Integer 0
    "changeSubordState" Integer 1
    "dcpSignalling" Uint16 205
    "dcpSpeechDataBegin" Uint16 206
    "dcpSpeechDataEnd" Uint32 213
    "dedicateToChannelGroup" Ref "null"
    "dedicateToGeranCell" Ref "null"
    "forcedBlocking" Integer 1
    "g12TrxcId" String "3"
    "g12TrxcIndividual" Uint32 30291
    "moAdmState" Integer 0
    "sig" Integer 4
    "tei" Uint8 3
    "traff" Integer 1
    "usesG12Mctr" Ref "null"
    "usesSuperChannel" Ref "null"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=3"
    identity "1"
    moType BscM:G12Rx
    exception none
    nrOfAttributes 10
    "antA" String "null"
    "antB" String "null"
    "band" Integer 0
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12RxId" String "1"
    "g12RxIndividual" Uint32 30291
    "imbVamos" Integer 1
    "moAdmState" Integer 0
    "rxd" Integer 2
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=3"
    identity "0"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "0"
    "g12TsIndividual" Uint32 242328
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=3"
    identity "1"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "1"
    "g12TsIndividual" Uint32 242329
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=3"
    identity "2"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "2"
    "g12TsIndividual" Uint32 242330
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=3"
    identity "3"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "3"
    "g12TsIndividual" Uint32 242331
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=3"
    identity "4"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "4"
    "g12TsIndividual" Uint32 242332
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=3"
    identity "5"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "5"
    "g12TsIndividual" Uint32 242333
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=3"
    identity "6"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "6"
    "g12TsIndividual" Uint32 242334
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=3"
    identity "7"
    moType BscM:G12Ts
    exception none
    nrOfAttributes 5
    "blState" Integer 0
    "forcedBlocking" Integer 1
    "g12TsId" String "7"
    "g12TsIndividual" Uint32 242335
    "moAdmState" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=3"
    identity "1"
    moType BscM:G12Tx
    exception none
    nrOfAttributes 10
    "ant" String "null"
    "band" Integer 0
    "blState" Integer 0
    "dedicateToChannelGroup" Ref "null"
    "dedicateToGeranCell" Ref "null"
    "forcedBlocking" Integer 1
    "g12TxId" String "1"
    "g12TxIndividual" Uint32 30291
    "mPwr" Uint8 35
    "moAdmState" Integer 0
)
MOSC
G1CELLLIST=`cat $PWD/../customdata/GsmTopology.csv | grep -i "SIM:$SIMNUM;NODE:$NODENAME" | grep "BTS:G1-$G1BTSCOUNT;" | awk -F"CELL:" '{print $2}' | awk -F";" '{print $1}'`
CELLS=(${G1CELLLIST// / })
CELLCOUNT=0
cat >> $MOSCRIPT << MOSC
SET
(
    mo "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT"
    exception none
    nrOfAttributes 1
    "connectedChannelGroup" Array Ref ${#CELLS[@]}
MOSC
  while [ "$CELLCOUNT" -lt "${#CELLS[@]}" ]
  do
  echo -e '        ManagedElement='$NODENAME',BscFunction=1,BscM=1,GeranCellM=1,GeranCell='${CELLS[$CELLCOUNT]}',ChannelGroup=0' >> $MOSCRIPT
  CELLCOUNT=`expr $CELLCOUNT + 1`
  done
  echo -e ')' >> $MOSCRIPT
  CELLCOUNT=0
  while [ "$CELLCOUNT" -lt "${#CELLS[@]}" ]
  do
cat >> $MOSCRIPT << MOSC
SET
(
    mo "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=$CELLCOUNT"
    exception none
    nrOfAttributes 1
    "dedicateToGeranCell" Ref "ManagedElement=$NODENAME,BscFunction=1,BscM=1,GeranCellM=1,GeranCell=${CELLS[$CELLCOUNT]}"
)

SET
(
    mo "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G12Tg=$G1BTSCOUNT,BscM:G12Trxc=$CELLCOUNT"
    exception none
    nrOfAttributes 1
    "dedicateToChannelGroup" Ref "ManagedElement=$NODENAME,BscFunction=1,BscM=1,GeranCellM=1,GeranCell=${CELLS[$CELLCOUNT]},ChannelGroup=0"
)
MOSC
  CELLCOUNT=`expr $CELLCOUNT + 1`
  done
G1BTSCOUNT=`expr $G1BTSCOUNT + 1`
done
fi

if [ "$NUMOFG2BTS" -ne "0" ]
then
### Setting for G2 BTS #####
while [ "$G2BTSCOUNT" -le "$NUMOFG2BTS"  ]
do
   G2CELLLIST=`cat $PWD/../customdata/GsmTopology.csv | grep -i "SIM:$SIMNUM;NODE:$NODENAME" | grep "BTS:G2-$G2BTSCOUNT;" | awk -F"CELL:" '{print $2}' | awk -F";" '{print $1}'`
CELLS=(${G2CELLLIST// / })
CELLCOUNT=0
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1"
    identity "$G2BTSCOUNT"
    moType BscM:G31Tg
    exception none
    nrOfAttributes 14
    "g31TgId" String "$G2BTSCOUNT"
    "connectedChannelGroup" Array Ref 0
    "alCoTim" Uint16 90
    "blState" Integer "null"
    "bssWanted" Uint16 0
    "ccchCmd" Integer 0
    "confMd" Integer 2
    "moAdmState" Integer 0
    "rSite" String "B072_1005_09058"
    "sector" String "$G2BTSCOUNT"
    "tgCoord" Integer 1
    "forcedBlocking" Integer 1
    "imbVamos" Integer 1
    "g31TgIndividual" Uint32 "null"
)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:Bts=1,BscM:G31Tg=$G2BTSCOUNT"
    exception none
    nrOfAttributes 1
    "connectedChannelGroup" Array Ref 1
        ManagedElement=$NODENAME,BscFunction=1,BscM=1,GeranCellM=1,GeranCell=${CELLS[@]},ChannelGroup=0
)
MOSC
   G2BTSCOUNT=`expr $G2BTSCOUNT + 1`
done

fi

cat >> $MMLSCRIPT << MML
.open $SIMNAME
.select $NODENAME
.start
kertayle:file="$PWD/$MOSCRIPT";
MML
~/inst/netsim_shell < $MMLSCRIPT
rm $MMLSCRIPT
rm $MOSCRIPT
