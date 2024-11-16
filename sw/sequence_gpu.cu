#include "stdlib.h"
#include "sequence_gpu.h"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <cassert>
#include <cstddef>
#include <cstdlib>
#include <iostream>
#include <ostream>
#include <unordered_map>
#include <cuda.h>


__global__ void matrix_mult_gpu(int *a, int *b, int *c, int M, int N, int K)
{
    // Calculate row and column
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if(row < M && col < K)
    {
        // Temp variable for acuumulatting results
        int temp = 0;
        for(int i = 0; i < N; i++)
        {
            temp += a[row * N + i] * b[i * K + col];
        }
        c[row * K + col] = temp;
    }
}


Sequence::Sequence(
    std::vector<std::vector<int>> temp_table,
    std::unordered_map<char,matrix*> &temp_dict) : s_table(temp_table), str_matrix_dict(temp_dict)
{
}   


Node* Sequence::init_sequence(int i, int j)
{
    /*
        Base cases
    */
    if(i > j) 
    {
        return nullptr;
    }
    Node* n = new Node();
    if(i == j-1)
    {
        n->left = nullptr;
        n->right = nullptr;
        n->seq = static_cast<char*>(malloc(3 * sizeof(char)));
        n->seq[0] = '0' + i;
        n->seq[1] = '0' + j;
        n->seq[2] = '\0';
        return n;
    }
    if(i == j)
    {
        //Node n;
        n->left = nullptr;
        n->right = nullptr;
        n->seq = static_cast<char*>(malloc(2 * sizeof(char)));
        n->seq[0] = '0' + i;
        n->seq[1] = '\0';
        return n;
    }
    int sub_sequence = s_table[i-1][j-1];
    n->seq = static_cast<char*>(malloc((j-i+1) * sizeof(char)));
    for(int x = 0; x <= (j-i); x++)
    {
        n->seq[x] = '0' + (x + i);
    }
    n->seq[j-i+1] = '\0';
    n->left = init_sequence(i, sub_sequence);
    n->right = init_sequence(sub_sequence+1, j);
    return n;
}

void Sequence::print_sequence(Node* n)
{
    if(n == nullptr)
    {
        return;
    }
    if(n->left == nullptr && n->right == nullptr)
    {
        std::cout << n->seq << " ";
    }
    
    if(n->left)
    {
        std::cout << "(" << " ";
        print_sequence(n->left);
        std::cout << ")" << " ";
    }
    if(n->right)
    {
        std::cout << "(" << " ";
        print_sequence(n->right);
        std::cout << ")" << " ";
    }
}

void Sequence::printMatrix(matrix *m)
{
    int rows, cols;
    std::tie(rows, cols) = m->dimension;
    for(int i = 0; i < rows; i++)
    {
        for(int j = 0; j < cols; j++)
        {
            std::cout << m->values[i][j] << " ";
        }
        std::cout << std::endl;
    }
}


matrix* Sequence::compute(Node* n)
{
    /*
        Solo
    */
    if(n->left == nullptr && n->right == nullptr && n->seq[1] == '\0') 
    {
        return str_matrix_dict[n->seq[0]];
    }
    /*
        Two pairs
    */
    if(n->left == nullptr && n->right == nullptr && n->seq[2] == '\0')
    {
        matrix* matrix_A = str_matrix_dict[n->seq[0]];
        matrix* matrix_B = str_matrix_dict[n->seq[1]];
        matrix* matrix_C = new matrix;
        int m,n,x,y;
        std::tie(m,n) = matrix_A->dimension;
        std::tie(x,y) = matrix_B->dimension;
        matrix_C->dimension = std::make_tuple(m,y);
        matrix_C->values.resize(m);
        for (int i = 0; i < m; ++i) 
        {
            matrix_C->values[i].resize(y);
        }
        int val = matrix_A->values[0][0];
        matrix_mult(matrix_A,matrix_B,matrix_C,m,y,x);
        return matrix_C;
    }
    else
    {
        matrix* left_res = compute(n->left);
        matrix* right_res = compute(n->right);

        matrix* matrix_C = new matrix;
        int a,b,c,d;
        std::tie(a,b) = left_res->dimension;
        std::tie(c,d) = right_res->dimension;
        matrix_C->dimension = std::make_tuple(a,d);
        matrix_C->values.resize(a);
        for (int i = 0; i < a; ++i) 
        {
            matrix_C->values[i].resize(d);
        }
        matrix_mult(left_res,right_res,matrix_C,a,d,b);
        return matrix_C;   
    }  
}



