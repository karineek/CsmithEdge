# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Create User
USER root
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN useradd -ms /bin/bash ubuntu

# Install dependencies
RUN apt-get update
RUN apt-get install -y \
    git \
    build-essential \
    wget \
    curl \
    libboost-all-dev \
    python3.8=3.8.10-0ubuntu1~20.04.5 \
    python3-pip=20.0.2-5ubuntu1.6 \
    cmake=3.16.3-1ubuntu1 \
    ninja-build=1.10.0-1build1 \
    gcc-10=10.3.0-1ubuntu1~20.04 \
    clang-10=1:10.0.0-4ubuntu1
RUN apt-get clean

# Set Python3.8 as default
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

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
RUN git clone git@github.com:karineek/CsmithEdge.git
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
    
# Clone GFAuto (commit 8030f33, 15th July 2021)
USER ubuntu
WORKDIR /home/ubuntu/
RUN git clone https://github.com/google/gfauto.git && \
    cd gfauto && \
    git checkout 8030f33
# TODO: continue installation

# Install Frama-C 22.0 (Titanium)
# TODO

# Set default gcc to gcc-10
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 10

# Set default clang to clang-10
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-10 10

# Verify installations
RUN python3 --version && \
    pip3 --version && \
    cmake --version && \
    ninja --version && \
    gcc --version && \
    clang --version && \
    frama-c --version && \
    csmith --help && \
    gfauto --help

# Default command
CMD ["/bin/bash"]
