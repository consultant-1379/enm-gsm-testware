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
SIMCOUNT=$1
. $PWD/../dat/Build.env
CELLNUM=0

addCells() {
CELLS=$1
IFS='|' read -a cellList <<< "$CELLS"
TotalCells=`echo "${cellList[@]/%/+}0" | bc`
echo "$TotalCells"
}

getCells() {
SIMCOUNT=$1
CELLARRAY=$2
IFS=";"
for x in $CELLARRAY
do
SIM=$(echo $x | awk -F":" '{print $1}')
if [ "$SIMCOUNT" -eq "$SIM" ]
then
  CELLS=$(echo $x | awk -F"," '{print $2}')
  if [[ $CELLS = *"|"* ]]
  then
     CELLS=`addCells $CELLS`
  fi
  echo $CELLS
  break
elif [ "$SIMCOUNT" -eq "0" ]
  then
  echo $SIMCOUNT
  break
fi
done
}

CELLS=`getCells $SIMCOUNT $CELLARRAY`
SIMNUM=0
while [ "$SIMNUM" -le "$SIMCOUNT" ]
do
CELLCOUNT=`getCells $SIMNUM $CELLARRAY`
CELLNUM=`expr $CELLCOUNT + $CELLNUM`
SIMNUM=`expr $SIMNUM + 1`
done

STARTCELL=`expr $CELLNUM - $CELLS + 1`
echo "$STARTCELL $CELLNUM"
