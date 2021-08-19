#!/bin/bash
function modify_test {
	## Single test - create a test case and its precompilation
	testcaseModify=$1
	testcaseEXEC=$1.o

	# Compile and test modify program: (with input compiler flags or with defualts)
	ulimit -St 150;$compiler $compile_line ${compilerflags} $testcaseModify -o $testcaseEXEC
	
	# Test exec	
	filesize=`stat --printf="%s" $testcaseModify`
	ulimit -St 30; $testcaseEXEC >> $testcaselogger
	echo "program= $1, size= $filesize" >> $testcaselogger
	echo "---" >> $testcaselogger
	
	#clean
	rm $testcaseEXEC
}

################### MAIN ###############################
# Basic parameters
compiler=$1		# Compiler to test
program_in=$2		# File with all the seeds to use
testcaselogger=$3	# The logger file for the results
compile_line=$4		# Includes + Duse
compilerflags=$5	# compiler flags
# $compiler $program_location/$seed $loggerCurr "$compile_line" "${arr[1]}"
modify_test "$program_in" # Run a single test
