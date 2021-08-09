#!/bin/bash

############################################# REPORT and DEBUG DATA #############################################
function general_report {
	## Init:
	testValid=1
	cd $curr_folder

	ASANfail=0
	MSANfail=0
	UBSANfail=0
	FRAMAcfail=0

	## General stat.
	if [[ $diff_lines_progs -eq 0 ]]; then
		testValid=1
        elif [[ $diff_lines_progs -eq 1 ]]; then
		testValid=1
	elif [[ $time_out_flag_edge -eq 1 ]]; then	## save time, if gets time out skips all sanitizers and checkers and marks as not-valid test
		testValid=0
	else
		## Check the reports:	
		cut $framac_run_folder/Fres1.txt -d':' -f 3- > $framac_run_folder/cutFres1.txt
		cut $framac_run_folder/Fres2.txt -d':' -f 3- > $framac_run_folder/cutFres2.txt
		
		diff_lines_FramaC=`diff -y --suppress-common-lines $framac_run_folder/cutFres1.txt $framac_run_folder/cutFres2.txt`
		diff_lines_ASAN=`diff -y --suppress-common-lines $curr_folder/ASANres1.txt $curr_folder/ASANres2.txt`
		diff_lines_MSAN=`diff -y --suppress-common-lines $curr_folder/MSANres1.txt $curr_folder/MSANres2.txt`
		diff_lines_UBSAN=`diff -y --suppress-common-lines $curr_folder/UBSANres1.txt $curr_folder/UBSANres2.txt`

		ASANresSize2=`cat $curr_folder/ASANres2.txt  | wc -l`
		MSANresSize2=`cat $curr_folder/MSANres2.txt  | wc -l`
		UBSANresSize2=`cat $curr_folder/UBSANres2.txt  | wc -l`
		FramaCresSize2=`cat $framac_run_folder/cutFres2.txt  | wc -l`

		## ASAN failed?
		if [ ! -z "$diff_lines_ASAN" ] && [[ $ASANresSize2 -gt 1 ]]; then
			ASANfail=1
		fi
		if [[ $ASANresSize2 -eq 0 ]] ; then
			ASANfail=1	
		fi
		## MSAN failed?
		if [ ! -z "$diff_lines_MSAN" ] && [[ $MSANresSize2 -gt 1 ]]; then
			MSANfail=1
		fi
		if [[ $MSANresSize2 -eq 0 ]]; then
			MSANfail=1	
		fi
		## UBSAN failed?
		if [ ! -z "$diff_lines_UBSAN" ] && [ $UBSANresSize2 -gt 0 ]; then
			UBSANfail=1
		fi
		## FRAMA-C failed?
		if [ ! "$FramaCresSize2" -eq "0" ]; then
			if [ ! -z "$diff_lines_FramaC" ] && [ $FramaCresSize2 -gt 0 ]; then
				FRAMAcfail=1
			fi
		fi
		## Test-case failed
		if [[ $ASANfail -eq 1 ]] || [[ $MSANfail -eq 1 ]] || [[ $UBSANfail -eq 1 ]] || [[ $FRAMAcfail -eq 1 ]] ; then
			testValid=0		
		fi
	fi 

	## Report if valid: $seed
	is_valid="YES"
	err_rrs=0
	if [[ $testValid == 0 ]]; then
		is_valid="NO"

		if [[ $time_out_flag_edge -eq 1 ]]; then
			tool="CSMITH-WA"
			prog=temp_edge.c
			check_plain_rrs $tool $prog $csmith_build "$curr_folder/PlainRRS2.txt" "gcc-10 -O2 -w"
			diff_lines_Plain=`diff -y --suppress-common-lines $curr_folder/Plain2.txt $curr_folder/PlainRRS2.txt`
                        if [ -z "$diff_lines_Plain" ]; then
				echo ">> Same result (in timeout!)"
                                same_result_flage=1
                                cat $curr_folder/Plain2.txt
                                cat $curr_folder/PlainRRS2.txt
                        fi
		fi
	else
		## Diff testing: if valid is YES
		tool="CSMITH-WA"
		progM=__test$seed"M.c"
		(./WA4_restore_RRS_given_prog.sh "clang-10" "$seed" "$rrs_folder" $prog $csmith_location $timeout_bound) > rrs.log 2>&1
		err_rrs=`grep "error" rrs.log | wc -l`
		if [[ $err_rrs -eq 0 ]] ; then				 
			(./WA5_restore_testcase_given_prog.sh $seed $prog)
			check_plain_rrs $tool $progM $csmith_build "$curr_folder/PlainRRS1.txt" "clang-10 -O2 -w"		
			check_plain_rrs $tool $progM $csmith_build "$curr_folder/PlainRRS2.txt" "gcc-10 -O2 -w"
			diff_lines_Plain=`diff -y --suppress-common-lines $curr_folder/PlainRRS1.txt $curr_folder/PlainRRS2.txt`
			if [ -z "$diff_lines_Plain" ]; then
				echo ">> Same result"
				same_result_flage=1
				cat $curr_folder/PlainRRS1.txt
				cat $curr_folder/PlainRRS2.txt
			fi
		fi
	fi
	timeE=$(date +"%T")
	echo ">> ($seed) | #line csmith: $linesCsmithProg | #lines wa: $linesWAProg | Delta: $diff_lines_progs | Valid: $is_valid | ASAN: $ASANfail | MSAN: $MSANfail | UBSAN: $UBSANfail | FRAMAC: $FRAMAcfail | FaildRRS: $err_rrs | TIMEOUT: $time_out_flag_edge | timeS: $timeS | timeE: $timeE"
}

