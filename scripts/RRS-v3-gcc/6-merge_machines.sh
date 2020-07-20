#!/bin/bash 
process_number=1
modify=1
working_folder=/home/user42/gcc-csmith-$process_number
coverage_processed=$working_folder/coverage_processed-$modify
coverage_processed_merged=$coverage_processed-merged

time1=$(date +"%T")
echo "--> MERGE COVERAGE... ("$time1")"
(
	source /home/user42/git/graphicsfuzz/gfauto/.venv/bin/activate
	max=20
	mkdir -p $coverage_processed_merged

	########## i = 1 ##########
	i=1	
	folderB=$coverage_processed/x-$i
	folderM=$coverage_processed_merged/x-$i
	cp -r $folderB $folderM

	########## i = 2 ##########
	i=$(($i+1))
	folderB=$coverage_processed/x-$i
	folderM=$coverage_processed_merged/x-$i
	cp -r $folderB $folderM
	
	########## i > 2 ##########
	for (( i=3; i<=$max; i=$(($i+2)))); do
		echo "===="
		im1=$(($i-1))
		ip1=$(($i+1))
		folderM=$coverage_processed_merged/x-$im1

		folderB=$coverage_processed/x-$i
		folderM_out=$coverage_processed_merged/x-$i
		mkdir -p $folderM_out
		
		res_merge=$folderM_out/run_gcov2cov.cov
		dump_merge=$folderM_out/cov.out
		
		gfauto_cov_merge $folderM/run_gcov2cov.cov $folderB/run_gcov2cov.cov --out $res_merge
		gfauto_cov_to_source --coverage_out $dump_merge --cov $res_merge $working_folder/gcc-build/ >> gfauto.log 2>&1	

		### Second one ###
		folderB=$coverage_processed/x-$ip1
		folderM_out=$coverage_processed_merged/x-$ip1
		mkdir -p $folderM_out
		
		res_merge=$folderM_out/run_gcov2cov.cov
		dump_merge=$folderM_out/cov.out
	
		echo " >> merge: gfauto_cov_merge $folderM/run_gcov2cov.cov $folderB/run_gcov2cov.cov --out $res_merge"
		gfauto_cov_merge $folderM/run_gcov2cov.cov $folderB/run_gcov2cov.cov --out $res_merge
		#echo " >> dump: gfauto_cov_to_source --coverage_out $dump_merge --cov $res_merge $working_folder/gcc-build/ >> gfauto.log 2>&1"
		gfauto_cov_to_source --coverage_out $dump_merge --cov $res_merge $working_folder/gcc-build/ >> gfauto.log 2>&1			 
	done
	
	echo " >> dump: gfauto_cov_to_source --coverage_out $dump_merge --cov $res_merge $working_folder/gcc-build/ >> gfauto.log 2>&1"
	gfauto_cov_to_source --coverage_out $dump_merge --cov $res_merge $working_folder/gcc-build/ >> gfauto.log 2>&1

	time2=$(date +"%T")
	echo "DONE. RESULTS AVAILABLE IN $res_merge and $dump_merge ($time2)"
)
