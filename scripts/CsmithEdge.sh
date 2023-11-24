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
	if [[ $debug -eq 1 ]]; then
		cat $logger
	fi
	exit -1
}

###################################################################################
base=$1    # Project main folder
logger=$2  # logger file
seed=$3    # seed

## Compilers, B is only used for lazy
testedCompilerA=$4
testedCompilerB=$5

## Lazy or regular?
lazy=$6	# lazy=1, csmith=9 (but will add unsafe math part/DWA)

## Print Debug information
debug=$7

scripts_folder=$base/scripts/CsmithEdge
tool_location=$base/csmith

cd $scripts_folder

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
modified_WSA_testcase=$temp_folder/'__test'$seed'M_WSA.c'
modified_testcase=$temp_folder/'__test'$seed'M.c'

## Clean old files
rm -f $confgFile $fileinvalid $safelist $modified_testcase $logger

# Clean before start
clean_itr "$scripts_folder"

## Generate WA test-case:
if [[ "$lazy" == "9" ]] ; then
	## Debug information
	if [[ $debug -eq 1 ]]; then
		echo ">> Relax arithmetic mode (only)."
	fi

	## No WSA -> will only add WDA (RRS) part
	touch $logger
	genrator=$base/csmith/build/src/csmith
	CSMITH_USER_OPTIONS=" --bitfields --packed-struct --annotated-arith-wrappers"
	cp $seedsProbs/probs_OrigSafeAnalyse_test.txt $confgFile
	ulimit -St 150; $genrator $CSMITH_USER_OPTIONS --seed $seed > $annotated_testcase
elif [[ "$lazy" == "1" ]] ; then
        ## Debug information
        if [[ $debug -eq 1 ]]; then
                echo ">> CsmitheEdge Lazy mode."
        fi

	## Lazy WSA CsmithEdge
	(ulimit -St 9999; ./WA1_gen_test_lazy.sh $seed $base "$temp_folder" "$logger" "$logger" $testedCompilerA $testedCompilerB) >> "$logger" 2>&1
else
        ## Debug information
        if [[ $debug -eq 1 ]]; then
                echo ">> CsmithEdge regular mode."
        fi

	## Regular WSA CsmithEdge
	(ulimit -St 9999; ./WA1_gen_test.sh $seed $base "$temp_folder" "$logger" "$logger" $testedCompilerA) >> "$logger" 2>&1
fi

fileinvalid=$DA_folder/'__test'$seed'INVALID'
if [ -f "$fileinvalid" ] || [ ! -f "$confgFile" ] ; then
	exit_error "$scripts_folder" 1
fi
cat "$confgFile" | grep . > test.tmp; cp -f test.tmp "$confgFile"; rm -f test.tmp ## Delete space lines
sizeConfg=`cat "$confgFile" | wc -l` ## test all is ok now, need 10 lines
if [[ "$sizeConfg" -eq "0" ]] || [[ ! "$sizeConfg" -eq "10" ]]; then ## Bad seed
        ## Debug information
        if [[ $debug -eq 1 ]]; then
                echo ">> Bad Seed. Exit."
        fi
	echo "sizeConfg=$sizeConfg"
	exit_error "$scripts_folder" 2
fi

## Apply RRS on it (generate a list of must-be-safe locations)
(ulimit -St 9999; ./DA2_math_unsafe_list.sh $testedCompilerA $seed $base "$annotated_testcase" "$safelist" "$confgFile") >> "$logger" 2>&1
if [ ! -f "$safelist" ] ; then
        ## Debug information
        if [[ $debug -eq 1 ]]; then
                echo ">> Bad Seed. Error during generation of unsafe math list. Exit."
        fi
	exit_error "$scripts_folder" 3
fi

## Generate modified testcase
(ulimit -St 9999; ./3-constructModifyTests.sh "$seed" "$annotated_testcase" "$safelist" "$confgFile" "$temp_folder") >> "$logger" 2>&1
if [ ! -f "$confgFile" ] || [ ! -f "$annotated_testcase" ] || [ ! -f "$modified_testcase" ] || [ ! -f "$safelist" ] ; then
        ## Debug information
        if [[ $debug -eq 1 ]]; then
                echo ">> Bad Seed. Error during construction of the final modified relaxed test. Exit."
        fi
	exit_error "$scripts_folder" 4
fi

# Kepp data without WDA (only WSA part)
cp $annotated_testcase $modified_WSA_testcase

# cleaning
clean_itr "$scripts_folder"
# Exit
echo " >> OK. Write test case to $modified_testcase with configuration files <$confgFile,$safelist>."
exit 0
