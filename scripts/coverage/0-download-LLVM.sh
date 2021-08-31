#!/bin/bash
working_folder=$1
version=$2
if [ -z "$version" ] ; then
	version=11
fi

# Downloading LLVM and Csmith sources, building Csmith
TMP_SOURCE_FOLDER=$(mktemp -d $working_folder/.sources.XXXXXXX.tmp)
cd $TMP_SOURCE_FOLDER
## LLVM
wget https://github.com/llvm/llvm-project/releases/download/llvmorg-$version.0.0/llvm-$version.0.0.src.tar.xz
tar -xvf llvm-$version.0.0.src.tar.xz
rm llvm-$version.0.0.src.tar.xz
mv llvm-$version.0.0.src llvm-source
cd ./llvm-source/tools
wget https://github.com/llvm/llvm-project/releases/download/llvmorg-$version.0.0/clang-$version.0.0.src.tar.xz
tar -xvf clang-$version.0.0.src.tar.xz
rm clang-$version.0.0.src.tar.xz
mv clang-$version.0.0.src clang
echo ">> Downloading LLVM $version source filese ($TMP_SOURCE_FOLDER)"
