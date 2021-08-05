#!/bin/bash
number_of_progs=10	# Set to be 10 for artifact; for accurate reasults please set to 100000

function diff_testing {
	timeout_bound=$1
	i=0
	time1=$(date +"%T")
	######################################## Start Cov. ########################################
	# Loop over compilation and coverage measurement
	while IFS= read -r seed && (( $i < $number_of_progs ));
	do
		## Generate
		echo "$AE_path/../scripts/diff_testing_rate/WA1_post_gen_test.sh $seed $base $timeout_bound"
		exit
		$AE_path/../scripts/diff_testing_rate/WA1_post_gen_test.sh $seed $base $timeout_bound
		i=$(($i+1))
	done < "$seeds"
	time2=$(date +"%T")

	StartDate=$(date -u -d "$time1" +"%s.%N")
	FinalDate=$(date -u -d "$time2" +"%s.%N")
	T=`date -u -d "0 $FinalDate sec - $StartDate sec" +"%H:%M:%S.%N"`

	Y=`grep "Generating Program" $output | wc -l`
	Z=`grep "checksum" $output | wc -l`
	X=`sed 's:^$:TIMEOUTBAD:g' $output | grep "TIMEOUTBAD" | wc -l`

	echo " >> Csmith Generated ($Y) Programs in ($T) time; it got ($X) timed-out runs, and ($Z) terminating within $timeout_bound s runs."
}
################################################# MAIN #################################################
base=$1
AE_location=$2
seeds=$3
output=$4

current_location=`pwd`
cd $AE_location
AE_path=`pwd`

diff_testing 10
diff_testing 50
diff_testing 120

rm a.out 
rm csmith_test.c 
rm platform.info 

echo " >> Note: for the paper's results we measure the time according to the start/end time in $output. The time in this script is some more general evaluation for short time. To get more accurate results one shall increase the number of generated programs to be a large number."
echo "DONE."
