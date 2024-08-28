#!/bin/sh
### VERSION HISTORY
#####################################################################################
#     Version     : 1.2
#
#     Revision    : CXP 903 6542-1-12
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : No JIRA
#
#     Description : Updating cellRelationIndividual type
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
NODENAME=$1
CELL=$2
RELATION=$3
MOSCRIPT=$4

. $PWD/../dat/Build.env
str1=`echo $BSCNODEVERSION | cut -d'-' -f1`
str2=`echo $BSCNODEVERSION | cut -d'-' -f2`

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
    identity "$RELATION"
    moType BscM:GeranCellRelation
    exception none
    nrOfAttributes 13
    "cand" Integer 0
    "cellRelationIndividual" Uint16 $RELATION
    "cs" Integer 0
    "geranCellRelationId" String "$RELATION"
    "gprsValid" Integer 1
    "hiHyst" Uint8 5
    "kHyst" Uint8 3
    "lHyst" Uint8 3
    "loHyst" Uint8 3
    "offset" Int8 0
    "relationDirection" Integer 0
    "tRHyst" Int8 2
    "pROffset" Uint8 1
)
MOSC
       else
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELL"
    identity "$RELATION"
    moType BscM:GeranCellRelation
    exception none
    nrOfAttributes 13
    "cand" Integer 0
    "cellRelationIndividual" Uint32 $RELATION
    "cs" Integer 0
    "geranCellRelationId" String "$RELATION"
    "gprsValid" Integer 1
    "hiHyst" Uint8 5
    "kHyst" Uint8 3
    "lHyst" Uint8 3
    "loHyst" Uint8 3
    "offset" Int8 0
    "relationDirection" Integer 0
    "tRHyst" Int8 2
    "pROffset" Uint8 1
)
MOSC
      fi
   else
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELL"
    identity "$RELATION"
    moType BscM:GeranCellRelation
    exception none
    nrOfAttributes 13
    "cand" Integer 0
    "cellRelationIndividual" Uint32 $RELATION
    "cs" Integer 0
    "geranCellRelationId" String "$RELATION"
    "gprsValid" Integer 1
    "hiHyst" Uint8 5
    "kHyst" Uint8 3
    "lHyst" Uint8 3
    "loHyst" Uint8 3
    "offset" Int8 0
    "relationDirection" Integer 0
    "tRHyst" Int8 2
    "pROffset" Uint8 1
)
MOSC
   fi
else
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELL"
    identity "$RELATION"
    moType BscM:GeranCellRelation
    exception none
    nrOfAttributes 13
    "cand" Integer 0
    "cellRelationIndividual" Uint16 $RELATION
    "cs" Integer 0
    "geranCellRelationId" String "$RELATION"
    "gprsValid" Integer 1
    "hiHyst" Uint8 5
    "kHyst" Uint8 3
    "lHyst" Uint8 3
    "loHyst" Uint8 3
    "offset" Int8 0
    "relationDirection" Integer 0
    "tRHyst" Int8 2
    "pROffset" Uint8 1
)
MOSC
fi