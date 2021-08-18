#!/bin/bash 
process_number=$1						# Process number
nb_gen_progs=$2							# How many we will do by the end of the loop
nb_progs_to_gen_per_step=$3					# How many we shall generate now
initc=$(($nb_gen_progs + 1 - $nb_progs_to_gen_per_step)) 	# Calc. the position of the first seed of this batch
modify=$4							# With modifications --> use 1
seed_location=$5						# Seeds file location, coverage takes good+bad
csmith_location=$6						# Where is the csmith we use
compconfg=$7							# Where to take the compiler configuration
outputs_location=$8						# Where to expect the results
compile_line=$9							# Include and -D params for testcase
csmith_flags=${10}						# csmith flags
wda_folder=${11}						# location of weaken dynamic anlaysis results for these seeeds

### Check we have all the data we need before proceeding:
if [ "$#" -ne 11 ]; then
	echo "Illegal number of parameters. Please enter compiler and number of testcases to generate."
	echo "Requires: process number, size of population, size of population per step, flag (1-modify, 0-original csmith) seeds file, csmith location, configuration file location, output location, compilation line for test case, and csmith flags."
	exit 1
fi	

# Sets the logger -general name
logger=$outputs_location"__logger_cov"
if [[ "$modify" == "1" ]] ; then
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
	fi

	# Logger per-compiler - add only once (at start)
	loggerCurr=$logger"_"${compiler//\//\_}"_"seeds-$process_number.txt
	#if (($initc < 2)); then
		touch $loggerCurr
		echo "## (modify=$modify) Configuration: $str" >> $loggerCurr
		echo "##  - Compiler version:" `$compiler --version | head -1` >> $loggerCurr
		echo "##  - Applying coverage for $nb_gen_progs testcases in batches of $nb_progs_to_gen_per_step" >> $loggerCurr
		echo "##  - CSMITH_HOME: $csmith_location" >> $loggerCurr
		echo "##  - CSMITH_USER_OPTIONS: $csmith_flags" >> $loggerCurr
 		echo "##  - Configuration file: $compconfg" >> $loggerCurr
		echo "##  - Compilation of testcase: $compile_line" >> $loggerCurr
		echo "##  - Seeds: $seed_location for process $process_number" >> $loggerCurr
		echo "##  - date: $(date '+%Y-%m-%d at %H:%M.%S')" >> $loggerCurr
		echo "##  - host name $(hostname -f)" >> $loggerCurr
	#fi

	## Perform per configuration
	for (( c=$initc; c<=$nb_gen_progs; c++ ))
	do 
		cp=$c'p'
		seed=`sed -n $cp $seed_location`
		./RRS5_2_constructModifyTests.sh $compiler $seed $loggerCurr $wda_folder $modify $csmith_location "$csmith_flags" "$compile_line" "${arr[1]}"
	done
	## Per configuartion the loop generates $initc to $nb_gen_progs modified testcases
done < $compconfg
## The loop is going over all the configurations in compiler_test.in file
