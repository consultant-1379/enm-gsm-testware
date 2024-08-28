#!/bin/sh
### VERSION HISTORY
#####################################################################################
#     Version     : 1.2
#
#     Revision    : CXP 903 6542-1-9
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : No Jira
#
#     Description : Intsalling telnet on vM 
#
#     Date        : 05th Mar 2021
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
NODENAME=$2
SIMNUM="${SIMNAME:(-2)}"
simNum=`expr $SIMNUM + 0`
RANGE=`cat $PWD/../customdata/GsmTopology.csv | grep -i "SIM:$simNum;NODE:$NODENAME" | awk -F"INTRARANGE:" '{print $2}' | awk -F";" '{print $1}' | head -n+1`
STARTCELL=$(echo $RANGE | awk -F"-" '{print $1}')
ENDCELL=$(echo $RANGE | awk -F"-" '{print $2}')
G2BTSCOUNT=`cat $PWD/../customdata/GsmTopology.csv | grep -i "SIM:$simNum;NODE:$NODENAME" | grep "BTS:G2" | wc -l`
NODEIP=`echo -e '.open '$SIMNAME' \n .select '$NODENAME' \n .start \n .show simne' | ~/inst/netsim_shell | grep -w subaddr | awk -F"\"" '{print $2}'`
echo shroot | sudo -S -H -u root bash -c "yum install -y telnet"
MMLSCRIPT=telnet.mml
VAR="1"
while [ "$VAR" -lt "$G2BTSCOUNT" ]
do
/usr/bin/expect << EOF
set timeout -1
spawn telnet $NODEIP 5000
expect {
    -re > {send "mml OPTFEATUREON:CODE=24;\r
mml OPTFEATUREON:CODE=26;\r
mml OPTFEATUREON:CODE=24;\r
mml OPTFEATUREON:CODE=26;\r
mml OPTFEATUREON:CODE=25;\r
mml OPTFEATUREON:CODE=52;\r
mml OPTFEATUREON:CODE=58;\r
mml OPTFEATUREON:CODE=62;\r
mml OPTFEATUREON:CODE=153&&156&169&174;\r
mml OPTFEATUREON:NAME=MASTERRES;\r
mml OPTFEATUREON:NAME=ABISmml OPT;\r
mml RXMOI:MO=RXSTG-$VAR,RSITE=B072_1005_0907,SECTOR=SECTOR$VAR;\r
exit\r";
exp_continue}
}
EOF
VAR=`expr $VAR + 1`
done
rm telnet.mml
