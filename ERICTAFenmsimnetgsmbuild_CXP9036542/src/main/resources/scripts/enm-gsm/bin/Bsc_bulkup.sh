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
SIM=$1
simNum="${SIM:(-2)}"
SIMNUM=`expr $simNum + 0`
. $PWD/../dat/Build.env

echo "running Bsc_Cellbulkup.sh"
sh Bsc_Cellbulkup.sh $SIM
echo "running BulkupHwWork.sh"
sh BulkupHwInventory.sh $SIM
echo "running BulkupWorkG12.sh"
sh BulkupG12.sh $SIM
echo "running BulkupWorkInfinite.sh"
sh BulkupInfinite.sh $SIM

echo "Running Subinfinite deletion"
NODELIST=`echo -e '.open '$SIM' \n .show simnes' | ~/inst/netsim_shell | grep "LTE BSC"| cut -d' ' -f1`
Nodes=(${NODELIST// / })
NumOfNodes=${#Nodes[@]}
NODECOUNT=0
while [ "$NODECOUNT" -lt "$NumOfNodes" ]
do
 NODENAME=${Nodes[$NODECOUNT]}
  CELLRANGE=`cat $PWD/../customdata/GsmTopology.csv | grep -i "SIM:$SIMNUM;NODE:$NODENAME" | awk -F"INTRARANGE:" '{print $2}' | awk -F";" '{print $1}'| head -n+1`
  STARTCELL=$(echo $CELLRANGE | awk -F"-" '{print $1}')
  ENDCELL=$(echo $CELLRANGE | awk -F"-" '{print $2}')
  CellsPerNode=`expr $ENDCELL - $STARTCELL + 1`
  STARTCELL=`expr 1000000 + $STARTCELL`
  ENDCELL=`expr 1000000 + $ENDCELL`
  NUMOFBTS=`expr $CellsPerNode / 6`
  #echo "createNodeData $SIM $NODENAME $CellsPerNode $STARTCELL $ENDCELL $NUMOFBTS"
  if [[ "$CellsPerNode" == "" ]]
  then
     echo "Bulkup Failed at DeleteInfinte .... !!!"
     exit 1
  elif [[ "$CellsPerNode" == "150" ]]
  then
     infiniteMos=40
     infiniteSubMos=50
  elif [[ "$CellsPerNode" == "200" ]]
  then
     infiniteMos=52
     infiniteSubMos=50
  elif [[ "$CellsPerNode" == "250" ]]
  then
     infiniteMos=52
     infiniteSubMos=60
  elif [[ "$CellsPerNode" == "500" ]]
  then
     infiniteMos=62
     infiniteSubMos=100
  elif [[ "$CellsPerNode" == "1200" ]]
  then
     infiniteMos=96
     infiniteSubMos=150
  elif [[ "$CellsPerNode" == "2000" ]]
  then
     infiniteMos=162
     infiniteSubMos=160
  else
     echo "Bulkup is running for a non-standard cell file"
     exit 1
  fi
  ./deleteSubinfinite.sh $SIM $NODENAME $infiniteMos $infiniteSubMos
  NODECOUNT=`expr $NODECOUNT + 1`
done