## Checks modified code for seg-fault (DEBUG)
function check_plain_rrs {
	tool=$1
	prog=$2
	build_folder=$3
	printoutput=$4
	compilerP=$5

	# PLAIN
	{
		rm -f a.out
		(ulimit -St 300; $compilerP -I$build_folder/../RRS_runtime_test/ -I$build_folder/runtime/ $prog)
		(ulimit -St $timeout_bound; ./a.out) > $printoutput 2>&1 ## Csmith original paper offered 5 seconds.
		rm -f a.out
		timeout=`cat $printoutput | wc -l`
		if [[ $timeout -eq 0 ]]; then
			time_out_flag=1
			echo "Recognized timeout, skip all sanitizers and checkers!"
		fi
		errorGen=`grep "No such file or directory" $printoutput | wc -l`
		if [[ $errorGen -eq 1 ]]; then
			time_out_flag=1
			echo "Recognized error in generating this test-case, skip all sanitizers and checkers!"
		fi
	}
}

############################################# TESTCASE VALIDATION #############################################
function is_valid_program {
	tool=$1
	filename=$2
	buildprm=$3
	asan_output=$4
	msan_output=$5
	ubsan_output=$6
	framac_output=$7

	## Copy to have the same filename when comparing logs
	cp $filename temp.c

	## Run tests

	## ASAN
	check_wt_ASAN $tool temp.c $buildprm $curr_folder/$asan_output
	## MSAN
	check_wt_MSAN $tool temp.c $buildprm $curr_folder/$msan_output
	## UBSAN
	check_wt_UBSAN $tool temp.c $buildprm $curr_folder/$ubsan_output
	## FRAMA-C
	check_wt_FramaC $tool temp.c $curr_folder $framac_run_folder/$framac_output

	## clean-up
	cd $curr_folder
	rm temp.c
}

