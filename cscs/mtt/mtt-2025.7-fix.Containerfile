FROM nvcr.io/nvidia/pytorch:25.03-py3

RUN python3 -m pip install -U pip && \
    python3 -m pip uninstall -y setuptools packaging wheel
    python3 -m pip install git+https://github.com/RMeli/metatrain.git@2025.7-fix
