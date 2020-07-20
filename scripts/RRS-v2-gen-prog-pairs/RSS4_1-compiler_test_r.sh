#!/bin/bash 
process_number=$1											# Process number
modify=$2													# With modifications --> use 1
seed_location=$3											# Seeds file location, coverage takes good+bad
csmith_location=$4											# Where is the csmith we use
compconfg=$5												# Where to take the compiler configuration
outputs_location=$6											# Where to expect the results
compile_line=$7												# Include and -D params for testcase
csmith_flags=$8												# csmith flags
# Was: $working_folder/csmith/scripts/compiler_test.in
#echo "Get compilers lists: $working_folder/csmith/scripts/compiler_test.in"
if [ "$#" -ne 8 ]; then
	echo "Illegal number of parameters. Please enter compiler and number of testcases to generate."
	echo "Requires: process number, flag (1-modify, 0-original csmith), seeds file, csmith location, configuration file location, output location, compilation line for test case, and csmith flags."
	exit 1
fi

# Sets the logger -general name
logger=$outputs_location"__logger"
if [[ "$modify" == "1" ]]
	then
	logger=$logger"M"
fi
# Loop over compilation for the current batch of seeds
while read str; do
	arr=( $str )
	
	## Create the temp folder if required
	compiler=${arr[0]}
	folder=$compiler-mainRes
	if [ ! -d $folder ]
		then
		mkdir $folder
		mkdir $folder/csmith
		mkdir $folder/modify
	fi
	
	# Logger per-compiler
	loggerCurr=$logger"_"${compiler//\//\_}"_"seeds-$process_number.txt
	touch $loggerCurr
	echo "## (modify=$modify) Configuration: $str" >> $loggerCurr
	echo "##  - Compiler version:" `$compiler --version | head -1` >> $loggerCurr
	echo "##  - Not applying coverage" >> $loggerCurr
	echo "##  - CSMITH_HOME: $csmith_location" >> $loggerCurr
	echo "##  - CSMITH_USER_OPTIONS: $csmith_flags" >> $loggerCurr
	echo "##  - Configuration file: $compconfg" >> $loggerCurr
	echo "##  - Compilation of testcase: $compile_line" >> $loggerCurr
	echo "##  - Seeds: $seed_location for process $process_number" >> $loggerCurr
	echo "##  - date: $(date '+%Y-%m-%d at %H:%M.%S')" >> $loggerCurr
	echo "##  - host name $(hostname -f)" >> $loggerCurr

	## Perform per configuration
	## Read seeds from line
	while IFS= read -r seed
	do
		./RSS5_2_constructTestsPairs.sh $compiler $seed $csmith_location "$csmith_flags"
	done < "$seed_location"
	## Per configuartion the loop generates $initc to $nb_gen_progs modified testcases
done < $compconfg
## The loop is going over all the configurations in compiler_test.in file
