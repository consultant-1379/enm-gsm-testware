#!/bin/sh
### VERSION HISTORY
#####################################################################################
#     Version     : 1.5
#
#     Revision    : CXP 903 6542-1-22
#
#     Author      : AjayGanesh Achyutha
#
#     JIRA        : NSS-39187
#
#     Description : Updating the scho value for external gerancell
#
#     Date        : 27th May 2022
#
#####################################################################################
#####################################################################################
#     Version     : 1.4
#
#     Revision    : CXP 903 6542-1-12
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : No JIRA
#
#     Description : Adding utranCellRelationIndividual attribute type code support for all versions
#
#     Date        : 18th May 2021
#
####################################################################################
#####################################################################################
#     Version     : 1.3
#
#     Revision    : CXP 903 6542-1-11
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-34531
#
#     Description : Updating BSC ExternalGeranCell.layerThr attribute value is -75 
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
#     JIRA        : NSS-30601,NSS-30603
#
#     Description : Adding Code for GSM and LTE Consistencies 
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
CELL=$1
NODENAME=$2
EXTCELLSDATA=$3
MOSCRIPT=$4
EXTRELPERCELL=$5

. $PWD/../dat/Build.env
LTEHandOverFile=$PWD/../customdata/$LRANHANDOVERFILE
str1=`echo $BSCNODEVERSION | cut -d'-' -f1`
str2=`echo $BSCNODEVERSION | cut -d'-' -f2`

RELCOUNT=1
NUMOFEXTCELLS=`wc -l < $EXTCELLSDATA`

getRandomValue() {
NUMOFEXTCELLS=$1
#res=`awk -v min=1 -v max=$NUMOFEXTCELLS 'BEGIN{srand(); print int(min+rand()*(max-min+1))}'`
res=`shuf -i 1-$NUMOFEXTCELLS -n 1`
echo $res
}

randomPointer=`getRandomValue $NUMOFEXTCELLS`
randomPointers=()
randomPointers+=($randomPointer)
RELATIONCOUNTER=0
RELATIONTYPE=${EXTCELLSDATA%.csv}
counter=1
while [[ "$RELCOUNT" -le "$EXTRELPERCELL" ]]
do
randomPointer=`getRandomValue $NUMOFEXTCELLS`
randomPointers+=($randomPointer)
  for elem in ${randomPointers[@]}
  do
  if [[ "$randomPointer" -eq "$elem" ]]
  then
     randomPointers+=($randomPointer)
     #RELCOUNT=`expr $RELCOUNT - 1`
     break 1;
  fi
  done
RELCOUNT=`expr $RELCOUNT + 1`
Relation=`awk 'NR=='$randomPointer $EXTCELLSDATA`
echo "CELL: $CELL ;"$RELATIONTYPE"Relation: $Relation"
cellLocationData=`cat $PWD/../customdata/plmnNetworkData.csv | grep "CELL_NAME=$Relation"`
if [[ $cellLocationData == "" ]]
then
   echo "ERROR: No PLMN Id is set for External Cell $Relation of GeranCell $CELL"
else
   cellData=(${cellLocationData//;/ })
   PLMNID=${cellData[1]}"-"${cellData[2]}"-"${cellData[3]}"-"${cellData[4]}
fi
IdRelation=`expr $counter + 32768`
counter=`expr $counter + 1`
csvLine=`cat $LTEHandOverFile | grep "CELL_NAME=${Relation};"`
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
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:ExternalGeranCellM=1"
    identity "$Relation"
    moType BscM:ExternalGeranCell
    exception none
    nrOfAttributes 22
    "externalGeranCellId" String "$Relation"
    "aw" Integer 0
    "bcc" Uint8 "${BCC}"
    "bcchNo" Uint16 "${BCCHNO}"
    "cSysType" Integer 0
    "fastMsReg" Integer 0
    "layer" Uint8 2
    "layerHyst" Uint8 2
    "layerThr" Int16 "-75"
    "missnM" Uint8 3
    "msTxPwr" Uint8 "null"
    "ncc" Uint8 "${NCC}"
    "pHcsThr" Uint8 "null"
    "pLayer" Uint8 "null"
    "pSsTemp" Uint8 0
    "pTimTemp" Uint16 0
    "scho" Integer 1
    "rac" Uint8 1
    "rimNaCc" Integer 0
    "dfi" Integer 0
    "cgi" String "${CGI}"
    "externalGeranCellIndividual" Uint16 "$IdRelation"
)
MOSC
if [[ $str1 -ge 21 ]]
then
   if [[ $str1 == 21 ]]
   then
      if [[ $str2 == "Q1" ]]
      then
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELL"
    identity "$Relation"
    moType BscM:ExternalGeranCellRelation
    exception none
    nrOfAttributes 11
    "externalGeranCellRelationId" String "$Relation"
    "hiHyst" Uint8 5
    "kHyst" Uint8 3
    "loHyst" Uint8 3
    "lHyst" Uint8 3
    "offset" Int8 0
    "tRHyst" Uint8 2
    "gprsValid" Integer 1
    "cand" Integer 0
    "cellRelationIndividual" Uint16 "$IdRelation"
    "pROffset" Uint8 1
)
MOSC
       else
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELL"
    identity "$Relation"
    moType BscM:ExternalGeranCellRelation
    exception none
    nrOfAttributes 11
    "externalGeranCellRelationId" String "$Relation"
    "hiHyst" Uint8 5
    "kHyst" Uint8 3
    "loHyst" Uint8 3
    "lHyst" Uint8 3
    "offset" Int8 0
    "tRHyst" Uint8 2
    "gprsValid" Integer 1
    "cand" Integer 0
    "cellRelationIndividual" Uint32 "$IdRelation"
    "pROffset" Uint8 1
)
MOSC
        fi
     else
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELL"
    identity "$Relation"
    moType BscM:ExternalGeranCellRelation
    exception none
    nrOfAttributes 11
    "externalGeranCellRelationId" String "$Relation"
    "hiHyst" Uint8 5
    "kHyst" Uint8 3
    "loHyst" Uint8 3
    "lHyst" Uint8 3
    "offset" Int8 0
    "tRHyst" Uint8 2
    "gprsValid" Integer 1
    "cand" Integer 0
    "cellRelationIndividual" Uint32 "$IdRelation"
    "pROffset" Uint8 1
)
MOSC
     fi
else
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELL"
    identity "$Relation"
    moType BscM:ExternalGeranCellRelation
    exception none
    nrOfAttributes 11
    "externalGeranCellRelationId" String "$Relation"
    "hiHyst" Uint8 5
    "kHyst" Uint8 3
    "loHyst" Uint8 3
    "lHyst" Uint8 3
    "offset" Int8 0
    "tRHyst" Uint8 2
    "gprsValid" Integer 1
    "cand" Integer 0
    "cellRelationIndividual" Uint16 "$IdRelation"
    "pROffset" Uint8 1
)
MOSC
fi
done
