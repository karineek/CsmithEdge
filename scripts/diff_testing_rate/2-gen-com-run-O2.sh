#!/bin/bash 
baseD=$1		# e.g., /home/user42
seeds=$2		# e.g., "../../Data/seeds_all/seeds_out1.txt"
timeout_bound=$3	# csmith-generated programs timeout when diff-testing
######################################## Start Cov. ########################################
# Loop over compilation and coverage measurement
echo ">> Tool, Result GCC O2, Result CLANG O2, SEED, File-Size, Start, End, Ver-Start, Ver-End, Gen-Start, Gen-End, DIFF-Start, DIFF-END, TEST1-Comp-Start, TEST1-RUN-Start, TEST1-RUN-end, TEST2-Comp-Start, #line csmith, #lines wa, Delta, Valid, UB-NON-FREEDOM REASON, FaildRRS, Parameters"
while IFS= read -r seed
do
	## Generate
	./WA1_post_gen_test_v2.sh $seed $baseD $timeout_bound 1
done < "$seeds"
time2=$(date +"%T")
echo "DONE."
