#!/bin/sh
### VERSION HISTORY
#####################################################################################
#     Version     : 1.4
#
#     Revision    : CXP 903 6542-1-12
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : No JIRA
#
#     Description : Coorecting the code for getting freeIps
#
#     Date        : 08th Jun 2021
#
####################################################################################
#####################################################################################
#     Version     : 1.3
#
#     Revision    : CXP 903 6542-1-11
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : No Jira
#
#     Description : Correcting code for IS node creation
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
SIMNUM="${SIMNAME:(-2)}"
simNum=`expr $SIMNUM + 0`
. $PWD/../dat/Build.env
if [ -e createMscblade.mml ]
then
   rm createMscblade.mml
fi

#### subRoutines ######################################################
createBlade() {
SIMNAME=$1
MSCNAME=$2
NODENAME=$3
NODETYPE=$4
NODENUM=$5
bladePort=$6
if [[ "$NODENAME" == "-IS" ]]
then
   nodeType="IS "$NODETYPE
cat >> createMscblade.mml << MML
.open $SIMNAME
.select -IS01
.stop
.delete
MML
else
   nodeType="GSM "$NODETYPE
fi

## creating Blades ###

if [[ "$NODENAME" == "-IS" ]]
then
   cat >> createMscblade.mml << MML
.open $SIMNAME
.createne checkport $dg2Port
.new simne -auto $NODENUM $NODENAME 01
.set netype $nodeType
.set port DG2_PORT
.set taggedaddr subaddr $ipAddr 1
.set external IS_DEST
.set save
.start
.selectregexp simne $MSCNAME|$NODENAME.*
.stop
.relate
.start -parallel
MML
else
   cat >> createMscblade.mml << MML
.open $SIMNAME
.createne checkport $bladePort
.new simne -auto $NODENUM $NODENAME 01
.set netype $nodeType
.set port $bladePort
.set taggedaddr subaddr 0 1
.set save
.start
.selectregexp simne $MSCNAME|$NODENAME.*
.stop
.relate
.start -parallel
MML
fi
if [[ "$NODENAME" == "-IS" ]]
then
   continue;
else
cp -r ../SYBUE /netsim/netsimdir/$SIMNAME/user_cmds/
cp -r ../LAMIP /netsim/netsimdir/$SIMNAME/user_cmds/
cp -r ../DBTSP /netsim/netsimdir/$SIMNAME/user_cmds/
cp -r ../NSS-USER-COMMANDS /netsim/netsimdir/$SIMNAME/user_cmds/
cat >> createMscblade.mml << MML
.selectregexp simne $MSCNAME$NODENAME.*
.stop
.set ulib /netsim/netsimdir/$SIMNAME/user_cmds/NSS-USER-COMMANDS
.set save
.restart
MML
fi
}

########################################################################
#### Main ###
MSCNAME="M"$SIMNUM

#lsof -nl >/tmp/lsof.log;rm -rf ~/freeIPs.log; for ip in `ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'`;do grep $ip /tmp/lsof.log > /dev/null; if [ $? != 0 ]; then echo $ip >> ~/freeIPs.log; fi; done; rm -rf /tmp/lsof.log;echo "Total IPs:`ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'|wc -l`"; echo "Free IPs:`wc -l ~/freeIPs.log`";

ipAddr=`cat "/netsim/freeIPs.log" | grep -vi ":" | head -n+1`
sed -i "/${ipAddr}/d" /netsim/freeIPs.log

IFS=";"
for x in $MSCBLADEARRAY
do
 simulationNum=$(echo $x | awk -F":" '{print $1}')
 if [ "$simulationNum" -eq "$simNum" ]
 then
    simBladeData=$(echo $x | awk -F":" '{print $2}')
    break;
 fi
done
if [[ "$simBladeData" == "" ]]
then
   echo "No Blades will be created for $SIMNAME"
   exit 1
fi
IFS=","
for node in $simBladeData
do
  NODEBASE=$(echo $node | awk -F"/" '{print $1}')
  NODENAME="-"$NODEBASE
  NODETYPE=$(echo $node | awk -F"/" '{print $2}' | awk -F"(" '{print $1}')
  NODENUM=$(echo $node | awk -F"(" '{print $2}' | awk -F")" '{print $1}')
`createBlade $SIMNAME $MSCNAME $NODENAME $NODETYPE $NODENUM $bladePort`
done
~/inst/netsim_shell < createMscblade.mml
rm createMscblade.mml
if [[ $MSCNODEVERSION = *"MSC-DB"* ]] || [[ $MSCNODEVERSION = *"MSC-IP-STP"* ]] || [[ $MSCNODEVERSION = *"MSC-vIP-STP"* ]] || [[ $MSCNODEVERSION = *"MSCv"* ]]
then
  continue;
else
 ./mscBladeInfo.sh $SIMNAME >> $PWD"/../log/GSM"$SIMNUM"_MscBladeInfo.log"
fi

