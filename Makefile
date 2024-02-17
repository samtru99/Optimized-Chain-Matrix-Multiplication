#all:
#	nvcc main.cu -o main  -lcudart -lcudadevrt
CXX = nvcc
CPP = gcc
CFLAGS = -std=c++17 -g
LDFLAGS =  -lcudart -lcudadevrt

main: main.o sequence.o
	$(CXX) $(CFLAGS) -o main main.o sequence.o $(LDFLAGS)

main.o: main.cu
	$(CXX) $(CFLAGS) -c main.cu
sequence.o: sequence.cpp
	$(CPP) $(CFLAGS) -c sequence.cpp

clean:
	rm -f main main.o sequence.o