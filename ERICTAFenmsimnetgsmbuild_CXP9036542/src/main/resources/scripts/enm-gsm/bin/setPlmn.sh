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
SIMNAME=$1
NODENAME=$2
START=`date`
SIMNUM="${SIMNAME:(-2)}"
simNum=`expr $SIMNUM + 0`
NODES=(${NODESLIST// / })
cellid=0
MOSCRIPT=$NODENAME"_gcell_set.mo"
MMLSCRIPT=$NODENAME"_gcell_set.mml"
if [ -e $MOSCRIPT ]
then
  rm $MOSCRIPT
fi

if [ -e $MMLSCRIPT ]
then
  rm $MMLSCRIPT
fi

NODECELLSCSV="GSM"$SIMNUM$NODENAME"_cells.csv"
if [ -e $NODECELLSCSV ]
then
  rm $NODECELLSCSV
fi

cat "$PWD/../customdata/GsmTopology.csv" | grep -i "SIM:$simNum;NODE:$NODENAME" | awk -F"CELL:" '{print $2}' | awk -F";" '{print $1}' > "GSM"$SIMNUM$NODENAME"_cells.csv"
    
while read -r CELLVALUE
do
PLMNID=`cat GSM30K_PLMN.csv | grep "CELL_NAME=$CELLVALUE" | awk -F";" '{print $2}' | awk -F"=" '{print $2}'`
cat >> $MOSCRIPT << MOSC
SET
(
    mo "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:GeranCellM=1,BscM:GeranCell=$CELLVALUE"
    exception none
    nrOfAttributes 1
    "cgi" String "$PLMNID"
)
MOSC
done < "GSM"$SIMNUM$NODENAME"_cells.csv"
cat >> $MMLSCRIPT << MML
.open $SIMNAME
.select $NODENAME
.start
useattributecharacteristics:switch="off";
kertayle:file="$PWD/$MOSCRIPT";
.save
MML
~/inst/netsim_shell < $MMLSCRIPT
rm $MOSCRIPT
rm $MMLSCRIPT


##### For ExternalGeranCells #########################################
PARENT=`echo -e  '.open '$SIMNAME' \n .select '$NODENAME' \ne: csmo:get_mo_ids_by_type(null,"BscM:ExternalGeranCellM").'  | /netsim/inst/netsim_shell | tail -n+6`
STR=$PARENT
STR1=(${STR//[/ })
STR2=(${STR1//]/ })
moId=$STR2
echo "MOID=$moId"
if [ -e external.mo ]
then
rm external.mo
fi
if [ -e external.mml ]
then
rm external.mml
fi
echo -e  '.open '$SIMNAME' \n .select '$NODENAME' \n dumpmotree:moid='$moId',outputfile="'$PWD'/values.txt";'  | /netsim/inst/netsim_shell > /dev/null 2>&1
while read -r MO;
do
  externalId=`echo $MO | awk -F"ExternalGeranCell=" '{print $2}'`
  if [[ $externalId == "" ]]
  then
      continue;
  else
  PLMNID=`cat GSM30K_PLMN.csv | grep "CELL_NAME=$externalId" | awk -F";" '{print $2}' | awk -F"=" '{print $2}'`
cat >> external.mo << MOSC
SET
(
    mo "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1,BscM:ExternalGeranCellM=1,BscM:ExternalGeranCell=$externalId"
    exception none
    nrOfAttributes 1
    "cgi" String "$PLMNID"
)
MOSC
   fi
done < values.txt
rm values.txt
cat >> external.mml << MML
.open $SIMNAME
.select $NODENAME
.start
useattributecharacteristics:switch="off";
kertayle:file="$PWD/external.mo";
.save
MML
~/inst/netsim_shell < external.mml
rm external.mml
rm external.mo
END=`date`
echo "SCRIPT started at $START"
echo "SCRIPT ended at $END"
