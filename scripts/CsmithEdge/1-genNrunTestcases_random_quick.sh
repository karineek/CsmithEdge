#!/bin/bash
function clean_itr {
	xFolder=$1
	rm -f $xFolder/ASANres1.txt $xFolder/ASANres2.txt 
	rm -f $xFolder/MSANres1.txt $xFolder/MSANres2.txt 
	rm -f $xFolder/UBSANres1.txt $xFolder/UBSANres2.txt 
	rm -f $xFolder/Plain1.txt $xFolder/Plain2.txt 
	# cleaning before continue incase first script crash because of resources.
}

echo "This script generates testcases with less conservative restrictions on undefined behviours and perform diff-testing"
echo " - date: $(date '+%Y-%m-%d at %H:%M.%S')"
echo " - host name $(hostname -f)"
echo " - script path: $(readlink $0)"
base=$1 # e.g. /git
datelog=$2
seeds_min=$3  # Where to start from
seeds_max=$4 # How many seeds to iterate on

base_expr=$base/RRS_EXPR
base_script_WA2=$base_expr/scripts/CsmithEdge
csmith_location=$base_expr/csmith
output=$base_script_WA2/output
seedsProbs=$base_script_WA2/seedsProbs
rrs_folder=$seedsProbs/seedsSafeLists
log_folder=$base_script_WA2/loggers
refernceCompiler=clang-10
testedCompilerA=$5
testedCompilerB=$6

# Clean before start
clean_itr "$base_script_WA2"

# Check if the first parameter is a compiler exist in the machine
var=`dpkg --list | grep -c "$refernceCompiler"`
if (($var < 1)) ; then
	echo "error: no such a compiler" >&2; exit 1
fi	

#### Test we have Frama-c, and not the system default ####
eval $(opam config env) ## Just to assure it gets it from the right place
frama-c --version
echo " ==> Frama-C version"
testIT=`frama-c --version`
if [ "$testIT" == "Phosphorus-20170501" ]; then
	echo ">> Frama-C version is too old. Please install version 20.0.0 or up."
	exit
fi
if [[ "$testIT" == "" ]]; then
	echo ">> Please install Frama-C version 20.0.0 or up."
	exit
fi

## Create output folder if not exists
if test -d "$output" ; then
	echo "Using exists folder $output"
else
	mkdir $output
fi
if test -d "$seedsProbs" ; then
	echo "Using exists folder $seedsProbs"
else
	mkdir $seedsProbs
fi
if test -d "$rrs_folder" ; then
	echo "Using exists folder $rrs_folder"
else
	mkdir $rrs_folder
fi
if test -d "$log_folder" ; then
	echo "Using exists folder $log_folder"
else
	mkdir $log_folder
fi

