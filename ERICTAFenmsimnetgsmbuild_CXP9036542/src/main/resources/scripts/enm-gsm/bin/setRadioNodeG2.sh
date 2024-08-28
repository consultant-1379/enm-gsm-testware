#!/bin/sh
### VERSION HISTORY
#####################################################################################
#     Version     : 1.3
#
#     Revision    : CXP 903 6542-1-11
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : No Jira
#
#     Description : Adding code support 8000 cell BSC
#
#     Date        : 07th Apr 2021
#
####################################################################################
#####################################################################################
#     Version     : 1.2
#
#     Revision    : CXP 903 6542-1-8
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-34293
#
#     Description : Changing BSC and MSC Node names
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
simNum="${SIMNAME:(-2)}"
SIMNUM=`expr $simNum + 0`
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

NUMOFG2BTS=`cat $PWD/../customdata/GsmTopology.csv | grep -i "SIM:$SIMNUM;NODE:$NODENAME" | grep "BTS:G2" | wc -l`
if [ "$NUMOFG2BTS" -eq "0" ]
then
  echo "ERROR: No G2 Bts are present ...."
  exit 1
fi

G2BTSDATA=`cat $PWD/../customdata/GsmTopology.csv | grep -i "SIM:$SIMNUM;NODE:$NODENAME" | grep "BTS:G2" | awk -F"G2-" '{print $2}' | awk -F";" '{print $1}'`
G2BTSLIST=(${G2BTSDATA// / })
BTSCOUNT=0
RADIOCOUNT=1
RADIOCSV=$NODENAME"_RadioNode.csv"
MMLSCRIPT=$SIMNAME"_setRadio.mml"
if [ -e $MMLSCRIPT ]
then
   rm $MMLSCRIPT
fi

if [ -e $RADIOCSV ]
then
   rm $RADIOCSV
fi
while [ "$BTSCOUNT" -lt "${#G2BTSLIST[@]}" ]
do
  if [ "$RADIOCOUNT" -le "9" ]
  then
     RADIONUM='0'$RADIOCOUNT
  else
     RADIONUM=$RADIOCOUNT
  fi
  NodeName=`echo $NODENAME | sed -r 's/^.{3}//'`
  echo "SECTOR:${G2BTSLIST[$BTSCOUNT]};"RADIONODE:$NodeName"MSRBS-V2"$RADIONUM >> $NODENAME"_RadioNode.csv"
  COUNT=`expr $BTSCOUNT + 1`
  if [[ $simNum == "48" ]] && [[ $NodeName == "B96" ]] && [[ $cellFlag == "8000" ]]
  then
      INDEX=`expr $COUNT % 1`
  else
      INDEX=`expr $COUNT % 3`
  fi
  if [ "$INDEX" -eq "0" ]
  then
     RADIOCOUNT=`expr $RADIOCOUNT + 1`
  fi
  BTSCOUNT=`expr $BTSCOUNT + 1`
done
RADIOCOUNT=`cat $RADIOCSV | tail -n-1 | awk -F"MSRBS-V2" '{print $2}'`
#echo "RADIOCOUNT: $RADIOCOUNT"
NODECOUNT=1
while [ "$NODECOUNT" -le "$RADIOCOUNT" ]
do
  if [ "$NODECOUNT" -le "9" ]
  then
     RADIONUM='0'$NODECOUNT
  else
     RADIONUM=$NODECOUNT
  fi
  NodeName=`echo $NODENAME | sed -r 's/^.{3}//'`
  RADIONODE=$NodeName"MSRBS-V2"$RADIONUM
  MOSCRIPT=$RADIONODE"_setRadio.mo"
  if [ -e $MOSCRIPT ]
  then
     rm $MOSCRIPT
  fi
  cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$RADIONODE"
    identity "1"
    moType Grat:BtsFunction
    exception none
    nrOfAttributes 1
    "btsFunctionId" String "1"
)
MOSC
 cat >> $MMLSCRIPT << MML
.open $SIMNAME
.select $RADIONODE
.start
useattributecharacteristics:switch="off";
kertayle:file="$PWD/$MOSCRIPT";
.save
MML
NODECOUNT=`expr $NODECOUNT + 1`
done

while IFS= read Line ;
do
  DG2NODE=$(echo $Line | awk -F"RADIONODE:" '{print $2}')
  SECTOR=$(echo $Line | awk -F"SECTOR:" '{print $2}' | awk -F";" '{print $1}')
  MOSCRIPT=$DG2NODE"_setRadio.mo"
  cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$DG2NODE,Grat:BtsFunction=1"
    identity "$SECTOR"
    moType Grat:GsmSector
    exception none
    nrOfAttributes 2
    "gsmSectorId" String "$SECTOR"
    "bscTgIdentity" String "$SECTOR"
    "bscNodeIdentity" String "$NODENAME"
)
MOSC
done < $NODENAME"_RadioNode.csv"

echo "******RADIOCOUNT:$RADIOCOUNT"
NodeName=`echo $NODENAME | sed -r 's/^.{3}//'`
#./createRadioNode.sh $SIMNAME $NodeName $RADIOCOUNT $NODEVERSION >> $PWD/../log/$NODENAME"-RadioNode.log"
rm $NODENAME"_RadioNode.csv"
echo "## Running $0 script ..... ####" >> $PWD/../log/$NODENAME"-RadioNode.log"
~/inst/netsim_shell < $MMLSCRIPT | tee -a $PWD/../log/$NODENAME"-RadioNode.log"
rm $MMLSCRIPT
rm *.mo
./createDG2Product.sh $SIMNAME $NodeName $RADIOCOUNT $NODEVERSION
