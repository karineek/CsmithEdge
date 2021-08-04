Differential Testing - Rate
===========================

This folder contains the scripts to reproduce the rate of differential testing for 3 tools: Csmith, CsmithEdge and CsmithEdge with optimizations.
We did differential testing using GCC and LLVM with -O2 optimization to test the throughput of the tools.

Run:
```
./1-gen-com-run-O2.sh <csmithedge-gitrepo-path> <#programs-generate>
```
to generate and perform differential testing with Csmith.

Run:
```
./2-gen-com-run-O2-opt.sh <csmithedge-gitrepo-path> <seeds-file>
```
to generate and perform differential testing with CsmithEdge with optimizations.
