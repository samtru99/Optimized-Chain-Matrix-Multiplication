FROM ubuntu:20.04
FROM nvidia/cuda12.3.2-cudnn9-devel-ubuntu22.04
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    wget \


