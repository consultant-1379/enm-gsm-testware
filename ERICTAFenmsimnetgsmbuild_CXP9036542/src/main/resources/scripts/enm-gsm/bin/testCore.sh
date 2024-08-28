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
PLMNID=$3
nodeName=$NODENAME

MMLSCRIPT="core.mml"
MOSCRIPT="core.mo"
rm $MMLSCRIPT
rm $MOSCRIPT
cat >> $MOSCRIPT << MML
CREATE
(
    parent "ComTop:ManagedElement=$nodeName,BscFunction:BscFunction=1,BscM:BscM=1,BscM:CoreNetwork=1"
    identity "$PLMNID"
    moType BscM:Plmn
    exception none
    nrOfAttributes 14
    "plmnId" String "$PLMNID"
    "mcc" String "46"
    "mnc" String "6"
    "plmnIndividual" Uint8 "$PLMNID"
)
MML

cat >> $MMLSCRIPT << MOSC
.open $SIMNAME
.select $NODENAME
.start
kertayle:file="$PWD/$MOSCRIPT";
MOSC
~/inst/netsim_shell < $MMLSCRIPT
rm $MMLSCRIPT
rm $MOSCRIPT