## Checks modified code with Frama-C
function check_wt_FramaC {
	tool=$1	
	prog=$2
	curr_folder=$3
	output=$4
	progRMv=$curr_folder/_rmv_$prog
	progOrig=$curr_folder/$prog

	# FRAMA-C
	if [[ $time_out_flag -eq 0 ]]; then ## Only if did not crash and we need to test for dangling pointers
	{
		cd $framac_run_folder
		
		sed 's/volatile/ /g' $progOrig > $progRMv
		ulimit -St 300; frama-c -eva -slevel 100 -plevel 256 -eva-precision 5 -val-warn-undefined-pointer-comparison pointer -no-val-alloc-returns-null -warn-signed-overflow -val -no-val-show-progress -machdep x86_64 $progRMv > $output 2>&1
		rm -f $progRMv

		## Frama-C installation can easiliy be broken, test it:
		countError=`cat $output | grep "cannot load module" | wc -l`
		if [[ $countError -gt 0 ]]; then
			echo ">>>>>> PLEASE re-insall frama-C!"
			cat $output | grep "cannot load module"
			exit
		fi

		## Filter what we need:
		#notes=`cat $output | grep -e "alarms generated by the analysis" -e "invalid memory access" -e "access out of bounds index"`
		sed -i ':a;N;$!ba;s/\n / /g' $output
		if [[ $flag_dang_ptr -eq 1 ]]; then
			cat $output | grep ".c:" | grep -ve "starting to merge loop iterations" -ve "Automatic loop unrolling" -ve "function strcmp" -ve "Values at end of function" -ve "Trace partitioning superposing" -ve "valid_read(argv" -ve "∈" -ve "but got argument of type 'uint" -ve "but got argument of type 'int" -ve "Warning:   unsigned overflow. assert " -ve "assertion 'Eva,unsigned_overflow' got final status invalid." -ve " unsigned overflow." -ve "escaping" > $output.tmp
		else
			cat $output | grep ".c:" | grep -ve "starting to merge loop iterations" -ve "Automatic loop unrolling" -ve "function strcmp" -ve "Values at end of function" -ve "Trace partitioning superposing" -ve "valid_read(argv" -ve "∈" -ve "but got argument of type 'uint" -ve "but got argument of type 'int" -ve "Warning:   unsigned overflow. assert " -ve "assertion 'Eva,unsigned_overflow' got final status invalid." -ve " unsigned overflow." -ve "escaping" -ve "Eva,dangling_pointer" > $output.tmp
		fi
		cp $output.tmp $output
		rm $output.tmp

		cd $curr_folder

		#frama-c -cpp-extra-args="-I$csmith_folder -C -Dvolatile= -E -I."  prog.c 
		## -eva . . . . . . . . . . . . . . . . . . . . .	==> Use the eva plug-in
		## -slevel. . . . . . . . . . . . . . . . . . . .	==> unroll loops, and it makes it propagate separately the states that comefrom thethenandelsebranches of a conditional statement
		## -slevel-function . . . . . . . . . . . . . . .	==> The option-slevel-function f:n tells the analyzer to apply semantic unrolling level n to function f (no need for it)
		## -plevel. . . . . . . . . . . . . . . . . . . .	==> precise when the total number of locations to read or write is less than the value of -plevel option
		## -eva-precision . . . . . . . . . . . . . . . .	==> setting a global trade-off between precision and analysis time from 0 (fast but imprecise) to 11 (accurate but slow) 
		## -val-warn-undefined-pointer-comparison pointer	==> pointer comparison alarms are emitted only on comparisons involving lvalues with pointer type
		## -no-val-alloc-returns-null 				==> supposes that malloc never fails
		## -eva-builtin malloc:Frama_C_malloc_fresh . . .	==> enables builtins for the malloc function of the standard library < NOT SUPPORTED >
	    	## -eva-builtin free:Frama_C_free . . . . . . . .	==> enables builtins for the free function of the standard library < NOT SUPPORTED >
		## -warn-signed-overflow. . . . . . . . . . . . .	==> check that the analyzed code does not overflow on integer operations
		## -warn-unsigned-overflow. . . . . . . . . . . . 	==> check that the analyzed code does not overflow on unsigned integer operations
		## -val . . . . . . . . . . . . . . . . . . . . .	==> Run value analysis plug-in
		## -no-val-show-progress. . . . . . . . . . . . . 	==> omit messages emitted whenever entering a new function (shall be included)
		## -machdep . . . . . . . . . . . . . . . . . . . 	==> defines the target platform (x86_64 seems to be correct)i
	}
	else
		touch $output
		echo "Skips Frama-c for $tool"
	fi
}

## Checks modified code for seg-fault (DEBUG)
function check_plain {
	tool=$1
	prog=$2
	build_folder=$3
	printoutput=$4

	# PLAIN
	{
		rm -f a.out
		(ulimit -St 300; clang-10 -O0 -w -I$build_folder/../runtime/ -I$build_folder/runtime/ $prog)
		(ulimit -St $timeout_bound; ./a.out) > $printoutput 2>&1 ## Csmith original paper offered 5 seconds.
		rm -f a.out
		timeout=`cat $printoutput | wc -l`
		if [[ $timeout -eq 0 ]]; then
			time_out_flag=1
			echo "Recognized timeout, skip all sanitizers and checkers!"
		fi
		errorGen=`grep "No such file or directory" $printoutput | wc -l`
		if [[ $errorGen -eq 1 ]]; then
			time_out_flag=1
			echo "Recognized error in generating this test-case, skip all sanitizers and checkers!"
		fi
	}
}

