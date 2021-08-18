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
		done

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
compiler=$1		# Compiler to test
seed=$2			# File with all the seeds to use
testcaselogger=$3	# The logger file for the results
wda_folder=$4		# Folder with Results.txt files
modify=$5		# Do we run on modified or original tests
csmith_location=$6	# Csmith location
csmith_flags=$7		# Csmith options
compile_line=$8		# Includes + Duse
compilerflags=$9	# compiler flags

# Single iteration, requires a compiler and a seed
CSMITH_USER_OPTIONS=$csmith_flags

# Check if second parameter is a number
re='^[0-9]+$'
if ! [[ $seed =~ $re ]] ; then
	echo ">> error: Not a number" >&2; exit 1
fi
# folders for all the results
folder=$compiler-mainRes
testcaseRes=$wda_folder/'__test'$seed'Results'
if [ ! -f $testcaseRes ] &&  [[ "$modify" == "1" ]] ; then
	coverage_test_only "$seed" # Just measure coverage if cannot run the program
else
	modify_test "$seed" # Run a single test
fi
