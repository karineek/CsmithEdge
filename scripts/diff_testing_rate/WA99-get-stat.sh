#!/bin/bash
tool=$1	# 0 - Csmith, 1 - CsmithEdge, and 2 - CsmithEdge-Lazy
logger=$2	# Logger of the 24 H experiment
################## START ######################

### TOTAL
if [[ $tool -eq 1 ]] ;then
	sample_size=`grep -a ">> CsmithEdge," $logger | wc -l`
	
	## VALID
	valid=`grep -a ">> CsmithEdge," $logger | cut -d',' -f21 | awk '{if ($1 == "1") sum+=1;} END{print sum}'`
	valid_skip=0
	invalid=`grep -a ">> CsmithEdge," $logger | cut -d',' -f21 | awk '{if ($1 == "0") sum+=1;} END{print sum}'`
elif [[ $tool -eq 2 ]] ; then
	sample_size=`grep -a ">> CsmithEdge-Lazy," $logger | wc -l`
	
	## VALID
	valid=`grep -a ">> CsmithEdge-Lazy," $logger | cut -d',' -f21 | awk '{if ($1 == "1") sum+=1;} END{print sum}'`
	valid_skip=`grep -a ">> CsmithEdge-Lazy," $logger | cut -d',' -f21 | awk '{if ($1 == "2") sum+=1;} END{print sum}'`
	invalid=`grep -a ">> CsmithEdge-Lazy," $logger | cut -d',' -f21 | awk '{if ($1 == "0") sum+=1;} END{print sum}'`
else
	sample_size=`grep -a ">> Csmith," $logger | wc -l`
	valid=`grep -a ">> Csmith," $logger | cut -d',' -f4 | grep -e"checksum" | wc -l`
	invalid=`grep -a ">> Csmith," $logger | cut -d',' -f4 | grep -ve"checksum" | wc -l`
	valid_skip=0
fi

### DIFF
miscomp=`grep -a ">> Diff: " $logger | grep -ve"<>" | wc -l` # Real mis-comp without performance issues


### REASONS:
asan_comp=`grep -a ">> ASAN Failed Compilation" $logger | wc -l`
asan_timeout=`grep -a ">> ASAN Failed TIMEOUT" $logger | wc -l`
asan_analysis=`grep -a ">> Failed ASAN Analysis" $logger | wc -l`
asan=`grep -a "ASAN" $logger | wc -l`

msan_comp=`grep -a ">> MSAN Failed Compilation" $logger | wc -l`
msan_timeout=`grep -a ">> MSAN Failed TIMEOUT" $logger | wc -l`
msan_analysis=`grep -a ">> Failed MSAN Analysis" $logger | wc -l`
msan=`grep -a "MSAN" $logger | wc -l`

ubsan_comp=`grep -a ">> UBSAN Failed Compilation" $logger | wc -l`
ubsan_timeout=`grep -a ">> UBSAN Failed TIMEOUT" $logger | wc -l`
ubsan_analysis=`grep -a ">> Failed UBSAN Analysis" $logger | wc -l`
ubsan=`grep -a "UBSAN" $logger | wc -l`

framac_analysis=`grep -a ">> Failed Frama-c Analysis" $logger | wc -l`
framac=`grep -a -e 'Frama-c' -e'frama-c' $logger | wc -l`

plain_comp=`grep -a ">> Plain Failed Compilation" $logger | wc -l`
plain_timeout=`grep -a ">> Plain Failed TIMEOUT" $logger | wc -l`
plain_seg=`grep -a ">> Plain Failed Segmentation fault" $logger | wc -l`
plain_ill_inst=`grep -a ">> Plain Failed Illegal instruction" $logger | wc -l`
plain=`grep -a "Plain" $logger | wc -l`


general_1=`grep -a ">> Failed Generating " $logger | wc -l`
general_2=`grep -a ">> Plain Failed due to other errors" $logger | wc -l`
general_3=`grep -a ">> Plain Failed. Skip the test" $logger | wc -l`

rrs_1=`grep -a ">> Plain Failed - cannot find RRS Analysis Results" $logger | wc -l`
rrs_2=`grep -a " >> Empty testcase list A" $logger | wc -l`
rrs_3=`grep -a " >> Cannot find testcase list A" $logger | wc -l`
rrs_4=`grep -a " >> Cannot find testcase file A" $logger | wc -l`
rrs_5=`grep -a " >> Empty testcase list" $logger | wc -l`
rrs_6=`grep -a " >> Cannot find testcase list" $logger | wc -l`
rrs_7=`grep -a " >> Cannot find testcase file" $logger | wc -l`
env_1=`grep -a ">>>>>> PLEASE re-insall frama-C!" $logger | wc -l`

all=`grep -a ">> Csmith" $logger | cut -d',' -f22 | grep -ve"()" | wc -l`

echo ">> $sample_size, $valid, $valid_skip, $invalid, ($all), $miscomp"
echo ">>> ASAN: $asan_comp, $asan_timeout, $asan_analysis, ($asan)"
echo ">>> MSAN: $msan_comp, $msan_timeout, $msan_analysis, ($msan)"
echo ">>> UBSAN: $ubsan_comp, $ubsan_timeout, $ubsan_analysis, ($ubsan)"
echo ">>> Frama-C: $env_1, $framac_analysis, $framac"
echo ">>> Plain: $plain_comp, $plain_timeout, $plain_seg, $plain_ill_inst, ($plain)"
echo ">>> General-Plain: $rrs_1, $general_2, $general_3"
echo ">>> General-RRS: $general_1, $rrs_2, $rrs_3, $rrs_4, $rrs_5, $rrs_6, $rrs_7"
