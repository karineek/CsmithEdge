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
	all_valid=$valid
elif [[ $tool -eq 2 ]] ; then
	sample_size=`grep -a ">> CsmithEdge-Lazy," $logger | wc -l`
	
	## VALID
	valid=`grep -a ">> CsmithEdge-Lazy," $logger | cut -d',' -f21 | awk '{if ($1 == "1") sum+=1;} END{print sum}'`
	valid_skip=`grep -a ">> CsmithEdge-Lazy," $logger | cut -d',' -f21 | awk '{if ($1 == "2") sum+=1;} END{print sum}'`
	invalid=`grep -a ">> CsmithEdge-Lazy," $logger | cut -d',' -f21 | awk '{if ($1 == "0") sum+=1;} END{print sum}'`
	all_valid=$(($valid + $valid_skip))
else
	sample_size=`grep -a ">> Csmith," $logger | wc -l`
	
	valid=`grep -a ">> Csmith," $logger | cut -d',' -f4 | grep -e"checksum" | wc -l`
	valid_skip=0
	invalid=`grep -a ">> Csmith," $logger | cut -d',' -f4 | grep -ve"checksum" | wc -l`
	all_valid=$valid
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
echo "..."
echo ">> Hourly rate: $(($sample_size/ 24))"
echo ">> Hourly rate - valid : $(($all_valid / 24))"
if [[ $tool -eq 0 ]] ;then
	avgS=`grep ">> Csmith" $logger | cut -d',' -f6  | awk '{if ($1 != "") {line+=1; sum+=$1;}} END{print sum/line}'`
	echo ">> AVG. size (valid only): $avgS"
	
	avgT=`grep ">> Csmith" $logger | cut -d',' -f7,8 | sed 's:,::g' | awk 'function to_time(time,t,a) {split(time, a, ":"); t = mktime("1970 1 1 " a[1] " " a[2] " " a[3]);return t} {gap=(to_time($2)-to_time($1)+(24*60*60))%(24*60*60); print gap}' | datamash -s mean 1`
	echo ">> AVG. time: $avgT"
	
	medianT=`grep ">> Csmith" $logger | cut -d',' -f7,8 | sed 's:,::g' | awk 'function to_time(time,t,a) {split(time, a, ":"); t = mktime("1970 1 1 " a[1] " " a[2] " " a[3]);return t} {gap=(to_time($2)-to_time($1)+(24*60*60))%(24*60*60); print gap}' | datamash -s median 1`
	echo ">> Median time: $medianT"
	
	avgTG=`grep ">> Csmith" $logger | cut -d',' -f9,10 | sed 's:,::g' | awk 'function to_time(time,t,a) {split(time, a, ":"); t = mktime("1970 1 1 " a[1] " " a[2] " " a[3]);return t} {gap=(to_time($2)-to_time($1)+(24*60*60))%(24*60*60); print gap}' | datamash -s mean 1`
	echo ">> Generation AVG. time: $avgTG"
	
	medianTG=`grep ">> Csmith" $logger | cut -d',' -f9,10 | sed 's:,::g' | awk 'function to_time(time,t,a) {split(time, a, ":"); t = mktime("1970 1 1 " a[1] " " a[2] " " a[3]);return t} {gap=(to_time($2)-to_time($1)+(24*60*60))%(24*60*60); print gap}' | datamash -s median 1`
	echo ">> Generation Median time: $medianTG"
	
	avgTD=`grep ">> Csmith" $logger | cut -d',' -f11,12 | sed 's:,::g' | awk 'function to_time(time,t,a) {split(time, a, ":"); t = mktime("1970 1 1 " a[1] " " a[2] " " a[3]);return t} {gap=(to_time($2)-to_time($1)+(24*60*60))%(24*60*60); print gap}' | datamash -s mean 1`
	echo ">> Testing AVG. time: $avgTD"
	
	medianTD=`grep ">> Csmith" $logger | cut -d',' -f11,12 | sed 's:,::g' | awk 'function to_time(time,t,a) {split(time, a, ":"); t = mktime("1970 1 1 " a[1] " " a[2] " " a[3]);return t} {gap=(to_time($2)-to_time($1)+(24*60*60))%(24*60*60); print gap}' | datamash -s median 1`
	echo ">> Testing Median time: $medianTD"
