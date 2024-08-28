#!/bin/sh
### VERSION HISTORY
#####################################################################################
#     Version     : 1.1
#
#     Revision    : CXP 903 6542-1-13
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-36059
#
#     Description : Reparenting BSC node. It runs only for BSC94 node
#
#     Date        : 12th Jul 2021
#####################################################################################

SIMNAME=$1
NodeName=$2
SIMNUM="${SIMNAME:(-2)}"
simNum=`expr $SIMNUM + 0`
. $PWD/../dat/Build.env

if [ -e reparentingBsc.mml ]
then
   rm reparentingBsc.mml
fi

echo "###############################################"
echo " This Script runs only on M47B94 Node for Reparenting the BSC node"
echo "###############################################"

cat >> reparentingBsc.mml << MML
.open $SIMNAME
.select $NodeName
.start
bsc_configure_delay:create_gerancell_child=no;
bsc_configure_delay:list;
.date
MML

~/inst/netsim_shell < reparentingBsc.mml
rm reparentingBsc.mml
