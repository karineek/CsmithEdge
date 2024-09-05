# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Create User
USER root
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN useradd -ms /bin/bash ubuntu

# Install dependencies
RUN apt-get update
RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y
RUN add-apt-repository universe -y
RUN apt-get install -y git build-essential wget curl
RUN apt-get update -y
RUN apt autoremove -y
## Compilers:
RUN apt install gcc-10 g++-10 -y
RUN apt-get install clang-11 clang-10 -y

## For Csmith
RUN apt-get install make
RUN apt-get install flex -y
RUN apt-get install -y bison
RUN apt install -y rename
RUN apt install -y cmake
RUN apt install -y m4
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:deadsnakes/ppa -y
# For CsmithEdge
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y libboost-all-dev


############################################### PART 1 - Installing CsmithEdge

# Clone and build CSmith (commit d0b585a, 31st May 2020)
USER ubuntu
WORKDIR /home/ubuntu/
RUN git clone https://github.com/csmith-project/csmith.git && \
    cd csmith && \
    git checkout d0b585a
WORKDIR /home/ubuntu/csmith
RUN mkdir build
WORKDIR /home/ubuntu/csmith/build
RUN cmake ../ && make

# Clone and build CsmithEdge
USER ubuntu
WORKDIR /home/ubuntu/
RUN git clone https://github.com/karineek/CsmithEdge.git
WORKDIR /home/ubuntu/CsmithEdge
RUN rm -rf csmith
RUN git clone https://github.com/csmith-project/csmith.git
WORKDIR /home/ubuntu/CsmithEdge/csmith/
RUN git checkout d0b585a
WORKDIR /home/ubuntu/CsmithEdge
RUN git stash
WORKDIR /home/ubuntu/CsmithEdge/csmith
RUN mkdir build
WORKDIR /home/ubuntu/CsmithEdge/csmith/build
RUN cmake ../
RUN make

############################################### PART 2 - Evaluation code/tools
# Install dependencies for Python build
USER root
WORKDIR /home/ubuntu/
RUN apt-get update && apt-get install -y \
    software-properties-common \
    wget \
    build-essential \
    zlib1g-dev \
    libssl-dev \
    libreadline-dev \
    libsqlite3-dev \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libncurses5-dev \
    libgdbm-dev \
    uuid-dev \
    tk-dev \
    libnss3-dev \
    libgdbm-compat-dev

# Install Python 3.8.10
RUN wget https://www.python.org/ftp/python/3.8.10/Python-3.8.10.tgz && \
    tar -xf Python-3.8.10.tgz && \
    cd Python-3.8.10 && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make altinstall

# Ensure pip is installed and upgraded for Python 3.8.10
RUN python3.8 -m ensurepip --upgrade && \
    python3.8 -m pip install --upgrade pip

# Set Python3.8 as default
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

# Install Frama-C 22.0 (Titanium)
USER root
RUN add-apt-repository ppa:avsm/ppa
RUN apt update
RUN apt-get install ocaml ocaml-native-compilers graphviz \
             libzarith-ocaml-dev libfindlib-ocaml-dev \
             liblablgtksourceview2-ocaml-dev liblablgtk2-gnome-ocaml-dev -y -f

USER ubuntu
RUN apt install opam -f -y
RUN apt-get install libgtk-3-dev libgtksourceview-3.0-dev -y
RUN opam init --disable-sandboxing -y
RUN opam update
RUN opam init --disable-sandboxing -y
RUN eval `opam config env`
RUN opam install dune ppxlib menhir -y
RUN opam install why3 why3-ide alt-ergo -y
RUN eval $(opam env)
RUN apt remove ocaml -y
# environment setup
RUN opam init --disable-sandboxing -y
RUN eval `opam env`
# install given version of the compiler
RUN opam switch create 4.10.0
RUN eval `opam env`
# check you got what you want
RUN which ocaml
RUN ocaml -version
RUN opam install alt-ergo.2.2.0 -y
RUN opam install opam-depext -y
RUN opam depext frama-c -y
RUN opam install frama-c.24.0 -y
RUN eval $(opam config env)


# Install gcc and clang compilers
USER root
# Set default gcc to gcc-10
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 10

# Set default clang to clang-10
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-10 10

# Clone gfauto (commit 8030f33, 15th July 2021)
USER ubuntu
WORKDIR /home/ubuntu/
RUN git clone https://github.com/google/graphicsfuzz.git
WORKDIR /home/ubuntu/graphicsfuzz/gfauto/
RUN git checkout 8030f33
RUN rm -f Pipfile.lock
RUN cp  /home/ubuntu/CsmithEdge/gfauto/dev_shell.sh.template dev_shell.sh

# Make the script executable
RUN chmod +x dev_shell.sh

# Run the script using the correct shell interpreter
RUN /home/ubuntu/graphicsfuzz/gfauto/dev_shell.sh

# Default command
USER ubuntu
WORKDIR /home/ubuntu//CsmithEdge
CMD ["/bin/bash"]
