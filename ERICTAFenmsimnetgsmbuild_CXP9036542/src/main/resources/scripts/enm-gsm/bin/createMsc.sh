#!/bin/sh
### VERSION HISTORY
#######################################################################################
#     Version     : 1.4
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
#     Version     : 1.3
#
#     Revision    : CXP 903 6542-1-9
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : No Jira
#
#     Description : Adding Support for ECM nodes
#
#     Date        : 05th Mar 2021
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
if [ -e createMsc.mml ]
then
   rm createMsc.mml
fi

lsof -nl >/tmp/lsof.log;rm -rf ~/freeIPs.log; for ip in `ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'`;do grep $ip /tmp/lsof.log > /dev/null; if [ $? != 0 ]; then echo $ip >> ~/freeIPs.log; fi; done; rm -rf /tmp/lsof.log;echo "Total IPs:`ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'|wc -l`"; echo "Free IPs:`wc -l ~/freeIPs.log`";

ipAddr=`cat "/netsim/freeIPs.log" | grep -vi ":" | head -n+1`
sed -i "/${ipAddr}/d" /netsim/freeIPs.log
cd ../
rm -rf NSS-USER-COMMANDS
unzip NSS-USER-COMMANDS.zip 2>&1 >/dev/null
cp -r NSS-USER-COMMANDS /netsim/netsimdir/$SIMNAME/user_cmds/
cp -r LAMIP /netsim/netsimdir/$SIMNAME/user_cmds/
cp -r DBTSP /netsim/netsimdir/$SIMNAME/user_cmds/
cp -r SYBUE /netsim/netsimdir/$SIMNAME/user_cmds/
cd -
cat >> createMsc.mml << MML
.open $SIMNAME
.createne checkport $bscPort
.new simne -auto 1 M $SIMNUM
.set netype LTE $MSCNODEVERSION 
.set port $bscPort
.createne subaddr 0 subaddr no_value
.createne dosetext external $bscPort
.set ssliop no no_value
.set save
.select M$SIMNUM
.set port $bscPort
.modifyne set_subaddr $ipAddr subaddr no_value
.set save
.open $SIMNAME
.select M$SIMNUM
.stop
.set ulib /netsim/netsimdir/$SIMNAME/user_cmds/NSS-USER-COMMANDS
.set ulib none
.set ulib NSS-USER-COMMANDS|/netsim/netsimdir/$SIMNAME/user_cmds/LAMIP
.set ulib none
.set ulib NSS-USER-COMMANDS|LAMIP|/netsim/netsimdir/$SIMNAME/user_cmds/DBTSP
.set ulib none
.set ulib NSS-USER-COMMANDS|LAMIP|DBTSP|/netsim/netsimdir/$SIMNAME/user_cmds/SYBUE
.set save
.set ulib none
.set ulib NSS-USER-COMMANDS|LAMIP|DBTSP|SYBUE
.set save
MML
if [[ $SIMNAME = *"MSC-DB"* ]] || [[ $SIMNAME = *"MSC-IP-STP"* ]] || [[ $SIMNAME = *"MSC-vIP-STP"* ]] || [[ $SIMNAME = *"MSCv"* ]]
then
cat >> createMsc.mml << MML
.start
MML
fi
~/inst/netsim_shell < createMsc.mml
rm createMsc.mml
if [[ $SWITCHTORV = "NO" ]]
then
    if [[ $SIMNAME = *"BSP"* ]]
    then
        ./createBspNode.sh $SIMNAME
    fi
    if [[ $MSCNODEVERSION = *"MSCv"* ]] || [[ $MSCNODEVERSION = *"MSC-vIP-STP"* ]]
    then
        ./createECM.sh $SIMNAME
    fi
fi
