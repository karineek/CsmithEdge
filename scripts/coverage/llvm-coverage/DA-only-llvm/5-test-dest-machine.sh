#!/bin/bash 
process_number=$1		# Seeds set number
working_folder=$2		# compiler installed with coverage
project_folder=$3		# project folder location (where CsmithEdge is)
nb_progs_to_gen=$4		#100000
nb_progs_to_gen_per_step=$5	#20000
modify=$6			# 0 - regular Csmith, 1 - CsmithEdge

## Check we have process number
if [ -z "$1" ]
  then
        echo "No process number supplied."
        exit 1
fi

base=$project_folder
seed_location=$base/Data/seeds/seeds-$process_number.txt 		# seed location
csmith_location=$base/csmith						# csmith location
wda_folder=$base/AE/Data/set-3/WDA/					# location of dynamic anlysis results for this set
configuration_location=$working_folder/csmith/scripts/compiler_test.in	# config file locatoin
outputs_location=../../../ # where we will put all outputs

## Change per test:
#csmith_flags=" --bitfields --packed-struct " #" --bitfields --packed-struct --math-notmp --annotated-arith-wrappers" 
if [[ "$modify" == "1" ]] ; then
	echo "Get seed list from $seed_location <CsmithEdge>"
	## modify=1 : 0-original, 1-modify
	compile_line=" -I$csmith_location/runtime -I$csmith_location/build/runtime -lgcov -w" #how we compile it,modify=0
	##compile_line=" -I$csmith_location/runtime -I$csmith_location/build/runtime -lgcov -w -DUSE_MATH_MACROS" #how we compile it,modify=0
	csmith_flags=" --bitfields --packed-struct " #" --bitfields --packed-struct --math-notmp" 
else
	echo "Get seed list from $seed_location <Csmith>"
	## modify=0 : 0-original, 1-modify
	##compile_line=" -I../../csmith_runtime_orig -I../../csmith_runtime_orig_build -lgcov -w" #how we compile it,modify=1
	compile_line=" -I$csmith_location/RRS_runtime_test -I$csmith_location/build/runtime -DUSE_MATH_MACROS -lgcov -w" #how we compile it,modify=1
	csmith_flags=" --bitfields --packed-struct --annotated-arith-wrappers" #" --bitfields --packed-struct --math-notmp" 
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
 	./RRS5_1-compiler_test.sh $process_number $nb_gen_progs $nb_progs_to_gen_per_step $modify $seed_location $csmith_location $configuration_location $outputs_location "$compile_line" "$csmith_flags" $wda_folder
	unset GCOV_PREFIX
	unset GCOV_PREFIX_STRIP
		
 	time3=$(date +"%T")
 	echo "--> MEASURING COVERAGE... ("$time3")"
	mkdir -p $working_folder/coverage_processed-$modify/x-$i
	(
		cd $working_folder/coverage_processed-$modify/x-$i
		source $baseD/graphicsfuzz/gfauto/.venv/bin/activate
		gfauto_cov_from_gcov --out run_gcov2cov.cov $working_folder/llvm-build/ --gcov_prefix_dir $working_folder/coverage_gcda_files/application_run-$modify/ --num_threads 32 --gcov_uses_json >> gfauto.log 2>&1 
		gfauto_cov_to_source --coverage_out cov.out --cov run_gcov2cov.cov  $working_folder/llvm-build/ >> gfauto.log 2>&1 
	)
	cd $current_folder
done
time2=$(date +"%T")
echo "DONE. RESULTS AVAILABLE IN $working_folder/coverage_processed-$modify/x-$i ($time2)"
ls -l $working_folder/coverage_processed-$modify/x-$i
