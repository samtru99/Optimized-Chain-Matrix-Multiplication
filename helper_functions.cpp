#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <tuple>
#include <vector>
#include <unordered_map>
#include "sequence.h"
#include "helper_functions.h"

int dp(int i, int j, std::vector<int> dimensions, std::vector<std::vector<int>> *s_table,  std::unordered_map<std::pair<int,int>,int, pair_hash> *seen)
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
        int x = dp(i,k,dimensions, s_table, seen);
        int y = dp(k+1, j,dimensions, s_table, seen);
        int z = dimensions[i-1] * dimensions[k] * dimensions[j];
        int ans = x + y + z;
        if(ans < res)
        {
            res = ans;
            s_value = k;
        }
    }
    (*s_table)[i-1][j-1] = s_value;
    (*seen)[pair] = res;
    return res;

}


matrix* new_matrix(int row, int col, int val)
{
    matrix *m = (matrix*)malloc(sizeof(matrix));
    m->row = row;
    m->col = col;
    m->ptr = (int*)malloc(row*col*sizeof(int));
    for(int i = 0; i < row * col; i++)
    {
        m->ptr[i] = val;
    }
    return m;
}

void print_matrix(matrix *x)
{
    for(int i = 0; i < x->row; i++)
    {
        for(int j = 0; j <x->col;j++)
        {
            std::cout << x->ptr[i*j] << " ";
        }
        std::cout << std::endl;
    }
}

//Perform DP to find the path of least operations
void init_dp(std::vector<std::vector<int>> *s_table, std::vector<matrix> list_matrixes)
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
        //int a = std::get<0>(temp.dimension);
        //int b = std::get<1>(temp.dimension);
        int a = temp.row;
        int b = temp.col;
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
    dp(1,list_matrixes.size(), dimenions, s_table, &seen);
    //std::cout << "MAX is " << seen[{1,list_matrixes.size()}] << std::endl;

}

