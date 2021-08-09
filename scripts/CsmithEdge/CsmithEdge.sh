#!/bin/bash
function clean_itr {
	xFolder=$1
	rm -f $xFolder/ASANres1.txt $xFolder/ASANres2.txt 
	rm -f $xFolder/MSANres1.txt $xFolder/MSANres2.txt 
	rm -f $xFolder/UBSANres1.txt $xFolder/UBSANres2.txt 
	rm -f $xFolder/Plain1.txt $xFolder/Plain2.txt 
	
	rm -f $xFolder/probs_WeakenSafeAnalyse.txt
	rm -f $xFolder/platform.info
	rm -f $annotated_testcase
}

function exit_error {
	xFolder=$1
	loc=$2
	echo " >> (ERROR) Testcase creation failed. <loc=$loc>"
	touch $fileinvalid
	clean_itr $xFolder
	exit -1
}

###################################################################################
base=$1	# Project main folder
logger=$2	# logger file 
seed=$3	# seed

## Compilers, B is only used for lazy
testedCompilerA=$4
testedCompilerB=$5

## Lazy or regular?
lazy=$6	# lazy=1

scripts_folder=$base/scripts/CsmithEdge
tool_location=$base/csmith


# Check if the first parameter is a compiler exist in the machine
var=`dpkg --list | grep -c "$testedCompilerA"`
if (($var < 1)) ; then
	echo "error: no such a compiler" >&2; exit 1
fi	

#### Test we have Frama-c, and not the system default ####
eval $(opam config env) ## Just to assure it gets it from the right place
testIT=`frama-c --version`
if [ "$testIT" == "Phosphorus-20170501" ]; then
	echo ">> Frama-C version is too old. Please install version 20.0.0 or up."
	exit
fi
if [[ "$testIT" == "" ]]; then
	echo ">> Please install Frama-C version 20.0.0 or up."
	exit
fi

## Create folders if not exists
seedsProbs=$scripts_folder/seedsProbs
DA_folder=$seedsProbs/seedsSafeLists
temp_folder=$seedsProbs/tmp
mkdir -p $DA_folder $temp_folder

## Possible output files
confgFile=$seedsProbs/'probs_WeakenSafeAnalyse_test.txt'$seed
fileinvalid=$DA_folder/'__test'$seed'INVALID'
safelist=$DA_folder/'__test'$seed'Results'
annotated_testcase=$temp_folder/'__test_annotated'$seed'.c'
modified_testcase=$temp_folder/'__test'$seed'M.c'

## Clean old files
rm -f $confgFile $fileinvalid $safelist $modified_testcase $logger

# Clean before start
clean_itr "$scripts_folder"


## Generate WA test-case:
if [[ "$lazy" == "0" ]] ; then
	(ulimit -St 9999; ./WA1_gen_test.sh $seed $base "$temp_folder" "$logger" "$logger" $testedCompilerA) >> "$logger" 2>&1
else
	(ulimit -St 9999; ./WA1_gen_test_lazy.sh $seed $base "$temp_folder" "$logger" "$logger" $testedCompilerA $testedCompilerB) >> "$logger" 2>&1
fi

fileinvalid=$DA_folder/'__test'$seed'INVALID'
if [ -f "$fileinvalid" ] || [ ! -f "$confgFile" ] ; then
	exit_error "$scripts_folder" 1
fi
cat "$confgFile" | grep . > test.tmp; cp -f test.tmp "$confgFile"; rm -f test.tmp ## Delete space lines
sizeConfg=`cat "$confgFile" | wc -l` ## test all is ok now, need 10 lines
if [[ "$sizeConfg" -eq "0" ]] || [[ ! "$sizeConfg" -eq "10" ]]; then ## Bad seed
	exit_error "$scripts_folder" 2
fi

## Apply RRS on it (generate a list of must-be-safe locations)		
(ulimit -St 9999; ./DA2_math_unsafe_list.sh $testedCompilerA $seed $base "$annotated_testcase" "$safelist" "$confgFile") >> "$logger" 2>&1
if [ ! -f "$safelist" ] ; then
	exit_error "$scripts_folder" 3
fi

## Generate modified testcase
(ulimit -St 9999; ./3-constructModifyTests.sh "$seed" "$annotated_testcase" "$safelist" "$confgFile" "$temp_folder") >> "$logger" 2>&1
if [ ! -f "$confgFile" ] || [ ! -f "$annotated_testcase" ] || [ ! -f "$modified_testcase" ] || [ ! -f "$safelist" ] ; then
	exit_error "$scripts_folder" 4
fi

# cleaning
clean_itr "$scripts_folder"
# Exit
echo " >> Write test case to $modified_testcase"
exit 0
