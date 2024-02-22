#ifndef _SEQUENCE_H
#include <string.h>
#include "stdlib.h"
#include <iostream>
#include <vector>
struct Node
{
    char* seq;
    Node left;
    Node right;
    int val;
};

class Sequence
{
    private:
        Node root;
        std::vector<std::vector<int>> s_table;
        std::vector<int> matrix_sequence;
    public:
        Sequence(std::vector<std::vector<int>> s_table,std::vector<int> matrix_sequence);
        Node init_sequence(int i, int j);
        
        //void find_sequence();
};

#endif