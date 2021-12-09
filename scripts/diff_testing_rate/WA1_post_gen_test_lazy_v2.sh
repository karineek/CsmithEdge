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

### EXEC & BUILD LOCATION
csmith_build=$base/csmith/build
scripts_location=$base/scripts/diff_testing_rate
### ARGS
csmith_args="$CSMITH_USER_OPTIONS --annotated-arith-wrappers"
wa_probs=$scripts_location/seedsProbs/probs_WeakenSafeAnalyse_test.txt
rrs_folder=$scripts_location/seedsProbs/seedsSafeLists
framac_run_folder=$scripts_location/Frama-C-zone
UBfreedom_RC=""
BUGS=$scripts_location/BUGS
####

mkdir -p $rrs_folder $BUGS
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
	## We assume we generated a UB-free program
	## We later - after excuting the tests check this assumption.
	valid=1
fi
## Set to default
timeSV=$timeEG
timeEV=$timeEG
diff_lines_progs=0
linesWAProg=0
linesCsmithProg=0	

timeST=$(date +"%T")
## Run Tests x2
if [[ $valid -eq 1 ]]; then
	testcaseRes='seedsProbs/seedsSafeLists'/'__test'$seed'Results'
	err_rrs=`(./WA5_restore_testcase_given_prog.sh "$seed" "__temp_edge.c" "$testcaseRes")`
	progM=__test$seed"M.c"
	if [ -f $progM ] && [ -f $testcaseRes ] ; then
		## Run modify
		filesize=`stat --printf="%s" $progM`	
		timeSTEX1=$(date +"%T")
		execute_test $progM $csmith_build "$scripts_location/Plain11.txt" "clang-10 -O2 -w"	
		timeSTEX2=$(date +"%T")	
		execute_test $progM $csmith_build "$scripts_location/Plain10.txt" "gcc-10 -O2 -w"
		timeSTEX3=$(date +"%T")
		res1=`cat $scripts_location/Plain10.txt`
		res2=`cat $scripts_location/Plain11.txt`
		## Test diff
		if [[ $res1 != $res2 ]] ; then
			# First test if UB-free
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
				
				# IF UB-free, print the diff
				echo ">> Diff: <$res1> vs. <$res2>"
				cp $progM $BUGS/
			else
				valid=0
				## Failed Validation of UB-free program: result already in UBfreedom_RC
				## Don't print the diff in this case
			fi
		else
			valid=2
			timeSV=$timeSTEX3
			timeEV=$timeSTEX3
		fi
	else 
		valid=0
		UBfreedom_RC=">> Failed Generating $progM"
		## Failed Restoring Program after RRS
	fi
	rm -rf $progM # Don't need it now
else
	timeSTEX1=$timeST
	timeSTEX2=$timeST
	timeSTEX3=$timeST
	timeSV=$timeSTEX3
	timeEV=$timeSTEX3
fi
timeET=$(date +"%T")

###################################
## Output Final
###################################
params=`cat "$wa_probs$seed" | tr "\n" "|"`
(rm Plain10.txt Plain11.txt __temp_edge.c __temp_orig.c test1e.txt test2c.txt test2e.txt test3c.txt test3e.txt test4c.txt test4e.txt test5c.txt test5e.txt temp.c res1.txt res2.txt probs_WeakenSafeAnalyse.txt platform.info output.txt csmith_test.c) > /tmp/err 2>&1
timeE=$timeET
echo ">> CsmithEdge-Lazy, $res1, $res2, $seed, $filesize, $timeS, $timeE, $timeSV, $timeEV, $timeSG, $timeEG, $timeST, $timeET, $timeSTEX1, $timeSTEX2, $timeSTEX2, $timeSTEX3, $linesCsmithProg, $linesWAProg, $diff_lines_progs, $valid, ($UBfreedom_RC), ($err_rrs), ($params)"
## END
