#!/bin/bash 
process_number=$1		# Seeds set number
working_folder=$2		# compiler installed with coverage
project_folder=$3		# project folder location (where CsmithEdge is)
nb_progs_to_gen=$4		#100000
nb_progs_to_gen_per_step=$5	#20000
modify=$6			# 0 - regular Csmith, 1 - CsmithEdge, 2 - CsmithEdge+float
macros=$7			# 0 - functions, 1 - macros
basic_flags=" -lgcov -w"
include_flags="-I$csmith_location/runtime -I$csmith_location/build/runtime"
include_flags_RRS="-I$csmith_location/RRS_runtime_test -I$csmith_location/build/runtime"
include_flags_float="-I/home/user42/float-headers/runtime/"
float_flags="-DSTRICT_FLOAT_VALUE -lm"
macro_flags="-DUSE_MATH_MACROS"

## Check we have process number
if [ -z "$1" ]
  then
        echo "No process number supplied."
        exit 1
fi

base=$project_folder
program_location=$base'/Data/programs/set'$process_number		# seed location
csmith_location=$base/csmith						# csmith location
configuration_location=$working_folder/csmith/scripts/compiler_test.in	# config file locatoin
outputs_location=../../../ # where we will put all outputs

## Change per test:
#csmith_flags=" --bitfields --packed-struct " #" --bitfields --packed-struct --math-notmp --annotated-arith-wrappers" 
if [[ "$macros" == "1" ]] ; then
	compile_line_basic="$basic_flags $macro_flags"
else
	compile_line_basic="$basic_flags"
fi

if [[ "$modify" == "2" ]] ; then
        echo "Get programs from from $program_location <CsmithEdge-float>"
        ## modify=1 : 0-original, 1-modify
        compile_line="$compile_line_basic $include_flags_float $float_flags"

elif [[ "$modify" == "1" ]] ; then
	echo "Get programs from from $program_location <CsmithEdge>"
	## modify=1 : 0-original, 1-modify
	compile_line="$compile_line_basic $include_flags_RRS"
else
	echo "Get seed list from $program_location <Csmith>"
	## modify=0 : 0-original, 1-modify
	compile_line="$compile_line_basic $include_flags"
fi

time1=$(date +"%T")
echo "EVOLUTION OF GCC COVERAGE WHEN COMPILING "$nb_progs_to_gen" CSMITH PROGRAMS BY STEPS OF "$nb_progs_to_gen_per_step
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
 	./RRS5_1-compiler_test.sh $process_number $nb_gen_progs $nb_progs_to_gen_per_step $modify $program_location $csmith_location $configuration_location $outputs_location "$compile_line" 
	unset GCOV_PREFIX
	unset GCOV_PREFIX_STRIP
		
 	time3=$(date +"%T")
 	echo "--> MEASURING COVERAGE... ("$time3")"
	mkdir -p $working_folder/coverage_processed-$modify/x-$i
	(
		cd $working_folder/coverage_processed-$modify/x-$i
		source $project_folder/../graphicsfuzz/gfauto/.venv/bin/activate
		gfauto_cov_from_gcov --out run_gcov2cov.cov $working_folder/llvm-build/ --gcov_prefix_dir $working_folder/coverage_gcda_files/application_run-$modify/ --num_threads 32 --gcov_uses_json >> gfauto.log 2>&1
		gfauto_cov_to_source --coverage_out cov.out --cov run_gcov2cov.cov  $working_folder/llvm-build/ >> gfauto.log 2>&1 
	)
	cd $current_folder
done
time2=$(date +"%T")
echo "DONE. RESULTS AVAILABLE IN $working_folder/coverage_processed-$modify/x-$i ($time2)"
ls -l $working_folder/coverage_processed-$modify/x-$i
