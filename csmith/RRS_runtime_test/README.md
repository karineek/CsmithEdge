### Use to compile csmith test-cases with RRS - Use to test compilers stage

1. After generation with RRS_runtime_gen folder, use it as a compiler test-case.
2. Replace redandant calls to wrappers by the exact expression (script)
3. Compile the result:
	ulimit -St 500; gcc -I $build_folder/../RRS_runtime_test/ -I $build_folder/runtime/ -w -O $prog -o $output
	ulimit -St 500; ./$output >> $printoutput 2>&1
4. Compare the result in $printoutput between compilers.

