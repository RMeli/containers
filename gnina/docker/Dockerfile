FROM nvidia/cuda:11.2.0-devel-ubuntu20.04

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# https://stackoverflow.com/questions/58269375/how-to-install-packages-with-miniconda-in-dockerfile
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

RUN apt update -y && apt upgrade -y \
    && apt install -y vim git wget curl parallel \
        build-essential cmake valgrind \
        libatlas-base-dev \
        libgoogle-glog-dev libprotobuf-dev libhdf5-serial-dev \
        protobuf-compiler \
    && cmake --version \
    && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh \
    && conda config --add channels conda-forge \
    && conda install -y conda \
    && conda update --all --yes \
    && conda --version

# https://github.com/pytorch/pytorch/blob/master/Dockerfile
#ENV CONDA_OVERRIDE_CUDA=11.0

ARG CONDA_ENV_FILE="environment.yml"
COPY ${CONDA_ENV_FILE} /opt/${CONDA_ENV_FILE}
RUN conda env create -f /opt/${CONDA_ENV_FILE} \
    && conda clean --all --yes

#ENV LIBRARY_PATH=/root/miniconda3/envs/myenv/lib/:/usr/local/lib/:/usr/lib:${LIBRARY_PATH}

# https://stackoverflow.com/questions/19810940/ubuntu-linking-boost-python-fatal-error-pyconfig-cannot-be-found
#ENV CPLUS_INCLUDE_PATH=/root/miniconda3/include/python3.7m:${CPLUS_INCLUDE_PATH}
#ARG CPLUS_INCLUDE_PATH=/root/miniconda3/include/python3.7m:${CPLUS_INCLUDE_PATH}

RUN mkdir /software
WORKDIR /software

# OpenBabel
#RUN . /root/miniconda3/etc/profile.d/conda.sh && conda activate myenv \
#    && apt purge --auto-remove libopenbabel-dev \
#    && git clone https://github.com/openbabel/openbabel.git \
#    && mkdir /software/openbabel/build && cd /software/openbabel/build \
#    && cmake .. -DWITH_MAEPARSER=OFF -DWITH_COORDGEN=OFF \
#    && make -j 4 \
#    && ctest && make install

# libmolgrid
# https://stackoverflow.com/questions/24174394/cmake-is-not-able-to-find-python-libraries
RUN . /root/miniconda3/etc/profile.d/conda.sh && conda activate myenv \
    && git clone https://github.com/gnina/libmolgrid.git \
    && mkdir /software/libmolgrid/build && cd /software/libmolgrid/build \
    #&& git checkout cmake \
    && cmake ..  \
        -DPYTHON_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
        -DPYTHON_LIBRARY=$(python -c "import distutils.sysconfig as sysconfig; print(sysconfig.get_config_var('LIBDIR'))") \
        #-DPython3_INCLUDE_DIR=/root/miniconda3/envs/myenv/include/python3.7m/ \
        #-DPython3_LIBRARY=/root/miniconda3/envs/myenv/lib/ \
        -DOPENBABEL3_INCLUDE_DIR=/root/miniconda3/envs/myenv/include/openbabel3/ \
        -DOPENBABEL3_LIBRARIES=/root/miniconda3/envs/myenv/lib/libopenbabel.so \
        -DZLIB_LIBRARIES=/root/miniconda3/envs/myenv/lib/libz.so \
        -DZLIB_INCLUDE_DIRS=/root/miniconda3/envs/myenv/include/ \
    && make -j 4 \
#    && ctest -V \
    && make install

# gnina
RUN . /root/miniconda3/etc/profile.d/conda.sh && conda activate myenv \
    && git clone https://github.com/gnina/gnina.git \
    && mkdir /software/gnina/build && cd /software/gnina/build \
    && cmake .. \
        -DCUDA_ARCH_NAME=All \
        -DPYTHON_EXECUTABLE=/root/miniconda3/envs/myenv/bin/python \
        -DPYTHON_LIBRARY=/root/miniconda3/envs/myenv/lib/libpython3.7m.so \
        -DPYTHON_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
        #-DBUILD_python:BOOLEAN=TRUE \
        #-DBUILD_python_layer:BOOLEAN=TRUE \
        #-DBOOST_ROOT=/root/miniconda3/envs/myenv/lib/ \
        #-DBoost_INCLUDE_DIR=/root/miniconda3/envs/myenv/include/ \
        #-DPYTHON_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
        #-DRDKIT_INCLUDE_DIR=/root/miniconda3/envs/myenv/include/rdkit/ \
        #-DRDKIT_LIBRARIES=/root/miniconda3/envs/myenv/lib/ \
        # https://github.com/ndarray/Boost.NumPy/issues/45
        #-DBoost_NO_BOOST_CMAKE=ON \
    && make -j 4 \
#    && ctest -V \
    && make install

WORKDIR /

# Hacky way to provide protobuf to caffe via conda
# TODO: Use conda-installed protobuf eveywhere
RUN . /root/miniconda3/etc/profile.d/conda.sh && conda activate myenv \
    && conda install -y protobuf

ENV LD_LIBRARY_PATH=/root/miniconda3/envs/myenv/lib/:/usr/local/lib/:/usr/lib:${LD_LIBRARY_PATH}
ENV PYTHONPATH=/software/libmolgrid/build/python/:/software/gnina/caffe/python/:${PYTHONPATH}
