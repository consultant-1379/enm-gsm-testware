#!/bin/sh
SIMLIST=`ls ~/netsimdir | grep GSM | grep -v zip`
SIMS=(${SIMLIST// / })
for SIMNAME in ${SIMS[@]}
do
BSCNODELIST=`echo -e '.open '$SIMNAME'\n.show simnes' | ~/inst/netsim_shell | grep "LTE BSC" | cut -d" " -f1`
BSCNODES=(${BSCNODELIST// / })
for BSCNODE in ${BSCNODES[@]}
do
  swItemId=`echo -e '.open '$SIMNAME'\n.select '$BSCNODE'\ne: ecim_csmo:ldn_string_to_mo_id(null,"ManagedElement='$BSCNODE',SystemFunctions=1,SwInventory=1,SwVersion=1").' | ~/inst/netsim_shell | tail -n+6`
  productNumber=`echo -e '.open '$SIMNAME'\n.select '$BSCNODE'\ne: csmodb:get_mo_attribute_by_id(null, '$swItemId', administrativeData).' | ~/inst/netsim_shell | tail -n+6 | grep -i "productnumber" | awk -F"productnumber," '{print $2}' | awk -F"}" '{print $1}'`
  productRevision=`echo -e '.open '$SIMNAME'\n.select '$BSCNODE'\ne: csmodb:get_mo_attribute_by_id(null, '$swItemId', administrativeData).' | ~/inst/netsim_shell | tail -n+6 | grep -i "productrevision" | awk -F"productrevision," '{print $2}' | awk -F"}" '{print $1}'`
  if [ $productNumber == "" ] || [ productRevision == "" ]
  then
     productNumber="NO_VALUE"
     productRevision="NO_VALUE"
  fi
  echo "$SIMNAME,$BSCNODE,$productNumber,$productRevision" >> UnitTest.log
done
DG2NODELIST=`echo -e '.open '$SIMNAME'\n.show simnes' | ~/inst/netsim_shell | grep "LTE MSRBS-V2" | cut -d" " -f1`
DG2NODES=(${DG2NODELIST// / })
for DG2NODE in ${DG2NODES[@]}
do
  swItemId=`echo -e '.open '$SIMNAME'\n.select '$DG2NODE'\ne: ecim_csmo:ldn_string_to_mo_id(null,"ManagedElement='$DG2NODE',SystemFunctions=1,SwInventory=1,SwVersion=1").' | ~/inst/netsim_shell | tail -n+6`
  productNumber=`echo -e '.open '$SIMNAME'\n.select '$DG2NODE'\ne: csmodb:get_mo_attribute_by_id(null, '$swItemId', administrativeData).' | ~/inst/netsim_shell | tail -n+6 | grep -i "productnumber" | awk -F"productnumber," '{print $2}' | awk -F"}" '{print $1}'`
  productRevision=`echo -e '.open '$SIMNAME'\n.select '$DG2NODE'\ne: csmodb:get_mo_attribute_by_id(null, '$swItemId', administrativeData).' | ~/inst/netsim_shell | tail -n+6 | grep -i "productrevision" | awk -F"productrevision," '{print $2}' | awk -F"}" '{print $1}'`
  if [ $productNumber == "" ] || [ productRevision == "" ]
  then
     productNumber="NO_VALUE"
     productRevision="NO_VALUE"
  fi
  echo "$SIMNAME,$DG2NODE,$productNumber,$productRevision" >> UnitTest.log
done
done
checkproductData=`cat UnitTest.log | grep "NO_VALUE"`
if [ $checkproductData == "" ]
then
   echo "All the nodes have productData...."
else
   echo "####ERROR:Below nodes failed with empty Data ######"
   cat UnitTest.log | grep "NO_VALUE"
fi
