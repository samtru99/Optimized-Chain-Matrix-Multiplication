#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <tuple>
#include <vector>
#include <unordered_map>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <string.h>
#include "sequence.h"
#include "helper_functions.h"



__global__ void GPUmatrixmult(int *a, int *b, int *c, int M, int N, int K)
{
   int row = blockIdx.y * blockDim.y + threadIdx.y;
   int col = blockIdx.x * blockDim.x + threadIdx.x;

   if(row < M && col < K)
   {
    int temp = 0;
    for(int i = 0; i < N; i++)
    {
        temp += a[row * N + i] * b[i*K+col];
    }
    //c[row*K+col] = temp;
    c[row*K+col] = 4;
   }
}

matrix* matrix_mult(matrix *a, matrix *b)
{
    matrix *c = (matrix*)malloc(sizeof(matrix));

    std::cout << "Matrix A is " << std::endl;
    print_matrix(a);
    std::cout << "Matrix B is "<< std::endl;
    print_matrix(b);

    int row_A,col_A,row_B,col_B;
    row_A = a->row;
    col_A = a->col;

    row_B = b->row; 
    col_B = b->col;
   
    c->row = row_A;
    c->col = col_B;
    c->ptr = (int*)malloc(row_A*col_B*sizeof(int));

    size_t bytes = row_A * col_B * sizeof(int);
    int *C;
    C = (int*)malloc(bytes);
    //C = (int*)malloc(row_A*col_B*sizeof(int));
    //Memory Allocations
    size_t bytes_A = row_A * col_A * sizeof(int);
    size_t bytes_B = row_B * col_B * sizeof(int);
    size_t bytes_C = row_A * col_B * sizeof(int);

    int *d_a, *d_b, *d_c;
    cudaMalloc(&d_a, bytes_A);
    cudaMalloc(&d_b, bytes_B);
    cudaMalloc(&d_c,bytes_C);

    cudaMemcpy(d_a, a->ptr, bytes_A, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b->ptr, bytes_B, cudaMemcpyHostToDevice);
    //cudaMemcpy(d_c, &c->ptr, bytes_C, cudaMemcpyHostToDevice);

    int threads = 4;
    int num_of_block_row = (int)ceil((row_A + threads - 1) / threads);
    int num_of_block_col = (int)ceil((col_B + threads - 1) / threads);

    dim3 THREADS(threads,threads);
    dim3 GRID(num_of_block_col,num_of_block_row);

    GPUmatrixmult<<<THREADS,GRID>>>(d_a,d_b,d_c,row_A,col_A,col_B);
    cudaDeviceSynchronize();
    std::cout << "printing C MATRIX" << std::endl;
    cudaMemcpy(C,d_c,bytes_C,cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();
    for(int i = 0; i < c->row; i++)
    {
        for(int j = 0; j < c->col;j++)
        {
            std::cout << C[i* c->col + j] << " ";
        }
        std::cout << std::endl;
    }
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    return c;
}

matrix* compute(Node* n,std::unordered_map<char, matrix*>& dict )
{
    if(n->left == nullptr && n->right == nullptr && n->seq[1] == '\0') 
    { 
        return dict[n->seq[0]]; 
    }  
    if(n->left == nullptr && n->right == nullptr && n->seq[2] == '\0')  
    { 
        std::cout << "Computing Pair " << n->seq << std::endl; 
        matrix* matrix_A = dict[n->seq[0]];
        matrix* matrix_B = dict[n->seq[1]]; 
        std::cout << "Result is " << std::endl;
        matrix* matrix_C = matrix_mult(matrix_A,matrix_B); 
        //print_matrix(matrix_C);
        return matrix_C; 
    } 
    else 
    { 
        matrix* left_res = compute(n->left, dict); 
        matrix* right_res = compute(n->right, dict); 
        std::cout << "Node " << n->seq << " is " << std::endl;  
        matrix* matrix_C = matrix_mult(left_res,right_res);  
        return matrix_C;   
    }  
}  
 


int main()
{
    

    int deviceCount;
    cudaGetDeviceCount(&deviceCount);
    if (deviceCount == 0) {
        std::cerr << "No CUDA-enabled devices found" << std::endl;
        return 1;
    }
    //Generate Matrices
    //Odd Number 
    matrix *a1 = new_matrix(4,10,1);
    matrix *a2 = new_matrix(10,3,2);
    matrix *a3 = new_matrix(3,12,3);
    matrix *a4 = new_matrix(12,20,4);
    matrix *a5 = new_matrix(20,7,5);

    std::unordered_map<char, matrix*> dict;
    dict['1'] = a1;
    dict['2'] = a2;
    dict['3'] = a3;
    dict['4'] = a4;
    dict['5'] = a5;

    std::vector<matrix> list_matrixes;
    list_matrixes.push_back(*a1);
    list_matrixes.push_back(*a2);
    list_matrixes.push_back(*a3);
    list_matrixes.push_back(*a4);
    list_matrixes.push_back(*a5);
    /*
        Create S table and initalize diagonal to zeros
    */
    std::vector<std::vector<int>> s_table;
    int rows = list_matrixes.size();
    int columns = list_matrixes.size();
    for(int i = 0; i < rows; i++)
    {
        std::vector<int> row(columns, 0);
        s_table.push_back(row);
    }
    /*
        Perform DP
    */
    init_dp(&s_table, list_matrixes);
    std::cout << "S TABLE: " << std::endl;
    for(int i = 0; i < s_table.size(); i++)
    {
        for(int j = 0; j < s_table[0].size(); j++)
        {
            std::cout << s_table[i][j] << "\t";
        }
        std::cout << std::endl;
    }
    
    Sequence seq(s_table, dict);
    Node* root = new Node();
    root = seq.init_sequence(1, list_matrixes.size());
     
    std::cout << "printing " << std::endl;
    std::cout << "(" << " ";
    seq.print_sequence(root);
    std::cout << ")" << " \n";
    
    std::cout << "COMPUTING " << std::endl;
    matrix* res = compute(root, dict);

    std::cout << "RES IS " << std::endl;
    seq.printMatrix(res);
    return 0;
}