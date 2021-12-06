#!/bin/bash

## Checks modified code with ASAN
function check_wt_ASAN {
	prog=temp.c ; cp $1 temp.c
	printoutput=$2

	# ASAN
	rm -f a.out
	(ulimit -St 300; clang-10 -fsanitize=address -O0 -w -fno-omit-frame-pointer -g $compile_line $prog)
	if [[ ! -f "a.out" ]]; then ## check if the file exists
	        echo ">> ASAN Failed Compilation"
	        exit
        else
		(ulimit -St 600; ASAN_OPTIONS=detect_stack_use_after_return=1 ./a.out) > $printoutput 2>&1 ## x2 slow down, allow twice the time
		rm -f a.out
		timeout=`grep "time limit" $printoutput | wc -l`
		if [[ $timeout -gt 0 ]]; then
                	echo ">> ASAN Failed TIMEOUT"
                	exit
		fi
		# ASAN
		cat $printoutput | grep -ve"checksum = " > $printoutput.tmp
		cp $printoutput.tmp $printoutput
		rm $printoutput.tmp
	fi
}

## MSAN: ulimit -St 300; clang-10 -fsanitize=memory -fno-omit-frame-pointer -g -O1 -w -I ../runtime/ -I runtime/ test.c
function check_wt_MSAN {
	prog=temp.c ; cp $1 temp.c
	printoutput=$2

	# MSAN
	rm -f a.out
	(ulimit -St 300; clang-10 -fsanitize=memory -fno-omit-frame-pointer -g -O0 -w $compile_line $prog)
	if [[ ! -f "a.out" ]]; then ## check if the file exists
		echo ">> MSAN Failed Compilation"
		exit
	else
		(ulimit -St 600; ./a.out) > $printoutput 2>&1 ## x2 slow down, allow twice the time
		rm -f a.out
		timeout=`grep "time limit" $printoutput | wc -l`
		if [[ $timeout -gt 0 ]]; then
                	echo ">> MSAN Failed TIMEOUT"
                	exit
		fi
		# MSAN
		cat $printoutput | grep -ve"checksum = " > $printoutput.tmp
		cp $printoutput.tmp $printoutput
		rm $printoutput.tmp
	fi
}

## UBSAN: ulimit -St 300; clang-10 -fsanitize=undefined -g -O1 -w -I ../runtime/ -I runtime/ test.c
function check_wt_UBSAN {
	prog=temp.c ; cp $1 temp.c
	printoutput=$2

	# UBSAN
	rm -f a.out
	(ulimit -St 300; clang-10 -fsanitize=undefined -g -O1 -lgcc_s --rtlib=compiler-rt -w $compile_line $prog)
	if [[ ! -f "a.out" ]]; then ## check if the file exists
		echo ">> UBSAN Failed Compilation"
		exit
        else
		(ulimit -St 600; ./a.out) > $printoutput 2>&1 ## x2 slow down, allow twice the time
		rm -f a.out
		timeout=`grep "time limit" $printoutput | wc -l`
		if [[ $timeout -gt 0 ]]; then
                	echo ">> UBSAN Failed TIMEOUT"
                	exit
		fi
		# UBSAN
		cat $printoutput | grep ".c:" | grep -ve "SUMMARY: " -ve " misaligned address 0" > $printoutput.tmp
		cp $printoutput.tmp $printoutput
		rm $printoutput.tmp
	fi
}

