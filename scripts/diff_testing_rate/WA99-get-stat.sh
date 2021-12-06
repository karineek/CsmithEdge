#!/bin/bash
tool=$1	# 0 - Csmith, 1 - CsmithEdge, and 2 - CsmithEdge-Lazy
logger=$2	# Logger of the 24 H experiment
################## START ######################

### TOTAL
if [[ $tool -eq 1 ]] ;then
	sample_size=`grep ">> CsmithEdge," $logger | wc -l`
	
	## VALID
	valid=`grep ">> CsmithEdge," $logger | cut -d',' -f21 | awk '{if ($1 == "1") sum+=1;} END{print sum}'`
	valid_skip=0
	invalid=`grep ">> CsmithEdge," $logger | cut -d',' -f21 | awk '{if ($1 == "0") sum+=1;} END{print sum}'`
elif [[ $tool -eq 2 ]] ; then
	sample_size=`grep ">> CsmithEdge-Lazy," $logger | wc -l`
	
	## VALID
	valid=`grep ">> CsmithEdge-Lazy," $logger | cut -d',' -f21 | awk '{if ($1 == "1") sum+=1;} END{print sum}'`
	valid_skip=`grep ">> CsmithEdge-Lazy," $logger | cut -d',' -f21 | awk '{if ($1 == "2") sum+=1;} END{print sum}'`
	invalid=`grep ">> CsmithEdge-Lazy," $logger | cut -d',' -f21 | awk '{if ($1 == "0") sum+=1;} END{print sum}'`
else
	sample_size=`grep ">> Csmith," $logger | wc -l`
	valid=`grep ">> Csmith," $logger  | cut -d',' -f4 | grep -e"checksum" | wc -l`
	invalid=`grep ">> Csmith," $logger  | cut -d',' -f4 | grep -ve"checksum" | wc -l`
	valid_skip=0
fi

### DIFF
miscomp=`grep ">> Diff: " $logger | grep -ve"<>" | wc -l` # Real mis-comp without performance issues


### REASONS:
asan_comp=`grep ">> ASAN Failed Compilation" $logger | wc -l`
asan_timeout=`grep ">> ASAN Failed TIMEOUT" $logger | wc -l`
asan_analysis=`grep ">> Failed ASAN Analysis" $logger | wc -l`
asan=`grep "ASAN" $logger | wc -l`

msan_comp=`grep ">> MSAN Failed Compilation" $logger | wc -l`
msan_timeout=`grep ">> MSAN Failed TIMEOUT" $logger | wc -l`
msan_analysis=`grep ">> Failed MSAN Analysis" $logger | wc -l`
msan=`grep "MSAN" $logger | wc -l`

ubsan_comp=`grep ">> UBSAN Failed Compilation" $logger | wc -l`
ubsan_timeout=`grep ">> UBSAN Failed TIMEOUT" $logger | wc -l`
ubsan_analysis=`grep ">> Failed UBSAN Analysis" $logger | wc -l`
ubsan=`grep "UBSAN" $logger | wc -l`

framac_analysis=`grep ">> Failed Frama-c Analysis" $logger | wc -l`
framac=`grep -e'Frama-c' -e'frama-c' $logger | wc -l`

plain_comp=`grep ">> Plain Failed Compilation" $logger | wc -l`
plain_timeout=`grep ">> Plain Failed TIMEOUT" $logger | wc -l`
plain_seg=`grep ">> Plain Failed Segmentation fault" $logger | wc -l`
plain_ill_inst=`grep ">> Plain Failed Illegal instruction" $logger | wc -l`
plain=`grep "Plain" $logger | wc -l`


general_1=`grep ">> Failed Generating " $logger | wc -l`
general_2=`grep ">> Plain Failed due to other errors" $logger | wc -l`
general_3=`grep ">> Plain Failed. Skip the test" $logger | wc -l`

rrs_1=`grep ">> Plain Failed - cannot find RRS Analysis Results" $logger | wc -l`
rrs_2=`grep " >> Empty testcase list A" $logger | wc -l`
rrs_3=`grep " >> Cannot find testcase list A" $logger | wc -l`
rrs_4=`grep " >> Cannot find testcase file A" $logger | wc -l`
rrs_5=`grep " >> Empty testcase list" $logger | wc -l`
rrs_6=`grep " >> Cannot find testcase list" $logger | wc -l`
rrs_7=`grep " >> Cannot find testcase file" $logger | wc -l`
env_1=`grep ">>>>>> PLEASE re-insall frama-C!" $logger | wc -l`

all=`grep ">> Csmith" $logger | cut -d',' -f22 | grep -ve"()" | wc -l`

echo ">> $sample_size, $valid, $valid_skip, $invalid, ($all), $miscomp"
echo ">>> ASAN: $asan_comp, $asan_timeout, $asan_analysis, ($asan)"
echo ">>> MSAN: $msan_comp, $msan_timeout, $msan_analysis, ($msan)"
echo ">>> UBSAN: $ubsan_comp, $ubsan_timeout, $ubsan_analysis, ($ubsan)"
echo ">>> Frama-C: $env_1, $framac_analysis, $framac"
echo ">>> Plain: $plain_comp, $plain_timeout, $plain_seg, $plain_ill_inst, ($plain)"
echo ">>> General-Plain: $rrs_1, $general_2, $general_3"
echo ">>> General-RRS: $general_1, $rrs_2, $rrs_3, $rrs_4, $rrs_5, $rrs_6, $rrs_7"
