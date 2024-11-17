#Install prebuilt base os that has all necessary NVIDIA dev tools
FROM nvidia/cuda:12.6.1-devel-ubuntu20.04



#Install additional dependencies 
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    wget \
    git \ 
    && apt-get clean

# Install CMAKE
RUN VERSION=3.31.0 && \
    mkdir cmakeInstall && \
    cd cmakeInstall && \
    wget https://github.com/Kitware/CMake/releases/download/v${VERSION}/cmake-${VERSION}.tar.gz && \
    tar -zxf cmake-${VERSION}.tar.gz && \
    cd cmake-${VERSION} && \ 
    ./bootstrap && \
    make install && \
    cd ../.. && \
    rm -rf cmakeInstall

# Install boost
RUN VERSION=1_81_0 && \
    mkdir BoostInstall && \
    cd BoostInstall && \
    wget https://archives.boost.io/release/1.81.0/source/boost_${VERSION}.tar.gz && \
    tar xvf boost_${VERSION}.tar.gz && \
    cd boost_{VERSION} && \
    ./bootstrap.sh --prefix=/usr/local && \
    ./b2 install && \
    cd ../.. && \
    rm -rf BoostInstall






# Step 4: Create a working directory in the container
WORKDIR /workspace

# Step 5: Copy your source code or project files into the container
COPY . /workspace