## Checks modified code with Frama-C
function check_wt_FramaC {	
	progOrig=$1
	output=$2
	progFile=${progOrig##*/}
	progRMv="$framac_run_folder/_rmv_$progFile"

	# FRAMA-C
	cd $framac_run_folder
	sed 's/volatile/ /g' $outputFolder/$progOrig > $progRMv
	(ulimit -St 300; frama-c -eva -eva-slevel 100 -eva-plevel 256 -eva-precision 5 -eva-warn-undefined-pointer-comparison pointer -eva-no-alloc-returns-null -warn-signed-overflow -eva-no-show-progress -machdep x86_64 $progRMv) > $output 2>&1
	rm -f $progRMv

	## Frama-C installation can easiliy be broken, test it:
	countError=`cat $output | grep "cannot load module" | wc -l`
	if [[ $countError -gt 0 ]]; then
		echo ">>>>>> PLEASE re-insall frama-C!"
		cat $output | grep "cannot load module"
		exit
	fi

	## Filter what we need:
        is_ok=`cat $output | grep "0 alarms generated by the analysis." | wc -l`
        if [[ "$is_ok" == "0" ]]; then
		sed -i ':a;N;$!ba;s/\n / /g' $output
		if [[ $flag_dang_ptr -eq 1 ]]; then
			cat $output | grep ".c:" | grep -ve "starting to merge loop iterations" -ve "Automatic loop unrolling" -ve "function strcmp" -ve "Values at end of function" -ve "Trace partitioning superposing" -ve "valid_read(argv" -ve "∈" -ve "but got argument of type 'uint" -ve "but got argument of type 'int" -ve "Warning:   unsigned overflow. assert " -ve "assertion 'Eva,unsigned_overflow' got final status invalid." -ve " unsigned overflow." -ve "escaping" -ve"Old style" -ve"Neither code nor specification for function" -ve"Assuming no side effects beyond" -ve'Warning: pointer comparison. assert \\pointer_comparable' -ve'Unexpected error (Z.Overflow)' -ve'cannot properly split on' > $output.tmp
		else
			cat $output | grep ".c:" | grep -ve "starting to merge loop iterations" -ve "Automatic loop unrolling" -ve "function strcmp" -ve "Values at end of function" -ve "Trace partitioning superposing" -ve "valid_read(argv" -ve "∈" -ve "but got argument of type 'uint" -ve "but got argument of type 'int" -ve "Warning:   unsigned overflow. assert " -ve "assertion 'Eva,unsigned_overflow' got final status invalid." -ve " unsigned overflow." -ve "escaping" -ve "Eva,dangling_pointer" -ve"Old style" -ve"Neither code nor specification for function" -ve"Assuming no side effects beyond" -ve'Warning: pointer comparison. assert \\pointer_comparable' -ve'Unexpected error (Z.Overflow)' -ve'cannot properly split on' > $output.tmp
		fi		
		cp $output.tmp $output
		rm $output.tmp
        else
		rm $output
		touch $output
	fi
	cd $curr_folder
}

################### TEST PROGRAM ###########
program=$1
filenameNoRelax=$2
outputFolder=$3
framac_run_folder=$4
timeout_bound=$5
flag_dang_ptr=$6
compile_line=$7
csmithprog=$filenameNoRelax

# define outputs
plain_output_compiler=test0.txt	
plain_output=test1e.txt
asan_output=test2e.txt
msan_output=test3e.txt
ubsan_output=test4e.txt
framac_output=test5e.txt

asan_output_x=test2c.txt
msan_output_x=test3c.txt
ubsan_output_x=test4c.txt
framac_output_x=test5c.txt

## clean-up
rm -f $outputFolder/$plain_output $outputFolder/$plain_output_compiler
rm -f $outputFolder/$asan_output
rm -f $outputFolder/$msan_output
rm -f $outputFolder/$ubsan_output
rm -f $framac_run_folder/$framac_output
rm -f $outputFolder/$asan_output_x
rm -f $outputFolder/$msan_output_x
rm -f $outputFolder/$ubsan_output_x
rm -f $framac_run_folder/$framac_output_x

## If Plain succeed, then test the difference from Csmith without Relaxations:
diff_lines_progs=`diff -y --suppress-common-lines $program $csmithprog | wc -l`
if [[ $diff_lines_progs -eq 0 ]]; then
	exit ## OK
elif [[ $diff_lines_progs -eq 1 ]]; then
	exit ## OK
else	
	## ASAN
	touch $outputFolder/$asan_output
	check_wt_ASAN $program $outputFolder/$asan_output
	count2=`cat "$outputFolder/$asan_output" | wc -l`
	if [[ $count2 -gt 0 ]] ; then
		check_wt_ASAN $csmithprog $outputFolder/$asan_output_x
		diff_lines_ASAN=`diff -y --suppress-common-lines $outputFolder/$asan_output $outputFolder/$asan_output_x | wc -l`
		if [[ $diff_lines_ASAN -gt 0 ]] ; then
			echo ">> Failed ASAN Analysis"
			exit
		fi
	fi ## ASAN
	
	## MSAN
	touch $outputFolder/$msan_output
	check_wt_MSAN $program $outputFolder/$msan_output
	count3=`cat "$outputFolder/$msan_output" | wc -l`
	if [[ $count3 -gt 0 ]] ; then
		check_wt_MSAN $csmithprog $outputFolder/$msan_output_x
		diff_lines_MSAN=`diff -y --suppress-common-lines $outputFolder/$msan_output $outputFolder/$msan_output_x | wc -l`
		if [[ $diff_lines_MSAN -gt 0 ]] ; then
			echo ">> Failed MSAN Analysis"
			exit
		fi
	fi ## MSAN

	## UBSAN
	touch $outputFolder/$ubsan_output
	check_wt_UBSAN $program $outputFolder/$ubsan_output
	count4=`cat "$outputFolder/$ubsan_output" | wc -l`
	if [[ $count4 -gt 0 ]] ; then
		check_wt_UBSAN $csmithprog $outputFolder/$ubsan_output_x
		diff_lines_UBSAN=`diff -y --suppress-common-lines $outputFolder/$ubsan_output $outputFolder/$ubsan_output_x | wc -l`
		if [[ $diff_lines_UBSAN -gt 0 ]] ; then
			echo ">> Failed UBSAN Analysis"
			exit
		fi
	fi ## UBSAN
	
	## FRAMA-C
	touch $framac_run_folder/$framac_output
	check_wt_FramaC "$program" "$framac_run_folder/$framac_output"
	count5=`cat "$framac_run_folder/$framac_output" | wc -l`
	if [[ $count5 -gt 0 ]] ; then
		check_wt_FramaC "$csmithprog" "$framac_run_folder/$framac_output_x"
		diff_lines_FramaC=`diff -y --suppress-common-lines "$framac_run_folder/$framac_output" "$framac_run_folder/$framac_output_x" | wc -l`
		if [[ $diff_lines_FramaC -gt 0 ]] ; then
			echo ">> Failed Frama-c Analysis"
			exit
		fi
	fi ## Frama-c
fi ## Diff not 0
## END
