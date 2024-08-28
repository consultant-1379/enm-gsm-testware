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
SIMNAME=$1
NODENAME=$2
NODECOUNT=$3

. $PWD/../dat/Build.env

MMLSCRIPT=$NODENAME"_RadioNode.mml"
lsof -nl >/tmp/lsof.log;rm -rf ~/freeIPs.log; for ip in `ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'`;do grep $ip /tmp/lsof.log > /dev/null; if [ $? != 0 ]; then echo $ip >> ~/freeIPs.log; fi; done; rm -rf /tmp/lsof.log;echo "Total IPs:`ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'|wc -l`"; echo "Free IPs:`wc -l ~/freeIPs.log`";

ipAddr=`cat "/netsim/freeIPs.log" | grep -vi ":" | head -n+1`
cat >> $MMLSCRIPT << MML
.open $SIMNAME
cmshell;
.createne checkport $dg2Port
.new simne -auto $NODECOUNT MSRBS-V2 01
.set netype LTE MSRBS-V2 $NODEVERSION
.set port $dg2Port
.createne subaddr 0 subaddr no_value
.set save
MML

COUNT=1
NODES=""
while [ "$COUNT" -le "$NODECOUNT" ]
do
  if [ "$COUNT" -le "9" ]
  then
     NODE="MSRBS-V20"$COUNT
  else
     NODE="MSRBS-V2"$COUNT
  fi
  NODES=$NODES" "$NODE
COUNT=`expr $COUNT + 1`
done

cat >> $MMLSCRIPT << MML
.selectnocallback $NODES
.set port $dg2Port
.modifyne set_subaddr $ipAddr subaddr no_value
.set save
MML
~/inst/netsim_shell < $MMLSCRIPT
