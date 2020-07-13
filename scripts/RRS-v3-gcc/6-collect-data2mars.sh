#!/bin/bash 
process_number=$1
machine_number=$2
baseD=/home/user42
working_folder=$baseD/gcc-csmith-$process_number
gitL=$baseD/git/RRS_EXPR
marsLocation=/data/compiler-testing-RRS

modify=1 # 0 or 1
dateLast=21052020
csmithmode=macr # func, macr

if [ -z "$1" ]
  then
	echo "--> No process number supplied. Exit."
	exit 1
fi

if [ -z "$2" ]
  then
	echo "--> No machine number supplied. Exit."
	exit 1
fi

#########################
#cd $gitL
scp $gitL/scripts/RRS-v3-gcc/part_1.txt kevenmen@mars:$marsLocation/gcc-res-$csmithmode-$modify-$dateLast/script_output-$machine_number.txt
#scp $gitL/__logger_cov__home_user42_gcc-csmith-1_gcc-install_bin_gcc_seeds-1.txt kevenmen@mars:$marsLocation/gcc-res-$csmithmode-$modify-$dateLast/__logger_cov__home_user42_gcc-csmith-1_gcc-install_bin_gcc_seeds-1-$machine_number.txt
scp $gitL/__logger_covM__home_user42_gcc-csmith-1_gcc-install_bin_gcc_seeds-1.txt kevenmen@mars:$marsLocation/gcc-res-$csmithmode-$modify-$dateLast/__logger_covM__home_user42_gcc-csmith-1_gcc-install_bin_gcc_seeds-1-$machine_number.txt
#########################
#cd $working_folder
scp -r $working_folder/coverage_gcda_files kevenmen@mars:$marsLocation/gcc-res-$csmithmode-$modify-$dateLast/res-$machine_number/
scp -r $working_folder/coverage_processed-$modify kevenmen@mars:$marsLocation/gcc-res-$csmithmode-$modify-$dateLast/res-$machine_number/ 

