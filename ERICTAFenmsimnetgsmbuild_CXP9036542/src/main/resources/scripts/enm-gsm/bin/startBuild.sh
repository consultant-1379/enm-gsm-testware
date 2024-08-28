#!/bin/bash

### VERSION HISTORY
#####################################################################################
##     Version1     : 20.11
##
##     Revision     : CXP 903 6542-1-5
##
##     Author       : zsujmad
##
##     JIRA         : NSS-31187
##
##     Description  : Installing the node templates and starting the build.
##
##     Date         : 17th June 2020
##
######################################################################################
#####################################################################################

if [ "$#" -ne 1 ]
then
cat<<HELP

####################
# HELP
####################

Usage  : $0 <SimName>

Example: $0 GSM-FT-MSC-DB-BSP-15cell_BSC_20-Q2_V1x9-GSM01

HELP

exit 1
fi

chmod -R 777 /netsim/enm-gsm-testware/

SIMNAME=$1
cp /var/nssSingleSimulationBuild/* ../dat
PWD=`pwd`
source "$PWD/../dat/Build.env"
RV=$SWITCHTORV

if [[ $RV == "NO" ]]
then
switchRV=no
else
switchRV=yes
fi

echo "Switch to Rv is given as $switchRV"


#cp /var/nssSingleSimulationBuild/* ../dat

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
rm -rf /netsim/netsimdir/${MSRBS_Template}
wget -P /netsim/netsimdir $MSRBS_Link
su netsim -c "echo -e '.uncompressandopen clear_lock \n .uncompressandopen $MSRBS_Template force' | /netsim/inst/netsim_shell"

####################################################################################

BSCVERSION=`cat ../dat/Build.env | grep ^"BSCNODEVERSION" | cut -d "=" -f 2 | cut -d "\"" -f 2`
BSCNode="BSC"
BSCNode=${BSCNode}".*"
vals2=(${BSCVERSION//-/ })
for i in "${vals2[@]}"
do
BSCNode=$BSCNode$i".*"
done
echo $BSCNode
#BSC_Link=`cat /netsim/simdepContents/nodeTemplate.content | grep -o '.*' | grep $BSCNode | cut -d "\"" -f 2`
if [[ ${SIMNAME} != *"vBSC"* ]]
then
BSC_Link=`cat /netsim/simdepContents/nodeTemplate.content | grep -o '.*' | grep $BSCNode | grep -v "vBSC" |   cut -d "\"" -f 2`
else
BSC_Link=`cat /netsim/simdepContents/nodeTemplate.content | grep -o '.*' | grep $BSCNode |  cut -d "\"" -f 2`
fi

BSC_Template=`echo $BSC_Link | awk -F '/' '{print $NF}'`
rm -rf /netsim/netsimdir/${BSC_Template}
wget -P /netsim/netsimdir $BSC_Link
su netsim -c "echo -e '.uncompressandopen clear_lock \n .uncompressandopen $BSC_Template force' | /netsim/inst/netsim_shell"

####################################################################################

MSCVERSION=`cat ../dat/Build.env | grep ^"MSCNODEVERSION" | cut -d "=" -f 2 | cut -d "\"" -f 2`
MSCNode=`echo $MSCVERSION | sed 's/ /-/g'`
vals3=(${MSCNode//-/ })
for i in "${vals3[@]}"
do
STR3=$STR3$i".*"
done
echo $STR3
MSC_Link=`cat /netsim/simdepContents/nodeTemplate.content | grep -o '.*' | grep $STR3 | cut -d "\"" -f 2`
MSC_Template=`echo $MSC_Link | awk -F '/' '{print $NF}'`
rm -rf /netsim/netsimdir/${MSC_Template}
wget -P /netsim/netsimdir $MSC_Link
su netsim -c "echo -e '.uncompressandopen clear_lock \n .uncompressandopen $MSC_Template force' | /netsim/inst/netsim_shell"

####################################################################################

su netsim -c "sh createSimulation.sh $SIMNAME"

##############################################################################
#Updating IPs
#####################################################################

echo "Running python script for Updating IP values on $SIMNAME : "

cd Updating_IPs/

chmod 777 *

python new_updateip.py -deploymentType mediumDeployment -release 22.03 -simLTE NO_NW_AVAILABLE -simWRAN NO_NW_AVAILABLE -simCORE $SIMNAME -switchToRv $switchRV -IPV6Per yes -docker no

echo "Completed...IP Details are updated in the Simulation folder"

######################################################################

