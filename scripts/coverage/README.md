# Evaluation - Coverage

## LLVM

1. Get LLVM source code:
```
./0-download-LLVM.sh <base-folder> <version>
```
for example:
```
./0-download-LLVM.sh /home/user42/git/ 11
```

2. Install LLVM with coverage:
```
./1-install-cov-llvm.sh <base-folder> <location-of-llvm-source-code> <number-of-copies>
```
for example:
```
./1-install-cov-llvm.sh /home/user42/LLVM /home/user42/git//.sources.KidEz7e.tmp 1
```

Note that you will need enough RAM. If you have less then 32 GB, you need to allocate a large swap file (e.g., 4 GB).

## GCC

1. Get GCC source code:
```
./0-download-GCC.sh <base-folder> <versioni-optional>
```
for example:
```
./0-download-GCC.sh /home/user42/git/ 10
```

2. Install LLVM with coverage:
```
./1-install-cov-gcc.sh <base-folder> <location-of-llvm-source-code> <number-of-copies>
```
for example:
```
./1-install-cov-gcc.sh /home/user42/GCC/ /home/user42/GCC/.sources.gWPDmjc.tmp/ 1
```


