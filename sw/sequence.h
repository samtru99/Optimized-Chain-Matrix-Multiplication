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
    std::vector<std::vector<int>> values;
};


class Sequence
{
    private:
        Node root;
        std::vector<std::vector<int>> s_table;
        std::unordered_map<char,matrix*> str_matrix_dict;
    public:
        Sequence(std::vector<std::vector<int>> temp_table, std::unordered_map<char,matrix*> &str_matrix_dict);
        Node* init_sequence(int i, int j);
        void print_sequence(Node* n);
        matrix* compute(Node* n);
        //void setvalues(matrix *m, int value);
        void printMatrix(matrix *m);
        void matrix_mult(matrix *a, matrix *b, matrix *c, int x, int y, int z);
    
        void init_dp(std::vector<matrix> list_matrixes);
        int dp(int i, int j, std::vector<int> dimensions,  
        std::unordered_map<std::pair<int,int>,int, pair_hash> *seen);
};

#endif