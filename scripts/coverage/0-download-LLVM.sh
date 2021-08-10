#!/bin/bash
working_folder=$1

# Downloading LLVM and Csmith sources, building Csmith
TMP_SOURCE_FOLDER=$(mktemp -d $working_folder/.sources.XXXXXXX.tmp)
cd $TMP_SOURCE_FOLDER
## LLVM
wget https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/llvm-11.0.0.src.tar.xz
tar -xvf llvm-11.0.0.src.tar.xz
rm llvm-11.0.0.src.tar.xz
mv llvm-11.0.0.src llvm-source
cd ./llvm-source/tools
wget https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/clang-11.0.0.src.tar.xz
tar -xvf clang-11.0.0.src.tar.xz
rm clang-11.0.0.src.tar.xz
mv clang-11.0.0.src clang
echo ">> Downloading LLVM 11 source filese ($TMP_SOURCE_FOLDER)"