echo 'Start extracting the configuration files for SA with WA and RRS'
### Start the loop
for (( i=$seeds_min; i<=$seeds_max; i++ ))
do  
	timeS=$(date +"%T")
	echo "Extracting set $i $timeS"

	## Loggers
	loggerRef=$log_folder/'__'$refernceCompiler'_'$i'.log'
	loggerV3=$log_folder/'__orig_'$refernceCompiler'_'$i'.log'
	loggerV0=$log_folder/'__orig_'$testedCompilerA'_'$i'.log'
	loggerV1=$log_folder/'__weak_gcc_'$testedCompilerA'_'$i'.log'
	loggerV2=$log_folder/'__weak_clang_'$testedCompilerB'_'$i'.log'
	generallogger=$log_folder/"logger_"$datelog"_"$i".txt"
	duringGenlogger=$log_folder/"WA-1_logger_"$datelog"_"$i".txt"

	### Inner loop per seed
	seeds=../../Data/seeds_all/random_seeds_out$i.txt	
	##seeds=../../Data/seeds_all/seeds_out$i.txt
	##seeds='../../Data/seeds_good/seeds_out'$i'_sample.txt'
	touch $seeds
	for j in {0..100000}
	do
		seed=$(($RANDOM$RANDOM$RANDOM%10000000000))
		echo $seed >> $seeds	
		timeS=$(date +"%T")
		echo " ============= START ITR ($timeS,$seed) =============" >> "$generallogger"

		## Tested if not already known to be a bad seed
		fileinvalid=$rrs_folder/'__test'$seed'INVALID'
		if [ -f "$fileinvalid" ] ; then
			echo ">> (ERROR) Testcase creation previously failed. Bad seed <$seed>."
			echo " >> (Warning) bad seed $seed previously detected. Skip testcase." >> "$generallogger"
			continue
		fi

		## Files required:
		confgFile=$seedsProbs/'probs_WeakenSafeAnalyse_test.txt'$seed
		annotated_testcase=$output/'__test_annotated'$seed'.c'
		modified_testcase=$output/'__test'$seed'M.c'
		safelist=$rrs_folder/'__test'$seed'Results'

		## Generate WA test-case:
		ulimit -St 9999; ./WA1_post_gen_test_quick.sh $seed $base $output "$duringGenlogger" "$loggerRef" >> "$generallogger" 2>&1
		clean_itr "$base_script_WA2" ## Clean before continue
		fileinvalid=$rrs_folder/'__test'$seed'INVALID'
		if [ -f "$fileinvalid" ] ; then
			echo ">> (ERROR) Testcase creation failed. Bad seed <$seed>."
			echo " >> (Warning) bad seed $seed detected during configuration file generation. Skip testcase." >> "$generallogger"
			rm $confgFile; rm $fileinvalid ## Remove trace, do not need it when doing quick
			continue
		fi
		if [ ! -f "$confgFile" ] ; then
			echo ">> (ERROR) Testcase already exists but with no configuration file <$confgFile>." 
			exit
		fi
		cat "$confgFile" | grep . > test.tmp; cp -f test.tmp "$confgFile"; rm -f test.tmp ## Delete space lines
		sizeConfg=`cat "$confgFile" | wc -l` ## test all is ok now, need 10 lines
		if [[ "$sizeConfg" -eq "0" ]]; then ## Bad seed
			#skip loop
			echo " >> (Warning) bad seed $seed. Skip testcase." >> "$generallogger"
			touch $fileinvalid
			continue
		fi
		if [[ ! "$sizeConfg" -eq "10" ]]; then
			echo ">> (ERROR) Configuration file <$confgFile> is faulty (probably extra empty line) <size=$sizeConfg>." 
			exit
		fi
		## Apply RRS on it (generate a list of must-be-safe locations)
		ulimit -St 9999; ./WA2_dynamic_analysis_RRS.sh gcc-7 $seed $base_expr $output "$annotated_testcase" "$safelist" "$confgFile" >> "$generallogger" 2>&1
		if [ ! -f "$safelist" ] ; then
			echo ">> (ERROR) Testcase creation failed. Bad seed <$seed>."
			touch $fileinvalid
			rm $annotated_testcase
			continue
		fi
		## Generate modified testcase
		ulimit -St 9999; ./RSS5_2_constructModifyTests.sh "$seed" "$annotated_testcase" "$safelist" "$confgFile" "$output" >> "$generallogger" 2>&1
		if [ ! -f "$confgFile" ] || [ ! -f "$annotated_testcase" ] || [ ! -f "$modified_testcase" ] || [ ! -f "$safelist" ] ; then
			echo ">> (ERROR) Testcase creation failed. One or more files are missing <$confgFile> <$annotated_testcase> <$modified_testcase> <$safelist>." 
			exit
		fi

		## Do diff-testing
		## Original functions
		compilerflags=" -w -O2 "
		compile_line=""
		runtime="runtime"
		Orig_confgFile=$seedsProbs/'probs_OrigSafeAnalyse_test.txt'
		ulimit -St 9999; ./RSS5_3-compiler_test.sh "$refernceCompiler" "$seed" "$annotated_testcase" "$Orig_confgFile" "$loggerV3" "$compile_line" "$compilerflags" "$output" "$csmith_location" "$runtime" >> "$generallogger" 2>&1
		## WA only functions
		compilerflags=" -w -O2 "
		compile_line=""
		runtime="RRS_runtime_test"
		ulimit -St 9999; ./RSS5_3-compiler_test.sh "$testedCompilerA" "$seed" "$annotated_testcase" "$Orig_confgFile" "$loggerV0" "$compile_line" "$compilerflags" "$output" "$csmith_location" "$runtime" >> "$generallogger" 2>&1
		## WA+RRS macros
		compilerflags=" -w -O2 "
		compile_line=""
		runtime="RRS_runtime_test"
		ulimit -St 9999; ./RSS5_3-compiler_test.sh "$testedCompilerA" "$seed" "$modified_testcase" "$confgFile" "$loggerV1" "$compile_line" "$compilerflags" "$output" "$csmith_location" "$runtime" >> "$generallogger" 2>&1
		ulimit -St 9999; ./RSS5_3-compiler_test.sh "$testedCompilerB" "$seed" "$modified_testcase" "$confgFile" "$loggerV2" "$compile_line" "$compilerflags" "$output" "$csmith_location" "$runtime" >> "$generallogger" 2>&1
		##compile_line="/home/user42/gcc-csmith-0/gcc-build/gcc/xgcc -B/home/user42/gcc-csmith-0/gcc-build/gcc/. "
		##ulimit -St 9999; ./RSS5_3-compiler_test.sh "" "$seed" "$modified_testcase" "$confgFile" "$loggerV1" "$compile_line" "$compilerflags" "$output" "$csmith_location" "$runtime" >> "$generallogger" 2>&1
		##compile_line="/home/user42/llvm-csmith-0/llvm-install/bin/clang "
		##ulimit -St 9999; ./RSS5_3-compiler_test.sh "" "$seed" "$modified_testcase" "$confgFile" "$loggerV2" "$compile_line" "$compilerflags" "$output" "$csmith_location" "$runtime" >> "$generallogger" 2>&1

		## Cleaning (to save space, can be removed if have space)
		rm -f $safelist
		rm -f $modified_testcase
		rm -f $annotated_testcase
	done < "$seeds"
done 

# cleaning
rm -f $base_script_WA2/probs_WeakenSafeAnalyse.txt
rm -f $base_script_WA2/platform.info

## Print time and exit
timeS=$(date +"%T")
echo "End script $timeS"
