# Donwload and Install Csmith

We use a modified version of Csmith as part of our precess to generate our relaxed compiler test-cases. We modified the following files:
```
src/AbsProgramGenerator.cpp
src/ArrayVariable.cpp
src/Block.cpp
src/Block.h
src/CGContext.cpp
src/CGContext.h
src/CGOptions.cpp
src/CGOptions.h
src/CMakeLists.txt
src/ExpressionVariable.cpp
src/FactPointTo.cpp
src/FactPointTo.h
src/FunctionInvocationBinary.cpp
src/Makefile.am
src/Makefile.in
src/RandomProgramGenerator.cpp
src/SafeOpFlags.cpp
src/SafeOpFlags.h
src/Statement.cpp
src/StatementFor.cpp
src/StatementGoto.cpp
src/StatementGoto.h
src/StatementIf.cpp
src/Variable.cpp
src/VariableSelector.cpp
src/WeakenSafeAnalysesMgr.h
src/WeakenSafeAnalysesMgr.cpp
```

## Build CsmithEdge

Clone Csmith here and compile with our version of classes in src folder. The folders RRS_runtime_gen and RRS_runtime_test are copies of the regular Csmith runtime folder with our modifications for each stage of the dynamic analysis for remove redundant math safe wrappers for arithmetic operators, when RRS_runtime_gen: required to run the analysis and RRS_runtime_test: required to run the test cases with the analysis result.

Then from root folder of csmith, build the Csmith with our modifications as before: 
```
mkdir build
cd build
cmake ../
make
```
