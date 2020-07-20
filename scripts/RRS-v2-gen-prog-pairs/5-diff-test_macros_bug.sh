#!/bin/bash
function test_seed {
	csmith_name=$1
	rrs_name=$2
	#clang -I$csmith_location/runtime -I$csmith_location/build/runtime -w -O $csmith_name -o temp_func_clang
	ulimit -St 500; $compiler -B/media/user42/74fcf0cb-471c-4501-8a84-8eaf1111613b/home/kar/expriments/gcc/gcc_1_before/build/gcc/. -I$csmith_location/runtime -I$csmith_location/build/runtime -w -O $csmith_name -o temp_func
 	ulimit -St 500; $compiler -B/media/user42/74fcf0cb-471c-4501-8a84-8eaf1111613b/home/kar/expriments/gcc/gcc_1_before/build/gcc/. -I$CEdgeSmithF_location/build/runtime -I$CEdgeSmithF_location/RRS_runtime_test -DUSE_MATH_MACROS -w -O2 $rrs_name -o temp_unsafe_macros
	#$compiler -I$CEdgeSmithF_location/build/runtime -I$CEdgeSmithF_location/RRS_runtime_test -w -O $rrs_name -o temp_unsafe_func
	res1=`./temp_func`
	res2=`./temp_unsafe_macros`
	#res3=`./temp_func_clang`
	#res4=`./temp_unsafe_func`
	#echo "$res1 <=> $res2 <=> $res3 <=> $res4"
	echo "$res1 <=> $res2"
	if [ ! "$res1" == "$res2" ]; then
		echo ">> Error. Results are not the same! ($csmith_name <$compiler> vs. $rrs_name <DUSE_MATH_MACROS>))"
		echo ">> ulimit -St 500; $compiler -B/media/user42/74fcf0cb-471c-4501-8a84-8eaf1111613b/home/kar/expriments/gcc/gcc_1_before/build/gcc/. -I$CEdgeSmithF_location/build/runtime -I$CEdgeSmithF_location/RRS_runtime_test -DUSE_MATH_MACROS -w -O2 $rrs_name -o temp_unsafe_macros"
	fi

	#if [ ! "$res3" == "$res2" ]; then
	#	echo ">> Error. Results are not the same! ($csmith_name<clang> vs. $rrs_name<DUSE_MATH_MACROS>))"
	#fi
	#if [ ! "$res4" == "$res2" ]; then
	#	echo ">> Error. Results are not the same! ($rrs_name<$compiler> vs. $rrs_name<DUSE_MATH_MACROS>)"
	#fi
}

########################## START TESTS ##################

seeds=$1				# Seeds files
csmith_location=$4		# Csmith location
CEdgeSmithF_location=$5	# Csmith location with our modifications
compiler=$6				# Tested compiler
## Pairs of semantically the same C programs ##
CsmithF=$2
CEdgeSmithF=$3

echo ">> compiler. . . . . . . . . . . . . . . :" $compiler
echo ">> Reads seeds from. . . . . . . . . . . :" $seeds
echo ">> csmith programs folder. . . . . . . . :" $CsmithF
echo ">> csmith programs folder. . . . . . . . :" $CEdgeSmithF
echo ">> csmith location . . . . . . . . . . . :" $csmith_location
echo ">> csmith with our modifications location:" $CEdgeSmithF_location

## Read seeds from line
while IFS= read -r seed
do
	file1="$CsmithF/__test"$seed".c"
	file2="$CEdgeSmithF/__test"$seed"M.c"
	test_seed "$file1" "$file2"
done < "$seeds"
