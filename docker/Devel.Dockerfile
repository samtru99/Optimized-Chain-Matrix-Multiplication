#Install prebuilt base os that has all necessary NVIDIA dev tools
FROM nvidia/cuda12.3.2-cudnn9-devel-ubuntu22.04


#Install additional dependencies 
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    wget \
    git \ 
    && apt-get clean

# Step 3: Set environment variables for CUDA
ENV PATH=/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}

# Step 4: Create a working directory in the container
WORKDIR /workspace

# Step 5: Copy your source code or project files into the container
COPY . /workspace