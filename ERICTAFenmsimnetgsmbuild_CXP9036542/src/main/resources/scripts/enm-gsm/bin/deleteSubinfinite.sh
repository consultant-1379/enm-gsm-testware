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
if [ "$#" -ne 4 ]
then
 echo
 echo "Usage: $0 <sim name> <node name> < infiniteMo count > < subInfiniteCount >"
 echo
 echo "Example: $0 GSM-FT-150cell_BSC_17-Q4_V4x9-GSM01 1"
 echo
 exit 1
fi

SIM=$1
NODENAME=$2
infiniteFileCount=$3
subInfiniteCount=$4
simNum="${SIM:(-2)}"
echo "simNum=$simNum"
SIMNUM=`expr $simNum + 0`
echo "SIMNUM=$SIMNUM"
PWD=`pwd`

createNodeData() {
SIM=$1
NODENAME=$2
STARTCELL=$3
ENDCELL=$4
NUMOFCELLS=$5
NUMOFBTS=$6
MOSCRIPT=$NODENAME"_SubInfinite.mo"
## Creating File Group Mos #############
GROUPNUM=`expr $NUMOFCELLS / 2`
FILENUM=$NUMOFCELLS
COUNT=1
while [ "$COUNT" -le "$infiniteFileCount" ]
do
Count=1
while [ "$Count" -le "$subInfiniteCount" ]
do
cat >> $MOSCRIPT << MOSC
DELETE
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,AxeFunctions:AxeFunctions=1,AxeFunctions:SystemHandling=1,AxeCpFileSystem:CpFileSystemM=1,AxeCpFileSystem:CpVolume=$COUNT,AxeCpFileSystem:InfiniteFile=$Count,AxeCpFileSystem:InfiniteSubFile=1"
)
MOSC
Count=`expr $Count + 1`
done
COUNT=`expr $COUNT + 1`
done
MMLSCRIPT=$NODENAME"_BulkupSubInfinite.mml"
## Creating MMLSCRIPT #################################
cat >> $MMLSCRIPT << MML
.open $SIM
.select $NODENAME
.start
useattributecharacteristics:switch="off";
kertayle:file="$PWD/$MOSCRIPT";
MML
}


###### MAIN ###########
  echo "------------NODENAME=$NODENAME------------"
  CELLRANGE=`cat "$PWD/../customdata/GsmTopology.csv" | grep -i "SIM:$SIMNUM;NODE:$NODENAME" | awk -F"INTRARANGE:" '{print $2}' | awk -F";" '{print $1}'| head -n+1`
  STARTCELL=$(echo $CELLRANGE | awk -F"-" '{print $1}')
  ENDCELL=$(echo $CELLRANGE | awk -F"-" '{print $2}')
  CellsPerNode=`expr $ENDCELL - $STARTCELL + 1`
  STARTCELL=`expr 1000000 + $STARTCELL`
  ENDCELL=`expr 1000000 + $ENDCELL`
  echo "NodeName: $NODENAME ; StartCell: $STARTCELL ; EndCell: $ENDCELL"
 `createNodeData $SIM $NODENAME $STARTCELL $ENDCELL $CellsPerNode $infiniteFileCount $subInfiniteCount`
  MMLSCRIPT=$NODENAME"_BulkupSubInfinite.mml"
  MOSCRIPT=$NODENAME"_SubInfinite.mo"
~/inst/netsim_shell < $MMLSCRIPT
rm $MMLSCRIPT
rm $MOSCRIPT
