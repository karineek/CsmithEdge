#!/bin/bash 
#!/bin/bash 
process_number=$1
baseD=/home/user42
working_folder=$baseD/gcc-csmith-$process_number
nb_progs_to_gen=10000
nb_progs_to_gen_per_step=5000
seed_location=../../Data/seeds_all/seeds_out$process_number.txt # seed location
configuration_location=$working_folder/csmith/scripts/compiler_test.in # config file locatoin
outputs_location=../../ # where we will put all outputs

## Change per test:
csmith_flags=" --bitfields --packed-struct" #" --bitfields --packed-struct --math-notmp" 
## 0
#modify=0 # 0-original, 1-modify
#csmith_location=./../../../../gcc-csmith-$process_number/csmith # csmith location,modify=0
##compile_line="-B$working_folder/gcc-build/gcc/. -I$working_folder/csmith/runtime -lgcov -w" #how we compile it,modify=0
#compile_line="-B$working_folder/gcc-build/gcc/. -I$working_folder/csmith/runtime -lgcov -w -DUSE_MATH_MACROS" #how we compile it,modify=0
## 1
modify=1 # 0-original, 1-modify
csmith_location=../../csmith # csmith location,modify=1
##compile_line="-B$working_folder/gcc-build/gcc/. -I../../csmith_runtime_orig -I../../csmith_runtime_orig_build -lgcov -w" #how we compile it,modify=1
compile_line="-B$working_folder/gcc-build/gcc/. -I../../csmith_runtime_orig -I../../csmith_runtime_orig_build -DUSE_MATH_MACROS -lgcov -w" #how we compile it,modify=1


## Check we have process number
if [ -z "$1" ]
  then
	echo "--> No process number supplied. Exit."
	echo "	Single parameter: set process_number."
	echo "	3 Parameters, resume after crash: process_number, index i, seed number before the crash."
	echo "	4 Parameters, destribute execution: process_number, index i, seed from, seed to."
	exit 1
fi

time1=$(date +"%T")
echo "EVOLUTION OF GCC COVERAGE WHEN COMPILING "$nb_progs_to_gen" CSMITH PROGRAMS BY STEPS OF "$nb_progs_to_gen_per_step
if [ "$#" -eq 3 ]; then
	i=$2 		# Restore counters
	nb_gen_progs=$3	# Restore from seed (one before we crushed)
	echo "--> RESTORE COVERAGE DATA...("$i","$nb_gen_progs","$nb_progs_to_gen","$time1")" 
else
	rm -f $working_folder/seeds-$process_number.txt
	rm -rf $working_folder/coverage_processed-$modify
	rm -rf $working_folder/coverage_gcda_files/application_run-$modify
	
	if [ "$#" -eq 1 ]; then
		nb_gen_progs=0 # Start from 0
		i=0 # Init counters
		echo "--> RESETING COVERAGE DATA...("$time1")"
	else
		if [ "$#" -eq 4 ]; then
			i=$2 			# Restore counters
			nb_gen_progs=$3		# from seed 
			nb_progs_to_gen=$4	# to seed
			echo "--> RESETING COVERAGE DATA...("$i","$nb_gen_progs","$nb_progs_to_gen","$time1")" 
		else
			echo "--> Wrong number of parameters! Exit."
			echo "	Single parameter: set process_number."
			echo "	3 Parameters, resume after crash: process_number, index i, seed number before the crash."
			echo "	4 Parameters, destribute execution: process_number, index i, seed from, seed to."
			exit 1
		fi
	fi
fi

# Keep current folder:
current_folder=`pwd`

######################################## Prepare the env. for using GCC compiler ########################################
# Restore softlink linker lto
cd $working_folder/gcc-build/gcc/
ln -sf liblto_plugin.so.0.0.0 liblto_plugin.so
ln -sf liblto_plugin.so.0.0.0 liblto_plugin.so.0

## Assure we are using the gcov in the gcc built:
usrLib=$working_folder/gcc-install
sudo rm -f /usr/local/bin/gcov /usr/bin/gcov 
sudo ln -s $usrLib/bin/gcov /usr/bin/gcov
#rm -f /usr/local/bin/gcov /usr/bin/gcov 
#ln -s $usrLib/bin/gcov /usr/bin/gcov

# Back to original folder
cd $current_folder

######################################## Start Cov. ########################################
# Loop over compilation and coverage measurement
#>> start loop with i=0, nb_gen_progs=0, nb_progs_to_gen=100000
#i=0
#nb_gen_progs=0
#>> start loop with i=2, nb_gen_progs=10000, nb_progs_to_gen=100000
#i=2 
#nb_gen_progs=10000
#>> start loop with i=4, nb_gen_progs=20000, nb_progs_to_gen=100000
#i=4 
#nb_gen_progs=20000
#>> start loop with i=6, nb_gen_progs=30000, nb_progs_to_gen=100000
#i=6 
#nb_gen_progs=30000
#>> start loop with i=8, nb_gen_progs=40000, nb_progs_to_gen=100000
#i=8 
#nb_gen_progs=40000
#>> start loop with i=10, nb_gen_progs=50000, nb_progs_to_gen=100000
#i=10
#nb_gen_progs=50000
#>> start loop with i=12, nb_gen_progs=60000, nb_progs_to_gen=100000
#i=12
#nb_gen_progs=60000
#>> start loop with i=14, nb_gen_progs=70000, nb_progs_to_gen=100000
#i=14
#nb_gen_progs=70000
#>> start loop with i=16, nb_gen_progs=80000, nb_progs_to_gen=100000
#i=16
#nb_gen_progs=80000
#>> start loop with i=18, nb_gen_progs=90000, nb_progs_to_gen=100000
#i=18
#nb_gen_progs=90000
##

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
		source $baseD/git/graphicsfuzz/gfauto/.venv/bin/activate
		gfauto_cov_from_gcov --out run_gcov2cov.cov $working_folder/gcc-build/ $working_folder/coverage_gcda_files/application_run-$modify/ --num_threads 32 --gcov_uses_json >> gfauto.log 2>&1 
		gfauto_cov_to_source --coverage_out cov.out --cov run_gcov2cov.cov  $working_folder/gcc-build/ >> gfauto.log 2>&1 
	)
	cd $current_folder
done
time2=$(date +"%T")
echo "DONE. RESULTS AVAILABLE IN $working_folder/coverage_processed-$modify/x-$i ($time2)"

## Revert back all gcc changes: restore gcov
sudo rm -f /usr/local/bin/gcov /usr/bin/gcov 
sudo ln -s /usr/bin/gcov-9 /usr/bin/gcov
#rm -f /usr/local/bin/gcov /usr/bin/gcov 
#ln -s /usr/bin/gcov-9 /usr/bin/gcov
