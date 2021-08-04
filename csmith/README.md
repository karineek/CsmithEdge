# Donwload and Install Csmith

We use a modified version of Csmith as part of our precess to generate our compiler test-cases.

Clone Csmith here and compile with our version of classes in src folder. The folders RRS_runtime_gen and RRS_runtime_test are copies of the regular Csmith runtime folder with our modifications for each stage of the dynamic analysis for remove redundant math safe wrappers for arithmetic operators, when RRS_runtime_gen: required to run the analysis and RRS_runtime_test: required to run the test cases with the analysis result.

Then from root folder of csmith, build the Csmith with our modifications as before: 
```
mkdir build
cd build
cmake ../
make
```
