FROM resin/raspberry-pi3-openjdk:openjdk-8-jdk-20170426

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    git\
    ca-certificates \
    apt \
    software-properties-common \
    unzip \
    cpp \
    binutils \
    maven \
    gettext \
    libc6-dev \
    make \
    cmake \
    cmake-data \
    pkg-config \
    clang \
    gcc-4.9 \
    g++-4.9 \
    qdbus \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install --no-install-recommends -y \
    libglib2.0-0=2.42.1-1+b1 \
    libglib2.0-dev=2.42.1-1+b1 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


RUN mkdir /work
WORKDIR /work

COPY api/ api/
COPY cmake/ cmake/
COPY examples/ examples/
COPY include/ include/
COPY java/ java/
COPY src/ src/

COPY Doxyfile.java.in Doxyfile.java.in
COPY Doxyfile.cpp.in Doxyfile.cpp.in

COPY CMakeLists.txt .

RUN mkdir build \
 && cd build \
 && cmake .. \
    -DBUILDJAVA=ON \
    -DCMAKE_CXX_FLAGS="-std=c++11" \
    -DCMAKE_BUILD_TYPE=Release

RUN cd build \
 && make -j2 tinybjar \
 && make -j4

RUN cd build \
 && make install
