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
NODENAME=$1
MOSCRIPT=$2
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,BscFunction:BscFunction=1,BscM:BscM=1"
    identity "1"
    moType BscM:ExternalGeranCellM
    exception none
    nrOfAttributes 1
    "externalGeranCellMId" String "1"
)
MOSC
