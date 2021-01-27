FROM nvidia/cuda:11.2.0-devel-ubuntu20.04

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update -y

RUN apt install -y vim git wget curl parallel

RUN apt install -y build-essential cmake valgrind
RUN cmake --version

RUN apt install -y libboost-all-dev libatlas-base-dev libeigen3-dev \
    libgoogle-glog-dev libprotobuf-dev libhdf5-serial-dev \
    librdkit-dev \
    protobuf-compiler

RUN apt install -y python3-dev python3-pip
RUN ln -s /usr/bin/python3 /usr/bin/python && ln -s /usr/bin/pip3 /usr/bin/pip
RUN which python && which pip && python -V
RUN python -m pip install -U pip
RUN python -m pip install ipython pytest \
    numpy scipy pandas scikit-learn \
    matplotlib seaborn scikit-image \
    torch torchvision \
    biopython pyquaternion protobuf psutil

RUN mkdir /software

# OpenBabel
RUN apt purge --auto-remove libopenbabel-dev
RUN apt -y install libxml2-dev libcairo2-dev rapidjson-dev swig
WORKDIR /software
RUN git clone https://github.com/openbabel/openbabel.git
RUN mkdir /software/openbabel/build
WORKDIR /software/openbabel/build/
RUN cmake .. -DWITH_MAEPARSER=OFF -DWITH_COORDGEN=OFF \
    && make -j 4
RUN ctest && make install

# libmolgrid
RUN apt install -y swig
RUN python -m pip install openbabel
WORKDIR /software
RUN git clone https://github.com/gnina/libmolgrid.git
RUN mkdir /software/libmolgrid/build
WORKDIR /software/libmolgrid/build
RUN cmake .. && make -j 4
#RUN ctest -V && make install
RUN make install

# gnina
WORKDIR /software
RUN git clone https://github.com/gnina/gnina.git
RUN mkdir /software/gnina/build
WORKDIR /software/gnina/build
RUN cmake .. -DCUDA_ARCH_NAME=All && make -j 4
#RUN ctest -V && make install
RUN make install

WORKDIR /

ENV LD_LIBRARY_PATH=/usr/local/lib/:${LD_LIBRARY_PATH}

RUN python -m pip install GPUtil