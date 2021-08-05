#!/bin/bash 
base=$1					# e.g., /home/user42
nb_progs_to_gen=$2				# e.g., 100000
timeout_bound=$3				# csmith-generated programs timeout when diff-testing
csmith_location=$base/csmith			# csmith location
genrator=$csmith_location/build/src/csmith	# build
csmith_flags=" --bitfields --packed-struct "
i=0

######################################## Start Cov. ########################################
# Loop over compilation and coverage measurement
prog=csmith_test.c
while (( $i < $nb_progs_to_gen ));
do
	i=$(($i+1))
	time2=$(date +"%T")
 	echo "--> Generating Program "$i" out of "$nb_progs_to_gen"... (time="$time2")"

	## Generate
	rm $prog
 	(ulimit -St 150; $genrator $csmith_flags > $prog)
 	seed=`grep "Seed: " $prog`
	filesize=`stat --printf="%s" $prog`
	echo "seed= $seed, size= $filesize"
	
 	## Test -O0
 	rm -f a.out
	(ulimit -St 300; clang-10 -O2 -w -I$csmith_location/build/runtime/ -I$csmith_location/runtime/ $prog)
	res1=`(ulimit -St $timeout_bound; ./a.out)` ## Csmith original paper offered 5 seconds.
	echo "$res1" 
	 	
 	## Test -O2
 	rm -f a.out
	(ulimit -St 300; gcc-10 -O2 -w -I$csmith_location/build/runtime/ -I$csmith_location/runtime/ $prog)
	res2=`(ulimit -St $timeout_bound; ./a.out)` ## Csmith original paper offered 5 seconds.
	echo "$res2"
	
	## Test diff
	if [[ $res1 != $res2 ]] ; then 
		echo ">> Diff: <$res1> vs. <$res2>"
	fi
done
time2=$(date +"%T")
echo "DONE."
