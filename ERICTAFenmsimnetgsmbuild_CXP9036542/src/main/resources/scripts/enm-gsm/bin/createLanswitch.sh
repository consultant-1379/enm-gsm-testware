#!/bin/sh
### VERSION HISTORY
#####################################################################################
#     Version     : 1.2
#
#     Revision    : CXP 903 6542-1-19
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NO-JIRA
#
#     Description : Lanswitch nodes will not be creating for vBSC node
#
#     Date        : 23rd Dec 2021
#####################################################################################
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
NODECOUNT=2
. $PWD/../dat/Build.env

if [[ $SIMNAME == *vBSC* ]]
then
    echo "No need to create Lanswitch nodes on vBSC"
    exit 1
fi

MMLSCRIPT=$SIMNAME"_lanSwitch.mml"
lsof -nl >/tmp/lsof.log;rm -rf ~/freeIPs.log; for ip in `ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'`;do grep $ip /tmp/lsof.log > /dev/null; if [ $? != 0 ]; then echo $ip >> ~/freeIPs.log; fi; done; rm -rf /tmp/lsof.log;echo "Total IPs:`ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'|wc -l`"; echo "Free IPs:`wc -l ~/freeIPs.log`";

ipAddr=`cat /netsim/freeIPs.log | grep -vi ":" | head -n+1`

cat >> $MMLSCRIPT << MML
.open $SIMNAME
.createne checkport $lanswitchPort
.new simne -auto $NODECOUNT -LAN- 0
.set netype GSM LANSWITCH R1
.set port $lanswitchPort
.createne subaddr 0 subaddr no_value
.set save
MML

COUNT=0
NODES=""
while [ "$COUNT" -lt "$NODECOUNT" ]
do
  if [ "$COUNT" -le "9" ]
  then
     NODE="-LAN-0"$COUNT
  else
     NODE="-LAN-"$COUNT
  fi
  NODES=$NODES" "$NODE
COUNT=`expr $COUNT + 1`
done

cat >> $MMLSCRIPT << MML
.selectnocallback $NODES
.set port $lanswitchPort
.modifyne set_subaddr $ipAddr subaddr no_value
.set save
.generatearne off LANSWITCH R1
.save
MML
cat >> $MMLSCRIPT << MML
.open $SIMNAME
.select $NODENAME
.stop
.selectregexp simne $NODENAME|-LAN.*
.relate
.save
MML
~/inst/netsim_shell < $MMLSCRIPT | tee -a $PWD/../log/$NODENAME"-LanswitchNode.log"
rm $MMLSCRIPT
