#!/bin/sh
### VERSION HISTORY
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
NODENAME="M"$SIMNUM
MMLSCRIPT=$SIMNAME"_cp.mml"
if [ $SIMNAME == *DB* ] || [ $SIMNAME == *IP-STP* ] || [ $SIMNAME == *MSCv* ]
then
   continue;
else
if [ -e $MMLSCRIPT ]
then
   rm $MMLSCRIPT
fi
cat >> $MMLSCRIPT << MML
.open $SIMNAME
.select $NODENAME
aploc;
MML
cpBladeList=`echo -e '.open '$SIMNAME'\n .show simnes' | ~/inst/netsim_shell | grep "GSM MSC" | cut -d" " -f1 | grep "SX"`
ipLbList=`echo -e '.open '$SIMNAME'\n .show simnes' | ~/inst/netsim_shell | grep "GSM MSC" | cut -d" " -f1 | grep "IPLB"`
bcBladeList=`echo -e '.open '$SIMNAME'\n .show simnes' | ~/inst/netsim_shell | grep "GSM MSC" | cut -d" " -f1 | grep -E "CP|TSC"`
cpBlades=(${cpBladeList// / })
bcBlades=(${bcBladeList// / })
ipBlades=(${ipLbList// / })
bcCount=1
for bcBlade in ${bcBlades[@]}
do
  bcName="BC"$bcCount
  cat >> $MMLSCRIPT << MML
.setcpname $bcBlade $bcName
MML
  bcCount=`expr $bcCount + 1`
done
cpCount=1
for cpBlade in ${cpBlades[@]}
do
  cpName="CP"$cpCount
  cat >> $MMLSCRIPT << MML
.setcpname $cpBlade $cpName
MML
  cpCount=`expr $cpCount + 1`
done
ipCount=1
for ipBlade in ${ipBlades[@]}
do
  ipName="IPLB"$ipCount
  cat >> $MMLSCRIPT << MML
.setcpname $ipBlade $ipName
MML
  ipCount=`expr $ipCount + 1`
done
~/inst/netsim_shell < $MMLSCRIPT
rm $MMLSCRIPT
fi
