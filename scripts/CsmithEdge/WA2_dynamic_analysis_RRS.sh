#!/bin/bash
compiler=$1		# Compiler to test
seed=$2		# File with all the seeds to use - shall be only good seeds here!
base=$3		# Base folder
testcasesF=$4		# where all testcases are
testcaseNameWA=$5	# Annotated testcase
testcaseNameRes=$6	# safelist
testcaseConfg=$7	# Config file

confDif=$base/scripts/CsmithEdge/seedsProbs		# A folder with all config files to create WA test-case
wa_probs=$confDif/probs_WeakenSafeAnalyse_test.txt	# Base name of config file
rrs_folder=$confDif/seedsSafeLists			# A folder to find all these seeds' safe lists
csmith_exec_wa=$base/csmith/build/src/csmith		# csmith exec
csmith_location_wa=$base/csmith			# csmith location
folder=$compiler-mainRes

# Check if second parameter is a real file
if test -f "$testcaseNameRes" ; then
	# skip, we already did it
	echo ">> List already exists. Skip $testcaseNameWA." 
else
	./RSS3_2_genUnsafeInfo4Tests.sh "$compiler" "$seed" "$testcaseNameWA" "$rrs_folder" "$testcaseConfg" "$csmith_location_wa"
fi	


