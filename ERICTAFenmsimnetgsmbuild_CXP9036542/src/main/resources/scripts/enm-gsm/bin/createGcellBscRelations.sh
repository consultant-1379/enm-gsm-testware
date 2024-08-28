#!/bin/sh
### VERSION HISTORY
#####################################################################################
#     Version     : 1.2
#
#     Revision    : CXP 903 6542-1-8
#
#     Author      : zsujmad
#
#     JIRA        : NSS-34065
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
SIMNAME=$1
NODENAME=$2

if [ "$#" -ne 2  ]
then
 echo
 echo "Usage: $0 <sim name> <nodename>"
 echo
 echo "-------------------------------------------------------------------"
 echo "# $0 script ended ERRONEOUSLY !!!!"
 echo "###################################################################"
 exit 1
fi

. $PWD/../dat/Build.env
SIMNUM="${SIMNAME:(-2)}"
NODENUM="${NODENAME:(-2)}"
simNum=`expr $SIMNUM + 0`
CELLSDATA="GSM"$SIMNUM$NODENAME"_cells.csv"
EXTGSMCELLSDATA="ExternalGsmRelations.csv"
GSMEXTCELLSDATA="GsmExternalRelations.csv"
MOSCRIPT="GSM"$SIMNUM$NODENAME"_Relations.mo"
MMLSCRIPT="GSM"$SIMNUM$NODENAME"_Relations.mml"

if [ -e $CELLSDATA ]
then
   rm $CELLSDATA
fi
if [ -e $EXTGSMCELLSDATA ]
then
   rm $EXTGSMCELLSDATA
fi
if [ -e $GSMEXTCELLSDATA ]
then
   rm $GSMEXTCELLSDATA
fi
if [ -e $MOSCRIPT ]
then
   rm $MOSCRIPT
fi
if [ -e $MMLSCRIPT ]
then
   rm $MMLSCRIPT
fi

cat $PWD/../customdata/GsmTopology.csv | grep -i "SIM:$simNum;NODE:$NODENAME" | awk -F"CELL:" '{print $2}' | awk -F";" '{print $1}' > $CELLSDATA
PLMNID=`cat $PWD/../customdata/GsmTopology.csv | grep -i "SIM:$simNum;" | awk -F"PLMNID:" '{print $2}' | awk -F";" '{print $1}' | head -n+1`
cat $PWD/../customdata/GsmTopology.csv | grep "PLMNID:$PLMNID" | grep -v "SIM:$simNum;NODE:$NODENAME" | awk -F"CELL:" '{print $2}' | awk -F";" '{print $1}' > $GSMEXTCELLSDATA
cat $PWD/../customdata/GsmTopology.csv | grep -v "PLMNID:$PLMNID" | awk -F"CELL:" '{print $2}' | awk -F";" '{print $1}' > $EXTGSMCELLSDATA
./createExtGsmNetwork.sh $NODENAME $MOSCRIPT
GsmInternalRelationsLog=$PWD"/../log/GSM"$SIMNUM$NODENAME"-GsmInternalCellRelations.log"
GsmIntraCellRelationsLog=$PWD"/../log/GSM"$SIMNUM$NODENAME"-GsmIntraCellRelations.log"
echo "******************** Creating Internal relations ********************************************" >> $GsmInternalRelationsLog
./createGeranInternalRelations.sh $SIMNAME $NODENAME $MOSCRIPT >> $GsmInternalRelationsLog

echo "******************** Creating Intracell relations *******************************************" >> $GsmIntraCellRelationsLog
./createGeranIntraRelations.sh $SIMNAME $NODENAME $MOSCRIPT >> $GsmIntraCellRelationsLog

GsmExternalRelationsLog=$PWD"/../log/GSM"$SIMNUM$NODENAME"-GsmExternalRelations.log"
ExternalGsmRelationsLog=$PWD"/../log/GSM"$SIMNUM$NODENAME"-ExternalGsmRelations.log"
echo "******************** Creating Gsm External relations ********************************************" >> $GsmExternalRelationsLog
echo "******************** Creating External Gsm relations ********************************************" >> $ExternalGsmRelationsLog
while read -r CELLVALUE
do
 ./createExternalRelations.sh $CELLVALUE $NODENAME $GSMEXTCELLSDATA $MOSCRIPT $GSMEXTRELPERCELL >> $GsmExternalRelationsLog
done < $CELLSDATA
while read -r cellValue
do
 ./createExternalRelations.sh $cellValue $NODENAME $EXTGSMCELLSDATA $MOSCRIPT $EXTGSMRELPERCELL >> $ExternalGsmRelationsLog
done < $CELLSDATA
gsmExternalRelationsCounter=`cat $GsmExternalRelationsLog | wc -l`
gsmExternalRelationsCount=`expr $gsmExternalRelationsCounter - 1`
externalGsmRelationsCounter=`cat $ExternalGsmRelationsLog | wc -l`
externalGsmRelationsCount=`expr $externalGsmRelationsCounter - 1`

ExternalUtranRelationsLog=$PWD"/../log/GSM"$SIMNUM$NODENAME"-ExternalUtranRelations.log"
echo "******************** Creating External Utran relations ******************************************" >> $ExternalUtranRelationsLog
./createUtranRelations.sh $SIMNAME $NODENAME $MOSCRIPT >> $ExternalUtranRelationsLog
echo "NodeName=$NODENAME;GsmExternalRelations=$gsmExternalRelationsCount" >> $PWD/../customdata/NetworkStats.csv
#echo "NodeName=$NODENAME;GsmExternalRelations=$gsmExternalRelationsCount" >> preBuildGSMCounts.csv
echo "NodeName=$NODENAME;ExternalGsmRelations=$externalGsmRelationsCount" >> $PWD/../customdata/NetworkStats.csv
#echo "NodeName=$NODENAME;ExternalGsmRelations=$externalGsmRelationsCount" >> preBuildGSMCounts.csv
rm $CELLSDATA
cat >> $MMLSCRIPT << MML
.open $SIMNAME
.select $NODENAME
.start
useattributecharacteristics:switch="off";
kertayle:file="$PWD/$MOSCRIPT";
.save
MML
~/inst/netsim_shell < $MMLSCRIPT
rm $GSMEXTCELLSDATA
rm $EXTGSMCELLSDATA
rm $MOSCRIPT
rm $MMLSCRIPT
