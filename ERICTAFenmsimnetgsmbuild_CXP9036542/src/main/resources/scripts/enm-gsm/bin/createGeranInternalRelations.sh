#!/bin/sh
### VERSION HISTORY
#####################################################################################
#     Version     : 1.2
#
#     Revision    : CXP 903 6542-1-8
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-34459,NSS-34065
#
#     Description : Adding support for 8000 cell BSC related to NRM5.1
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
SIMNAME=$1
NODENAME=$2
MOSCRIPT=$3
SIMNUM="${SIMNAME:(-2)}"
NODENUM="${NODENAME:(-2)}"
simNum=`expr $SIMNUM + 0`
cellFlag=0
. $PWD/../dat/Build.env

NETWORKLIST=(${CELLARRAY//;/ })
for elem in ${NETWORKLIST[@]}
do
cellDistribution=$(echo $elem | awk -F"," '{print $2}')
if [[ $cellDistribution = *"|8000"* ]]
then
# This attribute will set only for node 8000 cell
cellFlag=8000
fi
done

if [[ $SIMNUM == "48" ]] && [[ $NODENUM == "96" ]] && [[ $cellFlag == "8000" ]]
then
   G1BTSCOUNT=8000
else
   G1BTSCOUNT=`cat "$PWD/../customdata/GsmTopology.csv" | grep -i "SIM:$simNum;NODE:$NODENAME" | grep "BTS:G1" | tail -n-1 | awk -F"G1-" '{print $2}' | awk -F";" '{print $1}'`
fi
BTSCOUNT=1
if [[ $SIMNUM == "48" ]] && [[ $NODENUM == "96" ]] && [[ $cellFlag == "8000" ]]
then
  CELL=`cat "$PWD/../customdata/GsmTopology.csv" | grep -i "SIM:$simNum;NODE:$NODENAME" | grep "BTS:G1-$BTSCOUNT;" | awk -F"CELL:" '{print $2}' | awk -F";" '{print $1}'`
fi
relationCount=0
while [[ "$BTSCOUNT" -le "$G1BTSCOUNT" ]]
do
  if [[ $SIMNUM == "48" ]] && [[ $NODENUM == "96" ]] && [[ $cellFlag == "8000" ]]
  then
      if [[ $CELL == "1030000" ]]
      then
         relation=`expr $CELL - $cellFlag + 1`
      else
         relation=`expr $CELL + 1`
      fi
      echo "CELL:$CELL INTERNALRELATION: $relation"
      ./createInternalCellRelation.sh $NODENAME $CELL $relation $MOSCRIPT
      CELL=`expr $CELL + 1`
      relationCount=`expr $relationCount + 1`
  else
  cat "$PWD/../customdata/GsmTopology.csv" | grep -i "SIM:$simNum;NODE:$NODENAME" | grep "BTS:G1-$BTSCOUNT;" | awk -F"CELL:" '{print $2}' | awk -F";" '{print $1}' > internalCells.csv
  while read -r CELL
  do
    internalRelationData=`cat "internalCells.csv" | grep -vi "$CELL"`
    internalRelations=(${internalRelationData// / })
    if [ "${#internalRelations[@]}" -ne "0" ]
    then
       for relation in ${internalRelations[@]}
       do
         echo "CELL:$CELL INTERNALRELATION: $relation"
         ./createInternalCellRelation.sh $NODENAME $CELL $relation $MOSCRIPT
         relationCount=`expr $relationCount + 1`
       done
    fi
  done < internalCells.csv
  rm internalCells.csv
  fi
BTSCOUNT=`expr $BTSCOUNT + 1`
done
echo "NodeName=$NODENAME;GsmInternalCellRelations=$relationCount" >> $PWD/../customdata/NetworkStats.csv
#echo "NodeName=$NODENAME;GsmInternalCellRelations=$relationCount" >> preBuildGSMCounts.csv
