#!/bin/sh
### VERSION HISTORY
#####################################################################################
#####################################################################################
#     Version     : 1.3
#
#     Revision    : CXP 903 6542-1-21
#
#     Author      : zmogsiv
#
#     JIRA        : NSS-38490
#
#     Description : Making the below MOs set for vBSC type Cell also
#
#     Date        : 04th Feb 2022
#
####################################################################################
####################################################################################
#     Version     : 1.2
#
#     Revision    : CXP 903 6542-1-12
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-35753
#
#     Description : Setting flag on large BSC nodes
#
#     Date        : 08th Jun 2021
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
SIM=${SIMNAME%.zip}
. $PWD/../dat/Build.env

#lsof -nl >/tmp/lsof.log;rm -rf ~/freeIPs.log; for ip in `ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'`;do grep $ip /tmp/lsof.log > /dev/null; if [ $? != 0 ]; then echo $ip >> ~/freeIPs.log; fi; done; rm -rf /tmp/lsof.log;echo "Total IPs:`ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'|wc -l`"; echo "Free IPs:`wc -l ~/freeIPs.log`";

#ipAddr=`cat "/netsim/freeIPs.log" | grep -vi ":" | head -n+1`

NODELIST=`echo -e '.open '$SIM' \n .show simnes' | ~/inst/netsim_shell | grep -e "LTE BSC $BSCNODEVERSION" -e "LTE vBSC $BSCNODEVERSION" | cut -d' ' -f1`
Nodes=(${NODELIST// / })
if [ -e startNodes.mml ]
then
rm startNodes.mml
fi
cat >> startNodes.mml << MML
.open $SIM
.selectnocallback ${Nodes[@]}
.set port BSC_PORT
.modifyne set_subaddr $ipAddr subaddr no_value
.set save
.start -parallel
MML
#~/inst/netsim_shell < startNodes.mml
rm startNodes.mml
NumOfNodes=${#Nodes[@]}
NODECOUNT=0
cells=`awk 'BEGIN{print gsub(ARGV[2],"",ARGV[1])}' "$SIMNAME" "cell"`
cellType=`echo $SIMNAME | awk -F"cell" '{print $1}' | rev | cut -d'-' -f1 | rev`
while [ "$NODECOUNT" -lt "$NumOfNodes" ]
do
    NODENAME=${Nodes[$NODECOUNT]}
    NODECOUNT=`expr $NODECOUNT + 1`
    if [[ $cells == "2" ]] && [[ $NODECOUNT == "2" ]]
    then
        cellType=`echo $SIMNAME | awk -F"cell" '{print $2}' | cut -d'_' -f2`
    fi
    if [[ $cellType -ge 1200 ]]
    then
        echo -e ".open ${SIM} \n .select ${NODENAME} \n .start \n e: mmldb:update(largeBsc, true). \n e: mmldb:lookup(largeBsc)." | /netsim/inst/netsim_shell
    fi
MOCOUNT=`echo -e '.open '$SIM' \n .select '$NODENAME' \n dumpmotree:count;' | ~/inst/netsim_shell  | tail -n+6 | head -1`
echo "MOCOUNT of $NODENAME : $MOCOUNT"
MOSCRIPT=$NODENAME"_InfoUpdate.mo"
if [ -e $MOSCRIPT ]
then
  rm $MOSCRIPT
fi
MMLSCRIPT=$NODENAME_"InfoUpdate.mml"
if [ -e $MMLSCRIPT ]
then
  rm $MMLSCRIPT
fi
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1"
    identity "1"
    moType BscFunction:BscMAdministration
    exception none
    nrOfAttributes 1
    "bscMAdministrationId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscFunction:BscMAdministration=1"
    identity "1"
    moType BscFunction:BscMInformation
    exception none
    nrOfAttributes 2
    "bscMInformationId" String "1"
    "bscMMoNumber" Uint32 $MOCOUNT
)
MOSC
cat >> $MMLSCRIPT << MML
.open $SIM
.select $NODENAME
.start
useattributecharacteristics:switch="off";
kertayle:file="$PWD/$MOSCRIPT";
MML
~/inst/netsim_shell < $MMLSCRIPT
rm $MOSCRIPT
rm $MMLSCRIPT

done
