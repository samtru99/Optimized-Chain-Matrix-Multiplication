#ifndef _SEQUENCE_H
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
        std::unordered_map<std::string,matrix*> str_matrix_dict;
    public:
        Sequence(std::vector<std::vector<int>> temp_table, std::unordered_map<std::string,matrix*> &str_matrix_dict);
        Node* init_sequence(int i, int j);
        void print_sequence(Node* n);
        void compute(Node* n);
        void setvalues(matrix *m, int value);
        void printMatrix(matrix *m);
};

#endif