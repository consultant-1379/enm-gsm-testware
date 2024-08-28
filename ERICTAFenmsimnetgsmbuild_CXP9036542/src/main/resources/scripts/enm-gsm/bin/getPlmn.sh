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
COUNT=1
lac=1
mcc=262
mnc=04
cellList=`cat GsmTopology.csv | awk -F"CELL:" '{print $2}' | awk -F";" '{print $1}'`
cells=(${cellList// / })
for cellName in ${cellName[@]}
do
  echo "CELL_NAME=$cellName;MCC=$mcc;MNC=$mnc;LAC=$lac;CI=$cellId" >> $PWD/../customdata/plmnNetworkData.csv
#  echo "CELL_NAME=$cellName;PLMN=$MCC-$MNC-$LAC-$COUNT" >> GSM30K_PLMN_262.csv
  lacOffset=`expr $CELLCOUNT % 200`
  if [ "$lacOffset" -eq "0" ]
  then
     lac=`expr $lac + 1`
  fi
done
