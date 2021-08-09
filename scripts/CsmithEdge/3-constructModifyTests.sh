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
		#Check if it is a macro or a function
		if [ $headerMode -eq 2 ] && [[ " ${invocationsMacrosMix[@]} " =~ " ${locF} " ]]; then 
			## in mix mode, arr contains the value locF
			replacement_raw='_mixM('
		fi
		replacement_regexp="$(printf '%s' "$replacement_raw" | sed -e 's/[\/&]/\\&/g')"
		sed -i "s/$keyword_regexp/$replacement_regexp/g" $testcaseModify
	done < "$filename"
}

#### Remove safe calls when not required (when $headerMode -eq 2)
function replace2unsafeMix {
	testcaseName=$1
	testcaseModify=$folder/'__'$testcaseName'M.c'

	for locF in "${invocationsMacrosMix[@]}"; do
		#Replace the rest of the calls to unsafe macros
		keyword_raw='/* ___REMOVE_SAFE__OP *//*'$locF'*/'
		keyword_regexp="$(printf '%s' "$keyword_raw" | sed -e 's/[]\/$*.^|[]/\\&/g')"

		replacement_raw='_unsafe_macro_mixM/*'$locF'*/'
		replacement_regexp="$(printf '%s' "$replacement_raw" | sed -e 's/[\/&]/\\&/g')"
		sed -i "s/$keyword_regexp/$replacement_regexp/g" $testcaseModify
	done
}
function replace2unsafe {
	testcaseName=$1
	testcaseModify=$folder/'__'$testcaseName'M.c'

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
	testcaseName='test'$1	# testcase name
	testcase=$2				# annotated testcase
	safelist=$3				# must stay safe list
	testcaseModify=$folder/'__'$testcaseName'M.c' # new testcase with RRS too

	# Modify the test (the preprocessed file)
	cp "$testcase" "$testcaseModify"
	# Keep ops required to be safe as a macros or functions
	keep_required_safe $testcaseName 	## Uses: invocationsMacrosMix and testcaseRes
	# Replace the rest of the calls in mix mode to unsafe macros according to invocationsMacrosMix 
	if [ $headerMode -eq 2 ] && [ ${#invocationsMacrosMix[@]} -gt 0 ]; then
		replace2unsafeMix $testcaseName		## Uses: invocationsMacrosMix
	fi
	# Replace the rest of the calls to unsafe macros or functions
	replace2unsafe $testcaseName
}

#################################### PREPARE GEN TEST ####################################
function update_csmith_cmd_options {
	confg=$1

	## Arrays to choose which one to set to functions or macros if mix
	lastline=`tail -1 $confg`
	IFS=' ' read -r -a invocationsMacrosMix <<< "$lastline"

	## Check which version of headers we shall take
	res1=`grep "USE_MATH_MACROS" $confg | wc -l`
	if [[ "$res1" == "1" ]]; then 
		headerMode=1
	else
		res2=`grep "USE_MATH_MIX" $confg | wc -l`
		if [[ "$res2" == "1" ]]; then 
			headerMode=2
		fi
	fi
}

################### MAIN ###############################
# Single iteration, requires a compiler and a seed
# Basic parameters
seed=$1		# File with all the seeds to use
annotated_testcase=$2	# Testcase
testcaseRes=$3		# Safelist
testcaseConfgFile=$4	# name of config file
folder=$5		# output folder

# Check if second parameter is a number
re='^[0-9]+$'
if ! [[ $seed =~ $re ]] ; then
	echo ">> error: Not a number <$seed>." >&2; exit 1
fi
# check there is a safelist of calls
if [ ! -f $testcaseRes ]; then
	echo ">> error: No safelist file <$testcaseRes>." >&2; exit 1
fi
# Check the configuration file exist
if ! test -f "$testcaseConfgFile" ; then
	echo ">> error: No configuration file found for this seed $seed. Missing <$testcaseConfgFile>." >&2; exit 1
fi

## Build testcase
invocationsMacrosMix=()	## Invocation to set as function wrapper
headerMode=0			## Assume function version

# Get configuration data: Update $CSMITH_USER_OPTIONS
update_csmith_cmd_options "$testcaseConfgFile"

# Run a single test
modify_test "$seed" "$annotated_testcase"
## END ##
