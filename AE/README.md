# CsmithEdge - AE

## Install the Tool with its requirements
Before starting, please check you have all the requirements installed. The installation pulls several packages of python and other standard tools, which may take time if your internet connection is poor. There is no installation of our code at this phase, and you may skip it if you have all the requirements already installed.

You can do this by running this script; this script will also clone Csmith into this project.
```
./setupReq.sh <path to CsmithEdge folder>
```
for example:
```
./setupReq.sh /home/user42/git
```

## Generating a Single Test Case:

To generate a single test case with CsmithEdege, please use the following script (this will not invoke diff-testing scripts):
```
/home/user42/git/CsmithEdge/scripts/CsmithEdge.sh <base-folder> <logger> <seed> <compiler A> <compiler B> <Reg. or lazy> <print-debug-information>
```
Where compiler B is required only for the lazy version. For example:
```
/home/user42/git/CsmithEdge/scripts/CsmithEdge.sh /home/user42/git/CsmithEdge/ single_file_gen.log 1235349863 gcc-10 clang-10 --lazy 0
```
or
```
/home/user42/git/CsmithEdge/scripts/CsmithEdge.sh /home/user42/git/CsmithEdge/ single_file_gen.log 1235349863 clang-11 clang-11 --default 0
```

## Generating Tests (sections 4.1 and 4 in general)

CsmithEdge (regular and lazy) diff-testing with two compilers (A and B): 
```
./gen_and_diff_testing_csmithedge.sh <base-folder> <Reg. or lazy> <compiler A> <compiler B>
```
For example, diff-testing with regular CsmithEdge, clang-10 and gcc-10:
```
./gen_and_diff_testing_csmithedge.sh /home/user42/git/CsmithEdge/ 0 clang-10 gcc-10
```
or lazy CsmithEdge with gcc-11 and clang-12
```
./gen_and_diff_testing_csmithedge.sh /home/user42/git/CsmithEdge/ 1 gcc-11 clang-12
```

## Rate of differential testing (Section 4.2)

This section describes how to restore the results of section 4.2 in the evaluation. The scripts are currently set to run on a small set of programs. One should use a much larger set (say around 100,000 programs) to restore similar results to what was reported in the paper.

These scripts print the results with 10 s, 50 s and 120 s timeout. Each script run should take around 15-30 minutes.


1. Script to measure the rate for Csmith:
```
./rate_small_csmith.sh <Project folder> <output-file-of-diff-testing>
```
for example:
```
./rate_small_csmith.sh /home/user42/git/CsmithEdge/ output.log
```

2. Script to measure the rate for CsmithEdge:
```
./rate_small_csmithedge.sh <Project folder> <seeds-file> <output-file-of-diff-testing>
```
for example
```
./rate_small_csmithedge.sh /home/user42/git/CsmithEdge/ /home/user42/git/CsmithEdge/Data/seeds_all/seeds_out1.txt output.log
```

3. Script to measure the rate for CsmithEdge Lazy approach:
```
./rate_small_lazy.sh <Project folder> <seeds-file> <output-file-of-diff-testing>
```
for example
```
./rate_small_lazy.sh /home/user42/git/CsmithEdge/ /home/user42/git/CsmithEdge/Data/seeds_all/seeds_out1.txt output.log
```

## Coverage (Section 4.3)
Section 4.3 compares the coverage of four different sets of programs (CsmithEdge, CsmithEdge with WSA only, CsmithEdge with WDA only and Csmith). To reproduce with a smaller set (set of 10 programs instead of 135k):

### Set 1 - CsmithEdge
TODO 

### Set 2 - CsmithEdge with only weakening the static analysis results
TODO

### Set 3 - CsmithEdge with only weakening the dynamic analysis results
Run the following script for GCC coverage:
```
./../scripts/coverage/gcc-coverage/DA-only-gcc/5-test-dest-machine.sh 3 <compiler-under-measure> <CsmithEdge-folder> <total-programs> <measure-cov-each-n-programs> 1
```
and for LLVM:
```
./../scripts/coverage/llvm-coverage/DA-only-gcc/5-test-dest-machine.sh 3 <compiler-under-measure> <CsmithEdge-folder> <total-programs> <measure-cov-each-n-programs> 1
```
for example:
```
./../scripts/coverage/gcc-coverage/DA-only-gcc/5-test-dest-machine.sh 3 /home/user42/GCC/gcc-csmith-1/ /home/user42/CsmithEdge/ 10 5 1
```
### Set 4 - Csmith
Run the following script for GCC coverage:
```
./../scripts/coverage/gcc-coverage/DA-only-gcc/5-test-dest-machine.sh 4 <compiler-under-measure> <CsmithEdge-folder> <total-programs> <measure-cov-each-n-programs> 0
```
and for LLVM:
```
./../scripts/coverage/llvm-coverage/DA-only-gcc/5-test-dest-machine.sh 4 <compiler-under-measure> <CsmithEdge-folder> <total-programs> <measure-cov-each-n-programs> 0
```
for example:
```
./../scripts/coverage/gcc-coverage/DA-only-gcc/5-test-dest-machine.sh 4 /home/user42/GCC/gcc-csmith-1/ /home/user42/CsmithEdge/ 10 5 0
```
