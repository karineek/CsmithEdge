#!/bin/bash 
i=$1
baseD=/home/user42
base=$baseD/RRS_EXPR # $baseD/git/RRS_EXPR
nb_progs_to_gen=50000

######################################## Start Cov. ########################################
# Loop over compilation and coverage measurement
seeds="../../Data/seeds_all/seeds_out$i.txt"
while IFS= read -r seed
do
	## Generate
	./WA1_post_gen_test.sh $seed $baseD
done < "$seeds"
time2=$(date +"%T")
echo "DONE."