void Sequence::matrix_mult(matrix *a, matrix *b, matrix *c, int x, int y, int z)
{
    for(int row = 0; row < x; row++)
    {
        for(int col = 0; col < y; col++)
        {
            for(int k = 0; k < z; k++)
            {
                c->values[row][col] += (a->values[row][k] * b->values[k][col]);
            }
        }
    }
}




void Sequence::init_dp(std::vector<matrix> list_matrixes)
{
    /*
        Create dictionary for M_table called 'seen'

        -In C++ you need to provide a hashing function if you are 
        using a custom key 
    */
    std::unordered_map<std::pair<int,int>,int, pair_hash> seen;
    for(int i = 0; i < list_matrixes.size(); i++)
    {
        seen[std::make_pair(i,i)] = 0;
    }

    /*
        Extract D_0 -> D_(N-1) dimenison values
    */
    std::vector<int> dimenions;
    for(int i = 0; i < list_matrixes.size(); i++)
    {
        matrix temp = list_matrixes[i];
        int a = std::get<0>(temp.dimension);
        int b = std::get<1>(temp.dimension);
        if(i == list_matrixes.size()-1)
        {
            dimenions.push_back(a);
            dimenions.push_back(b); 
        }
        else
        {
            dimenions.push_back(a);
        }
    }
     dp(1,list_matrixes.size(), dimenions, &seen);
    //std::cout << "MAX is " << seen[{1,list_matrixes.size()}] << std::endl;
}

int Sequence::dp(int i, int j, std::vector<int> dimensions, std::unordered_map<std::pair<int, int>, int, pair_hash> *seen)
{
     /*
        Base cases
    */
    if(i == j)
    {
        return 0;
    }
    std::pair<int,int> pair = std::make_pair(i,j);
    if(seen->find((pair)) != seen->end())
    {
        return (*seen)[pair];    
    }
    int res = 1000000;
    int s_value = 0;
    for(int k = i; k < j; k++)
    {
        int x = dp(i,k,dimensions, seen);
        int y = dp(k+1, j,dimensions, seen);
        int z = dimensions[i-1] * dimensions[k] * dimensions[j];
        int ans = x + y + z;
        if(ans < res)
        {
            res = ans;
            s_value = k;
        }
    }
    s_table[i-1][j-1] = s_value;
    (*seen)[pair] = res;
    return res;
}

void Sequence::print_s_table()
{
    std::cout << "S TABLE: " << std::endl;
    for(int i = 0; i < s_table.size(); i++)
    {
        for(int j = 0; j < s_table[0].size(); j++)
        {
            std::cout << s_table[i][j] << "\t";
        }
        std::cout << std::endl;
    }
}

