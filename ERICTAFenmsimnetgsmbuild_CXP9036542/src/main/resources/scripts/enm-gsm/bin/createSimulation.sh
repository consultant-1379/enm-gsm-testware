#!/bin/sh

### VERSION HISTORY
#####################################################################################
#     Version     : 21.15
#
#     Revision    : CXP 903 6542-1-15
#
#     Author      : Siva Mogilicharla
#
#     JIRA        : NSS-42004
#
#     Description : Adding seperate script for RV ( SetGeranAttribute_RV.sh)
#
#     Date        : 16th Jan 2023
#
####################################################################################
#####################################################################################
#     Version     : 21.15
#
#     Revision    : CXP 903 6542-1-15
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-36905
#
#     Description : Setting IP address for BSC as per in Centos and setGRanscript added.
#                   supporting for vBSC node type
#
#     Date        : 13th Sep 2021
#
####################################################################################
#####################################################################################
#     Version     : 21.07
#
#     Revision    : CXP 903 6542-1-11
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NO Jira
#
#     Description : updating Code base for removing unwanted pm data while doing save
#
#     Date        : 06th Apr 2021
#
#####################################################################################
#####################################################################################
#     Version6    : 21.06
#
#     Revision    : CXP 903 6542-1-10
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-34459
#
#     Description : Correcting code for ERROR free log
#
#     Date        : 08th Mar 2021
#
####################################################################################
#####################################################################################
#     Version5    : 21.06
#
#     Revision    : CXP 903 6542-1-9
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : No JIRA
#
#     Description : Displays output on screen
#
#     Date        : 05th Mar 2021
#
####################################################################################
#####################################################################################
#     Version4    : 21.06
#
#     Revision    : CXP 903 6542-1-8
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-34293,NSS-34223
#
#     Description : Changing BSC and MSC Node names
#                   Creating 3% of FileM MOs on BSC nodes
#
#     Date        : 03rd Mar 2021
#
####################################################################################
#####################################################################################
#     Version3     : 21.04
#
#     Revision    : CXP 903 6542-1-7
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : NSS-33841
#
#     Description : Removing unwanted data while building the simulation
#
#     Date        : 23rd Dec 2020
#
####################################################################################
#######################################################################################
# Version2    : 20.05
# Revision    : CXP 903 6542-1-3
# Purpose     : Skipping Pm Check If Pm support is not availble in Mib.
# Description : Skipping Pm Check If Pm support is not availble in Mib.
# JIRA        : NSS-29142
# Date        : 20th Feb 2020
# Author      : zyamkan
########################################################################################
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
hostName=`hostname`
if [[ $SIMNAME == *"vBSC"* ]]
then
    BSCTYPE="vBSC"
else
    BSCTYPE="BSC"
fi
. $PWD/../dat/Build.env
RV=$SWITCHTORV

startTime=`date +%s`
./createBscTopology.sh
if [ -e $PWD/../customdata/NetworkStats.csv ]
then
   rm $PWD/../customdata/NetworkStats.csv
fi
if [ -e createSim.mml ]
then
   rm createSim.mml
fi
LOGPATH=$PWD"/../log"
STARTTIME=`date`
echo "##### Building $SIMNAME started at $STARTTIME #####"
if [ -z "$(ls -A $LOGPATH)" ]; then
   continue;
else
   rm -rf $PWD/../NSS-USER-COMMANDS
   cd $LOGPATH
   rm -rf *
   cd -
   echo "### Deleting Old LogFiles ....... #####"
fi

if [ -d /netsim/netsimdir/$SIMNAME ]
then
cat >> createSim.mml << MML
.open $SIMNAME
.select network
.stop
.deletesimulation $SIMNAME force
MML
fi
~/inst/netsim_shell < createSim.mml >> $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
rm createSim.mml
#### Creating Ports #########
if [ -e port.mml ]
then
   rm port.mml
