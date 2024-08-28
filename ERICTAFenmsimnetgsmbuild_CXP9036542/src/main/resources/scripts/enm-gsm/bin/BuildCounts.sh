#!/bin/bash

#####################################################################################
#     Version     : 1.1
#
#     Revision    : CXP 903 6542-1-8
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-34065
#
#     Description : Adding Support for Pre-Build Inspection
#
#     Date        : 26th Feb 2021
#
####################################################################################

TotalGsmCellsCount=0
TotalG1BTS=0
TotalG2BTS=0
TotalGeranInternalCellRelations=0
TotalGeranIntraCellRelations=0
TotalExternalUtranCells=0
TotalUtranRelations=0
TotalGsmExtRelations=0
TotalExtGsmRelations=0

cat preBuildGSMCounts.csv | grep "NumOfGsmCells" > GSMCells.csv
while read -r Line
do
   GsmCount=`echo $Line | awk -F"NumOfGsmCells=" '{print $2}'`
   TotalGsmCellsCount=`expr $TotalGsmCellsCount + $GsmCount`
done < GSMCells.csv
echo "Total GSM Cells : $TotalGsmCellsCount"
rm -rf GSMCells.csv

cat preBuildGSMCounts.csv | grep "NumOfG1Bts" > GSMCells.csv
while read -r Line
do
   G1BTS=`echo $Line | awk -F"NumOfG1Bts=" '{print $2}'`
   TotalG1BTS=`expr $TotalG1BTS + $G1BTS`
done < GSMCells.csv
echo "Total NumOfG1Bts : $TotalG1BTS"
rm -rf GSMCells.csv

cat preBuildGSMCounts.csv | grep "NumOfG2Bts" > GSMCells.csv
while read -r Line
do
   G2BTS=`echo $Line | awk -F"NumOfG2Bts=" '{print $2}'`
   if [[ $G2BTS == "1391" ]]
   then
      G2BTS=$G2BTS
   else
      G2BTS=`expr $G2BTS / 3`
   fi
   TotalG2BTS=`expr $TotalG2BTS + $G2BTS`
done < GSMCells.csv
echo "Total NumOfG2Bts : $TotalG2BTS"
rm -rf GSMCells.csv

cat preBuildGSMCounts.csv | grep "GsmInternalCellRelations" > GSMCells.csv
while read -r Line
do
   GsmInter=`echo $Line | awk -F"GsmInternalCellRelations=" '{print $2}'`
   TotalGeranInternalCellRelations=`expr $TotalGeranInternalCellRelations + $GsmInter`
done < GSMCells.csv
echo "Total GsmInternalCellRelations : $TotalGeranInternalCellRelations"
rm -rf GSMCells.csv

cat preBuildGSMCounts.csv | grep "GsmIntraCellRelations" > GSMCells.csv
while read -r Line
do
   GsmIntra=`echo $Line | awk -F"GsmIntraCellRelations=" '{print $2}'`
   TotalGeranIntraCellRelations=`expr $TotalGeranIntraCellRelations + $GsmIntra`
done < GSMCells.csv
echo "Total GsmIntraCellRelations : $TotalGeranIntraCellRelations"
rm -rf GSMCells.csv

cat preBuildGSMCounts.csv | grep "ExternalUtranCells" > GSMCells.csv
while read -r Line
do
   ExternalUtranCells=`echo $Line | awk -F"ExternalUtranCells=" '{print $2}'`
   TotalExternalUtranCells=`expr $TotalExternalUtranCells + $ExternalUtranCells`
done < GSMCells.csv
echo "Total ExternalUtranCells : $TotalExternalUtranCells"
rm -rf GSMCells.csv

cat preBuildGSMCounts.csv | grep "UtranRelations" > GSMCells.csv
while read -r Line
do
   UtranRelations=`echo $Line | awk -F"UtranRelations=" '{print $2}'`
   TotalUtranRelations=`expr $TotalUtranRelations + $UtranRelations`
done < GSMCells.csv
echo "Total UtranRelations : $TotalUtranRelations"
rm -rf GSMCells.csv

cat preBuildGSMCounts.csv | grep "GsmExternalRelations" > GSMCells.csv
while read -r Line
do
   GsmExtRel=`echo $Line | awk -F"GsmExternalRelations=" '{print $2}'`
   TotalGsmExtRelations=`expr $TotalGsmExtRelations + $GsmExtRel`
done < GSMCells.csv
echo "Total GsmExternalRelations : $TotalGsmExtRelations"
rm -rf GSMCells.csv

cat preBuildGSMCounts.csv | grep "ExternalGsmRelations" > GSMCells.csv
while read -r Line
do
   ExtGsmRel=`echo $Line | awk -F"ExternalGsmRelations=" '{print $2}'`
   TotalExtGsmRelations=`expr $TotalExtGsmRelations + $ExtGsmRel`
done < GSMCells.csv
echo "Total ExternalGsmRelations : $TotalExtGsmRelations"
rm -rf GSMCells.csv

totalBTScount=`expr $TotalG1BTS + $TotalG2BTS`
totalGsmIntCellRel=`expr $TotalGeranInternalCellRelations + $TotalGeranIntraCellRelations`
totalGsmExtCellRel=`expr $TotalGsmExtRelations + $TotalExtGsmRelations`

echo "Total BTS Counts : $totalBTScount"
echo "Total GsmIntCellRelations : $totalGsmIntCellRel"
echo "Total GsmExtCellRelations : $totalGsmExtCellRel"
