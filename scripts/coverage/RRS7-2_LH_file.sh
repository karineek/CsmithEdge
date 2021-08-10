#!/bin/bash
function get_line_stat {
	# Lines cov one side:
	# ==================

	# Line left and right that has the same counter (exactly the same) - can quit here if so.
	file12_hl_same=$(($file12_hl_all-$file12_hl_not_same))
	if [ "$file12_hl_all" == "$file12_hl_same" ]; then
		echo ">> $fileO,$file1_ln,$file2_ln,$file1_cov_any,$file2_cov_any,$file12_hl_all,$file12_hl_not_same,$file12_hl_same,0,0,0,0,0,0,0,0,X "
	else
		# Exists on left: 
		file1_hl=`diff -y --suppress-common-lines $file1 $file2 | grep -ve '.* 0 .* 0' | grep ' 0 ' | grep ".*|.* 0 " | wc -l`

		# Exists on right:
		file2_hl=`diff -y --suppress-common-lines $file1 $file2 | grep -ve '.* 0 .* 0' | grep ' 0 ' | grep " 0 .*|" | wc -l` 
		# Total not the same, miss + hits:
		totDiff=$(($file12_hl_not_same+$file1_hl+$file2_hl))
		if [ ! "$diffline" == "$totDiff" ]; then
			echo ">> $fileO,$file1_ln,$file2_ln,$file1_cov_any,$file2_cov_any,$file12_hl_all,$file12_hl_not_same,0,0,0,0,0,0,0,0,0,E2 ($diffline:$totDiff) "
		else
			## Major gap in cov.--> Fix stranger cases after replacing gcov with cov
			counter1=`diff -y --suppress-common-lines $file1 $file2 | awk '{print length($5)-length($2)+4}' | grep -e "-" | wc -l`
			counter2=`diff -y --suppress-common-lines $file1 $file2 | awk '{print length($2)-length($5)+4}' | grep -e "-" | wc -l`
			counter1L=`diff -y --suppress-common-lines $file1 $file2 | awk '{print length($5)-length($2)}' | grep -e "-" | wc -l`
			counter2L=`diff -y --suppress-common-lines $file1 $file2 | awk '{print length($2)-length($5)}' | grep -e "-" | wc -l`
			counter1Bigger=`diff -y --suppress-common-lines $file1 $file2 | awk '{print $5-$2}' | grep -e "-" | wc -l`
			counter2Bigger=`diff -y --suppress-common-lines $file1 $file2 | awk '{print $2-$5}' | grep -e "-" | wc -l`
			echo $fileO >> out_test.txt
			diff -y --suppress-common-lines $file1 $file2 >> out_test.txt
						
			## Short report for debug:
			if [  "$file1_hl" == "$file2_hl" ]; then
				echo ">> $fileO,$file1_ln,$file2_ln,$file1_cov_any,$file2_cov_any,$file12_hl_all,$file12_hl_not_same,$file12_hl_same,$file1_hl,$file2_hl,$counter1Bigger,$counter2Bigger,$counter1L,$counter2L,$counter1,$counter2,F "
			else
				echo ">> $fileO,$file1_ln,$file2_ln,$file1_cov_any,$file2_cov_any,$file12_hl_all,$file12_hl_not_same,$file12_hl_same,$file1_hl,$file2_hl,$counter1Bigger,$counter2Bigger,$counter1L,$counter2L,$counter1,$counter2,T "
			fi
		fi
	fi
}

############################
## MAIN:
############################

fileO=$1 			# file name originally
file1=$2 			# file 1
file2=$3 			# file 2
diffline=$4			# Number of lines different between the files

file1_ln=`cat $file1 | wc -l` # size file 1
file2_ln=`cat $file2 | wc -l` # size file 2
if [ ! "$file1_ln" == "$file2_ln" ]; then
	echo ">> $fileO,$file1_ln,$file2_ln,$file1_cov_any,$file2_cov_any,0,0,0,0,0,0,0,0,0,0,0,E1 "
else
	file12_hl_not_same=`diff -y --suppress-common-lines $file1 $file2 | grep -ve ' 0 ' | wc -l` # Any lines covered
	file12_hl_all=`diff -y $file1 $file2 | grep -ve '.* 0 .* 0' | wc -l` # Any lines covered
	file1_cov_any=`cat $file1 | awk '{if ($2 >0) print($2)}' | wc -l`
	file2_cov_any=`cat $file2 | awk '{if ($2 >0) print($2)}' | wc -l`
	if [ "$file12_hl_all" == "0" ]; then
		echo ">> $fileO,$file1_ln,$file2_ln,$file1_cov_any,$file2_cov_any,$file12_hl_all,$file12_hl_not_same,0,0,0,0,0,0,0,0,0,X "
	else
		## ONLY IF THERE ARE LINES COVERED!
		get_line_stat
	fi
fi
