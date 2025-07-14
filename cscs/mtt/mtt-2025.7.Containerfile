# PyTorch 2.7
FROM docker://nvcr.io/nvidia/pytorch:25.04-py3

RUN python3 -m pip list
RUN python3 -m pip install metatrain==2025.7