## Checks modified code with ASAN
function check_wt_ASAN {
	tool=$1
	prog=$2
	build_folder=$3
	printoutput=$4

	if [[ $time_out_flag -eq 0 ]]; then ## Only if did not crash
	# ASAN
	{
		rm -f a.out
		ulimit -St 300; clang-10 -fsanitize=address -O0 -w -fno-omit-frame-pointer -g -I$build_folder/../runtime/ -I$build_folder/runtime/ $prog
		ulimit -St 600; ASAN_OPTIONS=detect_stack_use_after_return=1 ./a.out > $printoutput 2>&1 ## x2 slow down, allow twice the time
		rm -f a.out
		timeout=`cat $printoutput | wc -l`
		if [[ $timeout -eq 0 ]]; then
			time_out_flag=1
			echo "($tool) Recognized timeout (ASAN), skip other sanitizers and checkers!" 
		fi
	}
	else
		touch $printoutput
		echo "Skips ASAN for $tool"
	fi
}

## MSAN: ulimit -St 300; clang-10 -fsanitize=memory -fno-omit-frame-pointer -g -O1 -w -I ../runtime/ -I runtime/ test.c
function check_wt_MSAN {
	tool=$1
	prog=$2
	build_folder=$3
	printoutput=$4

	if [[ $time_out_flag -eq 0 ]]; then ## Only if did not crash
	# MSAN
	{
		rm -f a.out
		ulimit -St 300; clang-10 -fsanitize=memory -fno-omit-frame-pointer -g -O0 -w -I$build_folder/../runtime/ -I$build_folder/runtime/ $prog
		ulimit -St 600; ./a.out > $printoutput 2>&1 ## x2 slow down, allow twice the time
		rm -f a.out
		timeout=`cat $printoutput | wc -l`
		if [[ $timeout -eq 0 ]]; then
			time_out_flag=1
			echo "($tool) Recognized timeout (MSAN), skip other sanitizers and checkers!" 
		fi
	}
	else
		touch $printoutput
		echo "Skips MSAN for $tool"
	fi
}

## UBSAN: ulimit -St 300; clang-10 -fsanitize=undefined -g -O1 -w -I ../runtime/ -I runtime/ test.c
function check_wt_UBSAN {
	tool=$1
	prog=$2
	build_folder=$3
	printoutput=$4

	if [[ $time_out_flag -eq 0 ]]; then ## Only if did not crash
	# UBSAN
	{
		rm -f a.out
		ulimit -St 300; clang-10 -fsanitize=undefined -g -O1 -w -I$build_folder/../runtime/ -I$build_folder/runtime/ $prog
		ulimit -St 600; ./a.out > $printoutput 2>&1 ## x2 slow down, allow twice the time
		rm -f a.out
		timeout=`cat $printoutput | wc -l`
		if [[ $timeout -eq 0 ]]; then
			time_out_flag=1
			echo "($tool) Recognized timeout (UBSAN), skip other sanitizers and checkers!" 
		fi
		cat $printoutput | grep ".c:" | grep -ve "SUMMARY: " -ve " misaligned address 0" > $printoutput.tmp
		cp $printoutput.tmp $printoutput
		rm $printoutput.tmp
	}
	else
		touch $printoutput
		echo "Skips UBSAN for $tool"
	fi
}

############################################################# GENERATE TEST-CASE #############################################################
## Generate a test-case
function gen_test_case {
	curr_seed=$1		#seed
	prog=$2		#program name
	genrator=$3		#csmith_exec
	args=$4		#csmith_args
	
	# set, clean, and generate
	cd $curr_folder; rm -f $prog
	(ulimit -St 150; $genrator $args $CSMITH_USER_OPTIONS --seed $curr_seed > $prog)
}