matrix* Sequence::gpu_compute(Node *n)
{
    /*
        Solo
    */
    if(n->left == nullptr && n->right == nullptr && n->seq[1] == '\0') 
    {
        return str_matrix_dict[n->seq[0]];
    }
    /*
        Two pairs
    */
    if(n->left == nullptr && n->right == nullptr && n->seq[2] == '\0')
    {
        matrix* matrix_A = str_matrix_dict[n->seq[0]];
        matrix* matrix_B = str_matrix_dict[n->seq[1]];
        matrix* matrix_C = new matrix;

        std::cout << "Matrix " << matrix_A->name << std::endl;
        printMatrix(matrix_A);
        std::cout << "Matrix " << matrix_B->name << std::endl;
        printMatrix(matrix_B);
        matrix_C->name = matrix_A->name + matrix_B->name;
        // Determine size of dimenisons
        int M;
        int N_1;
        int N_2;
        int K;

        std::tie(M,N_1) = matrix_A->dimension;
        std::tie(N_2,K) = matrix_B->dimension;

        assert(N_1 == N_2);
        matrix_C->dimension = std::make_tuple(M,K);
        matrix_C->values.resize(M);
        for (int i = 0; i < M; ++i) 
        {
            matrix_C->values[i].resize(K);
        }


        // Create and allocate host ptr
        int *host_memory_a = new int [M * N_1];
        int *host_memory_b = new int [N_2 * K];
        int *host_memory_c = new int [M * K];

        //transfer to int ptr
        transfer_to_ptr(host_memory_a, matrix_A);
        transfer_to_ptr(host_memory_b, matrix_B);

        std::cout << "after transfer to ptr A " << std::endl;
        int counter = 0;
        while(host_memory_a[counter] != 0)
        {
            std::cout << host_memory_a[counter] << " ";
            counter++;
        }
        std::cout << std::endl;
        std::cout << "---" << std::endl;
        std::cout << "after transfer to ptr B " << std::endl;
        counter = 0;
        while(host_memory_a[counter] != 0)
        {
            std::cout << host_memory_b[counter] << " ";
            counter++;
        }


        // Create and allocate device ptr
        int *device_memory_a, *device_memory_b, *device_memory_c;
        cudaMalloc(&device_memory_a,M * N_1 * sizeof(int));
        cudaMalloc(&device_memory_b,N_2 * K * sizeof(int));
        cudaMalloc(&device_memory_c,M * K * sizeof(int));

        // # of threads 
        int THREADS_M = 16;
        
        // set up blocks
        int block_rows = (M + THREADS_M - 1) / THREADS_M;
        int block_cols = (K + THREADS_M - 1) / THREADS_M;

        dim3 threads_m(THREADS_M, THREADS_M);
        dim3 grid_m(block_cols, block_rows);

        // Copy data to device
        cudaMemcpy(device_memory_a, host_memory_a, M * N_1 * sizeof(int), cudaMemcpyHostToDevice);
        cudaMemcpy(device_memory_b, host_memory_b, N_2 * K * sizeof(int), cudaMemcpyHostToDevice);
        cudaMemcpy(device_memory_c, host_memory_c, M * K * sizeof(int), cudaMemcpyHostToDevice);
        
        // Call Kernel Function
        matrix_mult_gpu<<<grid_m, threads_m>>>(device_memory_a, device_memory_b, device_memory_c, M, N_1, K);

        // Copy back the results
        cudaMemcpy(host_memory_c, device_memory_c, M * K * sizeof(int), cudaMemcpyDeviceToHost);

        // Verify 
        transfer_to_matrix(host_memory_c, matrix_C);
        std::cout << "Matrix " << matrix_C->name << std::endl;
        printMatrix(matrix_C);
        
        free(host_memory_a);
        free(host_memory_b);
        free(host_memory_c);
        cudaFree(device_memory_a);
        cudaFree(device_memory_b);
        cudaFree(device_memory_c);


        return matrix_C;
    }
    else
    {
        matrix* left_res = gpu_compute(n->left);
        matrix* right_res = gpu_compute(n->right);
        matrix* matrix_C = new matrix;
        
        std::cout << "Matrix left_res " << left_res->name << std::endl;
        printMatrix(left_res);
        std::cout << "Matrix right_res " << right_res->name << std::endl;
        printMatrix(right_res);
        matrix_C->name = left_res->name + right_res->name;
        // Determine size of dimenisons
        int M;
        int N_1;
        int N_2;
        int K;

        std::tie(M,N_1) = left_res->dimension;
        std::tie(N_2,K) = right_res->dimension;
        assert(N_1 == N_2);
        matrix_C->dimension = std::make_tuple(M,K);
        matrix_C->values.resize(M);
        for (int i = 0; i < M; ++i) 
        {
            matrix_C->values[i].resize(K);
        }

        // Create and allocate host ptr
        int *host_memory_a = new int [M * N_1];
        int *host_memory_b = new int [N_2 * K];
        int *host_memory_c = new int [M * K];

        // Transfer to ptr
        transfer_to_ptr(host_memory_a, left_res);
        transfer_to_ptr(host_memory_b, right_res);
        std::cout << "after transfer to ptr A " << std::endl;
        int counter = 0;
        while(host_memory_a[counter] != 0)
        {
            std::cout << host_memory_a[counter] << " ";
            counter++;
        }
        std::cout << std::endl;
        std::cout << "----" << std::endl;
        std::cout << "after transfer to ptr B " << std::endl;
        counter = 0;
        while(host_memory_a[counter] != 0)
        {
            std::cout << host_memory_b[counter] << " ";
            counter++;
        }
        // Create and allocate device ptr
        int *device_memory_a, *device_memory_b, *device_memory_c;
        cudaMalloc(&device_memory_a,M * N_1 * sizeof(int));
        cudaMalloc(&device_memory_b,N_2 * K * sizeof(int));
        cudaMalloc(&device_memory_c,M * K * sizeof(int));

        // # of threads 
        int THREADS_M = 16;
        
        // set up blocks
        int block_row = (M + THREADS_M - 1) / THREADS_M;
        int block_cols = (K + THREADS_M - 1) / THREADS_M;

        dim3 threads_m(THREADS_M, THREADS_M);
        dim3 grid_m(block_cols, block_row);

        // Copy data to device
        cudaMemcpy(device_memory_a, host_memory_a, M * N_1 * sizeof(int), cudaMemcpyHostToDevice);
        cudaMemcpy(device_memory_b, host_memory_b, N_2 * K * sizeof(int), cudaMemcpyHostToDevice);
        //cudaMemcpy(device_memory_c, host_memory_c, M * K * sizeof(int), cudaMemcpyHostToDevice);
        
        // Call Kernel Function
        matrix_mult_gpu<<<grid_m, threads_m>>>(device_memory_a, device_memory_b, device_memory_c, M, N_1, K);

        // Copy back the results
        cudaMemcpy(host_memory_c, device_memory_c, M * K * sizeof(int), cudaMemcpyDeviceToHost);

        // Verify 
        transfer_to_matrix(host_memory_c, matrix_C);
        std::cout << "Matrix c (res) " << matrix_C->name << std::endl;
        printMatrix(matrix_C);

        free(host_memory_a);
        free(host_memory_b);
        free(host_memory_c);
        cudaFree(device_memory_a);
        cudaFree(device_memory_b);
        cudaFree(device_memory_c);

        return matrix_C;
    }  
}
/* int rows, cols;
    std::tie(rows, cols) = m->dimension;
    for(int i = 0; i < rows; i++)
    {
        for(int j = 0; j < cols; j++)
        {
            std::cout << m->values[i][j] << " ";
        }
        std::cout << std::endl;
    }*/
void Sequence::transfer_to_ptr(int *a, matrix *x)
{
    int row, col;
    int counter = 0;
    std::tie(row, col) = x->dimension;
    for(int i = 0; i < row; i++)
    {
        for(int j = 0; j < col; j++)
        {
            a[counter] = x->values[i][j];
            counter+=1;
        }
    }
}

void Sequence::transfer_to_matrix(int *a, matrix *x)
{
    int row, col;
    std::tie(row, col) = x->dimension;
    for(int i = 0; i < row; i++)
    {
        for(int j = 0; j < col; j++)
        {
            x->values[i][j] = a[i*j];
        }
    } 
}