# CsmithEdge

Experimental data and scripts to reproduce the results reported for CsmithEdge (updated to September 2024).

Results and data that appeared in the paper along with additional details, can be found [here](https://github.com/karineek/CsmithEdge/tree/master/results).

## Overview

Compiler fuzzing techniques require a means of generating programs that are free from undefined behaviour (UB) to reliably reveal miscompilation bugs. Existing program generators such as CSMITH achieve UB-freedom by heavily restricting the form of generated programs. The idiomatic nature of the resulting programs risks limiting the test coverage they can offer, and thus the compiler bugs they can discover. We investigate the idea of adapting existing fuzzers to be less restrictive concerning UB, in the practical setting of C compiler testing via a new tool, CSMITHEDGE, which extends CSMITH. CSMITHEDGE probabilistically weakens the constraints used to enforce UB-freedom, thus generated programs are no longer guaranteed to be UB-free. It then employs several off-the-shelf UB detection tools and a novel dynamic analysis to (a) detect cases where the generated program exhibits UB and (b) determine where CSMITH has been too conservative in its use of safe math wrappers that guarantee UB-freedom for arithmetic operations, removing the use of redundant ones. The resulting UB-free programs can be used to test for miscompilation bugs via differential testing. The non-UB-free programs can still be used to check that the compiler under test does not crash or hang. Our experiments on recent versions of GCC, LLVM and the Microsoft Visual Studio Compiler show that CSMITHEDGE was able to discover 7 previously unknown miscompilation bugs (5 already fixed in response to our reports) that could not be found via intensive testing using CSMITH, and 2 compiler-hang bugs that were fixed independently shortly before we considered reporting them.

## Citation
*K. Even-Mendoza, C. Cadar and A. F. Donaldson, "Closer to the Edge: Testing Compilers More Thoroughly by Being Less Conservative About Undefined Behaviour," 2020 35th IEEE/ACM International Conference on Automated Software Engineering (ASE), Melbourne, VIC, Australia, 2020, pp. 1219-1223.
keywords: {Computer bugs;Prototypes;Tools;Software;Reliability;Testing;Software engineering;Compilers;fuzzing;Csmith;GCC}*
```
@inproceedings{10.1145/3324884.3418933,
author = {Even-Mendoza, Karine and Cadar, Cristian and Donaldson, Alastair F.},
title = {Closer to the edge: testing compilers more thoroughly by being less conservative about undefined behaviour},
year = {2021},
isbn = {9781450367684},
publisher = {Association for Computing Machinery},
address = {New York, NY, USA},
url = {https://doi.org/10.1145/3324884.3418933},
doi = {10.1145/3324884.3418933},
abstract = {Randomised compiler testing techniques require a means of generating programs that are free from undefined behaviour (UB) in order to reliably reveal miscompilation bugs. Existing program generators such as Csmith heavily restrict the form of generated programs in order to achieve UB-freedom. We hypothesise that the idiomatic nature of such programs limits the test coverage they can offer. Our idea is to generate less restricted programs that are still UB-free---programs that get closer to the edge of UB, but that do not quite cross the edge. We present preliminary support for our idea via a prototype tool, CsmithEdge, which uses simple dynamic analysis to determine where Csmith has been too conservative in its use of safe math wrappers that guarantee UB-freedom for arithmetic operations. By eliminating redundant wrappers, CsmithEdge was able to discover two new miscompilation bugs in GCC that could not be found via intensive testing using regular Csmith, and to achieve substantial differences in code coverage on GCC compared with regular Csmith.},
booktitle = {Proceedings of the 35th IEEE/ACM International Conference on Automated Software Engineering},
pages = {1219–1223},
numpages = {5},
keywords = {Csmith, GCC, compilers, fuzzing},
location = {Virtual Event, Australia},
series = {ASE '20}
}
```

*Even-Mendoza, K., Cadar, C. & Donaldson, A.F. CSMITHEDGE: more effective compiler testing by handling undefined behaviour less conservatively. 
Empir Software Eng 27, 129 (2022). https://doi.org/10.1007/s10664-022-10146-1*
```
@article{10.1007/s10664-022-10146-1,
author = {Even-Mendoza, Karine and Cadar, Cristian and Donaldson, Alastair F.},
title = {CsmithEdge: more effective compiler testing by handling undefined behaviour less conservatively},
year = {2022},
issue_date = {Nov 2022},
publisher = {Kluwer Academic Publishers},
address = {USA},
volume = {27},
number = {6},
issn = {1382-3256},
url = {https://doi.org/10.1007/s10664-022-10146-1},
doi = {10.1007/s10664-022-10146-1},
abstract = {Compiler fuzzing techniques require a means of generating programs that are free from undefined behaviour (UB) to reliably reveal miscompilation bugs. Existing program generators such as Csmith achieve UB-freedom by heavily restricting the form of generated programs. The idiomatic nature of the resulting programs risks limiting the test coverage they can offer, and thus the compiler bugs they can discover. We investigate the idea of adapting existing fuzzers to be less restrictive concerning UB, in the practical setting of C compiler testing via a new tool, CsmithEdge, which extends Csmith. CsmithEdge probabilistically weakens the constraints used to enforce UB-freedom, thus generated programs are no longer guaranteed to be UB-free. It then employs several off-the-shelf UB detection tools and a novel dynamic analysis to (a) detect cases where the generated program exhibits UB and (b) determine where Csmith has been too conservative in its use of safe math wrappers that guarantee UB-freedom for arithmetic operations, removing the use of redundant ones. The resulting UB-free programs can be used to test for miscompilation bugs via differential testing. The non-UB-free programs can still be used to check that the compiler under test does not crash or hang. Our experiments on recent versions of GCC, LLVM and the Microsoft Visual Studio Compiler show that CsmithEdge was able to discover 7 previously unknown miscompilation bugs (5 already fixed in response to our reports) that could not be found via intensive testing using Csmith, and 2 compiler-hang bugs that were fixed independently shortly before we considered reporting them.},
journal = {Empirical Softw. Engg.},
month = {nov},
numpages = {35},
keywords = {MSVC, LLVM, GCC, Csmith, Fuzzing, Compilers}
}
```

## Links
Githhub Repository:
```
https://github.com/karineek/CsmithEdge
```

Project:
```
https://srg.doc.ic.ac.uk/projects/csmithedge/
```

## Installation

To install from source, follow the instructions in this section. Scroll down to use Docker.

Requirements
------------
1. csmith (clone version: d0b585a, 31 of May 2020).
2. gfauto (clone version: 8030f33, 15 of July 2021).
3. Frama-c 22.0 (Titanium)
4. Python version 3.8.10 (known to work also with 3.6 and 3.7)
5. Python3 includes also install of pip (python3-pip package) 
6. cmake version 3.16.3
7. Ninja 1.10.0
8. GCC 10 (installed and can be accessed as gcc-10, needed only for coverage build of GCC)
9. Clang-10 for the scripts

** see subfolders, we modified a few files in each. Replace the files in these folders with ours.

See the AE folder for instructions on how to run the tool.

## Install CsmithEdge from source
CsmithEdge is built on top of Csmith. You need to first get the source files of csmith:
```
cd CsmithEdge
rm -rf csmith 
git clone https://github.com/csmith-project/csmith.git
cd csmith/
git checkout d0b585a
cd ..
git stash
```

Before build, if you do not have boost installed:
```
sudo apt-get install libboost-all-dev
``` 
Then build CsmithEdge:
```
cd csmith
mkdir build
cd build
cmake ../
make
```

If you do not have Frama-C installed, use this script:
```
./0-install-frama-c.sh 
```

Check frama-c is installed:
```
eval $(opam config env)  # this is some systems needed
frama-c --version
```

## Running CsmithEdge:
To use this script, you also need clang-10. To install clang-10:
```
sudo apt install clang-10
```

Say FOLDER-CSMITHEDGE is the path to where the CsmithEdge project is (where you cloned this repository).
To run CsmithEdge:
```
cd scripts 
./CsmithEdge.sh <FOLDER-CSMITHEDGE> <logger-file> <seed> <compiler-A> <compiler-B> <Lazy?> <Extra-debug-info?>
```
Generation modes of CsmithEdge: three different values of Lazy?
1. "--default": CsmithEdge Regular Mode
2. "--lazy": CsmithEdge Lazy Mode
3. "--csmith": CsmithEdge Relex Arithmetic Only Mode (ASE 2020 Paper).
Debug information: with 1 for extra debug information (value via Extra-debug-info?).

For example:
```
./CsmithEdge.sh /home/ubuntu/CsmithEdge/ output-gen.log 3172827853 gcc-10 clang-13 --default 1
```
Then you can use it to test compiles. Say GCC-10 and Clang-11:
```
gcc-10 -I/home/ubuntu/CsmithEdge/csmith/build/runtime/ -I/home/ubuntu/CsmithEdge/csmith/RRS_runtime_test/ /home/ubuntu/CsmithEdge//scripts/CsmithEdge/seedsProbs/tmp/__test1716897851M.c
clang-11 -I/home/ubuntu/CsmithEdge/csmith/build/runtime/ -I/home/ubuntu/CsmithEdge/csmith/RRS_runtime_test/ /home/ubuntu/CsmithEdge//scripts/CsmithEdge/seedsProbs/tmp/__test1716897851M.c
```

## Using Docker

Build the image:
```
docker build -t dockerfile .
```

Start a new docker container from the image:
```
docker run -it dockerfile
```

Once inside the docker, fix frama-c:
```
eval $(opam config env)
frama-c --version
```

You can run the flowing to test all is working well:
```
cd scripts/
./CsmithEdge.sh /home/ubuntu/CsmithEdge/ output-gen.log 3172827853 gcc clang --default 1
gcc-10 -I/home/ubuntu/CsmithEdge/csmith/build/runtime/ -I/home/ubuntu/CsmithEdge/csmith/RRS_runtime_test/ /home/ubuntu/CsmithEdge//scripts/CsmithEdge/seedsProbs/tmp/__test3172827853M.c -o g.o
clang -I/home/ubuntu/CsmithEdge/csmith/build/runtime/ -I/home/ubuntu/CsmithEdge/csmith/RRS_runtime_test/ /home/ubuntu/CsmithEdge//scripts/CsmithEdge/seedsProbs/tmp/__test3172827853M.c -o c.o
./g.o 
./c.o 
```
You can run again with a different seed than 3172827853.
