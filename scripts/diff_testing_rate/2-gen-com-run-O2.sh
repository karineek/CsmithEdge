#!/bin/bash 
baseD=$1		# e.g., /home/user42
seeds=$2		# e.g., "../../Data/seeds_all/seeds_out1.txt"
timeout_bound=$3	# csmith-generated programs timeout when diff-testing
######################################## Start Cov. ########################################
# Loop over compilation and coverage measurement
while IFS= read -r seed
do
	## Generate
	./WA1_post_gen_test.sh $seed $baseD $timeout_bound
done < "$seeds"
