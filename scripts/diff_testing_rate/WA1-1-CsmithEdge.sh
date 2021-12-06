############################################# Relax Test Case #############################################
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
		result_i=$(awk '{print $1/$2}' <<<"${probArr[$i]} 1000")
		echo $result_i >> $wa_probs
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
			#echo ">> (WARNING) list is empty! <$res_RRS_Wrapper_type>"
			res_RRS_Wrapper_type="0"
		fi
	else
		res_RRS_Wrapper_type="0" # Just to mark that it is not in use.	
	fi
	echo $res_RRS_Wrapper_type >> $testfile
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
####################################### Start Main #######################################
timeS=$(date +"%T")	# Measure time start

### In-params
seed=$1 			# File with all the seeds to use - shall be only good seeds here!
base=$2			# base folder
timeout_bound=$3		# csmith-generated programs timeout when diff-testing
### Generation Constants
probSize=10
probArrRangesFrom=(0 0 0 0 0 0 0 0 150 0)
probArrRangesTo=(1000 1000 1000 1 1 350 500 250 1000 1000)
CSMITH_USER_OPTIONS=" --bitfields --packed-struct "
### EXEC & BUILD LOCATION
csmith_location=$base/csmith
csmith_build=$csmith_location/build
scripts_location=$base/scripts/diff_testing_rate
### ARGS
csmith_args="$CSMITH_USER_OPTIONS --annotated-arith-wrappers"
wa_probs=$scripts_location/seedsProbs/probs_WeakenSafeAnalyse_test.txt
rrs_folder=$scripts_location/seedsProbs/seedsSafeLists
wa_args="$csmith_args --relax-anlayses-conditions --relax-anlayses-prob $wa_probs"
wa_local_args=""
maxRRS=0

rm -rf $base/tmp/
mkdir -p $base/tmp/
TMPFILE=$base$(mktemp).c
probfile_curr=$wa_probs$seed
rm -f $probfile_curr $wa_probs $TMPFILE

###################################
# Building new relaxed test-cases 
###################################
gen_probs_WA $probSize $seed 500
(ulimit -St 150; $csmith_build/src/csmith $wa_local_args --seed $seed) > $TMPFILE

## Check Error in generation
linesWAProg=`cat $TMPFILE | wc -l`
if [[ $linesWAProg -eq 14 ]] || [[ $linesWAProg -eq 0 ]] ; then
	rm $TMPFILE ; exit
fi

## Safe math relaxation
gen_RRS_mix_prob $TMPFILE $probfile_curr	## Generate the probablities
cd $scripts_location; mkdir -p $rrs_folder ; TMPFILE_RRS=$base/$(mktemp)
(ulimit -St 250; ./WA4_restore_RRS_given_prog.sh "clang-11" "$seed" "$rrs_folder" $TMPFILE $csmith_location $timeout_bound) > $TMPFILE_RRS 2>&1	# Generate the to-relax list
if [[ `grep ">> Plain Failed" $TMPFILE_RRS` == *">> Plain Failed"* ]] ; then
	cat $TMPFILE_RRS ; rm $TMPFILE_RRS ; exit
fi
testcaseRes='seedsProbs/seedsSafeLists'/'__test'$seed'Results'
if [ ! -f $testcaseRes ] ; then
	echo ">> Plain Failed - cannot find RRS Analysis Results"; rm $TMPFILE_RRS; exit
fi
(./WA5_restore_testcase_given_prog.sh $seed $TMPFILE $testcaseRes) 

## If All OK, print the program
progM=__test$seed"M.c"
cat $progM ; 
size_err=`cat $TMPFILE_RRS | wc -l`
if [[ $size_err -gt 0 ]] ; then
	echo "/* Error During Analysis: " ; cat $TMPFILE_RRS ; echo "*/"
fi
rm $progM $TMPFILE $TMPFILE_RRS
### END
