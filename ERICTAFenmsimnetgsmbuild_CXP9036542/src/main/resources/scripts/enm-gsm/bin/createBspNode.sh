#!/bin/sh
### VERSION HISTORY
######################################################################################
#     Version     : 1.3
#
#     Revision    : CXP 903 6542-1-12
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : No Jira
#
#     Description : Correcting the freeips assign issue
#
#     Date        : 08th Jun 2021
#####################################################################################
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
#     Date        : 01st Mar 2021
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
hostName=`hostname`

if [ -e createBspPort.mml ]
then
   rm createBspPort.mml
fi
if [ -e bsp.mml ]
then
   rm bsp.mml
fi
cat >> createBspPort.mml << MML
.select configuration
.config add port bspPort netconf_prot $hostName
.config port address bspPort 0 161 public 1|2|3 %unique 3 %simname_%nename authpass privpass 2 2
.config save
MML

~/inst/netsim_shell < createBspPort.mml
rm createBspPort.mml

#lsof -nl >/tmp/lsof.log;rm -rf ~/freeIPs.log; for ip in `ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'`;do grep $ip /tmp/lsof.log > /dev/null; if [ $? != 0 ]; then echo $ip >> ~/freeIPs.log; fi; done; rm -rf /tmp/lsof.log;echo "Total IPs:`ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'|wc -l`"; echo "Free IPs:`wc -l ~/freeIPs.log`";
ipAddr=`cat "/netsim/freeIPs.log" | grep -vi ":" | head -n+1`
sed -i "/${ipAddr}/d" /netsim/freeIPs.log

BASENAME="M"$SIMNUM"BSP"
cat >> bsp.mml << MML
.open $SIMNAME
.createne checkport bspPort
.new simne -auto 1 $BASENAME 01
.set netype CORE BSP R11-CORE-V2
.set port bspPort
.createne subaddr $ipAddr subaddr no_value
.set save
.start
MML

~/inst/netsim_shell < bsp.mml
rm bsp.mml
./bspFeatures.sh $SIMNAME
