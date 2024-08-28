#!/bin/sh
### VERSION HISTORY
####################################################################################
#     Version     : 1.3
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
####################################################################################
#####################################################################################
#     Version     : 1.2
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
. $PWD/../dat/Build.env
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
counter=1
while [ "$RELCOUNT" -le "$EXTRELPERCELL" ]
do
randomPointer=`getRandomValue $NUMOFEXTCELLS`
randomPointers+=($randomPointer)
  for elem in ${randomPointers[@]}
  do
  if [ "$randomPointer" -eq "$elem" ]
  then
     randomPointers+=($randomPointer)
     #RELCOUNT=`expr $RELCOUNT - 1`
     break 1;
  fi
  done
RELCOUNT=`expr $RELCOUNT + 1`
Relation=`awk 'NR=='$randomPointer $EXTCELLSDATA`
IdRelation=`expr $counter + 32768`
counter=`expr $counter + 1`
echo "CELL: $CELL ;RELATION: $Relation"
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
    "bcc" Uint8 "null"
    "bcchNo" Uint16 "null"
    "cSysType" Integer 0
    "fastMsReg" Integer 0
    "layer" Uint8 2
    "layerHyst" Uint8 2
    "layerThr" Int16 75
    "missnM" Uint8 3
    "msTxPwr" Uint8 "null"
    "ncc" Uint8 "null"
    "pHcsThr" Uint8 "null"
    "pLayer" Uint8 "null"
    "pSsTemp" Uint8 0
    "pTimTemp" Uint16 0
    "scho" Integer 1
    "rac" Uint8 1
    "rimNaCc" Integer 0
    "dfi" Integer 0
    "cgi" String "null"
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
    nrOfAttributes 10
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
    nrOfAttributes 10
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
    nrOfAttributes 10
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
    nrOfAttributes 10
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
)
MOSC
fi
done

RELATIONCOUNTER=`expr $RELATIONCOUNTER + $RELCOUNT - 1`
echo "NODENAME:$NODENAME;CELL:$CELL;EXTERNALGSMRELATIONS:$RELATIONCOUNTER" >> $PWD/../customdata/NetworkStats.csv
