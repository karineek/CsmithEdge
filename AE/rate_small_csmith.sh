#!/bin/bash
number_of_progs=10	# Set to be 10 for artifact; for accurate results please set to 100000

function diff_testing {
	timeout_bound=$1
	time1=$(date +"%T")
	$AE_path/../scripts/diff_testing_rate/1-gen-com-run-O2.sh $base $number_of_progs $timeout_bound > $output 2>&1
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
output=$2

current_location=`pwd`
cd $base/AE
AE_path=`pwd`

diff_testing 10
diff_testing 50
diff_testing 120

rm a.out 
rm csmith_test.c 
rm platform.info 
echo " >> Note: for the paper's results we measure the time according to the start/end time in $output. The time in this script is some more general evaluation for short time. To get more accurate results one shall increase the number of generated programs to be a large number."
echo "DONE."
