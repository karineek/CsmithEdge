### Use to compile csmith test-cases with RRS. Post-Gen Dynamic Analysis Stage

1. Generate a test case with --annotated-arith-wrappers option
2. Compile the test-case: (post-gen dynamic analysis)
	ulimit -St 500; gcc -I $build_folder/../RRS_runtime_gen/ -I $build_folder/runtime/ -w -O $prog -o $output
	ulimit -St 500; ./$output >> $printoutput 2>&1
3. Collect the results of the analysis in $printoutput to create a UB-free test-case with minimal arith-ops wrappers
4. See RRS_runtime_test folder how to build it into a proper compiler test-case.

