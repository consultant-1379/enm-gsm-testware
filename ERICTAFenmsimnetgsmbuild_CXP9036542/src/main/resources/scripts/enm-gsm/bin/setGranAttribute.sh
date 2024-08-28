### VERSION HISTORY
#####################################################################################
#     Version     : 23.04
#
#     Revision    : CXP 903 6542-1-25
#
#     Author      : Siva Mogilicharla
#
#     JIRA        : NSS-42004
#
#     Description : Removing unwanted kertayle creation in between
#
#     Date        : 16th Jan 2023
#
####################################################################################
#####################################################################################
#     Version     : 21.15
#
#     Revision    : CXP 903 6542-1-15
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : No-Jira
#
#     Description : Reading data fron correct csv file.
#
#     Date        : 06th Sep 2021
#
####################################################################################
#####################################################################################
##     Version1     : 21.13
##
##     Revision     : CXP 903 6542-1-14
##
##     Author       : zyamkan
##
##     JIRA         : NSS-35602,35603
##
##     Description  : Setting the Geran.balistIdle, GeranbalistActive, nccPerm attributes
##
##     Date         : 26th July 2021
##
######################################################################################

if [ "$#" -ne 1 ]
then
cat<<HELP

####################
# HELP
####################

Usage  : $0 <SimName>

Example: $0 GSM-FT-MSC-DB-BSP-15cell_BSC_20-Q2_V1x9-GSM01

HELP

exit 1
fi

SIM=$1
Path=`pwd`

. $PWD/../dat/Build.env
LTEHandOverFile=$PWD/../customdata/$LRANHANDOVERFILE

NodesList=`echo -e ".open $SIM \n .show simnes" | /netsim/inst/netsim_shell | grep "LTE BSC" | cut -d" " -f1`

for Node in ${NodesList[@]}
do
echo "***NODENAME=$Node***"
cellstring=`echo -e '.open '$SIM'\n.select '$Node'\ne csmo:get_mo_ids_by_type(null,"BscM:GeranCell").' | ~/inst/netsim_shell | tail -n+6`
cellRms=`echo $cellstring | sed 's/[][]//g'`
cellRms=`echo $cellRms | sed 's/ //g'`
cellList=(${cellRms//,/ })
for cellId in ${cellList[@]}
do
   Ldn=`echo -e ".open $SIM \n .select $Node \n e: csmo:mo_id_to_ldn(null, ${cellId})." | ~/inst/netsim_shell | tail -n+6 | tr -d '\n' | tr -d '[:space:]' | sed 's/[][]//g' | sed 's/"//g'`
   Ldn1=`echo "${Ldn//ComTop:}"`
   Ldn2=`echo "${Ldn1//BscFunction:}"`
   Ldn3=`echo "${Ldn2//BscM:}"`

echo -e ".open ${SIM} \n .select ${Node} \n setmoattribute:mo=\"${Ldn3}\", attributes = \"baListIdle (seq, Uint16 )=[]\";" | /netsim/inst/netsim_shell
echo -e ".open ${SIM} \n .select ${Node} \n setmoattribute:mo=\"${Ldn3}\", attributes = \"baListActive (seq, Uint16 )=[]\";" | /netsim/inst/netsim_shell
echo -e ".open ${SIM} \n .select ${Node} \n setmoattribute:mo=\"${Ldn3},IdleModeAndPaging=1\", attributes = \"nccPerm (seq, Uint8 )=[]\";" | /netsim/inst/netsim_shell

   childs=`echo -e ".open $SIM \n .select $Node \n e csmo:get_children_by_type(null, ${cellId}, \"BscM:GeranCellRelation\")." |  ~/inst/netsim_shell | tail -n+6`
   childcellRms=`echo $childs | sed 's/[][]//g'`
   childcellRms=`echo $childcellRms | sed 's/ //g'`
   childcellList=(${childcellRms//,/ })
   declare -a arr
   i=0
   for childcellId in ${childcellList[@]}
   do
     value=`echo -e ".open $SIM \n .select $Node \n e csmo:get_attribute_value(null,${childcellId},geranCellRelationId)." | ~/inst/netsim_shell | tail -1 | sed 's/"//g'`
     val=`cat $LTEHandOverFile | grep $value | awk -F "BCCHNO=" '{print $2}' | cut -d";" -f1`
     #ncc=`cat $LTEHandOverFile | grep $value | awk -F "NCC=" '{print $2}' | cut -d";" -f1`
     arr[$i]=$val
     #array[$i]=$ncc
     #echo "$i $value $val ${arr[$i]} $ncc ${array[$i]}"
     i=`expr $i + 1`
   done
   externalRel=`echo -e ".open $SIM \n .select $Node \n e csmo:get_children_by_type(null, ${cellId}, \"BscM:ExternalGeranCellRelation\")." |  ~/inst/netsim_shell | tail -n+6`
   extcellRms=`echo $externalRel | sed 's/[][]//g'`
   extcellRms=`echo $extcellRms | sed 's/ //g'`
   extcellList=(${extcellRms//,/ })
   for extcellId in ${extcellList[@]}
   do
       value1=`echo -e ".open $SIM \n .select $Node \n e csmo:get_attribute_value(null,${extcellId},externalGeranCellRelationId)." | ~/inst/netsim_shell | tail -1 | sed 's/"//g'`
       val1=`cat $LTEHandOverFile | grep $value1 | awk -F "BCCHNO=" '{print $2}' | cut -d";" -f1`
       #ncc1=`cat $LTEHandOverFile | grep $value1 | awk -F "NCC=" '{print $2}' | cut -d";" -f1`
       arr[$i]=$val1
       #array[$i]=$ncc1
       #echo "$i $value1 $val1 ${arr[$i]} $ncc1 ${array[$i]}"
       i=`expr $i + 1`
   done
   delim=,
   printf -v var "%s$delim" "${arr[@]}"
   var="${var%$delim}"

   echo -e ".open ${SIM} \n .select ${Node} \n setmoattribute:mo=\"${Ldn3}\", attributes = \"baListIdle (seq, Uint16 )=[$var]\";" | /netsim/inst/netsim_shell
   echo -e ".open ${SIM} \n .select ${Node} \n setmoattribute:mo=\"${Ldn3}\", attributes = \"baListActive (seq, Uint16 )=[$var]\";" | /netsim/inst/netsim_shell
   echo -e ".open ${SIM} \n .select ${Node} \n setmoattribute:mo=\"${Ldn3},IdleModeAndPaging=1\", attributes = \"nccPerm(Uint8 )=3\";" | /netsim/inst/netsim_shell

unset arr
done

done

