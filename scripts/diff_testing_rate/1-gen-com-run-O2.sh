#!/bin/bash 
base=$1                                         # e.g., /home/user42
nb_progs_to_gen=$2                              # e.g., 100000
timeout_bound=$3                                # csmith-generated programs timeout when diff-testing
csmith_location=$base/csmith                    # csmith location
genrator=$csmith_location/build/src/csmith      # build
csmith_flags=" --bitfields --packed-struct "
i=0

######################################## Start Cov. ########################################
# Loop over compilation and coverage measurement
prog=csmith_test.c
echo ">> Tool, Iteration, Result GCC O2, Result CLANG O2, SEED, File-Size, Start, End, Gen-Start, Gen-End, DIFF-Start, DIFF-END, TEST1-Comp-Start, TEST1-RUN-Start, TEST1-RUN-end, TEST2-Comp-Start, TEST2-Comp-end/TEST2-RUN-Start, TEST2-RUN-end"
while (( $i < $nb_progs_to_gen ));
do
        ## Generat
        time1=$(date +"%T")
        i=$(($i+1))
        rm $prog res1.txt
	res1=""
	res2=""
        (ulimit -St 150; $genrator $csmith_flags > $prog)
        seed=`grep "Seed: " $prog`
        filesize=`stat --printf="%s" $prog`
        time2=$(date +"%T")

        ## Test -O0
        time3=$time2
        rm -f a1.out res1.txt
        (ulimit -St 300; clang-10 -O2 -w -I$csmith_location/build/runtime/ -I$csmith_location/runtime/ $prog -o a1.out)
        time4=$(date +"%T")
	(ulimit -St $timeout_bound; ./a1.out) > res1.txt 2>&1  ## Csmith original paper offered 5 seconds.
        if [[ `grep -e'time limit' -e'Killed' res1.txt | wc -l` -gt 0 ]] ; then
                ## Timeout skip to make if far with CsmithEdge
		echo ">>i>>>> Csmith, $i, $res1, $res2, $seed, $filesize, $time1, $time4, $time1, $time2, $time3, $time4, $time3, $time4, $time4, $time4, $time4, $time4"
        else        
                res1=`cat res1.txt`
                time5=$(date +"%T")
                ## Test -O2
                time6=$time5
                rm -f a2.out
                (ulimit -St 300; gcc-10 -O2 -w -I$csmith_location/build/runtime/ -I$csmith_location/runtime/ $prog -o a2.out)
                time7=$(date +"%T")
                res2=`(ulimit -St $timeout_bound; ./a2.out)` ## Csmith original paper offered 5 seconds.
                time8=$(date +"%T")
                ## Test diff
                if [[ $res1 != $res2 ]] ; then
                        echo ">> Diff: <$res1> vs. <$res2>"
                fi
                time9=$(date +"%T")
                echo ">> Csmith, $i, $res1, $res2, $seed, $filesize, $time1, $time9, $time1, $time2, $time3, $time9, $time3, $time4, $time5, $time6, $time7, $time8"
        fi
done
time2=$(date +"%T")
echo "DONE."
