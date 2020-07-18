#!/bin/bash
shopt -s extglob # Activate extended pattern matching in bash

working_folder=/home/user42
nb_processes=2

# Downloading LLVM and Csmith sources, building Csmith
TMP_SOURCE_FOLDER=$1
cd $TMP_SOURCE_FOLDER

## Get pre-req. isl-0.18.tar.bz2;gmp-6.1.0.tar.bz2;mpc-1.0.3.tar.gz; mpfr-3.1.4.tar.bz2 => works for gcc-10
## GMP
cd gmp-6.1.0
./configure --disable-shared --enable-static --prefix=/tmp/gcc
make && make check && make install
cd ..
## MPFR
cd mpfr-3.1.4
./configure --disable-shared --enable-static --prefix=/tmp/gcc --with-gmp=/tmp/gcc
make && make check && make install
cd ..
## MPC
cd mpc-1.0.3
./configure --disable-shared --enable-static --prefix=/tmp/gcc --with-gmp=/tmp/gcc --with-mpfr=/tmp/gcc
make && make check && make install
cd ..
## ISL
cd isl-0.18
./configure --with-gmp-prefix=/tmp/gcc --disable-shared --enable-static --prefix=/tmp/isl
make -j $THREADS && make install
cd ..
echo ">> Downloading GCC and Csmith sources, building Csmith ($TMP_SOURCE_FOLDER)"
