#!/bin/bash
working_folder1=$1		# Add where gcov files are for compiler/test 1
working_folder2=$2		# Add where gcov files are for compiler/test 2
output_table_file=$3		# Where to put the table
unitest_skip=utils/unittest	# unittest folder should not be part of cov measurements
## E.g., ./7-gen-statistic-gcov-diff-tab_gfauto.sh /home/user42/llvm-csmith-1/coverage_processed-1/x-10/cov.out/ /home/user42/llvm-csmith-1/coverage_processed-0/x-10/cov.out/ table__all_1_0.csv
## E.g., ./7-gen-statistic-gcov-diff-tab_gfauto.sh /home/user42/llvm-csmith-1/coverage_processed-0/x-10/cov.out/ /home/user42/llvm-csmith-1/coverage_processed-1/x-10/cov.out/ table__all_0_1.csv

## INIT:
rm $output_table_file
rm list_gcov_1.txt
rm list_gcov_2.txt

wf1_size=${#working_folder1}
wf2_size=${#working_folder2}

## START ##

## Constract the lines on the table
find $working_folder1 -type f | sort >> list_gcov_1.txt
find $working_folder2 -type f | sort >> list_gcov_2.txt
linecount1=`cat list_gcov_1.txt | wc -l`
linecount2=`cat list_gcov_2.txt | wc -l`
if [ ! "$linecount1" == "$linecount2" ]; then
	echo ">> ERROR: not all files exists in both set-1 and set-2"
		
	# cleaning
	rm list_gcov_1.txt
	rm list_gcov_2.txt

	exit 1
fi

## If same population, continue: 

## file name: the name of the file we comapare
## #line 1: number of lines in file 1
## #line 2: number of lines in file 2
## #line 1: number of lines hit in file 1
## #line 2: number of lines hit in file 2
## LH1 U LH2: number of lines with hit in any of the files
## LH1 U LH2 (with c1!=c2): same but with a counter difference
## LH1 /\ LH2 (with c1==c2): same but where the counters are exactly the same
## LH1\LH2 : hit in file 1 and miss in file 2
## LH2\LH1 : hit in file 2 and miss in file 1
## LH1 > LH2: hit of LH1 is larger 
## LH1 < LH2: hit of LH2 is larger
## LH1 > LH2(x1): hit of LH1 is larger in order (e.g., 100k and 10k)
## LH1 < LH2(x1): hit of LH2 is larger in order (e.g., 10k and 100k)
## LH1 >> LH2(x4): hit of LH1 is larger in magnitude order
## LH1 << LH2(x4): hit of LH2 is larger in magnitude order
## Flag(LH1/LH2 != LH2/LH1): flag if the unique hits are not the same
echo ">> file name,#line 1,#line 2,#line 1 hit,#line 2 hit,LH1 U LH2,LH1 U LH2 (with c1!=c2),LH1 /\ LH2 (with c1==c2),LH1/LH2,LH2/LH1,LH1 > LH2,LH1 < LH2,LH1 > LH2(x1),LH1 < LH2(x1),LH1 >> LH2(x4),LH1 << LH2(x4),Flag(LH1/LH2 != LH2/LH1)" >> $output_table_file
while IFS= read -r -u 4 file_name_1 && IFS= read -r -u 5 file_name_2; do
		## check that the files matches. (without the working folders)
		fn1=${file_name_1:$wf1_size}
		fn2=${file_name_2:$wf2_size}
		if [[ ! "$fn1" == *"$unitest_skip"* ]]; then 	
			if [ ! "$fn1" == "$fn2" ]; then
				echo ">> ERROR: not all files exists in both set-1 and set-2"
				echo $file_name_1 " <-> " $file_name_2	# DEBUG
				exit 1
			fi

			## Add a row to the csv file
			tmp1=__tmp_1.txt
			tmp2=__tmp_2.txt
			test1=__test_1.txt
			test2=__test_2.txt
			cat $file_name_1 | sed 's:^        :      0 :1' | sed -n 's/\(^......[0-9]*[0-9] \).*$/\1/p' | cat -n > $tmp1
			cat $file_name_2 | sed 's:^        :      0 :1' | sed -n 's/\(^......[0-9]*[0-9] \).*$/\1/p' | cat -n > $tmp2
			cat -n $file_name_1 > $test1		
			cat -n $file_name_2 > $test2
			diff_lines=`diff -y --suppress-common-lines $test1 $test2 | wc -l`
			./RRS7-2_LH_file.sh $fn1 $tmp1 $tmp2 $diff_lines >> $output_table_file	
			rm -f $tmp1 $tmp2 $test1 $test2
		fi
done 4<list_gcov_1.txt 5<list_gcov_2.txt
echo " >> End extracting data for $linecount1:$linecount2 files."

resT=`sed '1d' $output_table_file | cut -d',' -f2 | awk '{ sum += $1 } END { print sum }'`
echo "#line 1 ................. ==> "$resT
resT=`sed '1d' $output_table_file | cut -d',' -f3 | awk '{ sum += $1 } END { print sum }'`
echo "#line 2 ................. ==> "$resT

resT=`sed '1d' $output_table_file | cut -d',' -f4 | awk '{ sum += $1 } END { print sum }'`
echo "#line 1 HIT ............. ==> "$resT
resT=`sed '1d' $output_table_file | cut -d',' -f5 | awk '{ sum += $1 } END { print sum }'`
echo "#line 2 HIT ............. ==> "$resT

resT=`sed '1d' $output_table_file | cut -d',' -f6 | awk '{ sum += $1 } END { print sum }'`
echo "LH1 U LH2 ............... ==> "$resT
resT=`sed '1d' $output_table_file | cut -d',' -f7 | awk '{ sum += $1 } END { print sum }'`
echo "LH1 U LH2 (with c1!=c2) . ==> "$resT
resT=`sed '1d' $output_table_file | cut -d',' -f8 | awk '{ sum += $1 } END { print sum }'`
echo "LH1 /\ LH2 (with c1==c2)  ==> "$resT
resT=`sed '1d' $output_table_file | cut -d',' -f9 | awk '{ sum += $1 } END { print sum }'`
echo "LH1\LH2 ................. ==> "$resT
resT=`sed '1d' $output_table_file | cut -d',' -f10 | awk '{ sum += $1 } END { print sum }'`
echo "LH2\LH1 ................. ==> "$resT
resT=`sed '1d' $output_table_file | cut -d',' -f11 | awk '{ sum += $1 } END { print sum }'`
echo "LH1 > LH2 ............... ==> "$resT
resT=`sed '1d' $output_table_file | cut -d',' -f12 | awk '{ sum += $1 } END { print sum }'`
echo "LH1 < LH2 ............... ==> "$resT
resT=`sed '1d' $output_table_file | cut -d',' -f13 | awk '{ sum += $1 } END { print sum }'`
echo "LH1 >>x1 LH2 .............. ==> "$resT
resT=`sed '1d' $output_table_file | cut -d',' -f14 | awk '{ sum += $1 } END { print sum }'`
echo "LH1 <<x1 LH2 .............. ==> "$resT
resT=`sed '1d' $output_table_file | cut -d',' -f15 | awk '{ sum += $1 } END { print sum }'`
echo "LH1 >>x4 LH2 .............. ==> "$resT
resT=`sed '1d' $output_table_file | cut -d',' -f16 | awk '{ sum += $1 } END { print sum }'`
echo "LH1 <<x4 LH2 .............. ==> "$resT

# cleaning
rm list_gcov_1.txt
rm list_gcov_2.txt
