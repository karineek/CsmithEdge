#!/bin/bash

##### Keep all the safe ops we need
function keep_required_safe {
	testcaseName=$1
	testcaseModify=$folder/'__'$testcaseName'M.c'
	filename="$testcaseRes"
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
			#echo "[$loc]"
		done
		#echo "location is: [$locF]"
		#echo "Function number is: [$funcF]"

        #Replace the rest of the calls to unsafe macros
		keyword_raw='/* ___REMOVE_SAFE__OP *//*'$locF'*//* ___SAFE__OP */('
		keyword_regexp="$(printf '%s' "$keyword_raw" | sed -e 's/[]\/$*.^|[]/\\&/g')"

		replacement_raw='('
		replacement_regexp="$(printf '%s' "$replacement_raw" | sed -e 's/[\/&]/\\&/g')"
		sed -i "s/$keyword_regexp/$replacement_regexp/g" $testcaseModify
	done < "$filename"
}

#### Remove safe calls when not required
function replace2unsafe {
	testcaseName=$1
	
	testcaseModify=$folder/'__'$testcaseName'M.c'

	#Replace the rest of the calls to unsafe macros
	keyword_raw='/* ___REMOVE_SAFE__OP */'
	keyword_regexp="$(printf '%s' "$keyword_raw" | sed -e 's/[]\/$*.^|[]/\\&/g')"

	replacement_raw='_unsafe_macro'
	replacement_regexp="$(printf '%s' "$replacement_raw" | sed -e 's/[\/&]/\\&/g')"
	sed -i "s/$keyword_regexp/$replacement_regexp/g" $testcaseModify


	#Add missing header unsafe macros
	#echo "#include \"unsafe_math_macros.h\""|cat - $testcaseModify > /tmp/out && mv /tmp/out $testcaseModify
	#keyword_raw='#include "csmith.h"'
	#keyword_regexp="$(printf '%s' "$keyword_raw" | sed -e 's/[]\/$*.^|[]/\\&/g')"

	#replacement_raw='#include "unsafe_math_macros_eCast.h"'
	#replacement_regexp="$(printf '%s' "$replacement_raw" | sed -e 's/[\/&]/\\&/g')"
	#sed -i "s/$keyword_regexp/$replacement_regexp/g" $testcaseModify
}

#################################### Modify TEST ####################################
function gen_pair_test {
	## Single test - create a test case and its precompilation
	testcaseName='test'$1
	testcaseModify=$folder/'__'$testcaseName'M.c'
	testcaseEXEC='__'$testcaseName'Exec'

	# Modify the test (the preprocessed file)
	ulimit -St 500;./$csmith_location/src/csmith --seed $seed $CSMITH_USER_OPTIONS > $testcaseModify 
	cp $testcaseModify $folder/csmith/'__'$testcaseName'.c'

	if [[ -f "$testcaseRes" ]]
		then	
		# Keep ops required to be safe
		keep_required_safe $testcaseName
		#Replace the rest of the calls to unsafe macros
		replace2unsafe $testcaseName
	else
		echo ">> info skip modify for seed $1 ($testcaseRes)"
 	fi
	cp $testcaseModify $folder/modify/'__'$testcaseName'M.c'

	filesize=`stat --printf="%s" $testcaseModify`
	
	#clean
	rm $testcaseModify
}

################### MAIN ###############################
# Basic parameters
compiler=$1			# Compiler to test
seed=$2				# File with all the seeds to use
csmith_location=$3		# Csmith location
csmith_flags=$4			# Csmith options
testcaseRes='/home/user42/git/MinCond/scripts/RSS-v2-general/seedsSafeLists'/'__test'$seed'Results'

# Single iteration, requires a compiler and a seed
#CSMITH_USER_OPTIONS=" --bitfields --packed-struct"
CSMITH_USER_OPTIONS=$csmith_flags

re='^[0-9]+$'
if ! [[ $seed =~ $re ]] ; then
	echo ">> error: Not a number" >&2; exit 1
fi

# folders for all the results
folder=$compiler-mainRes
gen_pair_test "$seed" # Run a single test

