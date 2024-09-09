#all:
#	nvcc main.cu -o main  -lcudart -lcudadevrt
CXX = nvcc
CPP = gcc
CFLAGS = -std=c++17 -g
LDFLAGS =  -lcudart -lcudadevrt

#######################
#   For Cude (once container is built)
# CXX = nvcc
# main: main.o sequence.o helper_functions.o
# 	$(CPP) $(CFLAGS) -o main main.o sequence.o helper_functions.o $(LDFLAGS)

#######################
#	For now without cuda
main: main.o sequence.o helper_functions.o
	$(CPP) $(CFLAGS) -o main main.o sequence.o helper_functions.o

main.o: main.cpp
	$(CPP) $(CFLAGS) -c main.cpp
	
sequence.o: sequence.cpp
	$(CPP) $(CFLAGS) -c sequence.cpp

helper_functions.o: helper_functions.cpp
	$(CPP) $(CFLAGS) -c helper_functions.cpp

clean:
	rm -f main main.o sequence.o helper_functions.o