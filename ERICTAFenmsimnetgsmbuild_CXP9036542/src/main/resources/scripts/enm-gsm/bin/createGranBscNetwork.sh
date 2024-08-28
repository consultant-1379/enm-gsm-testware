#!/bin/sh
### VERSION HISTORY
#####################################################################################
##     Version      : 1.5
##
##     Revision     : CXP 903 6542-1-14
##
##     Author       : zyamkan
##
##     JIRA         : NSS-35602,35603
##
##     Description  : Setting GeranCell.balistActive, GeranCell.balistIdle & nccPerm.
##
##     Date         : 26th July 2021
##
######################################################################################
#####################################################################################
#     Version     : 1.4
#
#     Revision    : CXP 903 6542-1-13
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-36059
#
#     Description : Reparenting BSC node. It runs only for BSC94 node
#
#     Date        : 12th Jul 2021
#####################################################################################
#####################################################################################
#     Version     : 1.3
#
#     Revision    : CXP 903 6542-1-9
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : No JIRA
#
#     Description : Updating log display
#
#     Date        : 05th Mar 2021
#
####################################################################################
#####################################################################################
#     Version     : 1.2
#
#     Revision    : CXP 903 6542-1-8
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-34293,NSS-34065
#
#     Description : Changing BSC and MSC Node names
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
if [ "$#" -ne 1  ]
then
 echo
 echo "Usage: $0 <sim name>"
 echo
 echo "Example: $0 GSM-FT-MSC-BC-IS-500cell_BSC_18-Q2_V4x7-GSM08"
 echo
 exit 1
fi

. $PWD/../dat/Build.env

#while read -r Line
#do
#SIMNAME=$Line
SIMNAME=$1
PWD=`pwd`
SIMNUM="${SIMNAME:(-2)}"
BASENAME="M"$SIMNUM"B"
simNum=`expr $SIMNUM + 0`
#################################################
## Subroutines
#################################################
getNumOfNodes() {
SIMNUM=$1
CELLARRAY=$2
IFS=";"
for x in $CELLARRAY
do
SIMPOS=$(echo $x | awk -F":" '{print $1}')
if [ "$SIMNUM" -eq "$SIMPOS" ]
then
  NODENUM=$(echo $x | awk -F":" '{print $2}' | awk -F"," '{print $1}')
  echo $NODENUM
  break
fi
done
}
#################################################
## Main Program
#################################################
NUMOFNODES=`getNumOfNodes $simNum $CELLARRAY`
NODECOUNT=1
echo $BASENAME
while [ "$NODECOUNT" -le "$NUMOFNODES"  ]
do
NODENUM=$(expr $(expr $simNum \* $NUMOFNODES) - $NUMOFNODES + $NODECOUNT )
if [ "$NODENUM" -le 9 ]
then
    NODENAME=$BASENAME'0'$NODENUM
else
    NODENAME=$BASENAME$NODENUM
fi
echo "SIMNAME:$SIMNAME NODENAME:$NODENAME"
./bscFeatures.sh $SIMNAME $NODENAME | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
./createGcellBsc.sh $SIMNAME $NODENAME | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
./createBts.sh $SIMNAME $NODENAME | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
./createGcellBscRelations.sh $SIMNAME $NODENAME | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
./setRadioNodeG2.sh $SIMNAME $NODENAME | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
./createLanswitch.sh $SIMNAME $NODENAME | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
./setSTG.sh $SIMNAME $NODENAME >> $PWD"/../log/GSM"$SIMNUM"Telnet.log"
if [[ "$NODENAME" == "M47B94" ]]
then
    ./reparentingBSC.sh $SIMNAME $NODENAME | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
fi
NODECOUNT=`expr $NODECOUNT + 1`
done
#done < $PWD/simData.csv
