#!/bin/bash

#################################### PREPARE GEN TEST ####################################
function update_csmith_cmd_options {
	confg=$1

	## Update the line for compilation
	getlineconfig=`grep 'csmith_location' $confg`
	## Replace vars
	compile_line_confg=`eval echo "$getlineconfig"`
}

#################################### Modify TEST ####################################
function do_test {
	## Single test - create a test case and its precompilation
	testcase=$1
	testcaseEXEC=$folder/'__'$seed'Exec'
	
	# Compile and test modify program: (with input compiler flags or with defualts)
	ulimit -St 300;$compiler $compile_line $compile_line_confg ${compilerflags} $testcase -o $testcaseEXEC
	echo " >> (Info.) compile with <ulimit -St 500;$compiler $compile_line $compile_line_confg ${compilerflags} $testcase -o $testcaseEXEC>"

	# Test exec	
	filesize=`stat --printf="%s" $testcase`
	ulimit -St 300;$testcaseEXEC >> $testcaselogger
	echo "seed= $seed, size= $filesize" >> $testcaselogger
	echo "---" >> $testcaselogger
	
	#clean
	rm $testcaseEXEC
}

################### MAIN ###############################
# Single iteration, requires a compiler and a seed
# Basic parameters
compiler=$1			# Compiler to test
seed=$2			# File with all the seeds to use
testcase_file=$3		# testcase
testcaseConfgFile=$4		# Test-case configuration (WA and RRS)
testcaselogger=$5 		# The logger file for the results
compile_line=$6		# Includes + Duse
compilerflags=$7		# compiler flags
folder=$8			# working folder
csmith_location=$9		# csmith location
runtime=${10}			# runtime folder

# Check if second parameter is a number
re='^[0-9]+$'
if ! [[ $seed =~ $re ]] ; then
	echo ">> error: Not a number <$seed>." >&2; exit 1
fi

# folders for all the results
compile_line_confg=""
# Check the configuration file exist
if ! test -f "$testcaseConfgFile" ; then
	echo ">> error: No configuration file found for this seed $seed. Missing <$testcaseConfgFile>." >&2; exit 1
fi
# Get configuration data
update_csmith_cmd_options "$testcaseConfgFile"

# Run a single test
do_test "$testcase_file"

## END ##
