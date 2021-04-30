#!/bin/bash
baseD=$1		# e.g., /home/user42
nb_progs_to_gen=$2	# e.g., 100000
i=$3			# e.g., 1
base=$baseD/RRS_EXPR 	# $baseD/git/RRS_EXPR

######################################## Start Cov. ########################################
# Loop over compilation and coverage measurement
seeds="../../Data/seeds_all/seeds_out$i.txt"
while IFS= read -r seed
do
	## Generate
	./WA1_post_gen_test_quick.sh $seed $baseD
done < "$seeds"
time2=$(date +"%T")
echo "DONE."
