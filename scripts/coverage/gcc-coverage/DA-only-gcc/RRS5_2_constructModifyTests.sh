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
function modify_test {
	## Single test - create a test case and its precompilation
	testcaseName='test'$1
	testcaseModify=$folder/'__'$testcaseName'M.c'
	testcaseEXEC='__'$testcaseName'Exec'

	# Modify the test (the preprocessed file)
	ulimit -St 500; $csmith_location/build/src/csmith --seed $seed $CSMITH_USER_OPTIONS > $testcaseModify  
	if [[ "$modify" == "1" ]]
		then	
		# Keep ops required to be safe
		keep_required_safe $testcaseName
		#Replace the rest of the calls to unsafe macros
		replace2unsafe $testcaseName
 	fi
	
	# Compile and test modify program: (with input compiler flags or with defualts)
	ulimit -St 500;$compiler $compile_line ${compilerflags} $testcaseModify -o $testcaseEXEC
	
	# Test exec	
	filesize=`stat --printf="%s" $testcaseModify`
	ulimit -St 500;./$testcaseEXEC >> $testcaselogger
	echo "seed= $seed, size= $filesize" >> $testcaselogger
	echo "---" >> $testcaselogger
	
	#clean
	rm $testcaseModify
	rm $testcaseEXEC
}

### If it is a bad testcase, no need to run it, just build it for coverage measure.
function coverage_test_only {
	## Single test - create a test case and its precompilation
	testcaseName='test'$1
	testcaseOriginal=$folder/'__'$testcaseName'O.c'
	testcaseEXEC='__'$testcaseName'Exec'

	# Modify the test (the preprocessed file)
	ulimit -St 500; $csmith_location/build/src/csmith --seed $seed $CSMITH_USER_OPTIONS > $testcaseOriginal
	
	# Compile and test modify program: (with input compiler flags or with defualts)
	ulimit -St 500;$compiler $compile_line ${compilerflags} $testcaseOriginal -o $testcaseEXEC
	
	# Test exec	
	filesize=`stat --printf="%s" $testcaseOriginal`
	echo "Skip execution. Bad testcase." >> $testcaselogger
	echo "seed= $seed, size= $filesize" >> $testcaselogger
	echo "---" >> $testcaselogger
	
	#clean
	rm $testcaseOriginal
	rm $testcaseEXEC
}

################### MAIN ###############################
# Basic parameters
compiler=$1			# Compiler to test
process=$2			# To create temp storage for exec
seed=$3		  	# File with all the seeds to use
testcaselogger=$4 		# The logger file for the results
cov=$5				# To test for cov=1, else =0
modify=$6			# Do we run on modified or original tests
csmith_location=$7		# Csmith location
csmith_flags=$8		# Csmith options
compile_line=$9		# Includes + Duse
compilerflags=${10}		# compiler flags

# Single iteration, requires a compiler and a seed
#CSMITH_USER_OPTIONS=" --bitfields --packed-struct"
CSMITH_USER_OPTIONS=$csmith_flags

## For debug only
#echo "Compiler=$compiler"
#echo "process=$process"
#echo "seed=$seed"
#echo "testcaselogger=$testcaselogger"
#echo "csmith_location=$csmith_location"
#echo "csmith_flags=$csmith_flags"
#echo "compile_line=$compile_line"
#echo "compilerflags=$compilerflags"
# Check if second parameter is a number
re='^[0-9]+$'
if ! [[ $seed =~ $re ]] ; then
	echo ">> error: Not a number" >&2; exit 1
fi

# folders for all the results
folder=$compiler-mainRes
testcaseRes='../RSS-v2-general/seedsSafeLists_small'/'__test'$seed'Results'
if [ ! -f $testcaseRes ]
	then
	#echo "Seed's list is missing: $testcaseRes"
	## Only generate and compile test case to measure coverage
	if [[ "$cov" == "1" ]]
		then
		coverage_test_only "$seed"
	fi
else 
	modify_test "$seed" # Run a single test
fi
