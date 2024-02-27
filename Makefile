#all:
#	nvcc main.cu -o main  -lcudart -lcudadevrt
CXX = nvcc
CPP = gcc
CFLAGS = -std=c++11 -g
LDFLAGS =  -lcudart -lcudadevrt

main: main.o sequence.o helper_functions.o
	$(CXX) $(CFLAGS) -o main main.o sequence.o helper_functions.o $(LDFLAGS)

main.o: main.cu
	$(CXX) $(CFLAGS) -c main.cu
	
sequence.o: sequence.cpp
	$(CXX) $(CFLAGS) -c sequence.cpp

helper_functions.o: helper_functions.cpp
	$(CXX) $(CFLAGS) -c helper_functions.cpp

clean:
	rm -f main main.o sequence.o