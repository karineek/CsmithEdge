#!/bin/bash
number_of_progs=10	# Set to be 10 for artifact; for accurate reasults please set to 100000

function diff_testing {
	timeout_bound=$1
	i=1
	rm $output
	touch $output
	
	time1=$(date +"%T")
	######################################## Start Cov. ########################################
	# Loop over compilation and coverage measurement
	while IFS= read -r seed;
	do
		## Generate
		$AE_path/../scripts/diff_testing_rate/WA1_post_gen_test_quick.sh $seed $base $timeout_bound >> $output 2>&1
		
		# Break after 10
		((i++))
		if [[ $i -gt $number_of_progs ]]; then
			break
		fi
	done < "$seeds"
	time2=$(date +"%T")

	StartDate=$(date -u -d "$time1" +"%s.%N")
	FinalDate=$(date -u -d "$time2" +"%s.%N")
	T=`date -u -d "0 $FinalDate sec - $StartDate sec" +"%H:%M:%S.%N"`

	Y=`grep "Valid: " $output | wc -l`
	Z=`grep "Valid: YES" $output | wc -l`
	X=`grep "Valid: NO" $output | wc -l`
	ZT=`grep -e"Valid:" -e"./WA1_post_gen_test_quick.sh: line" $output | grep -B1 "TIMEOUT: 1" | grep "CPU time limit exceeded" | wc -l`
	
	echo " >> CsmithEdge-Lazy Generated ($Y) Programs in ($T) time; it got ($X) timed-out or UB programs ($ZT of which are timed-out), and ($Z) valid and terminating within $timeout_bound s programs."
}
################################################# MAIN #################################################
base=$1
seeds=$2
output=$3

current_location=`pwd`
cd $base/AE
AE_path=`pwd`

diff_testing 10
diff_testing 50
diff_testing 120

echo " >> Note: for the paper's results we measure the time according to the start/end time in $output. The time in this script is some more general evaluation for short time. To get more accurate results one shall increase the number of generated programs to be a large number."
echo "DONE."
