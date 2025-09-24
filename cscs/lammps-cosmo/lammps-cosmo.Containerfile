# PyTorch 2.7
FROM docker://nvcr.io/nvidia/pytorch:25.04-py3


RUN python3 -m pip install -U pip && \
    python3 -m pip list && \
    python3 -m pip install metatomic-torch

#RUN echo TORCH_PREFIX=$(python3 -c "import torch; print(torch.utils.cmake_prefix_path)") && \
#    echo MTS_PREFIX=$(python3 -c "import metatensor; print(metatensor.utils.cmake_prefix_path)") && \
#    echo MTS_TORCH_PREFIX=$(python3 -c 'import metatensor.torch; print(metatensor.torch.utils.cmake_prefix_path)') && \
#    echo MTA_TORCH_PREFIX=$(python3 -c 'import metatomic.torch; print(metatomic.torch.utils.cmake_prefix_path)')

ENV TORCH_PREFIX=/usr/local/lib/python3.12/dist-packages/torch/share/cmake
ENV MTS_PREFIX=/usr/local/lib/python3.12/dist-packages/metatensor/lib/cmake
ENV MTS_TORCH_PREFIX=/usr/local/lib/python3.12/dist-packages/metatensor/torch/torch-2.7/lib/cmake
ENV MTA_TORCH_PREFIX=/usr/local/lib/python3.12/dist-packages/metatomic/torch/torch-2.7/lib/cmake
ENV Torch_DIR=$TORCH_PREFIX/Torch/

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rust.sh && sh rust.sh -y

RUN git clone https://github.com/metatensor/lammps lammps-metatomic && \
    cd lammps-metatomic && \
    export CMAKE_PREFIX_PATH="$TORCH_PREFIX;$MTS_PREFIX;$MTS_TORCH_PREFIX;$MTA_TORCH_PREFIX" && \
    export CARGO_EXE="$HOME/.cargo/bin/cargo" && \
    cmake -B builddir -S cmake/ -DPKG_ML-METATOMIC=ON \
      -DLAMMPS_INSTALL_RPATH=ON \
      -DCMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH" \
      -DPKG_KOKKOS=ON \
      -DKokkos_ENABLE_CUDA=ON \
      -DKokkos_ENABLE_OPENMP=ON \
      -DKokkos_ARCH_HOPPER90=ON \
      -DCMAKE_CXX_COMPILER="$PWD/lib/kokkos/bin/nvcc_wrapper" && \
    cmake --build builddir -j32 && \
    cmake --install builddir

ENV PATH=/root/.local/bin/:$PATH
