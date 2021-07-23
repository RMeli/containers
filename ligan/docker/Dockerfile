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
    libgoogle-glog-dev libhdf5-serial-dev \
    && cmake --version \
    && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh \
    && conda config --add channels conda-forge \
    && conda install -y conda \
    && conda update --all --yes \
    && conda --version

# conda environment
ARG CONDA_ENV_FILE="environment.yml"
COPY ${CONDA_ENV_FILE} /opt/${CONDA_ENV_FILE}
RUN conda env create -f /opt/${CONDA_ENV_FILE} \
    && conda clean --all --yes

RUN mkdir /software
WORKDIR /software

ENV LD_LIBRARY_PATH=/root/miniconda3/envs/myenv/lib/:/usr/local/lib/:/usr/lib/:${LD_LIBRARY_PATH}
ARG LD_LIBRARY_PATH=/root/miniconda3/envs/myenv/lib/:/usr/local/lib/:/usr/lib/:${LD_LIBRARY_PATH}

# libmolgrid
# https://stackoverflow.com/questions/24174394/cmake-is-not-able-to-find-python-libraries
RUN . /root/miniconda3/etc/profile.d/conda.sh && conda activate myenv \
    && git clone https://github.com/gnina/libmolgrid.git \
    && mkdir /software/libmolgrid/build && cd /software/libmolgrid/build \
    #&& git checkout cmake \
    && cmake ..  \
    -DPYTHON_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
    -DPYTHON_LIBRARY=$(python -c "import distutils.sysconfig as sysconfig; print(sysconfig.get_config_var('LIBDIR'))") \
    -DOPENBABEL3_INCLUDE_DIR=/root/miniconda3/envs/myenv/include/openbabel3/ \
    -DOPENBABEL3_LIBRARIES=/root/miniconda3/envs/myenv/lib/libopenbabel.so \
    -DZLIB_ROOT=/root/miniconda3/envs/myenv/ \
    -DCMAKE_CUDA_FLAGS=-Wno-deprecated-gpu-targets \
    -DCMAKE_INSTALL_PREFIX=/root/miniconda3/envs/myenv/ \
    && make -j 4 \
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
    -DCMAKE_CUDA_FLAGS=-Wno-deprecated-gpu-targets \
    -DCMAKE_INSTALL_PREFIX=/root/miniconda3/envs/myenv/ \
    && make -j 4 \
    && make install

WORKDIR /

ENV PYTHONPATH=/software/libmolgrid/build/python/:/software/gnina/caffe/python/:${PYTHONPATH}

# RDKit Contrib
# python -c "from rdkit import RDConfig; print('RDConfig.RDContribDir')"
ENV RDKIT_CONTRIB=/root/miniconda3/envs/myenv/share/RDKit/Contrib/
ENV PYTHONPATH=${RDKIT_CONTRIB}:${PYTHONPATH}
