## Install GCC-9; LLVM will be compiled with gcc-9
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
sudo apt-get update -y
sudo apt install gcc-9 g++-9 -y
echo ">> (GCC) Set to defualt gcc-9!"
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90 --slave /usr/bin/g++ g++ /usr/bin/g++-9 --slave /usr/bin/gcov gcov /usr/bin/gcov-9
sudo apt-get install clang-6.0 -y
echo ">> (LLVM) Set to defualt clang-6.0!"
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-6.0 60 --slave /usr/bin/clang++ clag++ /usr/bin/clang++-6.0
