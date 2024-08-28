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
#SIMNAME=$1
#NODENAME=$2
STARTTIME=`date`
SIMLIST=`ls /netsim/netsimdir/ | grep "GSM" | grep -v zip`
SIMS=(${SIMLIST// / })
for SIMNAME in ${SIMS[@]}
do
NODESLIST=`echo -e '.open '$SIMNAME' \n.show simnes' | ~/inst/netsim_shell | grep "LTE BSC" | cut -d" " -f1`
NODES=(${NODESLIST// / })
for NODENAME in ${NODES[@]}
do
CELLSLIST=`cat GsmTopology.csv | grep $NODENAME | awk -F"CELL:" '{print $2}' | awk -F";" '{print $1}'`
CELLS=(${CELLSLIST// / })
MOSCRIPT=$NODENAME"_setOffset.mo"
if [ -e $MOSCRIPT ] 
then
   rm $MOSCRIPT
fi
if [ -e $NODENAME"_GeranCellM.mo" ]
then
   rm $NODENAME"_GeranCellM.mo"
fi
echo -e '.open '$SIMNAME' \n.select '$NODENAME'\n.start \ndumpmotree:moid=185,outputfile="'$PWD'/'$NODENAME'_GeranCellM.mo";' | ~/inst/netsim_shell
CELLCOUNT=0
while [ "$CELLCOUNT" -lt "${#CELLS[@]}" ]
do
  NEXTCELL=`expr $CELLCOUNT + 1`
  if [ "$NEXTCELL" -ge "${#CELLS[@]}" ]
  then
     internalRelationsList=`awk '/BscM:GeranCell='${CELLS[$CELLCOUNT]}'/{flag=1; next} /\n/{flag=0} flag' $NODENAME"_GeranCellM.mo" | grep "BscM:GeranCellRelation" | awk -F"=" '{print $2}'`
     externalRelationsList=`awk '/BscM:GeranCell='${CELLS[$CELLCOUNT]}'/{flag=1; next} /\n/{flag=0} flag' $NODENAME"_GeranCellM.mo" | grep "BscM:ExternalGeranCellRelation" | awk -F"=" '{print $2}'`
  else
     internalRelationsList=`awk '/BscM:GeranCell='${CELLS[$CELLCOUNT]}'/{flag=1; next} /BscM:GeranCell='${CELLS[$NEXTCELL]}'/{flag=0} flag' $NODENAME"_GeranCellM.mo" | grep "BscM:GeranCellRelation" | awk -F"=" '{print $2}'`
     externalRelationsList=`awk '/BscM:GeranCell='${CELLS[$CELLCOUNT]}'/{flag=1; next} /BscM:GeranCell='${CELLS[$NEXTCELL]}'/{flag=0} flag' $NODENAME"_GeranCellM.mo" | grep "BscM:ExternalGeranCellRelation" | awk -F"=" '{print $2}'`
  fi
  internalRelations=(${internalRelationsList// / })
  externalRelations=(${externalRelationsList// / })
  for externalRelationId in ${externalRelations[@]}
  do
    cat >> $MOSCRIPT << MOSC
SET
(
   mo "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=${CELLS[$CELLCOUNT]},BscM:ExternalGeranCellRelation=$externalRelationId"
   exception none
   nrOfAttributes 1
   "pROffset" Uint8 "1"
)
MOSC
  done
  for internalRelationId in ${internalRelations[@]}
  do
    cat >> $MOSCRIPT << MOSC
SET
(
   mo "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=${CELLS[$CELLCOUNT]},BscM:GeranCellRelation=$internalRelationId"
   exception none
   nrOfAttributes 1
   "pROffset" Uint8 "1"
)
MOSC
  done
CELLCOUNT=`expr $CELLCOUNT + 1`
done
echo -e '.open '$SIMNAME' \n.select '$NODENAME'\n.start \nkertayle:file="'$PWD'/'$MOSCRIPT'";' | ~/inst/netsim_shell
rm  $NODENAME"_GeranCellM.mo"
done
done
ENDTIME=`date`
echo "Script started at $STARTTIME"
echo "...  and ended at $ENDTIME"
