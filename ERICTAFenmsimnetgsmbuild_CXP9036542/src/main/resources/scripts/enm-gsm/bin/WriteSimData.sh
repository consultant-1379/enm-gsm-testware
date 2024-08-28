#!/bin/sh

### VERSION HISTORY
####################################################################################
#     Version     : 1.2
#
#     Revision    : CXP 903 6542-1-23
#
#     Author      : znrvbia
#
#     JIRA        : NSS-41461
#
#     Description : Copying RcsRem fragment functionality files to SimNetRevision folder in simulation
#
#     Date        : 22th November 2022
#
####################################################################################
####################################################################################
#     Version     : 1.1
#
#     Revision    : CXP 903 6542-1-1
#
#     Author      : zchianu
#
#     JIRA        : NSS-24845
#
#     Description : Copying Log and README to SimNetRevision folder in simulation
#
#     Date        : 26th july 2019
#
####################################################################################


SIMNAME=$1
PWD=`pwd`
BINPATH=/netsim/enm-gsm-testware/ERICTAFenmsimnetgsmbuild_CXP9036542/src/main/resources/scripts/enm-gsm/bin/

MSRBSVERSION=`cat ../dat/Build.env | grep ^"NODEVERSION" | cut -d "=" -f 2 | cut -d "\"" -f 2`
MSRBSNode="MSRBS"
STR1=${MSRBSNode}".*V2.*"
vals1=(${MSRBSVERSION//-/ })
for i in "${vals1[@]}"
do
STR1=$STR1$i".*"
done
echo $STR1
MSRBS_Link=`cat /netsim/simdepContents/nodeTemplate.content | grep -o '.*' | grep $STR1 | cut -d "\"" -f 2`
echo  "node templates is  ${MSRBS_Link} "
MSRBS_Template=`echo $MSRBS_Link | awk -F '/' '{print $NF}'`
MSRBS_Template_WithoutZIP=`echo $MSRBS_Template | cut -d "." -f1`
echo $MSRBS_Template_WithoutZIP is the node Template folder.

cd /netsim/netsimdir/$SIMNAME/
if [ -d SimNetRevision ]
then
cp $BINPATH/../dat/README /netsim/netsimdir/$SIMNAME/SimNetRevision/

cp $BINPATH/../log/*SimulationBuild.log /netsim/netsimdir/$SIMNAME/SimNetRevision/

else
mkdir SimNetRevision
cp $BINPATH/../dat/README /netsim/netsimdir/$SIMNAME/SimNetRevision/

cp $BINPATH/../log/*SimulationBuild.log /netsim/netsimdir/$SIMNAME/SimNetRevision/

fi

cd /netsim/netsimdir/$SIMNAME/SimNetRevision/

if [ -d NrEtcm ]
then
    chmod 777 NrEtcm
    cd NrEtcm/
    rm -rf *
    cp /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/etcm_* /netsim/netsimdir/$SIMNAME/SimNetRevision/NrEtcm/
else
    mkdir NrEtcm
    cp /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/etcm_* /netsim/netsimdir/$SIMNAME/SimNetRevision/NrEtcm/
fi

if [ -d NrFtem ]
then
    chmod 777 NrFtem
    cd NrFtem/
    rm -rf *
    cp /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ftem_* /netsim/netsimdir/$SIMNAME/SimNetRevision/NrFtem/
else
    mkdir NrFtem
    cp /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ftem_* /netsim/netsimdir/$SIMNAME/SimNetRevision/NrFtem/
fi

if [ -d NrPmEvents ]
then
    chmod 777 NrPmEvents
    cd NrPmEvents
    rm -rf *
    cp /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/pm_event_package_* /netsim/netsimdir/$SIMNAME/SimNetRevision/NrPmEvents/
else
    mkdir NrPmEvents
    cp /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/pm_event_package_* /netsim/netsimdir/$SIMNAME/SimNetRevision/NrPmEvents/
fi

