#!/bin/sh
### VERSION HISTORY
#####################################################################################
#     Version     : 1.2
#
#     Revision    : CXP 903 6542-1-8
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-34154,NSS-34065
#
#     Description : Correcting GeranCellrelation MOs code
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
. $PWD/../dat/Build.env

## Routine for random value generator ####
getRandomValue() {
NUMOFEXTCELLS=$1
#res=`awk -v min=1 -v max=$NUMOFEXTCELLS 'BEGIN{srand(); print int(min+rand()*(max-min+1))}'`
res=`shuf -i 1-$NUMOFEXTCELLS -n 1`
echo $res
}

if [[ "$SWITCHTORV" == "NO" ]]
then
    INTRARELPERCELL=5
fi
if [ -e nodeCellData.csv ]
then
   rm nodeCellData.csv
fi

if [ -e intraCellData.csv ]
then
rm intraCellData.csv
fi

cat "$PWD/../customdata/GsmTopology.csv" | grep -i "SIM:$simNum;NODE:$NODENAME" > nodeCellData.csv
BTSCOUNT=1
### Creating Relations for G1 BTS #######

relationCounter=0
while read -r Line
do
#  Line=`cat "nodeCellData.csv" | head -n +1`
#  echo $Line
  BTS=$(echo $Line | awk -F"BTS:G" '{print $2}' | awk -F"-" '{print $1}')
  CELL=$(echo $Line | awk -F"CELL:" '{print $2}' | awk -F";" '{print $1}')
  #### Extracting the cells of the bts other than the one in the current iteration ####
  BTSCOUNT=$(echo $Line | awk -F"BTS:G${BTS}-" '{print $2}' | awk -F";" '{print $1}')
  cat "nodeCellData.csv" | grep -v "BTS:G${BTS}-${BTSCOUNT};" | awk -F"CELL:" '{print $2}' | awk -F";" '{print $1}' > intraCellData.csv
  numOfIntraCells=`wc -l < intraCellData.csv`
  randomPointers=()
  cellPointers=()
  relationCount=1
  while [[ "$relationCount" -le "$INTRARELPERCELL" ]]
  do
    flag=0
    randomPointer=`getRandomValue $numOfIntraCells`
    randomPointers+=($randomPointer)
    if [[ $relationCount == 1 ]]
    then
        cellPointers+=($randomPointer)
        relationCount=`expr $relationCount + 1`
        Relation=`awk 'NR=='$randomPointer intraCellData.csv`
        echo "NODENAME: $NODENAME ;CELL: $CELL ;INTRARELATION: $Relation"
        ./createInternalCellRelation.sh $NODENAME $CELL $Relation $MOSCRIPT
        relationCounter=`expr $relationCounter + 1`
        flag=1
    else
        for elem in ${cellPointers[@]}
        do
            if [[ "$randomPointer" -eq "$elem" ]]
            then
                 # echo "***$elem and $randomPointer are equal*** ${randomPointers[@]} in loop $relationCount"
                  flag=1
                  break 1;
            fi
        done
    fi
    if [[ $flag == 0 ]]
    then
        cellPointers+=($randomPointer)
        relationCount=`expr $relationCount + 1`
        Relation=`awk 'NR=='$randomPointer intraCellData.csv`
        echo "NODENAME: $NODENAME ;CELL: $CELL ;INTRARELATION: $Relation in flag condition"
       ./createInternalCellRelation.sh $NODENAME $CELL $Relation $MOSCRIPT
        relationCounter=`expr $relationCounter + 1`
    fi
  done

  rm intraCellData.csv
BTSCOUNT=`expr $BTSCOUNT + 1`
done < nodeCellData.csv

rm nodeCellData.csv
echo "NodeName=$NODENAME;GsmIntraCellRelations=$relationCounter" >> $PWD/../customdata/NetworkStats.csv
#echo "NodeName=$NODENAME;GsmIntraCellRelations=$relationCounter" >> preBuildGSMCounts.csv