## Generate probablity per test-case
# 0 --> RRS with Functions (0) or Macro (1) or Both (2) (we always do RRS but can either use safe/unsafe macros or functions or both)
# 1 --> --null-ptr-deref-prob
# 2 --> --dangling-ptr-deref-prob
# 3-end --> array to a file: $wa_probs (0,1,2,3 as 3,4,5,6)
function gen_probs_WA {
	sizeWA=$1	# Size of the array to generate
	seed_curr=$2	# current seed
	threshold=$3	# threshold to ativate WA options
	probArr=()	# Start with an empty array
	
	## Create the probablities ##
	#############################
	
	## Options for RRS: (0,1,2 == functions, macros, mix)
	probArr[0]=$((RANDOM%3))
	## Options for WA:
	for (( i=1; i<$sizeWA; i++ ))
	do  
		probArr[$i]=0
		prob2take=$((RANDOM%1000))
		if [[ $prob2take -gt $threshold ]]; then
			probArr[$i]=$(((RANDOM%probArrRangesTo[$i])+probArrRangesFrom[$i]))
			if [[ ${probArr[$i]} -gt 1000 ]]; then
				probArr[$i]=998
			fi
		fi
	done
	# Bug in csmith, try to avoid it; /home/user42/git/csmith/build/src/csmith --dangling-ptr-deref-prob 1 --seed 2517861355
	#                                 /home/user42/git/csmith/build/src/csmith  --seed 2120095187  --null-ptr-deref-prob 1
	# ad-hoc patch
	if [[ ${probArr[1]} -gt 990 ]]; then
		probArr[1]=990
	fi
	if [[ ${probArr[2]} -gt 990 ]]; then
		probArr[2]=990
	fi

	## Create the command line call to Csmith ##
	############################################
	## If PA is > 0.0 then use --no-paranoid
	args_pa=""
	if [[ ${probArr[1]} -gt 0 ]] || [[ ${probArr[2]} -gt 0 ]]; then
		result1=$(awk '{print $1/$2}' <<<"${probArr[1]} 1000")
		result2=$(awk '{print $1/$2}' <<<"${probArr[2]} 1000")
		args_pa="--no-paranoid --null-ptr-deref-prob $result1 --dangling-ptr-deref-prob $result2"
		## --return-dead-pointer --dangling-global-pointers if dangling is >0
		if [[ ${probArr[2]} -gt 0 ]]; then
			args_pa="$args_pa --no-return-dead-pointer --dangling-global-pointers"
			flag_dang_ptr=1	## Frama-C can detect escaping pointers
		fi
	fi
	
	## If we use the WA with prob > 0, add --relax-anlayses-seed $seed
	args_other_WA=""
	activeWA=0
	rm -f $wa_probs; touch $wa_probs
	for (( i=3; i<$sizeWA; i++ ))
	do
		## Mark WA options as acitve
		if [[ ${probArr[$i]} -gt 0 ]]; then
			activeWA=1
		fi 

		## write to file $wa_probs
		resulti=$(awk '{print $1/$2}' <<<"${probArr[$i]} 1000")
		echo $resulti >> $wa_probs
	done
	if [[ $activeWA -gt 0 ]]; then
		args_other_WA="$wa_args --relax-anlayses-seed $seed_curr"
	else
		args_other_WA=$csmith_args
	fi

	## to use during this test-case generation
	wa_local_args="$args_pa $args_other_WA"
	## Save to restore csmith args to create a test-case
	echo $wa_local_args >> $probfile_curr
	cat $wa_probs >> $probfile_curr

	## Test-case's parameters during compilation:
	if [[ ${probArr[0]} -eq 0 ]]; then 
		## No macros
		echo '-I$csmith_location/$runtime -I$csmith_location/build/runtime' >> $probfile_curr
	else
		if [[ ${probArr[0]} -eq 1 ]]; then
			## With macros
			echo '-I$csmith_location/$runtime -I$csmith_location/build/runtime -DUSE_MATH_MACROS' >> $probfile_curr
		else
			## With mix
			echo '-I$csmith_location/$runtime -I$csmith_location/build/runtime -DUSE_MATH_MIX' >> $probfile_curr
		fi
	fi
}