else
	avgS=`grep ">> Csmith" $logger | cut -d',' -f5  | awk '{if ($1 != "") {line+=1; sum+=$1;}} END{print sum/line}'`
	echo ">> AVG. size (valid only): $avgS"
	
	#avgT=`grep ">> Csmith" $logger | cut -d',' -f6,7 | sed 's:,::g' | awk 'function to_time(time,t,a) {split(time, a, ":"); t = mktime("1970 1 1 " a[1] " " a[2] " " a[3]);return t} {sum+=1; gap=(to_time($2)-to_time($1)+(24*60*60))%(24*60*60); timeTot+=gap} END{print timeTot/sum}'`
	avgT=`grep ">> Csmith" $logger | cut -d',' -f6,7 | sed 's:,::g' | awk 'function to_time(time,t,a) {split(time, a, ":"); t = mktime("1970 1 1 " a[1] " " a[2] " " a[3]);return t} {gap=(to_time($2)-to_time($1)+(24*60*60))%(24*60*60); print gap}' | datamash -s mean 1`
	echo ">> AVG. time: $avgT"
	
	medianT=`grep ">> Csmith" $logger | cut -d',' -f6,7 | sed 's:,::g' | awk 'function to_time(time,t,a) {split(time, a, ":"); t = mktime("1970 1 1 " a[1] " " a[2] " " a[3]);return t} {gap=(to_time($2)-to_time($1)+(24*60*60))%(24*60*60); print gap}' | datamash -s median 1`
	echo ">> Median time: $medianT"
	
	avgTG=`grep ">> Csmith" $logger | cut -d',' -f10,11 | sed 's:,::g' | awk 'function to_time(time,t,a) {split(time, a, ":"); t = mktime("1970 1 1 " a[1] " " a[2] " " a[3]);return t} {gap=(to_time($2)-to_time($1)+(24*60*60))%(24*60*60); print gap}' | datamash -s mean 1`
	echo ">> Generation AVG. time: $avgTG"
	
	medianTG=`grep ">> Csmith" $logger | cut -d',' -f10,11 | sed 's:,::g' | awk 'function to_time(time,t,a) {split(time, a, ":"); t = mktime("1970 1 1 " a[1] " " a[2] " " a[3]);return t} {gap=(to_time($2)-to_time($1)+(24*60*60))%(24*60*60); print gap}' | datamash -s median 1`
	echo ">> Generation Median time: $medianTG"
	
	avgTV=`grep ">> Csmith" $logger | cut -d',' -f8,9 | sed 's:,::g' | awk 'function to_time(time,t,a) {split(time, a, ":"); t = mktime("1970 1 1 " a[1] " " a[2] " " a[3]);return t} {gap=(to_time($2)-to_time($1)+(24*60*60))%(24*60*60); print gap}' | datamash -s mean 1`
	echo ">> UB-freedom checks AVG. time: $avgTV"
	
	medianTV=`grep ">> Csmith" $logger | cut -d',' -f8,9 | sed 's:,::g' | awk 'function to_time(time,t,a) {split(time, a, ":"); t = mktime("1970 1 1 " a[1] " " a[2] " " a[3]);return t} {gap=(to_time($2)-to_time($1)+(24*60*60))%(24*60*60); print gap}' | datamash -s median 1`
	echo ">> UB-freedom checks Median time: $medianTV"

	avgTD=`grep ">> Csmith" $logger | cut -d',' -f12,13 | sed 's:,::g' | awk 'function to_time(time,t,a) {split(time, a, ":"); t = mktime("1970 1 1 " a[1] " " a[2] " " a[3]);return t} {gap=(to_time($2)-to_time($1)+(24*60*60))%(24*60*60); print gap}' | datamash -s mean 1`
	echo ">> Testing AVG. time: $avgTD"
	
	medianTD=`grep ">> Csmith" $logger | cut -d',' -f12,13 | sed 's:,::g' | awk 'function to_time(time,t,a) {split(time, a, ":"); t = mktime("1970 1 1 " a[1] " " a[2] " " a[3]);return t} {gap=(to_time($2)-to_time($1)+(24*60*60))%(24*60*60); print gap}' | datamash -s median 1`
	echo ">> Testing Median time: $medianTD"
fi
