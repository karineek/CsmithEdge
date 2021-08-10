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
		if [ $headerMode -eq 2 ] && [[ " ${inocationsMacrosMix[@]} " =~ " ${locF} " ]]; then 
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

	for locF in "${inocationsMacrosMix[@]}"; do
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
	testcaseName='test'$1
	testcaseModify=$folder/'__'$testcaseName'M.c'
	testcaseEXEC='__'$testcaseName'Exec'

	# Modify the test (the preprocessed file)
	ulimit -St 500;$csmith_exec --seed $seed $CSMITH_USER_OPTIONS > $testcaseModify  
	if [[ "$modify" == "1" ]]; then	
		# Keep ops required to be safe as a macros or functions
		keep_required_safe $testcaseName 	## Uses: inocationsMacrosMix
		# Replace the rest of the calls in mix mode to unsafe macros according to inocationsMacrosMix 
		if [ $headerMode -eq 2 ] && [ ${#inocationsMacrosMix[@]} -gt 0 ]; then
			replace2unsafeMix $testcaseName		## Uses: inocationsMacrosMix
		fi
		# Replace the rest of the calls to unsafe macros or functions
		replace2unsafe $testcaseName
 	fi
	
	# Compile and test modify program: (with input compiler flags or with defualts)
	#echo "ulimit -St 500;$compiler $compile_line $compile_line_confg ${compilerflags} $testcaseModify -o $testcaseEXEC"
	ulimit -St 500;$compiler $compile_line $compile_line_confg ${compilerflags} $testcaseModify -o $testcaseEXEC
	
	# Test exec	
	filesize=`stat --printf="%s" $testcaseModify`
	ulimit -St 500;./$testcaseEXEC >> $testcaselogger
	echo "seed= $seed, size= $filesize" >> $testcaselogger
	echo "---" >> $testcaselogger
	
	#clean
	##rm $testcaseModify
	rm $testcaseEXEC
}

### If it is a bad testcase, no need to run it, just build it for coverage measure.
function coverage_test_only {
	## Single test - create a test case and its precompilation
	testcaseName='test'$1
	testcaseOriginal=$folder/'__'$testcaseName'O.c'
	testcaseEXEC='__'$testcaseName'Exec'

	# Modify the test (the preprocessed file)
	ulimit -St 500;$csmith_exec --seed $seed $CSMITH_USER_OPTIONS > $testcaseOriginal
	
	# Compile and test modify program: (with input compiler flags or with defualts)
	#echo "ulimit -St 500;$compiler $compile_line ${runtime_default} ${compilerflags} $testcaseOriginal -o $testcaseEXEC"
	ulimit -St 500;$compiler $compile_line ${runtime_default} ${compilerflags} $testcaseOriginal -o $testcaseEXEC
	
	# Test exec	
	filesize=`stat --printf="%s" $testcaseOriginal`
	echo "Skip execution. Invalid or bad testcase." >> $testcaselogger
	echo "seed= $seed, size= $filesize" >> $testcaselogger
	echo "---" >> $testcaselogger
	
	#clean
	rm $testcaseOriginal
	rm $testcaseEXEC
}

#################################### PREPARE GEN TEST ####################################
function update_csmith_cmd_options {
	confg=$1

	## Update the csmith command line
	cmd=`head -1 $confg`
	CSMITH_USER_OPTIONS="$CSMITH_USER_OPTIONS $cmd"	

	## Get location of probablities file
	prob_file=`echo "$cmd" | awk '{for(i=1;i<=NF;i++) if ($i=="--relax-anlayses-prob") print $(i+1)}'`

	## Create the probablities file
	if [ ! -z "$prob_file" ]; then
		sed '1d;$d' $confg | sed '$d' > $prob_file
	fi

	## Update the line for compilation 
	getlineconfig=`sed '1d;$d' $confg | tail -1`
	## Replace vars
	compile_line_confg=`eval echo "$getlineconfig"`

	## Arrays to choose which one to set to functions or macros if mix
	lastline=`tail -1 $confg`
	IFS=' ' read -r -a inocationsMacrosMix <<< "$lastline"

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
CSMITH_USER_OPTIONS=" --bitfields --packed-struct"
# Basic parameters
compiler=$1			# Compiler to test
process=$2			# To create temp storage for exec
seed=$3		  	# File with all the seeds to use
testcaselogger=$4 		# The logger file for the results
cov=$5				# To test for cov=1, else =0
modify=$6			# Do we run on modified or original tests
csmith_location=$7		# Csmith location
compile_line=$8		# Includes + Duse
compilerflags=$9		# compiler flags
DA_folder=${10}		# DA (RRS lists) folder
testcaseConfg=${11}		# Test-case configuration (WA and RRS)
csmith_exec=${12}		# Location of Csmith exec
runtime=${13}			# Runtime for WA and RRS files
runtime_default=${14}		# Runtime Csmith defualt lib (with no RRS or WA)

## For debug only
#echo "Compiler=$compiler"
#echo "process=$process"
#echo "seed=$seed"
#echo "testcaselogger=$testcaselogger"
#echo "csmith_location=$csmith_location"
#echo "compile_line=$compile_line"
#echo "compilerflags=$compilerflags"
#echo "DA_folder=$DA_folder"
#echo "testcaseConfg=$testcaseConfg"
#echo "csmith_exec=$csmith_exec"
# Check if second parameter is a number
re='^[0-9]+$'
if ! [[ $seed =~ $re ]] ; then
	echo ">> error: Not a number" >&2; exit 1
fi

# folders for all the results
folder=$compiler-mainRes
testcaseRes=$DA_folder/'__test'$seed'Results'
compile_line_confg=""
inocationsMacrosMix=()	## Invocation to set as function wrapper
headerMode=0			## Assume function version
if [ ! -f $testcaseRes ]
	then
	#echo "Seed's list is missing: $testcaseRes"
	## Only generate and compile test case to measure coverage
	if [[ "$cov" == "1" ]]
		then
		coverage_test_only "$seed"
	fi
else
	# Check the configuration file exist
	testcaseConfgFile=$testcaseConfg/probs_WeakenSafeAnalyse_test.txt$seed	# name of config file
	if ! test -f "$testcaseConfgFile" ; then
		echo ">> error: No configuration file found for this seed $seed" >&2; exit 1
	fi

	# Get configuration data: Update $CSMITH_USER_OPTIONS
	update_csmith_cmd_options "$testcaseConfgFile"

	# Run a single test
	modify_test "$seed"
fi
## END ##
