#!/bin/bash

seeds=$1 	# File with all the seeds to use - shall be only good seeds here!
echo ">> Reads seeds from" $seeds
while IFS= read -r line
do
	#./src/csmith --annotated-arith-wrappers --relax-anlayses-conditions --relax-anlayses-prob /home/user42/git/MinCond/csmith/build/probs_WeakenSafeAnalyse.txt --seed $line > t2.c
	#./src/csmith --annotated-arith-wrappers --seed $line > t1.c
	./src/csmith --relax-anlayses-conditions --relax-anlayses-prob /home/user42/git/MinCond/csmith/build/probs_WeakenSafeAnalyse.txt --seed $line --relax-anlayses-seed $line > t2.c
	/home/user42/git/csmith/build/src/csmith --seed $line > t1.c
	#diff -y --suppress-common-lines t1.c t2.c
	diff -y t1.c t2.c
	lines1=`wc -l t1.c`	
	lines2=`wc -l t2.c`	
	echo ">> Seed: $line | lines t1: $lines1 | lines t2: $lines2"
done < "$seeds"
