#!/bin/sh
### VERSION HISTORY
####################################################################################
#     Version     : 1.3
#
#     Revision    : CXP 903 6542-111
#
#     Author      : Yamuna Kanchireddygari
#
#     JIRA        : No Jira
#
#     Description : Correcting Exceptiong for diff. types of MSC nodes
#
#     Date        : 07th Apr 2021
#
####################################################################################
####################################################################################
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
SIM=$1
SIMNUM="${SIM:(-2)}"
MSCNAME="M"$SIMNUM
BASENAME="M"$SIMNUM"B"
simNum=`expr $SIMNUM + 0`
NUMOFNODES=2
NODENUM1=$(expr $(expr $simNum \* $NUMOFNODES) - $NUMOFNODES + 1 )
NODENUM2=$(expr $(expr $simNum \* $NUMOFNODES) - $NUMOFNODES + 2 )
. ../dat/Build.env
if [ "$NODENUM1" -le 9 ]
then
    NODENAME1=$BASENAME'0'$NODENUM1
else
    NODENAME1=$BASENAME$NODENUM1
fi

if [ "$NODENUM2" -le 9 ]
then
    NODENAME2=$BASENAME'0'$NODENUM2
else
    NODENAME2=$BASENAME$NODENUM2
fi
if [ -e exceptions.mml ]
then
   rm exceptions.mml
fi
cat >> exceptions.mml << MML
.open $SIM
.new exception show_logicalnew
.set infotxt show_logicalnew
.set language ap
.set priority 1
.set netype  
.set commands show 
.set condition cmdst_comp [{cmdstring,"show ManagedElement=1,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,LogicalMgmt=1"}]
.set action direct_answer [{message_or_file,"/netsim/inst/APT/show_commandop"}]
.set save
.new exception show_logical_non_cluster
.set infotxt show_logical_non_cluster
.set language ap
.set priority 1
.set netype
.set commands show
.set condition cmdst_comp [{cmdstring,"show ManagedElement=1,SystemFunctions=1,AxeFunctions=1,SystemComponentHandling=1,EquipmentM=1,LogicalMgmt=1"}]
.set action direct_answer [{message_or_file,"/netsim/inst/APT/non_cluster_show_commandop"}]
.set save
.new exception PrcState
.set infotxt PrcState
.set language ap
.set priority 1
.set netype
.set commands pkzipc prcstate
.set condition cmdst_comp [{cmdstring,"prcstate -l"}]
.set action direct_answer [{message_or_file,"active node is up and working\npassive node is up and working"}]
.set save
.new exception PCORP_LAEIP
.set infotxt PCORP_LAEIP
.set language ap
.set priority 1
.set netype
.set commands mml
.set condition cmdst_comp [{cmdstring,"mml PCORP:BLOCK=ALL,EXT; LAEIP:SUID=ALL;"}]
.set action direct_answer [{message_or_file,"/netsim/inst/netsimbase/inst/PCORP_LAEIP.cfg"}]
.set save
.new exception PCORP_LAEIP_CP1
.set infotxt PCORP_LAEIP_CP1
.set language ap
.set priority 1
.set netype
.set commands mml
.set condition cmdst_comp [{cmdstring,"mml -cp CP1 PCORP:BLOCK=ALL,EXT; LAEIP:SUID=ALL;"}]
.set action direct_answer [{message_or_file,"/netsim/inst/netsimbase/inst/PCORP_LAEIP_CP.cfg"}]
.set save
.new exception PCORP_LAEIP_CP2
.set infotxt PCORP_LAEIP_CP2
.set language ap
.set priority 1
.set netype
.set commands mml
.set condition cmdst_comp [{cmdstring,"mml -cp CP2 PCORP:BLOCK=ALL,EXT; LAEIP:SUID=ALL;"}]
.set action direct_answer [{message_or_file,"/netsim/inst/netsimbase/inst/PCORP_LAEIP_CP.cfg"}]
.set save
.new exception SwPackage1
.set infotxt SwPackage
.set language ap
.set priority 0
.set netype
.set commands show
.set condition cmdst_comp [{cmdstring,"show ManagedElement=%NENAME%,SystemFunctions=1,AxeFunctions=1,DataOutputHandling=1,NbiFoldersM=1,swPackage"}]
.set action direct_answer [{message_or_file,"swPackage=\"sw_package\""}]
.set save
.open $SIM
.selectregexp simne $NODENAME1|$NODENAME2|$MSCNAME-.*|$MSCNAME
.selectregexp simne $NODENAME1|$NODENAME2|$MSCNAME-.*|$MSCNAME
.stop
.set ulib /netsim/netsimdir/$SIM/user_cmds/NSS-USER-COMMANDS
.set ulib none
.set ulib NSS-USER-COMMANDS|/netsim/netsimdir/$SIM/user_cmds/LAMIP
.set ulib none
.set ulib NSS-USER-COMMANDS|LAMIP|/netsim/netsimdir/$SIM/user_cmds/DBTSP
.set save
.set ulib none
.set ulib NSS-USER-COMMANDS|LAMIP|DBTSP
.set save
.select show3|show_logical_non_cluster|PrcState|PCORP_LAEIP|PCORP_LAEIP_CP1|PCORP_LAEIP_CP2|SwPackage1
.exception off
.select show3|show_logical_non_cluster|PrcState|PCORP_LAEIP|PCORP_LAEIP_CP1|PCORP_LAEIP_CP2|SwPackage1
.exception on
.save
.start
.open $SIM
.selectregexp simne $NODENAME1|$NODENAME2
.selectregexp simne $NODENAME1|$NODENAME2
.stop
.set ulib /netsim/netsimdir/$SIM/user_cmds/NSS-USER-COMMANDS
.set ulib none
.set ulib NSS-USER-COMMANDS|/netsim/netsimdir/$SIM/user_cmds/LAMIP
.set ulib none
.set ulib NSS-USER-COMMANDS|LAMIP|/netsim/netsimdir/$SIM/user_cmds/DBTSP
.set ulib none
.set ulib NSS-USER-COMMANDS|LAMIP|DBTSP|/netsim/netsimdir/$SIM/user_cmds/SYBUE
.set save
.set ulib none
.set ulib NSS-USER-COMMANDS|LAMIP|DBTSP|SYBUE
.set save
.start
MML
~/inst/netsim_shell < exceptions.mml
rm exceptions.mml
##############################################################
## Special Exceptions
##############################################################
## Setting DBTSP usercommands
if [ -e dbtsp.mml ]
then
   rm dbtsp.mml
