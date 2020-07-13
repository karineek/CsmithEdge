#!/bin/bash 
process_number=$1
machine_number=$2
baseD=/home/user42
working_folder=$baseD/gcc-csmith-$process_number
gitL=$baseD/git/RRS_EXPR
marsLocation=/data/compiler-testing-RRS
zipMachine=gcc-csmith-1.PLOTylK.tar.gz

#modify=0 # 0 or 1
#dateLast=13052020
#csmithmode=macr # func, macr

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

## Clean 
cd $baseD;rm -rf gcc-csmith-$process_number/;
## Load fresh copy scp kevenmen@mars:/data/compiler-testing-RRS/gcc-csmith-1.PLOTylK.tar.gz .;
cd $baseD; scp kevenmen@mars:$marsLocation/$zipMachine . ; tar -xhzvf $zipMachine; rm $zipMachine
## Remove old loggers
cd $gitL ;rm __logger_cov__home_user42_gcc-csmith-1_gcc-install_bin_gcc_seeds-1.txt __logger_covM__home_user42_gcc-csmith-1_gcc-install_bin_gcc_seeds-1.txt scripts/RRS-v3-gcc/part_1.txt
## git pull recent version of RRS
git pull
## Test machine
./5-test-dest-machine.sh 1
