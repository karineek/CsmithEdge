#!/bin/bash 
process_number=$1
baseD=/home/user42
working_folder=$baseD/llvm-csmith-1 ##$process_number
nb_progs_to_gen=4 #100000
nb_progs_to_gen_per_step=2 #20000
#seed_location=../../Data/seeds_all/seeds_out$process_number.txt # seed location

base=$baseD/RRS_EXPR # $baseD/git/RRS_EXPR
seed_location=$base/scripts/WA-v2-standalone/seeds/seeds-$process_number.txt	# seed location
csmith_location=$base/csmith							# csmith location
# csmith_exec=$base/csmith/build/src/csmith					# csmith exec
configuration_location=$working_folder/csmith/scripts/compiler_test.in		# config file locatoin
outputs_location=../../ # where we will put all outputs

## Change per test:
#csmith_flags=" --bitfields --packed-struct " #" --bitfields --packed-struct --math-notmp --annotated-arith-wrappers" 

## 0
modify=0 # 0-original, 1-modify
##compile_line=" -I$csmith_location/runtime -I$csmith_location/build/runtime -lgcov -w" #how we compile it,modify=0
compile_line=" -I$csmith_location/runtime -I$csmith_location/build/runtime -lgcov -w -DUSE_MATH_MACROS" #how we compile it,modify=0
csmith_flags=" --bitfields --packed-struct " #" --bitfields --packed-struct --math-notmp" 

## 1
#modify=1 # 0-original, 1-modify
##compile_line=" -I../../csmith_runtime_orig -I../../csmith_runtime_orig_build -lgcov -w" #how we compile it,modify=1
#compile_line=" -I$csmith_location/RRS_runtime_test -I$csmith_location/build/runtime -DUSE_MATH_MACROS -lgcov -w" #how we compile it,modify=1
#csmith_flags=" --bitfields --packed-struct --annotated-arith-wrappers" #" --bitfields --packed-struct --math-notmp" 

## Check we have process number
if [ -z "$1" ]
  then
	echo "No process number supplied."
	exit 1
fi

time1=$(date +"%T")
echo "EVOLUTION OF LLVM COVERAGE WHEN COMPILING "$nb_progs_to_gen" CSMITH PROGRAMS BY STEPS OF "$nb_progs_to_gen_per_step
if [ "$#" -ne 3 ]; then
	rm -f $working_folder/seeds-$process_number.txt
	rm -rf $working_folder/coverage_processed-$modify
	rm -rf $working_folder/coverage_gcda_files/application_run-$modify
	
	nb_gen_progs=0 # Start from 0
	i=0 # Init counters
	echo "--> RESETING COVERAGE DATA...("$time1")"
else
	nb_gen_progs=$2	# Restore 
	i=$3 		# Restore counters
	echo "RESTORE COVERAGE DATA...("$nb_gen_progs","$i","$time1")" 
fi

# Keep current folder:
current_folder=`pwd`


######################################## Start Cov. ########################################
# Loop over compilation and coverage measurement
while (( $nb_gen_progs < $nb_progs_to_gen ));
do
	i=$(($i+1))
 	nb_gen_progs=$(($nb_gen_progs + $nb_progs_to_gen_per_step))
	time2=$(date +"%T")
 	echo "--> COMPILING "$nb_progs_to_gen_per_step" PROGRAMS ("$(($nb_progs_to_gen-$nb_gen_progs))" REMAINING)... ("$time2")"
 	
	# Set location to record the data
	mkdir -p $working_folder/coverage_gcda_files/application_run-$modify

	# Run compiler and save coverage data
 	export GCOV_PREFIX=$working_folder/coverage_gcda_files/application_run-$modify
	export GCOV_PREFIX_STRIP=0
 	./RRS5_1-compiler_test.sh $process_number $nb_gen_progs $nb_progs_to_gen_per_step $modify $seed_location $csmith_location $configuration_location $outputs_location "$compile_line" "$csmith_flags"
	unset GCOV_PREFIX
	unset GCOV_PREFIX_STRIP
		
 	time3=$(date +"%T")
 	echo "--> MEASURING COVERAGE... ("$time3")"
	mkdir -p $working_folder/coverage_processed-$modify/x-$i
	(
		cd $working_folder/coverage_processed-$modify/x-$i
		source $baseD/graphicsfuzz/gfauto/.venv/bin/activate
		gfauto_cov_from_gcov --out run_gcov2cov.cov $working_folder/llvm-build/ $working_folder/coverage_gcda_files/application_run-$modify/ --num_threads 32 --gcov_uses_json >> gfauto.log 2>&1 
		gfauto_cov_to_source --coverage_out cov.out --cov run_gcov2cov.cov  $working_folder/llvm-build/ >> gfauto.log 2>&1 
	)
	cd $current_folder
done
time2=$(date +"%T")
echo "DONE. RESULTS AVAILABLE IN $working_folder/coverage_processed-$modify/x-$i ($time2)"
ls -l $working_folder/coverage_processed-$modify/x-$i