fi
cat >> dbtsp.mml << MML
.open $SIM
.selectregexp simne $MSCNAME-.*|$MSCNAME
.stop
.set ulib /netsim/netsimdir/$SIM/user_cmds/DBTSP
.set save
.start
MML
~/inst/netsim_shell < dbtsp.mml
rm dbtsp.mml
## Setting special exceptions
if [[ $MSCNODEVERSION = *"MSC-DB"* ]] || [[ $MSCNODEVERSION = *"MSC-IP-STP"* ]] || [[ $MSCNODEVERSION = *"MSC-vIP-STP"* ]] || [[ $MSCNODEVERSION = *"MSCv"* ]]
then
   echo "**** It is MSC-DB-BSP simulation *****"
   if [ -e specialExceptions.mml ]
   then
      rm specialExceptions.mml
   fi
   cat >> specialExceptions.mml << MML
.open $SIM
.selectregexp simne $MSCNAME
.stop
.select show_logicalnew
.exception off
.select show3|show_logical_non_cluster|PrcState|PCORP_LAEIP|PCORP_LAEIP_CP1|PCORP_LAEIP_CP2|SwPackage1
.exception off
.select show3|show_logical_non_cluster|PrcState|PCORP_LAEIP|PCORP_LAEIP_CP1|PCORP_LAEIP_CP2|SwPackage1
.exception on
.save
.start -parallel
MML
   ~/inst/netsim_shell < specialExceptions.mml
   rm specialExceptions.mml
else
   if [ -e specialExceptions.mml ]
   then
      rm specialExceptions.mml
   fi
   cat >> specialExceptions.mml << MML
.open $SIM
.selectregexp simne $MSCNAME-.*|$MSCNAME
.stop
.select show_logical_non_cluster
.exception off
.select show3|show_logicalnew|PrcState|PCORP_LAEIP|PCORP_LAEIP_CP1|PCORP_LAEIP_CP2|SwPackage1
.exception off
.select show3|show_logicalnew|PrcState|PCORP_LAEIP|PCORP_LAEIP_CP1|PCORP_LAEIP_CP2|SwPackage1
.exception on
.save
.start -parallel
MML
   ~/inst/netsim_shell < specialExceptions.mml
   rm specialExceptions.mml
fi
