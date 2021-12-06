#!/bin/bash

############################################# UB-FREEDON CHECK #############################################
function is_valid_program {
	filename=$1
	filenameNoRelax=$2
	build_folder=$3
	framac_output=$4
	
	###############################
	# Building original test-case #
	gen="(ulimit -St 150; $build_folder/src/csmith "$csmith_args" --seed $seed) > $filenameNoRelax"
	cd $scripts_location; eval $gen

	###################################
	# Check if the program is UB-free #
	flag_dang_ptr=`grep 'dangling-global-pointers' $filename | wc -l` # If we have dangling pointers, we check with the right flag in framac
	UBfreedom_RC=`./WA1-2-test-ub-freedom.sh "$filename" "$filenameNoRelax" "$scripts_location" "$framac_output" "$timeout_bound" "$flag_dang_ptr" "-I$build_folder/../RRS_runtime_test/ -I$build_folder/runtime/"`
}

############################################# Run Test Case #############################################
function execute_test {
	prog=$1
	build_folder=$2
	printoutput=$3
	compilerP=$4

	# PLAIN
	rm -f a.out
	(ulimit -St 300; $compilerP -I$build_folder/../RRS_runtime_test/ -I$build_folder/runtime/ $prog)
	if [[ -f "a.out" ]]; then ## check if the file exists
		(ulimit -St $timeout_bound; ./a.out) > $printoutput 2>&1 ## Csmith original paper offered 5 seconds.
		cat $printoutput | grep "checksum = " > $printoutput.tmp
		cp $printoutput.tmp $printoutput
		rm $printoutput.tmp
		rm -f a.out
	fi
}

####################################### Start Main #######################################
timeS=$(date +"%T")	# Measure time start

CSMITH_USER_OPTIONS=" --bitfields --packed-struct "
seed=$1 			# File with all the seeds to use - shall be only good seeds here!
base=$2			# base folder
timeout_bound=$3		# csmith-generated programs timeout when diff-testing
execute_diff_testing=$4	# Generation + diff testing

### EXEC & BUILD LOCATION
csmith_build=$base/csmith/build
scripts_location=$base/scripts/diff_testing_rate
### ARGS
csmith_args="$CSMITH_USER_OPTIONS --annotated-arith-wrappers"
wa_probs=$scripts_location/seedsProbs/probs_WeakenSafeAnalyse_test.txt
rrs_folder=$scripts_location/seedsProbs/seedsSafeLists
framac_run_folder=$scripts_location/Frama-C-zone
UBfreedom_RC=""
###

mkdir -p $rrs_folder
cd $scripts_location
rm -f $wa_probs$seed $wa_probs __temp_edge.c __temp_orig.c

###################################
# Building new relaxed test-cases 
###################################
timeSG=$(date +"%T")
(./WA1-1-CsmithEdge.sh $seed $base $timeout_bound) > __temp_edge.c 2>&1
timeEG=$(date +"%T")
is_testcase=`grep "int main" __temp_edge.c | wc -l`
if [[ $is_testcase -eq 0 ]] ; then
	UBfreedom_RC=`cat __temp_edge.c`
	valid=0
	## Failed Generation
else
	## Check if generated a UB-Free program
	timeSV=$(date +"%T")
	is_valid_program __temp_edge.c __temp_orig.c "$csmith_build" "$framac_run_folder"
	timeEV=$(date +"%T")
	## Is UB-free?
	if [[ ${#UBfreedom_RC} -eq 0 ]] ; then
		valid=1
		## Lines Differance
		linesCsmithProg=`cat __temp_orig.c | wc -l`
		linesWAProg=`cat __temp_edge.c | wc -l`
		if [[ $linesCsmithProg -gt 0 ]] ; then
			diff_lines_progs=`diff -y --suppress-common-lines __temp_edge.c __temp_orig.c | wc -l`
		else 
			diff_lines_progs=0
		fi
	else
		valid=0
		## Failed Generation of UB-free program: result already in UBfreedom_RC
	fi
fi
timeEGnV=$(date +"%T")
timeST=$timeEGnV
## Run Tests x2
if [[ $execute_diff_testing -eq 1 ]]  && [[ $valid -eq 1 ]]; then
	(./WA5_restore_testcase_given_prog.sh $seed __temp_edge.c)
	progM=__test$seed"M.c"
	testcaseRes='seedsProbs/seedsSafeLists'/'__test'$seed'Results'
	if [[ $progM -eq 0 ]] && [ -f $testcaseRes ] ; then
		## Run modify
		filesize=`stat --printf="%s" $progM`
		echo "seed= $seed, size= $filesize"
	
		execute_test $progM $csmith_build "$scripts_location/Plain11.txt" "clang-11 -O2 -w"		
		execute_test $progM $csmith_build "$scripts_location/Plain10.txt" "gcc-10 -O2 -w"
		cat $scripts_location/Plain11.txt
		cat $scripts_location/Plain10.txt
		## Test diff
		if [[ `cat $scripts_location/Plain11.txt` != `cat $scripts_location/Plain10.txt` ]] ; then 
			echo ">> Diff: <$res1> vs. <$res2>"
		fi
	else 
		valid=0
		UBfreedom_RC=">> Failed Generating $progM"
		## Failed Restoring Program after RRS
	fi
fi
timeET=$(date +"%T")

###################################
## Output Final
###################################
params=`cat "$wa_probs$seed" | tr "\n" ","`
(rm __temp_edge.c __temp_orig.c test1e.txt test2e.txt test3e.txt test4e.txt test5e.txt temp.c res1.txt res2.txt probs_WeakenSafeAnalyse.txt platform.info output.txt csmith_test.c) > /tmp/err 2>&1
timeE=$timeET
echo ">> ($seed) | timeS: $timeS | timeE: $timeE | timeSV: $timeSV | timeEV: $timeEV | timeGenS: $timeS | timeGenE: $timeEG | timeExeS: $timeEG | timeExeE: $timeE | #line csmith: $linesCsmithProg | #lines wa: $linesWAProg | Delta: $diff_lines_progs | Valid: $valid | UB-NON-FREEDOM REASON ($UBfreedom_RC) | FaildRRS: $err_rrs | Parameters: $params"
## END
