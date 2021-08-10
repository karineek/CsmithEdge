#!/bin/bash 
process_number=$1	## from 0
baseD=/home/user42
working_folder=$baseD/gcc-csmith-1 ##$process_number
nb_progs_to_gen=4
nb_progs_to_gen_per_step=2

base=$baseD/RRS_EXPR # $baseD/git/RRS_EXPR
seed_location=$base/scripts/WA-v2-standalone/seeds/seeds-$process_number.txt	# seed location
csmith_location=$base/csmith							# csmith location
csmith_exec=$base/csmith/build/src/csmith					# csmith exec
configuration_location=$working_folder/csmith/scripts/compiler_test.in		# config file locatoin
outputs_location=../../ 							# where we will put all outputs
#testcaseConfg=$base/scripts/WA-v2-standalone/seedsProbs 			# Test-case configuration (WA and RRS)
##testcaseConfg=$base/scripts/WA-v2-standalone/CsmithSeedsProbs			# Csmith mix
#testcaseConfg=$base/scripts/WA-v2-standalone/CsmithEdgeSeedsProbs_macros	# CsmithEdge func or macro
testcaseConfg=$base/scripts/WA-v2-standalone/CsmithEdgeSeedsProbs_func		# CsmithEdge func or macro
#DA_folder=$testcaseConfg/seedsSafeLists					# DA (RRS lists) folder
##DA_folder=$base/scripts/RSS-v2-general/seedsSafeLists_small			# Csmith mix
DA_folder=$base/scripts/WA-v2-standalone/seedsProbs/seedsSafeLists		# CsmithEdge func or macro	
runtime=RRS_runtime_test							# Runtime for WA and RRS files
compile_line="-B$working_folder/gcc-build/gcc/. -lgcov -w" 			#how we compile it
compile_line_lib_default="-I$csmith_location/runtime -I$csmith_location/build/runtime"
#compile_line_lib_default="-I$csmith_location/runtime -I$csmith_location/build/runtime -DUSE_MATH_MACROS"
modify=1 #1 #0 #2

## Check we have process number
if [ -z "$1" ]
  then
	echo "No process number supplied."
	exit 1
fi

time1=$(date +"%T")
echo "EVOLUTION OF GCC COVERAGE WHEN COMPILING "$nb_progs_to_gen" CSMITH PROGRAMS BY STEPS OF "$nb_progs_to_gen_per_step

rm -f $working_folder/seeds-$process_number.txt
rm -rf $working_folder/coverage_processed-$modify
rm -rf $working_folder/coverage_gcda_files/application_run-$modify

nb_gen_progs=0 # Start from 0
i=0 # Init counters
echo "--> RESETING COVERAGE DATA...("$time1")"

# Keep current folder:
current_folder=`pwd`

######################################## Prepare the env. for using GCC compiler ########################################
# Restore softlink linker lto
#cd $working_folder/gcc-build/gcc/
#ln -sf liblto_plugin.so.0.0.0 liblto_plugin.so
#ln -sf liblto_plugin.so.0.0.0 liblto_plugin.so.0

## Assure we are using the gcov in the gcc built:
#usrLib=$working_folder/gcc-install
#sudo rm -f /usr/local/bin/gcov /usr/bin/gcov 
#sudo ln -s $usrLib/bin/gcov /usr/bin/gcov

# Back to original folder
#cd $current_folder

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
	./RSS5_1-compiler_test.sh $process_number $nb_gen_progs $nb_progs_to_gen_per_step $seed_location $csmith_location $configuration_location $outputs_location "$compile_line" "$DA_folder" "$testcaseConfg" "$csmith_exec" "$runtime" "$compile_line_lib_default" $modify
	unset GCOV_PREFIX
	unset GCOV_PREFIX_STRIP
		
 	time3=$(date +"%T")
 	echo "--> MEASURING COVERAGE to $working_folder/coverage_processed-$modify/x-$i... ("$time3")"
	mkdir -p $working_folder/coverage_processed-$modify/x-$i
	(
		cd $working_folder/coverage_processed-$modify/x-$i
		source $baseD/graphicsfuzz/gfauto/.venv/bin/activate
		gfauto_cov_from_gcov --out run_gcov2cov.cov $working_folder/gcc-build/ $working_folder/coverage_gcda_files/application_run-$modify/ --num_threads 32 --gcov_uses_json >> gfauto.log 2>&1 
		gfauto_cov_to_source --coverage_out cov.out --cov run_gcov2cov.cov  $working_folder/gcc-build/ >> gfauto.log 2>&1 
	)
	cd $current_folder
done
time2=$(date +"%T")
echo "DONE. RESULTS AVAILABLE IN $working_folder/coverage_processed-$modify/x-$i ($time2)"
ls -l $working_folder/coverage_processed-$modify/x-$i

## Revert back all gcc changes: restore gcov
#sudo rm -f /usr/local/bin/gcov /usr/bin/gcov 
#sudo ln -s /usr/bin/gcov-9 /usr/bin/gcov
