#ifndef _SEQUENCE_H
#define _SEQUENCE_H
#include <string.h>
#include "stdlib.h"
#include <iostream>
#include <vector>
#include <tuple>
#include <unordered_map>

struct Node
{
    char* seq;
    Node* left;
    Node* right;
};

typedef struct matrix
{
    int row;
    int col;
    int *ptr;
}matrix;


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
        matrix* compute(Node* n, std::unordered_map<char, matrix*>& dict);
        void printMatrix(matrix *m);
        matrix* matrix_mult(matrix &a, matrix &b);
};

#endif