FROM  intel/oneapi-hpckit:2024.0.1-devel-ubuntu22.04

ENV TZ=US/Eastern
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN wget -qO - https://repositories.intel.com/gpu/intel-graphics.key | \
  gpg --yes --dearmor --output /usr/share/keyrings/intel-graphics-archive-keyring.gpg

RUN apt-get update && \
    apt-get install -y \
        software-properties-common cmake git vim htop wget environment-modules bison flex python3-venv build-essential \
        libmpfr-dev libgmp3-dev libmpc-dev zlib1g-dev libbz2-dev liblzma-dev automake libz-dev hwloc libhwloc-dev \
        ninja-build unzip && \
    apt-get clean

RUN cd /usr/bin/ && \
    ln -s /usr/bin/tclsh8.6 /usr/bin/tclsh
RUN echo '. /etc/profile.d/modules.sh' >> ~/.bashrc

RUN cd /opt/intel/oneapi && \
    ./modulefiles-setup.sh && \
    cd
RUN cp -r /root/modulefiles/* /usr/share/modules/modulefiles
RUN cd /opt/intel/oneapi/mkl/2024.0/lib/intel64 && ln -s libmkl_def.so.2 libmkl_def.so

# Install Spack
ENV SPACK_TAG="develop-2024-07-21"
WORKDIR /opt/spack
RUN git init --quiet && \
    git remote add origin https://github.com/spack/spack.git && \
    git fetch --quiet --depth 1 origin tag ${SPACK_TAG} --no-tags && \
    git checkout --quiet FETCH_HEAD
ENV PATH="/opt/spack/bin:${PATH}"
RUN spack compiler find && cat /root/.spack/linux/compilers.yaml
RUN spack external find --all --not-buildable && spack external find --not-buildable openmpi && \
    printf "  intel-oneapi-mkl:\n    externals:\n    - spec: \"intel-oneapi-mkl@2024.0.0 +cluster mpi_family=mpich threads=openmp\"\n      prefix: /opt/intel/oneapi\n    buildable: False\n" >> ~/.spack/packages.yaml && \
    printf "  intel-oneapi-mpi:\n    externals:\n    - spec: \"intel-oneapi-mpi@2021.11.0\"\n      prefix: /opt/intel/oneapi\n    buildable: False\n" >> ~/.spack/packages.yaml && \
    cat ~/.spack/packages.yaml

ENV DLAF_SPEC="dla-future-fortran@0.2.0 %oneapi ^[virtuals=blas,lapack,scalapack] intel-oneapi-mkl +cluster ^intel-oneapi-mpi"
RUN spack spec -lI ${DLAF_SPEC} && spack install --fail-fast ${DLAF_SPEC}
