#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <tuple>
#include <vector>
#include <unordered_map>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <string.h>

struct matrix
{
    std::tuple<int, int> dimension;
};


struct pair_hash 
{
    std::size_t operator () (const std::pair<int,int> &p) const
    {
        return std::hash<int>{}(p.first) ^ std::hash<int>{}(p.second);
    }
};

/*
std::size_t unordered_map_hashing1(const std::pair<int, int>& p) {
    auto h1 = std::hash<int>{}(p.first);
    auto h2 = std::hash<int>{}(p.second);

    // A simple combination hash function
    return h1 ^ h2;
};
*/
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
        Get all dimenisons
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
    /*
    for(int i = 0; i < dimenions.size(); i++)
    {
        std::cout << dimenions[i] << " \n " << std::endl;
    }
    */
    dp(1,list_matrixes.size(), dimenions, s_table, &seen);
    std::cout << "max is " << seen[{1,4}] << std::endl;

    std::cout << "S TABLE: " << std::endl;
    for(int i = 0; i < s_table->size(); i++)
    {
        for(int j = 0; j < s_table[0].size(); j++)
        {
            std::cout << (*s_table)[i][j] << "\t";
        }
        std::cout << std::endl;
    }
}

int main()
{
    matrix A1;
    matrix A2;
    matrix A3;
    matrix A4;
    A1.dimension = std::make_tuple(5,4);
    A2.dimension = std::make_tuple(4,6);
    A3.dimension = std::make_tuple(6,2);
    A4.dimension = std::make_tuple(2,7);



    /*
        Create M and S tables
    */
    std::vector<std::vector<int>> s_table;

    int rows = 4;
    int columns = 4;
    for(int i = 0; i < rows; i++)
    {
        std::vector<int> row(columns, 0);
        s_table.push_back(row);
    }
    /*
        Initialize m_table to set self X self to be 0
    */

    /*
        Extract D_0 -> D_(N-1) values
    */
    std::vector<matrix> list_matrixes;
    list_matrixes.push_back(A1);
    list_matrixes.push_back(A2);
    list_matrixes.push_back(A3);
    list_matrixes.push_back(A4);
    init_dp(&s_table, list_matrixes);
    return 0;
}