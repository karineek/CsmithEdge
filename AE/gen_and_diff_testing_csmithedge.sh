#!/bin/bash
base=$1		# E.g, /home/user42/git/CsmithEdge
lazy=$2		# 0 - Reg. and 1 - lazy
date_str=09082021	# Date for our experiments, does not change the results if you keep it that way.
compA=$3
compB=$4

## Check we have two parameters
if [ "$#" -ne 4 ]; then
	echo "Illegal number of parameters. Please enter base folder and 0 or 1 (csmithedge or lazy)."
	exit 1
fi

## Check the folder exists
if [ ! -d $base/scripts/CsmithEdge ] ; then
	echo "Cannot find base folder. No such path: <$base/scripts/CsmithEdge>"
	exit
fi

## Check we have process number
if [ -z "$2" ]; then
	echo "Exit. Missing second parameter. Please run with <0> for CsmithEdge diff-testing or <1> for the lazy version."
	exit 1
fi

## Run the tests
cd $base/scripts/CsmithEdge
./1-genNrunTestcases_random.sh $base $date_str 1 1 $compA $compB $lazy
echo "DONE."
