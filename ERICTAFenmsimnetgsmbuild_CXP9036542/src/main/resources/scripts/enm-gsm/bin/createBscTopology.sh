#!/bin/sh
### VERSION HISTORY
#####################################################################################
#     Version     : 1.3
#
#     Revision    : CXP 903 6542-1-10
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-34469
#
#     Description : Correcting code for BCCHNO
#
#     Date        : 08th Mar 2021
#
####################################################################################
#####################################################################################
#     Version     : 1.2
#
#     Revision    : CXP 903 6542-1-8
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-34293,NSS-34469,NSS-34459
#
#     Description : Changing BSC and MSC Node names
#                   Adding Code to create GRAN Handover file to LRAN & WRAN
#                   Adding support for 8000 cell BSC related to NRM5.1
#
#     Date        : 3rd Mar 2021
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
. $PWD/../dat/Build.env
cellid=0
lac=1
mcc=046
mnc=04
if [ -e $PWD/../customdata/GsmTopology.csv ]
then
    rm -rf $PWD/../customdata/GsmTopology.csv
fi
if [ -e $PWD/../customdata/plmnNetworkData.csv ]
then
    rm -rf $PWD/../customdata/plmnNetworkData.csv
fi
if [ -e $PWD/../customdata/GSMFile_handover.csv ]
then
    rm -rf $PWD/../customdata/GSMFile_handover.csv
fi

