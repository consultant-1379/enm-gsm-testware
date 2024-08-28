#!/bin/sh

#Version History
###################################################################################################
#Version1       : 20.07
#Created by     : Yamuna Kanchireddygari
#Created on     : 03rd Apr 2020
#Revision       : CXP 903 6542-1-4
#Purpose        : checking fileLocation Attribute on PmMeasurementCapabilities MO
#Jira Details   : NNS-27983
###################################################################################################

rm MSCNodeData1.txt MSCNodeData.txt BSCNodeData1.txt BSCNodeData.txt DG2NodeData1.txt DG2NodeData.txt

SIM=$1
Path=`pwd`

if [[ $SIM =~ "GSM" ]]
then
    BSCFileLocation="/apfs/cdh/cdhdefault/Ready"
    DG2FileLocation="/c/pm_data/"
    MSCFileLocation="/data_transfer/destinations/CDHDEFAULT/Ready"

    DG2outputDirectory="/c/pm_data/"
else
    echo "*********************************************" >> Result.txt
    echo "There is no fileLocation/Outputdirectory unit test for this simulation $SIM" >> Result.txt
    echo "*********************************************" >> Result.txt
	cat Result.txt
    exit
fi

echo "BSCFileLocation = $BSCFileLocation" >> Result.txt
echo "MSCFileLocation = $MSCFileLocation" >> Result.txt
echo "DG2FileLocation = $DG2FileLocation" >> Result.txt
echo "DG2outputDirectory = $DG2outputDirectory" >> Result.txt

echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SIM' \n .show simnes' | /netsim/inst/netsim_shell | grep -v \">>\" | grep -v \"OK\" | grep -v \"NE\" | grep \" MSC\"" > MSCNodeData.txt
echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SIM' \n .show simnes' | /netsim/inst/netsim_shell | grep -v \">>\" | grep -v \"OK\" | grep -v \"NE\" | grep \" BSC\"" > BSCNodeData.txt
echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SIM' \n .show simnes' | /netsim/inst/netsim_shell | grep -v \">>\" | grep -v \"OK\" | grep -v \"NE\" | grep \"MSRBS-V2\"" > DG2NodeData.txt

cat MSCNodeData.txt | awk '{print $1}' > MSCNodeData1.txt
IFS=$'\n' read -d '' -r -a MSCnode < MSCNodeData1.txt
Length=${#MSCnode[@]}

cat BSCNodeData.txt | awk '{print $1}' > BSCNodeData1.txt
IFS=$'\n' read -d '' -r -a BSCnode < BSCNodeData1.txt
Length=${#BSCnode[@]}

cat DG2NodeData.txt | awk '{print $1}' > DG2NodeData1.txt
IFS=$'\n' read -d '' -r -a DG2node < DG2NodeData1.txt
Length=${#DG2node[@]}

for i in "${MSCnode[@]}"
do
    id=`echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SIM' \n .select $i \n .start \n e X=csmo:ldn_to_mo_id(null,[\"ComTop:ManagedElement=$i\",\"ComTop:SystemFunctions=1\",\"CmwPm:Pm=1\"]).' | /netsim/inst/netsim_shell | tail -2"`

    MSCFileLocationId=`echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SIM' \n .select $i \n e Value=csmo:get_children_by_type(null,$id,\"CmwPm:PmMeasurementCapabilities\"). \n e [Y]=Value. \n e csmo:get_attribute_value(null,Y,fileLocation).' | /netsim/inst/netsim_shell | tail -2 | tr -d '\"'"`
	
    if [[ $MSCFileLocationId == $MSCFileLocation ]]
    then
         echo "Info: PASSED on $i fileLocation is $MSCFileLocationId" >> Result.txt
    else
         echo "Info: FAILED on $i fileLoaction is $MSCFileLocationId but it should be $MSCFileLocation" >> Result.txt
    fi
done

for j in "${BSCnode[@]}"
do
    id1=`echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SIM' \n .select $j \n .start \n e X=csmo:ldn_to_mo_id(null,[\"ComTop:ManagedElement=$j\",\"ComTop:SystemFunctions=1\",\"CmwPm:Pm=1\"]).' | /netsim/inst/netsim_shell | tail -1"`

    BSCFileLocationId=`echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SIM' \n .select $j \n e Value=csmo:get_children_by_type(null,$id1,\"CmwPm:PmMeasurementCapabilities\"). \n e [Y]=Value. \n e csmo:get_attribute_value(null,Y,fileLocation).' | /netsim/inst/netsim_shell | tail -1 | tr -d '\"'"`

    if [[ $BSCFileLocationId == $BSCFileLocation ]]
    then
         echo "Info: PASSED on $j fileLocation is $BSCFileLocationId" >> Result.txt
    else
         echo "Info: FAILED on $j fileLoaction is $BSCFileLocationId but it should be $BSCFileLocation" >> Result.txt
    fi
done

for k in "${DG2node[@]}"
do
    id2=`echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SIM' \n .select $k \n .start \n e X=csmo:ldn_to_mo_id(null,[\"ComTop:ManagedElement=$k\",\"ComTop:SystemFunctions=1\",\"RcsPm:Pm=1\"]).' | /netsim/inst/netsim_shell | tail -1"`

    DG2FileLocationId=`echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SIM' \n .select $k \n e Value=csmo:get_children_by_type(null,$id2,\"RcsPm:PmMeasurementCapabilities\"). \n e [Y]=Value. \n e csmo:get_attribute_value(null,Y,fileLocation).' | /netsim/inst/netsim_shell | tail -1 | tr -d '\"'"`
	
    id3=`echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SIM' \n .select $k \n .start \n e X=csmo:ldn_to_mo_id(null,[\"ComTop:ManagedElement=$k\",\"ComTop:SystemFunctions=1\",\"RcsPMEventM:PmEventM=1\",\"RcsPMEventM:EventProducer=Lrat\"]).' | /netsim/inst/netsim_shell | tail -1"`
	
    DG2outputDirectoryId=`echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SIM' \n .select $k \n e Value=csmo:get_children_by_type(null,$id3,\"RcsPMEventM:FilePullCapabilities\"). \n e [Y]=Value. \n e csmo:get_attribute_value(null,Y,outputDirectory).' | /netsim/inst/netsim_shell | tail -1 | tr -d '\"'"`
	
    if [[ $DG2FileLocationId == $DG2FileLocation ]]
    then
         echo "Info: PASSED on $k fileLocation is $DG2FileLocationId" >> Result.txt
    else
         echo "Info: FAILED on $k fileLoaction is $DG2FileLocationId but it should be $DG2FileLocation" >> Result.txt
    fi
    if [[ $DG2outputDirectoryId == $DG2outputDirectory ]]
    then
         echo "Info: PASSED on $k outputDirectory is $DG2outputDirectoryId" >> Result.txt
    else
         echo "Info: FAILED on $k outputDirectory is $DG2outputDirectoryId but it should be $DG2outputDirectory" >> Result.txt
    fi
done

cat Result.txt

if  grep -q FAILED "Result.txt"
then
    echo "******INFO: There are some Failures********"
    exit 903
else
    echo "****** PASSED PMfileLocation/ouputDirectory on $SIM **********"
fi
