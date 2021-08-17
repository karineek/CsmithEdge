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
testcase=$2
testcaseEXEC=$folder/'__'$testcaseName'Exec'
testcaseRes=$folder/'__'$testcaseName'Results'

# DO the test: 
ulimit -St 300; $compiler -I$tool_location/RRS_runtime_gen -I$tool_location/build/runtime -O -w $testcase -o $testcaseEXEC
ulimit -St $timeout_bound; $testcaseEXEC 2> /tmp/err | grep -e 'Condition' -e 'checksum' | sort | uniq | head -9999 > /tmp/out

# 1. Check no error
res=`cat /tmp/err | wc -l`
rm /tmp/err
#echo "Result error counter is" $res
if (($res > 0)); 
	then
	echo 'Skip the test' $testcaseRes 'due to timeout/error.'
	touch $folder/'__'$testcaseName'INVALID'
else
	# 2. Check we have a result 
	checksumEx=`cat /tmp/out | grep 'checksum' | wc -l`
    	#echo "checksum counter is" $checksumEx
	if (($checksumEx == 0)); 
		then
		echo 'Skip the test' $testcaseRes 'due to an error (no checksum).'
		touch $folder/'__'$testcaseName'INVALID'
	else
       		# 3. Test if the list is complete
		# Test if there is a large loop and we had to cut the info.
		cat /tmp/out | grep 'Condition' | sort | uniq | head -9999 > $testcaseRes
       		rm /tmp/out
		LC=`cat $testcaseRes | wc -l`
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
testcase=$2

# Add flags to print each notificatoin once (via static variables)
exist=`grep "static unsigned short __safe_print_flag" $testcase | wc -l`
if [ "$exist" -eq "0" ]; then
	lastline=`grep "___REMOVE_SAFE__OP" $testcase | tail -1`
	inject_flags "$testcase" "$lastline"
fi

# Amend code with the single printf per location
amend_testcase "$testcase"

# Generate locations SAFE required
gen_loc "$seed" "$testcase"

#clean
rm $testcase
}

################### MAIN ###############################
# Basic parameters
compiler=$1		# Compiler to test
seed=$2		# testcase seed
testcaseWA=$3 		# testcase name after WA changes
folder=$4		# folder for all the results
testcaseConfg=$5	# Test-case configuration (WA and RRS)
tool_location=$6	# Csmith folder - location
timeout_bound=$7	# csmith-generated programs timeout when diff-testing
 
# Is there any safe wrappers?
isNoSafeCalls=`grep "___REMOVE_SAFE__OP" $testcaseWA | wc -l`
if [ "$isNoSafeCalls" -eq "0" ]; then
	testcaseResEmpty=$folder/'__test'$seed'Results'
	touch $testcaseResEmpty
else
	# Run a Single case:
	cp $testcaseWA $testcaseWA.tmp
	get_test "$seed" "$testcaseWA" 	## Run a single test
	mv $testcaseWA.tmp $testcaseWA
fi