function gen_RRS_mix_prob {
	prog=$1
	testfile=$2
	res_RRS_Wrapper_type=""

	resTest=`grep "DUSE_MATH_MIX" $testfile | wc -l` 
	if [[ $resTest -gt 0 ]]; then
		lastline=`grep "___REMOVE_SAFE__OP" $prog | tail -1`
		get_max_RRS "$prog" "$lastline"
		threshold_RRS=$((RANDOM%1000))	## Instead of making in 50/50 mix, makes it more intersting
		for (( i=1; i<$maxRRS; i++ ))
		do
			prob2take=$((RANDOM%1000))
			if [[ $prob2take -gt $threshold_RRS ]]; then
				res_RRS_Wrapper_type="$res_RRS_Wrapper_type $i"			
			fi	
		done
		## Test that we really did something
		if [ ${#res_RRS_Wrapper_type} -eq 0 ]; then
			echo ">> (WARNING) list is empty! <$res_RRS_Wrapper_type>"
			res_RRS_Wrapper_type="0"
		fi
	else
		res_RRS_Wrapper_type="0" # Just to mark that it is not in use.	
	fi
	echo $res_RRS_Wrapper_type >> $probfile_curr
}

function get_max_RRS {
	prog=$1
	lastline=$2
	maxRRS=0
	if [ ! -z "$lastline" ]
	then
		declare -i lastindex=0;
		declare -i lastindexlen=0;
		## Find last index
		for (( i=0; i<${#lastline}; i++ )); do 
		    if [ "${lastline:$i:1}" == "_" ]; then
				if [ "${lastline:i:18}" == "___REMOVE_SAFE__OP" ]; then
					lastindex=i+23
					j=$lastindex
					num=${lastline:$j:1}
					while [ ! -z "${num##*[!0-9]*}" ]; do
						j=$j+1
						num=${lastline:$j:1}
					done
					lastindexlen=$j-$lastindex
					#echo "Found index" $lastindex " to " $(( lastindexlen + lastindex ))
				fi
			fi
		done
		
		maxRRS=$((${lastline:lastindex:lastindexlen} + 1))
	fi
}

############################################# TESTCASE - MAIN single seed #############################################
function test_single_seed {

	## Generate the test-cases:

	###############################
	# Building original test-case #
	progA=temp_orig.c
	tool="CSMITH"
	gen_test_case $seed $progA $csmith_build/src/csmith "$csmith_args" ## "$tool-tests"
	linesCsmithProg=`cat $progA | wc -l`
	
	###################################
	# Building new relaxed test-cases #
	progB=temp_edge.c
	tool="CSMITH-WA"
	gen_probs_WA $probSize $seed 500 # 7 $seed 500, but for testing took other parameters (300)
	gen_test_case $seed $progB $csmith_build/src/csmith "$wa_local_args" ## "$tool-tests"
	linesWAProg=`cat $progB | wc -l`
	if [[ $linesWAProg -eq 14 ]]; then ## Error in generation
		touch $rrs_folder/'__test'$seed'INVALID'
		exit
	fi
	diff_lines_progs=`diff -y --suppress-common-lines $progA $progB | wc -l`
	## If the same program, then no need to validate
	if [[ $diff_lines_progs -eq 0 ]]; then
		## Skip --> invalid test for diff-testing
		gen_RRS_mix_prob $progB $probfile_curr
		echo "(same file) Skips validation for $seed"
	elif [[ $diff_lines_progs -eq 1 ]]; then
		## Skip --> invalid test for diff-testing
		gen_RRS_mix_prob $progB $probfile_curr
		echo "(same code) Skips validation for $seed"
	else
		#####################################
		# Validating new relaxed test-cases #

		# INIT
		time_out_flag=0		# If hit once timeout, skip all
		prog=temp_edge.c
		tool="CSMITH-WA"

		## Plain
		check_plain	$tool $prog $csmith_build $curr_folder/Plain2.txt
		if [[ $time_out_flag -eq 0 ]]; then ## Only if did not crash
			gen_RRS_mix_prob $prog $probfile_curr
			is_valid_program $tool $prog "$csmith_build" ASANres2.txt MSANres2.txt UBSANres2.txt Fres2.txt
		else
			touch $curr_folder/ASANres2.txt $curr_folder/MSANres2.txt $curr_folder/UBSANres2.txt $framac_run_folder/Fres2.txt
		fi
		## Keep the flag regarding timeout
		time_out_flag_edge=$time_out_flag

		# INIT
		time_out_flag=0		# If hit once timeout, skip all
		prog=temp_orig.c
		tool="CSMITH"
		
		## Collect date to test
		if [[ $time_out_flag_edge -eq 0 ]]; then ## Only if did not crash
			## Check if there is an error at all (else why to continue testing?)
			ASANresSucc2=`cat $curr_folder/ASANres2.txt  | wc -l`
			MSANresSucc2=`cat $curr_folder/MSANres2.txt  | wc -l`
			UBSANresSucc2=`cat $curr_folder/UBSANres2.txt  | wc -l`
			FramaCresSucc2=`cat $framac_run_folder/Fres2.txt  | wc -l`
			if [[ $ASANresSucc2 -eq 1 ]] && [[ $MSANresSucc2 -eq 1 ]] && [[ $UBSANresSucc2 -eq 0 ]] && [[ $FramaCresSucc2 -eq 0 ]] ; then
				## No problem detected in the new testcase, no need to compare it to the old one!
				echo "(valid code) Skips validation against original testcase for $seed"
			else
				check_plain	$tool $prog $csmith_build $curr_folder/Plain1.txt
				if [[ $time_out_flag -eq 0 ]]; then ## Only if did not crash
					is_valid_program $tool $prog "$csmith_build" ASANres1.txt MSANres1.txt UBSANres1.txt Fres1.txt
				fi
			fi
		fi
		touch $curr_folder/ASANres1.txt $curr_folder/MSANres1.txt $curr_folder/UBSANres1.txt $framac_run_folder/Fres1.txt $curr_folder/Plain1.txt
	fi
}
## Clear all flies before exit
function clean_itr {
	cd $curr_folder
	rm -f rrs.log $curr_folder/__test* $framac_run_folder/Fres1.txt $framac_run_folder/Fres2.txt $curr_folder/ASANres1.txt $curr_folder/ASANres2.txt $curr_folder/MSANres1.txt $curr_folder/MSANres2.txt $curr_folder/UBSANres1.txt $curr_folder/UBSANres2.txt $curr_folder/Plain1.txt $curr_folder/Plain2.txt $framac_run_folder/cutFres1.txt $framac_run_folder/cutFres2.txt $curr_folder/temp.c $curr_folder/temp_orig.c $curr_folder/temp_edge.c $curr_folder/PlainRRS1.txt $curr_folder/PlainRRS2.txt # cleaning before starting
}

####################################### Start Main #######################################
CSMITH_USER_OPTIONS=" --bitfields --packed-struct "
seed=$1 		# File with all the seeds to use - shall be only good seeds here!
base=$2		# base folder
timeout_bound=$3	# csmith-generated programs timeout when diff-testing

probSize=10
probArrRangesFrom=(0 0 0 0 0 0 0 0 150 0)
probArrRangesTo=(1000 1000 1000 1 1 350 500 250 1000 1000)

### EXEC & BUILD LOCATION
csmith_location=$base/csmith
csmith_build=$csmith_location/build
scripts_location=$base/scripts/diff_testing_rate
### ARGS
csmith_args="$CSMITH_USER_OPTIONS --annotated-arith-wrappers"
wa_probs=$scripts_location/seedsProbs/probs_WeakenSafeAnalyse_test.txt
rrs_folder=$scripts_location/seedsProbs/seedsSafeLists
framac_run_folder=$scripts_location/Frama-C-zone
wa_args="$csmith_args --relax-anlayses-conditions --relax-anlayses-prob $wa_probs"
wa_local_args=""

mkdir -p $rrs_folder
cd $scripts_location

## Additionl flags and vars
diff_lines_progs=0	# to test if the programs are the same (and then we don't need validation)
probfile_curr=""	# 
time_out_flag=0		# If hit once timeout, skip all
time_out_flag_edge=0	# to test if a csmithEdge's testcase failed
flag_dang_ptr=0		# Only if created dangling pointers shall call Frama-c
same_result_flage=0	# if results are the same from two compilers
maxRRS=0
curr_folder=`pwd`

timeS=$(date +"%T")
echo " ============= START ITR (seed=$seed) ($timeS) ============="
probfile_curr=$wa_probs$seed
rm -f probfile_curr $wa_probs
#########################################
# Collect data for testing current seed #
test_single_seed
################
# Print Report #
cd $curr_folder
general_report
# cleaning before exit
clean_itr
