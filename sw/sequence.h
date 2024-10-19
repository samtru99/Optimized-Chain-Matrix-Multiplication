#ifndef _SEQUENCE_H
#include <string.h>
#include "stdlib.h"
#include <iostream>
#include <vector>
#include <tuple>
#include <unordered_map>

struct pair_hash 
{
    std::size_t operator () (const std::pair<int,int> &p) const
    {
        return std::hash<int>{}(p.first) ^ std::hash<int>{}(p.second);
    }
};

struct Node
{
    char* seq;
    Node* left;
    Node* right;
};

struct matrix
{
    std::tuple<int, int> dimension;
    std::vector<std::vector<double>> values;
};


class Sequence
{
    private:
        std::vector<std::vector<int>> s_table;
        std::unordered_map<char,matrix*> str_matrix_dict;
    public:

        /// @brief Initialize the object with the Sequence table and matrix dictionary
        /// @param temp_table Empty square table where Sequence values will be stored at
        /// @param str_matrix_dict Identity matrix to represent each matrix
        Sequence(std::vector<std::vector<int>> temp_table, std::unordered_map<char,matrix*> &str_matrix_dict);
        
        /// @brief - Generates a binary tree representing the sequence order
        /// @param i - current left most value in binary search (recursive)
        /// @param j - current right most value in binary search (recursive)
        /// @return - Returns the root of the newly generated binary tree 
        Node* init_sequence(int i, int j);

        /// @brief - Prints out the binary tree in Pre Order
        /// @param n - Current node in the binary tree (recursive)
        void print_sequence(Node* n);

        /// @brief - Performs the matrix chain multiplication a binary tree 
        /// @param n - current node in binary tree
        /// @return - matrix with the end result of the matrix chain mulitiplication 
        matrix* compute(Node* n);

        /// @brief - prints out matrix (debugging usage)
        /// @param m - matrix 
        void printMatrix(matrix *m);

        /// @brief - matrix multiplication 
        /// @param a - matrix a
        /// @param b - matrix b
        /// @param c - matrix to store results 
        /// @param x - row
        /// @param y - col
        /// @param z - col 
        void matrix_mult(matrix *a, matrix *b, matrix *c, int x, int y, int z);
    
        /// @brief - sets up dimenison list to perform Sequence dynamic programming to find 's' values for
        ///          sequence table 
        /// @param list_matrixes - List of matrixes to parse through to generate dimension list
        void init_dp(std::vector<matrix> list_matrixes);

        /// @brief - performs dynamic programming to fill in the Sequence Table
        /// @param i - Numerical value to represent matrix 'i'
        /// @param j - Numerical value to represent matrix 'j'
        /// @param dimensions - dimension list needed for finding s value
        /// @param seen - to store previous calculated 's' values 
        /// @return - returns value of best 's' value found and sequence table filled 's' values
        int dp(int i, int j, std::vector<int> dimensions,  
            std::unordered_map<std::pair<int,int>,int, pair_hash> *seen);

        /// @brief - Prints s table (debugging usage)
        void print_s_table();

        /// @brief - transfer the matrix from 2d vector to ptr array
        void transfer_matrix(int *a, matrix *x);
        
        /// @brief same as compute but using gpu computation
        matrix* gpu_compute(Node* n);

};

#endif