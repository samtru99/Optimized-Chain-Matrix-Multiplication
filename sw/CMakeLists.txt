cmake_minimum_required(VERSION 3.10)
project(MyCUDAProject LANGUAGES CXX CUDA)

# Set the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Specify CUDA as the compiler for .cu files
set(CMAKE_CUDA_COMPILER nvcc)

# Add the executable
add_executable(main main.cpp sequence_gpu.cu)

# Link CUDA libraries
set(CUDA_LIBS cudart cudadevrt)
target_link_libraries(main PRIVATE ${CUDA_LIBS})

# Enable debugging symbols
target_compile_options(main PRIVATE -g)

# Copy the config file to the build directory
file(COPY ${CMAKE_SOURCE_DIR}/config.xml DESTINATION ${CMAKE_BINARY_DIR})
