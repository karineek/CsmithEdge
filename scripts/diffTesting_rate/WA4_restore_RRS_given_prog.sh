#!/bin/bash

#################################### Inject flags to the test ####################
function inject_flags {
testcase=$1
lastline=$2
if [ ! -z "$lastline" ]
then
	declare -i lastindex=0;
    declare -i lastindexlen=0;
	## Find last index
	for (( i=0; i<${#lastline}; i++ )); do 
        if [ "${lastline:$i:1}" == "_" ]; then
			if [ "${lastline:i:18}" == "___REMOVE_SAFE__OP" ]; then
				lastindex=i+23
				j=$lastindex
				num=${lastline:$j:1}
				while [ ! -z "${num##*[!0-9]*}" ]; do
					j=$j+1
					num=${lastline:$j:1}
				done
				lastindexlen=$j-$lastindex
				#echo "Found index" $lastindex " to " $(( lastindexlen + lastindex ))
			fi
		fi
	done
	
	max=$((${lastline:lastindex:lastindexlen} + 1))
	# Gen bool flag up to max
	inj="static unsigned short __safe_print_flag[$max] = { 0"
	for (( k=0; k<$max; k++)); do
		inj+=", 0" 
	done
	STR=$' };\n'
	inj+="$STR"

	## Inject:
	echo "$inj" |cat - $testcase > /tmp/out && mv /tmp/out $testcase # add these static flags
else
	## No safe calls, adds dummy array so we can pass compilation 
	# Gen bool flag up to max
	inj="static unsigned short __safe_print_flag[1] = { 0 "
	STR=$' };\n'
	inj+="$STR"

	## Inject:
	echo "$inj" |cat - $testcase > /tmp/out && mv /tmp/out $testcase # add these static flags
fi
}

#################################### AMEND CODE ##################################
function amend_testcase {
testcase=$1

# Add locations of calls to safe_function wrappers
keyword_raw='/* ___SAFE__OP */('
keyword_regexp="$(printf '%s' "$keyword_raw" | sed -e 's/[]\/$*.^|[]/\\&/g')"

replacement_raw='(__COUNTER__, '
replacement_regexp="$(printf '%s' "$replacement_raw" | sed -e 's/[\/&]/\\&/g')"
sed -i "s/$keyword_regexp/$replacement_regexp/g" $testcase
}

#################################### GEN  Must SAFE location ######################
function gen_loc {
testcaseName='test'$1
testcase=$folder/'__'$testcaseName'.c'
testcaseEXEC=$folder/'__'$testcaseName'Exec'
testcaseRes=$folder/'__'$testcaseName'Results'
rm -f $testcaseRes

# DO the test: 
(ulimit -St 300;$compiler -I$csmith_location/RRS_runtime_gen -I$csmith_location/build/runtime -O -w $testcase -o $testcaseEXEC)
(ulimit -St 50; $testcaseEXEC 2> /tmp/err | grep -e 'Condition' -e 'checksum' | sort | uniq | head -9999 > /tmp/out)

# 1. Check no error
res=`cat /tmp/err | wc -l`
rm /tmp/err
#echo "Result error counter is" $res
if (($res > 0)); 
	then
	echo 'Skip the test' $testcaseRes 'due to timeout/error.'
else
	# 2. Check we have a result 
	checksumEx=`cat /tmp/out | grep 'checksum' | wc -l`
    	#echo "checksum counter is" $checksumEx
	if (($checksumEx == 0)); 
		then
		echo 'Skip the test' $testcaseRes 'due to an error (no checksum).'
	else
       	# 3. Test if the list is complete
		# Test if there is a large loop and we had to cut the info.
		cat /tmp/out | grep 'Condition' | sort | uniq | head -9999 > $testcaseRes
       	rm /tmp/out
		LC=`cat $testcaseRes | wc -l`
        	#echo "There are " $LC " conditions"
		if (($LC >= 9999)); 
			then
			echo '(error) Not all locations written to' $testcaseRes
		fi
	fi
fi

#clean
rm $testcaseEXEC
}

#################################### GEN TEST ####################################
function get_test {
## Single test - create a test case and its precompilation
seed=$1
testcase=$folder/'__test'$1'.c'
original_testcase=$2

# Gen. testcase with csmith
cp $original_testcase $testcase

# Add flags to print each notificatoin once (via static variables)
lastline=`grep "___REMOVE_SAFE__OP" $testcase | tail -1`
inject_flags "$testcase" "$lastline"

# Amend code with the single printf per location
amend_testcase "$testcase"

# Generate locations SAFE required
gen_loc "$seed"

#clean
rm $testcase
}

################### MAIN ###############################
## Called: ./RSS3_2_genUnsafeInfo4Tests.sh "$compiler" "$seed" "$rrs_folder" $testfile $csmith_location
# Single iteration, requires a compiler and a seed
CSMITH_USER_OPTIONS=" --bitfields --packed-struct"
# Basic parameters
compiler=$1		# Compiler to test
seed=$2 		# File with all the seeds to use
folder=$3 		# folder for all the results
testfile=$4		# testcase we have
csmith_location=$5	# Csmith location
 
# Run a Single case:
get_test $seed $testfile	## Run a single test

