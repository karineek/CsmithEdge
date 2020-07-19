#!/bin/bash

#################################### TEST INPUT ####################################
function test_input {
	if [ "$#" -ne 2 ]; then
	    echo "Illegal number of parameters. Please enter compiler and seeds file."
	    if [ -z "$1" ]
		  then
	    	echo "No compiler supplied."
	    	exit 1
	    fi

	    if [ -z "$2" ]
	  	  then
	    	echo "Please set the file with seeds of the testcases."
	    	exit 1
	    fi
	    exit 1
	else
	# Check parameters are valid
	    # Check if the first parameter is a compiler exist in the machine
	    var=`dpkg --list | grep compiler | grep -c $1`
	    if (($var < 1)) ; 
		  then
	   		echo "error: no such a compiler" >&2; exit 1
	    fi		
	
        # Check if second parameter is a real file
		if test -f "$2" ; then
			true
		else
			echo "Cannot find file $2"; exit 1
		fi	
	fi
}


################### MAIN ###############################
echo "This script generates testcases with locations of required checks of undefined behviours (Good Seeds only)."
echo " - date: $(date '+%Y-%m-%d at %H:%M.%S')"
echo " - host name $(hostname -f)"
echo " - script path: $(readlink $0)"

### Checks ###
test_input $1 $2

# Basic parameters
compiler=$1				# Compiler to test
seeds=$2 				# File with all the seeds to use - shall be only good seeds here!
folder=seedsSafeLists	# Fix folder to find all these seeds' safe lists

echo ">> Reads seeds from $seeds, Start extracting the safe-lists"
## Read seeds from line
while IFS= read -r line
do
	testcaseNameRes=$folder'/__test'$line'Results'
    # Check if second parameter is a real file
	if test -f "$testcaseNameRes" ; then
		#echo "Skips $testcaseNameRes"
		true # skip, we already did it
	else
		./RSS3_2_genUnsafeInfo4Tests.sh "$compiler" "$line" "$folder"
	fi	
done < "$seeds"
