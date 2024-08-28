#!/bin/sh
### VERSION HISTORY
#####################################################################################
#     Version     : 1.3
#
#     Revision    : CXP 903 6542-1-19
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NO-JIRA
#
#     Description : Adding Topology support for vBSC nodes.
#
#     Date        : 23rd Dec 2021
#####################################################################################
#####################################################################################
#     Version     : 1.2
#
#     Revision    : CXP 903 6542-1-6
#
#     Author      : zyamkan
#
#     JIRA        : NSS-31737
#
#     Description : Adding code for TRX data
#
#     Date        : 05th Aug 2020
#
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
STARTDATE=`date`
echo "$O script started running ...."
NODELIST=`echo -e '.open '$SIM'\n.show simnes' | ~/inst/netsim_shell | grep -e "LTE BSC" -e "LTE vBSC" | cut -d" " -f1`
NODES=(${NODELIST// / })
REVDIR="/netsim/netsimdir/"$SIM"/SimNetRevision"
#if [ -d $REVDIR ]
#then
#   rm -rf $REVDIR
#fi
mkdir -p $REVDIR
topologyFile=$REVDIR"/TopologyData.txt"
echo "#########################################################################" >>$topologyFile
echo "# TOPOLOGY DATA FOR $SIM" >>$topologyFile
echo "#########################################################################" >>$topologyFile
echo "" >>$topologyFile

echo "#################################################################################################################" >>$topologyFile
echo "#                               ManagedElement Information" >>$topologyFile
echo "#################################################################################################################" >>$topologyFile

for Node in ${NODELIST[@]}
do
#### Getting  ManagedElementData ######
elementString=`echo -e '.open '$SIM'\n.select '$Node'\ne csmo:get_mo_ids_by_type(null,"ComTop:ManagedElement").' | ~/inst/netsim_shell | tail -n+6`
elementRms=`echo $elementString | sed 's/[][]//g'`
elementRms=`echo $elementRms | sed 's/ //g'`
#elementList=(${elementRms//,/ })
Ldn="ManagedElement=$Node"
elementId=`echo -e '.open '$SIM'\n.select '$Node'\ne X= csmo:ldn_to_mo_id(null,["ComTop:ManagedElement='$Node'"]).\ne csmo:get_attribute_value(null,X,managedElementId).' | ~/inst/netsim_shell | tail -n+8 | cut -d '"' -f2`
echo $Ldn","managedElementId=$elementId >> $topologyFile

done

echo "#################################################################################################################" >>$topologyFile
echo "#                               GeranCell Information" >>$topologyFile
echo "#################################################################################################################" >>$topologyFile

for cellNode in ${NODELIST[@]}
do

#### Getting  GeranCellData ######
gcellstring=`echo -e '.open '$SIM'\n.select '$cellNode'\ne csmo:get_mo_ids_by_type(null,"BscM:GeranCell").' | ~/inst/netsim_shell | tail -n+6`
gcellRms=`echo $gcellstring | sed 's/[][]//g'`
gcellRms=`echo $gcellRms | sed 's/ //g'`
gcellList=(${gcellRms//,/ })
for cellId in ${gcellList[@]}
do
  echo -e '.open '$SIM'\n.select '$cellNode'\ndumpmotree:moid="'$cellId'",ker_out,outputfile="/netsim/gcell'$cellNode'.mo";' | ~/inst/netsim_shell >/dev/null 2>&1
  parentLdn=`awk 'NR==3' /netsim/gcell${cellNode}.mo | awk -F" " '{print $2}' | tr -d '"' | tr -d ' '`
  identity=`awk 'NR==4' /netsim/gcell${cellNode}.mo | awk -F" " '{print $2}' | tr -d '"' | tr -d ' '`
  moType=`awk 'NR==5' /netsim/gcell${cellNode}.mo | awk -F" " '{print $2}' | tr -d '"' | tr -d ' '`
  #echo "\"$parentLdn,$moType=$identity\""
  Ldn=$parentLdn","$moType"="$identity
  Ldn1=`echo "${Ldn//ComTop:}"`
  Ldn2=`echo "${Ldn1//BscFunction:}"`
  Ldn3=`echo "${Ldn2//BscM:}"`
  gcellIndividual=`echo -e '.open '$SIM'\n.select '$cellNode'\ne X= csmo:ldn_to_mo_id(null,["ComTop:ManagedElement='$cellNode'","BscFunction:BscFunction=1","BscM:BscM=1","BscM:GeranCellM=1","BscM:GeranCell='$identity'"]).\ne csmo:get_attribute_value(null,X,geranCellIndividual).' | /netsim/inst/netsim_shell | tail -n+8`
  echo $Ldn3","geranCellIndividual=$gcellIndividual >>$topologyFile
done

done

echo "#################################################################################################################" >>$topologyFile
echo "#                               GeranCellRelation Information" >>$topologyFile
echo "#################################################################################################################" >>$topologyFile

for relNode in ${NODELIST[@]}
do

#### Getting  GeranRelationData ######
grelstring=`echo -e '.open '$SIM'\n.select '$relNode'\ne csmo:get_mo_ids_by_type(null,"BscM:GeranCellRelation").' | ~/inst/netsim_shell | tail -n+6`
grelRms=`echo $grelstring | sed 's/[][]//g'`
grelRms=`echo $grelRms | sed 's/ //g'`
grelList=(${grelRms//,/ })
for relId in ${grelList[@]}
do
  echo -e '.open '$SIM'\n.select '$relNode'\ndumpmotree:moid="'$relId'",ker_out,outputfile="/netsim/grel'$relNode'.mo";' | ~/inst/netsim_shell >/dev/null 2>&1
  parentLdn=`awk 'NR==3' /netsim/grel${relNode}.mo | awk -F" " '{print $2}' | tr -d '"' | tr -d ' '`
  identity=`awk 'NR==4' /netsim/grel${relNode}.mo | awk -F" " '{print $2}' | tr -d '"' | tr -d ' '`
  moType=`awk 'NR==5' /netsim/grel${relNode}.mo | awk -F" " '{print $2}' | tr -d '"' | tr -d ' '`
  Ldn=$parentLdn","$moType"="$identity
  Ldn1=`echo "${Ldn//ComTop:}"`
  Ldn2=`echo "${Ldn1//BscFunction:}"`
  Ldn3=`echo "${Ldn2//BscM:}"`
  echo $Ldn3 >>$topologyFile
done
rm /netsim/grel${relNode}.mo
done

echo "#################################################################################################################" >>$topologyFile
echo "#                               ExternalGeranCell Information" >>$topologyFile
echo "#################################################################################################################" >>$topologyFile

for extcellNode in ${NODELIST[@]}
do

#### Getting  ExternalGeranCellData ######
extcellstring=`echo -e '.open '$SIM'\n.select '$extcellNode'\ne csmo:get_mo_ids_by_type(null,"BscM:ExternalGeranCell").' | ~/inst/netsim_shell | tail -n+6`
extcellRms=`echo $extcellstring | sed 's/[][]//g'`
extcellRms=`echo $extcellRms | sed 's/ //g'`
extcellList=(${extcellRms//,/ })
for relId in ${extcellList[@]}
do
  echo -e '.open '$SIM'\n.select '$extcellNode'\ndumpmotree:moid="'$relId'",ker_out,outputfile="/netsim/extcell'$extcellNode'.mo";' | ~/inst/netsim_shell >/dev/null 2>&1
  parentLdn=`awk 'NR==3' /netsim/extcell${extcellNode}.mo | awk -F" " '{print $2}' | tr -d '"' | tr -d ' '`
  identity=`awk 'NR==4' /netsim/extcell${extcellNode}.mo | awk -F" " '{print $2}' | tr -d '"' | tr -d ' '`
  moType=`awk 'NR==5' /netsim/extcell${extcellNode}.mo | awk -F" " '{print $2}' | tr -d '"' | tr -d ' '`
  Ldn=$parentLdn","$moType"="$identity
  Ldn1=`echo "${Ldn//ComTop:}"`
  Ldn2=`echo "${Ldn1//BscFunction:}"`
  Ldn3=`echo "${Ldn2//BscM:}"`
  extGCellIndividual=`echo -e '.open '$SIM'\n.select '$extcellNode'\ne X= csmo:ldn_to_mo_id(null,["ComTop:ManagedElement='$extcellNode'","BscFunction:BscFunction=1","BscM:BscM=1","BscM:ExternalGeranCellM=1","BscM:ExternalGeranCell='$identity'"]).\ne csmo:get_attribute_value(null,X,externalGeranCellIndividual).' | /netsim/inst/netsim_shell | tail -n+8`
  echo $Ldn3","externalGeranCellIndividual=$extGCellIndividual >>$topologyFile
done
rm /netsim/extcell${extcellNode}.mo
done

echo "#################################################################################################################" >>$topologyFile
echo "#                               ExternalCellRelation Information" >>$topologyFile
echo "#################################################################################################################" >>$topologyFile

for extNode in ${NODELIST[@]}
do
#### Getting  ExternalGeranCellData ######
extrelstring=`echo -e '.open '$SIM'\n.select '$extNode'\ne csmo:get_mo_ids_by_type(null,"BscM:ExternalGeranCellRelation").' | ~/inst/netsim_shell | tail -n+6`
extrelRms=`echo $extrelstring | sed 's/[][]//g'`
extrelRms=`echo $extrelRms | sed 's/ //g'`
extrelList=(${extrelRms//,/ })
for extrelId in ${extrelList[@]}
do
  echo -e '.open '$SIM'\n.select '$extNode'\ndumpmotree:moid="'$extrelId'",ker_out,outputfile="/netsim/extrel'$extNode'.mo";' | ~/inst/netsim_shell >/dev/null 2>&1
  parentLdn=`awk 'NR==3' /netsim/extrel${extNode}.mo | awk -F" " '{print $2}' | tr -d '"' | tr -d ' '`
  identity=`awk 'NR==4' /netsim/extrel${extNode}.mo | awk -F" " '{print $2}' | tr -d '"' | tr -d ' '`
  moType=`awk 'NR==5' /netsim/extrel${extNode}.mo | awk -F" " '{print $2}' | tr -d '"' | tr -d ' '`
  #echo "\"$parentLdn,$moType=$identity\""
  Ldn=$parentLdn","$moType"="$identity
  Ldn1=`echo "${Ldn//ComTop:}"`
  Ldn2=`echo "${Ldn1//BscFunction:}"`
  Ldn3=`echo "${Ldn2//BscM:}"`
  echo $Ldn3 >>$topologyFile
done
rm /netsim/extrel${extNode}.mo
done

echo "#################################################################################################################" >>$topologyFile
echo "#                               ExternalUtranCell Information" >>$topologyFile
echo "#################################################################################################################" >>$topologyFile

for utraCellNode in ${NODELIST[@]}
do
#### Getting UtranCellRelation Data #######
utrstring=`echo -e '.open '$SIM'\n.select '$utraCellNode'\ne csmo:get_mo_ids_by_type(null,"BscM:ExternalUtranCell").' | ~/inst/netsim_shell | tail -n+6`
utrRms=`echo $utrstring | sed 's/[][]//g'`
utrRms=`echo $utrRms | sed 's/ //g'`
utraList=(${utrRms//,/ })
for utra in ${utraList[@]}
do
  #echo $utra
  echo -e '.open '$SIM'\n.select '$utraCellNode'\ndumpmotree:moid="'$utra'",ker_out,outputfile="/netsim/utra'$utraCellNode'.mo";' | ~/inst/netsim_shell >/dev/null 2>&1
  parentLdn=`awk 'NR==3' /netsim/utra${utraCellNode}.mo | awk -F" " '{print $2}' | tr -d '"' | tr -d ' '`
  identity=`awk 'NR==4' /netsim/utra${utraCellNode}.mo | awk -F" " '{print $2}' | tr -d '"' | tr -d ' '`
  moType=`awk 'NR==5' /netsim/utra${utraCellNode}.mo | awk -F" " '{print $2}' | tr -d '"' | tr -d ' '`
  #echo "\"$parentLdn,$moType=$identity\""
  Ldn=$parentLdn","$moType"="$identity
  Ldn1=`echo "${Ldn//ComTop:}"`
  Ldn2=`echo "${Ldn1//BscFunction:}"`
  Ldn3=`echo "${Ldn2//BscM:}"`
  utraCellIndividual=`echo -e '.open '$SIM'\n.select '$utraCellNode'\ne X= csmo:ldn_to_mo_id(null,["ComTop:ManagedElement='$utraCellNode'","BscFunction:BscFunction=1","BscM:BscM=1","BscM:UtraNetwork=1","BscM:ExternalUtranCell='$identity'"]).\ne csmo:get_attribute_value(null,X,externalUtranCellIndividual).' | /netsim/inst/netsim_shell | tail -n+8`
  echo $Ldn3","externalUtranCellIndividual=$utraCellIndividual >>$topologyFile
done
rm /netsim/utra${utraCellNode}.mo
done

echo "#################################################################################################################" >>$topologyFile
echo "#                               UtranCellRelation Information" >>$topologyFile
echo "#################################################################################################################" >>$topologyFile

for utraNode in ${NODELIST[@]}
do
#### Getting UtranCellRelation Data #######
utrelstring=`echo -e '.open '$SIM'\n.select '$utraNode'\ne csmo:get_mo_ids_by_type(null,"BscM:UtranCellRelation").' | ~/inst/netsim_shell | tail -n+6`
utrelRms=`echo $utrelstring | sed 's/[][]//g'`
utrelRms=`echo $utrelRms | sed 's/ //g'`
utrarelList=(${utrelRms//,/ })
for utraRel in ${utrarelList[@]}
do
  #echo $utra
  echo -e '.open '$SIM'\n.select '$utraNode'\ndumpmotree:moid="'$utraRel'",ker_out,outputfile="/netsim/utraRel'$utraNode'.mo";' | ~/inst/netsim_shell >/dev/null 2>&1
  parentLdn=`awk 'NR==3' /netsim/utraRel${utraNode}.mo | awk -F" " '{print $2}' | tr -d '"' | tr -d ' '`
  identity=`awk 'NR==4' /netsim/utraRel${utraNode}.mo | awk -F" " '{print $2}' | tr -d '"' | tr -d ' '`
  moType=`awk 'NR==5' /netsim/utraRel${utraNode}.mo | awk -F" " '{print $2}' | tr -d '"' | tr -d ' '`
  #echo "\"$parentLdn,$moType=$identity\""
  Ldn=$parentLdn","$moType"="$identity
  Ldn1=`echo "${Ldn//ComTop:}"`
  Ldn2=`echo "${Ldn1//BscFunction:}"`
  Ldn3=`echo "${Ldn2//BscM:}"`
  echo $Ldn3 >>$topologyFile
done
rm /netsim/utraRel${utraNode}.mo
done

echo "#################################################################################################################" >>$topologyFile
echo "#                               TRX Information" >>$topologyFile
echo "#################################################################################################################" >>$topologyFile

for TRXNode in ${NODELIST[@]}
do

g12Tgstring=`echo -e '.open '$SIM'\n.select '$TRXNode'\ne csmo:get_mo_ids_by_type(null,"BscM:G12Trxc").' | ~/inst/netsim_shell | tail -n+6`
g12TgRms=`echo $g12Tgstring | sed 's/[][]//g'`
g12TgRms=`echo $g12TgRms | sed 's/ //g'`
g12TgList=(${g12TgRms//,/ })
for TRXId in ${g12TgList[@]}
do
  echo -e '.open '$SIM'\n.select '$TRXNode'\ndumpmotree:moid="'$TRXId'",ker_out,outputfile="/netsim/g12Tg'$TRXNode'.mo";' | ~/inst/netsim_shell >/dev/null 2>&1
  parentLdn=`awk 'NR==3' /netsim/g12Tg${TRXNode}.mo | awk -F" " '{print $2}' | tr -d '"' | tr -d ' '`
  identity=`awk 'NR==4' /netsim/g12Tg${TRXNode}.mo | awk -F" " '{print $2}' | tr -d '"' | tr -d ' '`
  moType=`awk 'NR==5' /netsim/g12Tg${TRXNode}.mo | awk -F" " '{print $2}' | tr -d '"' | tr -d ' '`
  #echo "\"$parentLdn,$moType=$identity\""
  Ldn=$parentLdn","$moType"="$identity
  Ldn1=`echo "${Ldn//ComTop:}"`
  Ldn2=`echo "${Ldn1//BscFunction:}"`
  Ldn3=`echo "${Ldn2//BscM:}"`
  echo $Ldn3 >>$topologyFile

  done
rm /netsim/g12Tg${TRXNode}.mo
done

ENDDATE=`date`

if [ -e Ldn.txt ]
then
   rm Ldn.txt
fi

if [ -e Summary.csv ]
then
   rm Summary.csv
fi
cat $topologyFile | grep "geranCellIndividual=" | awk -F",geranCellIndividual=" '{print $1}' >> Ldn.txt
cat $topologyFile | grep "GeranCellRelation=" >> Ldn.txt
cat $topologyFile | grep "externalGeranCellIndividual=" | awk -F",externalGeranCellIndividual=" '{print $1}' >> Ldn.txt
cat $topologyFile | grep "ExternalGeranCellRelation=" >> Ldn.txt
cat $topologyFile | grep "externalUtranCellIndividual=" | awk -F",externalUtranCellIndividual=" '{print $1}' >> Ldn.txt
cat $topologyFile | grep "UtranCellRelation=" >> Ldn.txt
cat $topologyFile | grep "G12Trxc=" >> Ldn.txt

GeranCells=`cat $topologyFile | grep "geranCellIndividual=" | wc -l`
GeranCellRelations=`cat $topologyFile | grep "GeranCellRelation=" | wc -l`
ExternalGeranCells=`cat $topologyFile | grep "externalGeranCellIndividual=" | wc -l`
ExternalGsmRelations=`cat $topologyFile | grep "ExternalGeranCellRelation=" | wc -l`
ExternalUtranCells=`cat $topologyFile | grep "externalUtranCellIndividual=" | wc -l`
UtranRelations=`cat $topologyFile | grep "UtranCellRelation=" | wc -l`
G12TrxcCount=`cat $topologyFile | grep "G12Trxc=" | wc -l`

echo "GeranCells=$GeranCells" >> Summary.csv
echo "GeranCellRelations=$GeranCellRelations" >> Summary.csv
echo "ExternalGeranCells=$ExternalGeranCells" >> Summary.csv
echo "ExternalGsmRelations=$ExternalGsmRelations" >> Summary.csv
echo "ExternalUtranCells=$ExternalUtranCells" >> Summary.csv
echo "UtranRelations=$UtranRelations" >> Summary.csv
echo "G12Trxc=$G12TrxcCount" >> Summary.csv

cp Summary.csv Ldn.txt $REVDIR
echo -e ".open $SIM \n .select network \n .stop" | /netsim/inst/netsim_shell
echo "$0 script started at $STARTDATE"
echo "$0 script ended at $ENDDATE"
