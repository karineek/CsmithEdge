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
frama-c --version
```
