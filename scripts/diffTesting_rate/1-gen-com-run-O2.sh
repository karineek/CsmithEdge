#!/bin/bash 
baseD=$1					# /home/user42
base=$baseD/RRS_EXPR 				# $baseD/git/RRS_EXPR
csmith_location=$base/csmith			# csmith location
genrator=$csmith_location/build/src/csmith	# build
outputs_location=../../ 			# where we will put all outputs
csmith_flags=" --bitfields --packed-struct "
nb_progs_to_gen=100000
i=0

prog=csmith_test.c
build_folder=$csmith_location
echo "$build_folder"

######################################## Start Cov. ########################################
# Loop over compilation and coverage measurement
while (( $i < $nb_progs_to_gen ));
do
	i=$(($i+1))
	time2=$(date +"%T")
 	echo "--> Generating Program "$i" out of "$nb_progs_to_gen"... (time="$time2")"

	## Generate
	rm $prog
 	ulimit -St 150; $genrator $csmith_flags > $prog
 	seed=`grep "Seed: " $prog`
	filesize=`stat --printf="%s" $prog`
	echo "seed= $seed, size= $filesize"
	
 	## Test -O0
 	rm -f a.out
	ulimit -St 300; clang-10 -O2 -w -I$build_folder/build/runtime/ -I$build_folder/runtime/ $prog
	res1=`ulimit -St 50; ./a.out` ## Csmith original paper offered 5 seconds.
	echo "$res1" 
	 	
 	## Test -O2
 	rm -f a.out
	ulimit -St 300; gcc-10 -O2 -w -I$build_folder/build/runtime/ -I$build_folder/runtime/ $prog
	res2=`ulimit -St 50; ./a.out` ## Csmith original paper offered 5 seconds.
	echo "$res2"
	
	## Test diff
	if [[ $res1 != $res2 ]] ; then 
		echo ">> Diff: <$res1> vs. <$res2>"
	fi
done
time2=$(date +"%T")
echo "DONE."
