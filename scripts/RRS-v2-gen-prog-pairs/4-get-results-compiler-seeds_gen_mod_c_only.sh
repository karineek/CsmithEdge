#!/bin/bash
#### GCC-7, modified csmith, macros, no compiler optimization ####
modify=1 																	# 0-original, 1-modify
csmith_location=../../csmith 												# csmith location
csmith_flags=" --bitfields --packed-struct" 								#" --bitfields --packed-struct --math-notmp --annotated-arith-wrappers" 
configuration_location=../../Data/comp_confg/compiler_test_D.in 			# config file locatoin
outputs_location=../ 														# where we will put all outputs
#compile_line="-I../../csmith_runtime_orig -I../../csmith_runtime_orig_build -DUSE_MATH_MACROS -w -O" # how we compile it
#compile_line="-I../../csmith_runtime_orig -I../../csmith_runtime_orig_build -DUSE_MATH_MACROS -w -O2" # how we compile it
compile_line="-I../../csmith_runtime_orig -I../../csmith_runtime_orig_build -w -O" # how we compile it
i=96

#seed_location=seeds_out_test_4_10.txt # seed location - to dump .c files pairs
seed_location=seeds_out_test.txt # seed location - to dump .c files pairs
./RSS4_1-compiler_test_r.sh $i $modify $seed_location $csmith_location $configuration_location $outputs_location "$compile_line" "$csmith_flags"



