# CsmithEdge - AE

## Install the Tool with its requirements
Before starting, please check you have all the requirements installed.

You can do this by running this script, which will also clone Csmith into this project.
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
Where compiler B is required only for lazy version. For example:
```
/home/user42/git/CsmithEdge/scripts/CsmithEdge.sh /home/user42/git/CsmithEdge/ single_file_gen.log 1235349863 gcc-10 clang-10 1 0
```
or
```
/home/user42/git/CsmithEdge/scripts/CsmithEdge.sh /home/user42/git/CsmithEdge/ single_file_gen.log 1235349863 clang-11 clang-11 0 0
```

## Generating Tests (section 4.1 and 4 in general)

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

This section describes how to restore the results of section 4.2 in the evaluation. The scripts are currently set to run on a small set of programs. To restore similar results to what was reported in the paper, one should use a much larger set (say around 100,000 programs).

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


