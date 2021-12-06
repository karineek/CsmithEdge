#!/bin/bash

##### Keep all the safe ops we need
function keep_required_safe {
	testcaseModify=$folder/'__'$1'M.c'
	testcaseRes=$2
	while read -r line; do
		data="$line"

		# Get locations:
		temp=${#data}
		size=$((temp - 44 -1)) 
		var="${data:44:$size}"
	 
		isFirst=1
		locF=0
		funcF=0
		locations=$(echo $var | tr "," " \n")
		for loc in $locations
		do
		    if (($isFirst==1))
		    	then
		  		isFirst=0
				funcF=$loc
			else
				locF=$loc
		    fi
		done

		#Replace the rest of the calls to unsafe macros
		keyword_raw='/* ___REMOVE_SAFE__OP *//*'$locF'*//* ___SAFE__OP */('
		keyword_regexp="$(printf '%s' "$keyword_raw" | sed -e 's/[]\/$*.^|[]/\\&/g')"

		replacement_raw='('
		replacement_regexp="$(printf '%s' "$replacement_raw" | sed -e 's/[\/&]/\\&/g')"
		sed -i "s/$keyword_regexp/$replacement_regexp/g" $testcaseModify
	done < "$testcaseRes"
}

#### Remove safe calls when not required
function replace2unsafe {
	testcaseModify=$folder/'__'$1'M.c'

	#Replace the rest of the calls to unsafe macros
	keyword_raw='/* ___REMOVE_SAFE__OP */'
	keyword_regexp="$(printf '%s' "$keyword_raw" | sed -e 's/[]\/$*.^|[]/\\&/g')"

	replacement_raw='_unsafe_macro'
	replacement_regexp="$(printf '%s' "$replacement_raw" | sed -e 's/[\/&]/\\&/g')"
	sed -i "s/$keyword_regexp/$replacement_regexp/g" $testcaseModify
}

#################################### Modify TEST ####################################
function modify_test {
	## Single test - create a test case and its precompilation
	testcaseName='test'$1
	testcaseModify=$folder/'__'$testcaseName'M.c'
	original_testcase=$2
	testcaseRes=$3
	# Modify the test (the preprocessed file) 	
	cp $original_testcase $testcaseModify 
	# Keep ops required to be safe
	keep_required_safe $testcaseName $testcaseRes
	#Replace the rest of the calls to unsafe macros
	replace2unsafe $testcaseName
}

################### MAIN ###############################
# Basic parameters
seed=$1	# File with all the seeds to use
testfile=$2	# original testcase
testcaseRes=$3	# Relax safe math relaxation analysis results

# folders for all the results
folder=`pwd`
if [ ! -f $testcaseRes ]; then
	echo " >> Cannot find testcase list <$testcaseRes>"; exit
fi
modify_test "$seed" $testfile $testcaseRes # Run a single test
# Done
