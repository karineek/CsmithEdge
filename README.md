# CsmithEdge

Experimental data and scripts to reproduce the results reported for CsmithEdge (updated to July 2021).

Results and data appeared in the paper along with additional details, can be found [here](https://github.com/karineek/CsmithEdge/tree/master/results).

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

** see subfolders, we modified few files in each. Replace the files in these folders with ours.

See AE folder for instructions how to run the tool.

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
cd CsmithEdge/scripts 
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