fi
cat >> port.mml << MML
.select configuration
.config add port $bscPort apgtcp_netconf_https_http_prot $hostName
.config port address $bscPort 0 161 public 1 %unique 1 5001 5000 52002 %simname_%nename authpass privpass 2 2
.config save
.select configuration
.config add port $dg2Port netconf_https_http_prot $hostName
.config port address $dg2Port 0 161 public 1 %unique 1 %simname_%nename authpass privpass 2 2
.config save
.select configuration
.config add port $lanswitchPort snmp_ssh_telnet_prot $hostName
.config port address $lanswitchPort 0 161 public 1 %unique %simname_%nename authpass privpass 2 2
.config save
.select configuration
.config add external $bscPort apgtcp_netconf_https_http_prot
.config external servers $bscPort $hostName
.config external address $bscPort
.config save
.select configuration
.config add external $dg2Port netconf_https_http_prot
.config external servers $dg2Port $hostName
.config external address $dg2Port
.config save
.select configuration
.config add port $bladePort msc-s_cp_prot $hostName
.config port address $bladePort
.config save
.select configuration
.config add external IS_DEST netconf_https_http_prot
.config external servers IS_DEST $hostName
.config external address IS_DEST 0.0.0.0 162 1
.config save
MML
~/inst/netsim_shell < port.mml >> $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
rm port.mml
#### Creating Radionodes #####
./createDG2nodes.sh $SIMNAME >> $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
### checking Pm Groups #####
echo " *******************************************************************************" | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
echo " ****************** PmUnit test are checking on MSRBS nodes ****************" | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
echo " *******************************************************************************" | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
echo shroot | sudo -S -H -u root bash -c "perl PmUnitTest.pl ${SIMNAME}" | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"

if [ $? != 0 ]; then
   echo "ERROR: Not able to run PmUnitTest.pl So we are exiting from build" | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
fi

CmdResult=`cat $PWD"/../log/Pmlogs.txt" | grep -i failed | wc -l`
if [ "$CmdResult" == "0" ]
then
   echo "Pm Data is proper on the RadioNodes" | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
else
   echo "Pm Data is not properly loaded on RadioNodes" | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
   echo "Please check the PM data on nodes with the respective MIB file" | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
   echo "We are exiting from Sim Build " | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
   exit 1
fi
rm -rf $PWD"/PmUnitTest.pl.mml"
echo " ******************End of PM unit script execution *************************" | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
#### Creating MSC Nodes ######
./createMsc.sh $SIMNAME | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
./createMscBlade.sh $SIMNAME  | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
#### Creating Nodes ##########
getNumOfNodes() {
SIMNUM=$1
CELLARRAY=$2
IFS=";"
for x in $CELLARRAY
do
SIMPOS=$(echo $x | awk -F":" '{print $1}')
if [ "$SIMNUM" -eq "$SIMPOS" ]
then
  NODENUM=$(echo $x | awk -F":" '{print $2}' | awk -F"," '{print $1}')
  echo $NODENUM
  break
fi
done
}
### Creating BSC nodes ###
lsof -nl >/tmp/lsof.log;rm -rf ~/freeIPs.log; for ip in `ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'`;do grep $ip /tmp/lsof.log > /dev/null; if [ $? != 0 ]; then echo $ip >> ~/freeIPs.log; fi; done; rm -rf /tmp/lsof.log;echo "Total IPs:`ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'|wc -l`"; echo "Free IPs:`wc -l ~/freeIPs.log`";
ipAddr=`cat /netsim/freeIPs.log | grep -vi ":" | head -n+1`
startNode=$(expr $(expr $simNum \* 2 ) - 1)
NUMOFBSCNODES=`getNumOfNodes $simNum $CELLARRAY`
BSCBASENAME="B"
cat >> createBsc.mml << MML
.open $SIMNAME
.createne checkport $bscPort
.new simne -auto $NUMOFBSCNODES B $startNode
.set netype $BSCTYPE $BSCNODEVERSION
.set port $bscPort
.createne subaddr 0 subaddr no_value
.set save
MML
COUNT=$startNode
endNode=`expr $NUMOFBSCNODES + $startNode - 1`
BSCNODES=""
lsof -nl >/tmp/lsof.log;rm -rf ~/freeIPs.log; for ip in `ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'`;do grep $ip /tmp/lsof.log > /dev/null; if [ $? != 0 ]; then echo $ip >> ~/freeIPs.log; fi; done; rm -rf /tmp/lsof.log;echo "Total IPs:`ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'|wc -l`"; echo "Free IPs:`wc -l ~/freeIPs.log`";
while [ "$COUNT" -le "$endNode" ]
do
  if [ "$COUNT" -le "9" ]
  then
     NODE=$BSCBASENAME"0"$COUNT
  else
     NODE=$BSCBASENAME$COUNT
  fi
  ipAddr=`cat /netsim/freeIPs.log | grep -vi ":" | head -n+1`
  sed -i "/${ipAddr}/d" /netsim/freeIPs.log
