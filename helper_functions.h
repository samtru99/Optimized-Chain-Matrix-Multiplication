#ifndef _HELPER_FUNCTIONS_H
#define _HELPER FUNCTIONS_H
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <tuple>
#include <vector>
#include <unordered_map>
#include "sequence.h"

struct pair_hash 
{
    std::size_t operator () (const std::pair<int,int> &p) const
    {
        return std::hash<int>{}(p.first) ^ std::hash<int>{}(p.second);
    }
};

int dp(int i, int j, std::vector<int> dimensions, 
    std::vector<std::vector<int>> *s_table,  
    std::unordered_map<std::pair<int,int>,int, pair_hash> *seen);


void init_dp(std::vector<std::vector<int>> *s_table, std::vector<matrix> list_matrixes);

void print_matrix(matrix *x);

matrix* new_matrix(int row, int col, int val);


#endif