#!/bin/sh
##########################################################################################################################
# Created by  : Mitali Sinha
# Created on  : 20.12.2018
# Purpose     : Checks the number of Blades on GSM Simulations.
###########################################################################################################################

PWD=`pwd`
SimName=$1
echo "-----SimName=$SimName-------"
echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SimName' \n .show simnes' | /netsim/inst/netsim_shell | grep -v \">>\" | grep -v \"OK\" | grep -v \"NE\"" > NodeData.txt
line=$(head -n 1 $PWD/NodeData.txt)
Node=`echo $line | awk '{print $1}'`
echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SimName' \n .select '$Node' \n aploc \n cpls' | /netsim/inst/netsim_shell" > CPid.txt
echo "Node is $Node"
grep . CPid.txt > file.txt
Startline=`cat file.txt |grep -n "CPID CPNAME ALIAS   APZSYS   CPTYPE" | cut -f1 -d:`
Lastline=`wc -l < file.txt`
TotalBlade=`expr "$Lastline" - "$Startline"`
echo "TotalBlade=$TotalBlade"
if [ $TotalBlade -eq 18 ]
then
    echo "PASSED : Total Blades is $TotalBlade "
else
    echo "FAILED : Total Blades is not 18 its $TotalBlade"
fi
