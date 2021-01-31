FROM nvidia/cuda:11.2.0-devel-ubuntu20.04

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update -y && apt upgrade -y \
    && apt install -y vim git wget curl parallel \
        build-essential cmake valgrind \
        libboost-all-dev libatlas-base-dev libeigen3-dev \
        libgoogle-glog-dev libprotobuf-dev libhdf5-serial-dev \
        librdkit-dev \
        protobuf-compiler \
        python3-dev python3-pip \
    && cmake --version

# python
RUN ln -s /usr/bin/python3 /usr/bin/python && ln -s /usr/bin/pip3 /usr/bin/pip \
    && which python && which pip && python -V \
    && python -m pip install -U pip \
    && python -m pip install \
        ipython pytest \
        numpy scipy pandas scikit-learn \
    matplotlib seaborn scikit-image \
    torch torchvision \
    biopython pyquaternion protobuf psutil GPUtil

RUN mkdir /software
WORKDIR /software

# OpenBabel
RUN apt purge --auto-remove libopenbabel-dev \
    && apt -y install libxml2-dev libcairo2-dev rapidjson-dev swig \
    && git clone https://github.com/openbabel/openbabel.git \
    && mkdir /software/openbabel/build && cd /software/openbabel/build \
    && cmake .. -DWITH_MAEPARSER=OFF -DWITH_COORDGEN=OFF \
    && make -j 4 \
    && ctest \
    && make install

# libmolgrid
RUN python -m pip install openbabel \
    && git clone https://github.com/gnina/libmolgrid.git \
    && mkdir /software/libmolgrid/build && cd /software/libmolgrid/build \
    && cmake .. \
    && make -j 4 \
    && make install

# gnina
RUN git clone https://github.com/gnina/gnina.git \
    && mkdir /software/gnina/build && cd /software/gnina/build \
    && cmake .. -DCUDA_ARCH_NAME=All \
    && make -j 4 \
    && make install

WORKDIR /

ENV LD_LIBRARY_PATH=/usr/local/lib/:${LD_LIBRARY_PATH}
