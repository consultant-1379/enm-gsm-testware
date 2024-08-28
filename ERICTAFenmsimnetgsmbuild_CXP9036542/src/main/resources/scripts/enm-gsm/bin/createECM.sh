#!/bin/sh
### VERSION HISTORY
#######################################################################################
#     Version     : 1.2
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
#     Version     : 1.1
#
#     Revision    : CXP 903 6542-1-9
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : No Jira
#
#     Description : Creating ECM nodes for MSCv and Msc-vIP-STP node type
#
#     Date        : 05th Mar 2021
#
####################################################################################
SIMNAME=$1
SIMNUM="${SIMNAME:(-2)}"
hostName=`hostname`

if [ -e createEcmPort.mml ]
then
   rm createEcmPort.mml
fi
if [ -e ecm.mml ]
then
   rm ecm.mml
fi
cat >> createEcmPort.mml << MML
.select configuration
.config add port EcmPort http_https_port $hostName
.config port address EcmPort 0 1161 public 2 %unique %simname_%nename authpass privpass 2 2
.config save
.select configuration
.config add external ECMPORT http_https_port
.config external servers ECMPORT $hostName
.config external address ECMPORT 0.0.0.0 162 1
.config save
MML

~/inst/netsim_shell < createEcmPort.mml
rm createEcmPort.mml

#lsof -nl >/tmp/lsof.log;rm -rf ~/freeIPs.log; for ip in `ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'`;do grep $ip /tmp/lsof.log > /dev/null; if [ $? != 0 ]; then echo $ip >> ~/freeIPs.log; fi; done; rm -rf /tmp/lsof.log;echo "Total IPs:`ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'|wc -l`"; echo "Free IPs:`wc -l ~/freeIPs.log`";
ipAddr=`cat "/netsim/freeIPs.log" | grep -vi ":" | head -n+1`
sed -i "/${ipAddr}/d" /netsim/freeIPs.log

BASENAME="ECM"
cat >> ecm.mml << MML
.open $SIMNAME
.createne checkport EcmPort
.new simne -auto 1 $BASENAME $SIMNUM
.set netype CORE ECM R17
.set port EcmPort
.createne subaddr $ipAddr subaddr no_value
.set external ECMPORT
.set save
.start
set_ecmalarm_type:type=http;
pmdata:disable;
MML

~/inst/netsim_shell < ecm.mml
rm ecm.mml
