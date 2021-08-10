#!/bin/bash 
process_number=$1						# Process number
nb_gen_progs=$2							# How many we will do by the end of the loop
nb_progs_to_gen_per_step=$3					# How many we shall generate now
initc=$(($nb_gen_progs + 1 - $nb_progs_to_gen_per_step)) 	# Calc. the position of the first seed of this batch
seed_location=$4						# Seeds file location, coverage takes good+bad
csmith_location=$5						# Where is the csmith we use
compconfg=$6							# Where to take the compiler configuration
outputs_location=$7						# Where to expect the results
compile_line=$8							# Include and -D params for testcase
DA_folder=$9							# DA (RRS lists) folder
testcaseConfg=${10}						# Test-case configuration (WA and RRS)
csmith_exec=${11}						# Location of Csmith exec
runtime=${12}							# Runtime for WA and RRS files
runtime_default=${13}						# Runtime Csmith defualt lib (with no RRS)
modify=${14}							# With modifications --> use 1

### Check we have all the data we need before proceeding:
if [ "$#" -ne 14 ]; then
	echo "Illegal number of parameters. Please enter compiler and number of testcases to generate."
	echo "Requires: process number, size of population, size of population per step, seeds file, csmith location, configuration file location, output location, compilation line for test case, RRS safe lists, WA config file, csmith exec, runtime lib for RRS, runtime lib without RRS, and modify or not version."
	exit 1
fi	

#echo "Get compilers lists: $working_folder/csmith/scripts/compiler_test.in"
# Sets the logger -general name
logger=$outputs_location"__logger_covM"

# Loop over compilation for the current batch of seeds
while read str; do
	arr=( $str )
	
	## Create the temp folder if required
	compiler=${arr[0]}
	folder=$compiler-mainRes
	if [ ! -d $folder ]
		then
		mkdir $folder
	fi

	# Logger per-compiler - add only once (at start)
	loggerCurr=$logger"_"${compiler//\//\_}"_"seeds-$process_number.txt
	if (($initc < 2)); then
		touch $loggerCurr
		echo "## (modify=$modify) Configuration: $str" >> $loggerCurr
		echo "##  - Compiler version:" `$compiler --version | head -1` >> $loggerCurr
		echo "##  - Applying coverage for $nb_gen_progs testcases in batches of $nb_progs_to_gen_per_step" >> $loggerCurr
		echo "##  - CSMITH_HOME: $csmith_location" >> $loggerCurr
		echo "##  - CSMITH EXEC: $csmith_exec" >> $loggerCurr
 		echo "##  - Configuration file: $compconfg" >> $loggerCurr
		echo "##  - WA and RRS configuration file: $testcaseConfg" >> $loggerCurr
		echo "##  - RRS safe lists location: $DA_folder" >> $loggerCurr
		echo "##  - Compilation of testcase: $compile_line" >> $loggerCurr
		if [[ "$modify" == "1" ]]; then
		echo "##  - Runtime libs for testcase compilation: $runtime" >> $loggerCurr
		else
		echo "##  - Runtime libs for testcase compilation: $runtime_default" >> $loggerCurr
		fi
		echo "##  - Seeds: $seed_location for process $process_number" >> $loggerCurr
		echo "##  - date: $(date '+%Y-%m-%d at %H:%M.%S')" >> $loggerCurr
		echo "##  - host name $(hostname -f)" >> $loggerCurr
	fi

	## Perform per configuration
	for (( c=$initc; c<=$nb_gen_progs; c++ ))
	do 
		cp=$c'p'
		seed=`sed -n $cp $seed_location`
		./RSS5_2_constructModifyTests.sh $compiler $process_number $seed $loggerCurr 1 $modify $csmith_location "$compile_line" "${arr[1]}" "$DA_folder" "$testcaseConfg" "$csmith_exec" "$runtime" "$runtime_default"
	done
	## Per configuartion the loop generates $initc to $nb_gen_progs modified testcases
done < $compconfg
## The loop is going over all the configurations in compiler_test.in file
