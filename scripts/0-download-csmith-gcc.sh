#!/bin/bash
shopt -s extglob # Activate extended pattern matching in bash

working_folder=/home/user42
nb_processes=2

sudo apt-get install make
sudo apt-get install flex -y
sudo apt-get install -y bison

# Downloading LLVM and Csmith sources, building Csmith
TMP_SOURCE_FOLDER=$(mktemp -d $working_folder/.sources.XXXXXXX.tmp)
cd $TMP_SOURCE_FOLDER
## Get gcc
git clone git://gcc.gnu.org/git/gcc.git
## Get pre-req. isl-0.18.tar.bz2;gmp-6.1.0.tar.bz2;mpc-1.0.3.tar.gz; mpfr-3.1.4.tar.bz2 => works for gcc-10
## GMP
wget ftp://gcc.gnu.org/pub/gcc/infrastructure/gmp-6.1.0.tar.bz2
bunzip2 gmp-6.1.0.tar.bz2
tar xvf gmp-6.1.0.tar
cd gmp-6.1.0
./configure --disable-shared --enable-static --prefix=/tmp/gcc
make && make check && make install
cd ..
## MPFR
wget ftp://gcc.gnu.org/pub/gcc/infrastructure/mpfr-3.1.4.tar.bz2
bunzip2 mpfr-3.1.4.tar.bz2
tar xvf mpfr-3.1.4.tar
cd mpfr-3.1.4
./configure --disable-shared --enable-static --prefix=/tmp/gcc --with-gmp=/tmp/gcc
make && make check && make install
cd ..
## MPC
wget ftp://gcc.gnu.org/pub/gcc/infrastructure/mpc-1.0.3.tar.gz
tar zxvf mpc-1.0.3.tar.gz
cd mpc-1.0.3
./configure --disable-shared --enable-static --prefix=/tmp/gcc --with-gmp=/tmp/gcc --with-mpfr=/tmp/gcc
make && make check && make install
cd ..
## ISL
wget ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.18.tar.bz2
bunzip2 isl-0.18.tar.bz2
tar xvf isl-0.18.tar
cd isl-0.18
./configure --with-gmp-prefix=/tmp/gcc --disable-shared --enable-static --prefix=/tmp/isl
make -j $THREADS && make install
cd ..
## Cleaning
rm gmp-6.1.0.tar 
rm isl-0.18.tar 
rm mpc-1.0.3.tar.gz 
rm mpfr-3.1.4.tar 
## Get csmith
git clone https://github.com/csmith-project/csmith.git
cd ./csmith
cmake .
make -j$(nproc)
rm ./scripts/compiler_test.in
cd ..
echo ">> Downloading GCC and Csmith sources, building Csmith ($TMP_SOURCE_FOLDER)"