cat >> createBsc.mml << MML
.open $SIMNAME
.select $NODE
.set port $bscPort
.modifyne set_subaddr $ipAddr subaddr no_value
.set save
.start
.stop
MML
  BSCNODES=$BSCNODES" "$NODE
COUNT=`expr $COUNT + 1`
done
MSCNAME="M"$SIMNUM
cat >> createBsc.mml << MML
.open $SIMNAME
.new exception show3
.set infotxt show3
.set language ap
.set priority 1
.set netype
.set commands show
.set condition cmdst_comp [{cmdstring,"show"}] 
.set action direct_answer [{message_or_file,"ManagedElement=1"}]
.set save
.stop
.select $BSCNODES $MSCNAME
.stop
.relate
.set save
.start -parallel
MML
~/inst/netsim_shell < createBsc.mml >> $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
rm createBsc.mml
####### Relating Radionodes to Bsc #######
./relateDg2ToBsc.sh $SIMNAME | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
####### Creating Bsc Network #############
echo "***** Creating Bsc network for $SIMNAME *****************" | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
./createGranBscNetwork.sh $SIMNAME
echo "***** Running Bulkup on $SIMNAME ************************" | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
./Bsc_bulkup.sh $SIMNAME  | tee -a $PWD"/../log/GSM"$SIMNUM"bulkUp.log"

if [[ $RV == "NO" ]]
then
./setGranAttribute.sh $SIMNAME | tee -a $PWD"../log/GSM"$SIMNUM"SimulationBuild.log"
else
./SetGranAttribute_RV.sh $SIMNAME | tee -a $PWD"../log/GSM"$SIMNUM"SimulationBuild.log"
fi

echo "***** Creating 3% of FileM MOs on BSC nodes in $SIMNAME ***********" | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
./createfileM.sh $SIMNAME | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
./updateMoInformation.sh $SIMNAME  | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
echo "***** Creating Msc nodes on $SIMNAME ********************" >> $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
####### Creating Msc Network ############
./setCpname.sh $SIMNAME  >> $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
./mscProduct.sh $SIMNAME  | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
./MscBulkup.sh $SIMNAME "M"$SIMNUM 42 | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
#./createLicenseMO.sh $SIMNAME >> $PWD"/../log/GSM"$SIMNUM"_setLicenseMo.log"
./setExceptions.sh $SIMNAME  | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
echo "***** Setting Ciphers on DG2 nodes in $SIMNAME ***********" | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
./setDG2Ciphers.sh $SIMNAME | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
echo "***** Saving and Compressing the simulations ************" | tee -a $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"

mkdir -p /netsim/netsimdir/$SIMNAME/SimNetRevision
cp $PWD/../customdata/NetworkStats.csv /netsim/netsimdir/$SIMNAME/SimNetRevision
#### Save and compress simulation ########
if [ -e save.mml ]
then
   rm save.mml
fi
cat >> save.mml << MML
.open $SIMNAME
.select network
.saveandcompress force nopmdata
MML
~/inst/netsim_shell < save.mml >> $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
rm save.mml
./createGsmTopology.sh $SIMNAME >> $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
./WriteSimData.sh $SIMNAME >> $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
if [ -e save1.mml ]
then
   rm save1.mml
fi
rm -rf /netsim/netsimdir/${SIMNAME}/allsaved/fss/*
rm -rf /netsim/netsimdir/${SIMNAME}/allsaved/old-fss/*
rm -rf /netsim/netsimdir/${SIMNAME}/saved/dbs/*
rm -rf /netsim/netsimdir/${SIMNAME}/saved/fss/*
rm -rf /netsim/netsim_dbdir/simdir/netsim/netsimdir/*/*/fs/*
cat >> save1.mml << MML
.open $SIMNAME
.select network
.stop
.saveandcompress force nopmdata
MML
~/inst/netsim_shell < save1.mml >> $PWD"/../log/GSM"$SIMNUM"SimulationBuild.log"
rm save1.mml
cd $LOGPATH
checkForErrors=`grep -nri "ERROR" *SimulationBuild.log`
if [[ "$checkForErrors" == "" ]]
then
   echo "####################### Build Completed successfully ##############################"
else
   echo "############# Build completed with ERRORS !! Please check log Files ###############"
fi
endTime=`date +%s`
timeOfExecutionInHours=$(expr $(expr $endTime - $startTime ) / 3600)
timeOfExecutionInMinutes=$(expr $(expr $endTime - $startTime ) % 60 )
echo "## The script ran for $timeOfExecutionInHours hrs $timeOfExecutionInMinutes minutes ##"
