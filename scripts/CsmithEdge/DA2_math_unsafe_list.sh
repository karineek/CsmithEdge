#!/bin/bash
compiler=$1		# Compiler to test
seed=$2		# File with all the seeds to use - shall be only good seeds here!
base=$3		# Base folder
testcaseNameWA=$4	# Annotated testcase
testcaseNameRes=$5	# safelist
testcaseConfg=$6	# Config file

confDif=$base/scripts/CsmithEdge/seedsProbs		# A folder with all config files to create WA test-case
wa_probs=$confDif/probs_WeakenSafeAnalyse_test.txt	# Base name of config file
rrs_folder=$confDif/seedsSafeLists			# A folder to find all these seeds' safe lists
tool_path=$base/csmith					# csmith location
tool_exec=$tool_path/build/src/csmith			# csmith exec

# Check if second parameter is a real file
if test -f "$testcaseNameRes" ; then
	# skip, we already did it
	echo ">> List already exists for seed <$seed>. Skipping generation of safe math lists."
	ls -l  $testcaseNameRes
else
	./DA2_1_gen_math_unsafe_list.sh "$compiler" "$seed" "$testcaseNameWA" "$rrs_folder" "$testcaseConfg" "$tool_path"
fi	