##########################################################
# Subroutines
##########################################################
## Get Number of Bsc nodes in the network ###
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
## Get PLMN identities for the GeranCells ###
getplmnId() {
SIMNUM=$1
PLMNGROUP=$2
IFS=";"
for x in $PLMNGROUP
do
SIMRANGE=$(echo $x | awk -F"," '{print $2}')
STARTSIM=$(echo $SIMRANGE | awk -F":" '{print $1}')
ENDSIM=$(echo $SIMRANGE | awk -F":" '{print $2}')
if [ "$SIMNUM" -le "$ENDSIM" ] && [ "$SIMNUM" -ge "$STARTSIM" ]
then
  PLMNID=$(echo $x | awk -F"," '{print $1}')
  echo $PLMNID
  break
fi
done
}
### Returns the cells for the corresponding node ###
getIntraCellData() {
NODENUM=$1
STARTCELL=$2
ENDCELL=$3
TOTALCELLS=$4
NUMOFNODES=$5
MUL=`expr $NODENUM \* $TOTALCELLS`
EndIntraCell=`expr $MUL / $NUMOFNODES`
ENDINTRACELL=`expr $STARTCELL + $EndIntraCell - 1`
NUMOFCELLS=`expr $TOTALCELLS / $NUMOFNODES`
STARTINTRACELL=`expr $ENDINTRACELL - $NUMOFCELLS + 1`
echo "$STARTINTRACELL $ENDINTRACELL"
}
###########################################
# MAIN PROGRAM
############################################
NETWORKLIST=(${CELLARRAY//;/ })
if [ -e $PWD/../customdata/GsmTopology.csv ]
then
   rm -rf $PWD/../customdata/GsmTopology.csv
fi
for elem in ${NETWORKLIST[@]}
do
SIMNUM=$(echo $elem | awk -F":" '{print $1}')
CELLRANGE=`./getCellId.sh $SIMNUM $CELLARRAY`
STARTCELL=$(echo $CELLRANGE | awk -F" " '{print $1}')
ENDCELL=$(echo $CELLRANGE | awk -F" " '{print $2}')
cellDistribution=$(echo $elem | awk -F"," '{print $2}')
TOTALCELLS=`expr $ENDCELL - $STARTCELL + 1`
NUMOFNODES=`getNumOfNodes $SIMNUM $CELLARRAY`
PLMNID=`getplmnId $SIMNUM $PLMNGROUP`
if [[ $elem = *"|"* ]] ; then
   IFS='|' read -a cellList <<< "$cellDistribution"
fi
if [ "$SIMNUM" -le "9" ]
then
   BASENAME="M0"$SIMNUM"B"
else
   BASENAME="M"$SIMNUM"B"
fi
NODENUM=1
while [ "$NODENUM" -le "$NUMOFNODES" ]
do
  if [[ $elem = *"|"* ]] ; then
     groupCount=`expr $NODENUM - 1`
     index=0;startIntraCell=1
     while [ "$index" -lt "$groupCount" ]
     do
       startIntraCell=`expr $startIntraCell + ${cellList[$index]}`
       index=`expr $index + 1`
     done
     totalIntraCells=${cellList[$groupCount]}
     endIntraCell=`expr $startIntraCell + $totalIntraCells - 1`
     numOfCells=`expr $endIntraCell - $startIntraCell + 1`
     endIntra=`expr $STARTCELL + $endIntraCell - 1`
     startIntra=`expr $endIntra - $numOfCells + 1`
     var=$startIntra" "$endIntra
  else
     var=`getIntraCellData $NODENUM $STARTCELL $ENDCELL $TOTALCELLS $NUMOFNODES`
  fi
  btsPosition=`expr $NODENUM - 1`
  STARTINTRACELL=$(echo $var | awk -F" " '{print $1}')
  ENDINTRACELL=$(echo $var | awk -F" " '{print $2}')
  StartIntraCell=$STARTINTRACELL
  numOfCells=`expr $ENDINTRACELL - $StartIntraCell + 1`
#  g1g2range=`expr $numOfCells / 2`
  #Below condition is for 8000 cell bSC as per jira 33048
  if [[ $SIMNUM == "48" ]] && [[ $NODENUM == "2" ]] && [[ $numOfCells == "8000" ]]
  then
      g1g2range=6609
  else
      g1g2range=`expr $numOfCells / 2`
  fi
  btsLimiter=`expr $g1g2range + $STARTINTRACELL - 1`
  g1btsCount=1
  g2btsCount=1
  btsCount=$g1btsCount
  iteration=0
  cellCount=0
  btsType=G1
     while [ "$STARTINTRACELL" -le "$ENDINTRACELL" ]
     do
      CELLVALUE=`expr $STARTINTRACELL + 1000000`
      cellCount=`expr $cellCount + 1`
      remainingCells=`expr $btsLimiter - $STARTINTRACELL`
       if [ "$STARTINTRACELL" -le "$btsLimiter" ]
       then
         if [[ $SIMNUM == "48" ]] && [[ $NODENUM == "2" ]] && [[ $numOfCells == "8000" ]]
         then
             btsIterator=`expr $cellCount % 1`
             btsCount=$g1btsCount
             g1btsCount=`expr $g1btsCount + 1`
         else
             btsIterator=`expr $cellCount % 3`
             btsCount=$g1btsCount
             if [ "$btsIterator" -eq "0" ] && [ "$remainingCells" -ge "2" ]
             then
                 g1btsCount=`expr $g1btsCount + 1`
             fi
          fi
       else
         btsType=G2
         btsCount=$g2btsCount
         g2btsCount=`expr $g2btsCount + 1`
       fi
        nodeNum=$(expr $(expr $SIMNUM \* $NUMOFNODES) - $NUMOFNODES + $NODENUM )
        if [ "$nodeNum" -le "9" ]
        then
           NODENAME=$BASENAME"0"$nodeNum
        else
           NODENAME=$BASENAME$nodeNum
        fi
         echo "PLMNID:$PLMNID;SIM:$SIMNUM;NODE:$NODENAME;CELL:$CELLVALUE;RANGE:$STARTCELL-$ENDCELL;INTRARANGE:$StartIntraCell-$ENDINTRACELL;BTS:$btsType-$btsCount;" >> $PWD/../customdata/GsmTopology.csv
         STARTINTRACELL=`expr $STARTINTRACELL + 1`
     done
     NODENUM=`expr $NODENUM + 1`
done
done
##### Creating Plmn Data ##########################################
if [ -e $PWD/../customdata/plmnNetworkData.csv ]
then
   rm -rf $PWD/../customdata/plmnNetworkData.csv
fi
cellList=`cat "$PWD/../customdata/GsmTopology.csv" | awk -F"CELL:" '{print $2}' | awk -F";" '{print $1}'`
cells=(${cellList// / })
cellId=1
for cellName in ${cells[@]}
do
  echo "CELL_NAME=$cellName;$mcc;$mnc;$lac;$cellId" >> $PWD/../customdata/plmnNetworkData.csv
  lacOffset=`expr $cellId % 200`
  if [[ "$lacOffset" -eq "0" ]]
  then
     lac=`expr $lac + 1`
  fi
  cellId=`expr $cellId + 1`
done

##### Creating LRAN and WRAN Handover files #############################
if [ -e $PWD/../customdata/GSMFile_handover.csv ]
then
    rm -rf $PWD/../customdata/GSMFile_handover.csv
fi

CellList=`cat "$PWD/../customdata/GsmTopology.csv" | awk -F"CELL:" '{print $2}' | awk -F";" '{print $1}'`
Cells=(${CellList// / })
CellId=1
LAC=14000
bcc=0
bccTemp=1
bcchTemp=1
bcchNo=1
for CellName in ${Cells[@]}
do
  echo "CELL_NAME=$CellName;MCC=$mcc;MNC=$mnc;BSC.MNCDIGITHAND=2;LAC=$LAC;CI=$CellId;NCC=3;BCC=$bcc;BCCHNO=$bcchNo;C_SYS_TYPE=GSM900" >> $PWD/../customdata/GSMFile_handover.csv
  LacOffset=`expr $CellId % 200`
  if [[ "$LacOffset" -eq "0" ]]
  then
     LAC=`expr $LAC + 1`
  fi
  if [[ "$bccTemp" -le "5" ]]
  then
     bccTemp=`expr $bccTemp + 1`
  else
     if [[ "$bcc" -lt "7" ]]
     then
         bcc=`expr $bcc + 1`
     else
         bcc=0
     fi
     bccTemp=1
  fi
  if [[ "$bcchNo" -lt "359" ]]
  then
     bcchNo=`expr $bcchNo + 3`
  else
     if [[ "$bcchTemp" -eq "1" ]]
     then
        bcchTemp=3
     elif [[ "$bcchTemp" -eq "3" ]]
     then
        bcchTemp=2
     elif [[ "$bcchTemp" -eq "2" ]]
     then
        bcchTemp=1
     fi
     bcchNo=$bcchTemp
  fi
  CellId=`expr $CellId + 1`
done
