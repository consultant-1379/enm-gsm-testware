#!/bin/sh
# Created by  : Harish Dunga
# Created in  : 07 04 2019
##
### VERSION HISTORY
###########################################
# Ver1        : Modified for ENM
# Purpose     : To validate CGI attributes on BSC nodes
# Description :
# Date        : 07 04 2019
# Who         : Harish Dunga
################## Parameters #################################
SIMNAME=$1
echo "###################################################################"
echo "# $0 script started Execution"
echo "-------------------------------------------------------------------"

if [ "$#" -ne 1 ]
then
 echo
 echo "Usage: $0 <sim name>"
 echo
 echo "Example: $0 RNCV71659x1-FT-RBSU4460x10-RNC01"
 echo
 echo "-------------------------------------------------------------------"
 echo "# Please give inputs correctly !!!!"
 echo "###################################################################"
 exit 1
fi
##########################################################################
# MAIN
##########################################################################
NODELIST=`echo -e '.open '$SIMNAME'\n.show simnes' | ~/inst/netsim_shell | grep "LTE BSC" | cut -d" " -f1`
NODES=(${NODELIST// / })

for NODE in ${NODES[@]}
do
var=`echo -e '.open '$SIMNAME'\n.select '$NODE'\ne csmo:get_mo_ids_by_type(null,"BscM:ExternalGeranCellM").' | ~/inst/netsim_shell | tail -n+6`
val=${var//\n/ }
value=`echo $val | tr -d ' '`
str=`echo $value | sed 's/[][]//g'`
molist=(${str//,/ })
cgiFlag="passed"
if [ -e /netsim/cgi_value.mo ]
then
   rm /netsim/cgi_value.mo
fi
echo -e '.open '$SIMNAME'\n.select '$NODE'\ndumpmotree:moid="'${molist[0]}'",ker_out,outputfile="/netsim/cgi_value.mo";' | ~/inst/netsim_shell > /dev/null
if [ -e "/netsim/cgi_value.mo" ]
then
    if [ -e checkCgi.txt ]
	then
	   rm checkCgi.txt
	fi
    cat  /netsim/cgi_value.mo | grep "cgi" | cut -d" " -f7 | sed 's/\"//g' >> checkCgi.txt
	while read -r line
	do
	   if [[ $line =~ ^[A-Za-z] ]];
       then
          echo -e '\033[1mFAILED: The CGI values are incorrect on the node '$NODE'\033[0m'
		  cgiFlag="failed"
		  break ;
       else
	      if [[ $line == "" ]]
		  then
		     echo -e '\033[1mFAILED: The CGI attribute is empty on the node '$NODE'\033[0m'
			 cgiFlag="failed"
		     break ;
		  fi
       fi

	done < checkCgi.txt
	if [[ $cgiFlag == "passed" ]]
	then
	   echo "PASSED: The CGI attribute has valid values on the node $NODE"
	fi
	
else
    echo -e '\033[1mFAILED: CGI value is not found on the node '$NODE'\033[0m'
fi
done


   
