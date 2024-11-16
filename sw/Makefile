CXX = nvcc
CPP = g++
CFLAGS = -std=c++17 -g
LDFLAGS =  -lcudart -lcudadevrt

main: main.o sequence_gpu.o
	$(CXX) $(CFLAGS) -o main main.o sequence_gpu.o

main.o: main.cpp
	$(CPP) $(CFLAGS) -c main.cpp
	
sequence_gpu.o: sequence_gpu.cu
	$(CXX) $(CFLAGS) -c sequence_gpu.cu $(LDFLAGS)

clean:
	rm -f main main.o sequence_gpu.o 