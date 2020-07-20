## Read seeds from line
seeds=seeds_out_test.txt
while IFS= read -r seed
do
	echo ">> Compile $seed"
	clang -O -w -I/home/user42/git/MinCond/csmith/build/runtime/ -I/home/user42/git/MinCond/csmith/runtime/ ../csmith/__test$seed.c -o csmith_clang_6_test$seed
	clang-10 -O -w -I/home/user42/git/MinCond/csmith/build/runtime/ -I/home/user42/git/MinCond/csmith/runtime/ ../csmith/__test$seed.c -o csmith_clang_10_test$seed
	gcc-7 -O -w -I/home/user42/git/MinCond/csmith/build/runtime/ -I/home/user42/git/MinCond/csmith/runtime/ ../csmith/__test$seed.c -o csmith_gcc_7_test$seed	
	gcc-9 -O -w -I/home/user42/git/MinCond/csmith/build/runtime/ -I/home/user42/git/MinCond/csmith/runtime/ ../csmith/__test$seed.c -o csmith_gcc_9_test$seed	
	/home/user42/gcc-csmith-0/gcc-build/gcc/xgcc -B/home/user42/gcc-csmith-0/gcc-build/gcc/. -O2 -w -I/home/user42/git/MinCond/csmith/build/runtime/ -I/home/user42/git/MinCond/csmith/runtime/ ../csmith/__test$seed.c -o csmith_gcc_10_test$seed
	clang -O2 -w -I/home/user42/git/MinCond/csmith/build/runtime/ -I/home/user42/git/MinCond/csmith/RRS_runtime_test/ ../modify/__test"$seed"M.c -o modify_clang_6_test$seed
	clang-10 -O2 -w -I/home/user42/git/MinCond/csmith/build/runtime/ -I/home/user42/git/MinCond/csmith/RRS_runtime_test/ ../modify/__test"$seed"M.c -o modify_clang_10_test$seed
	gcc-7 -O2 -w -I/home/user42/git/MinCond/csmith/build/runtime/ -I/home/user42/git/MinCond/csmith/RRS_runtime_test/ ../modify/__test"$seed"M.c -o modify_gcc_7_test$seed
	gcc-9 -O2 -w -I/home/user42/git/MinCond/csmith/build/runtime/ -I/home/user42/git/MinCond/csmith/RRS_runtime_test/ ../modify/__test"$seed"M.c -o modify_gcc_9_test$seed
	/home/user42/gcc-csmith-0/gcc-build/gcc/xgcc -B/home/user42/gcc-csmith-0/gcc-build/gcc/. -O2 -w -I/home/user42/git/MinCond/csmith/build/runtime/ -I/home/user42/git/MinCond/csmith/RRS_runtime_test/ ../modify/__test"$seed"M.c -o modify_gcc_10_test$seed
done < "$seeds"
