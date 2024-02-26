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



struct pair_hash 
{
    std::size_t operator () (const std::pair<int,int> &p) const
    {
        return std::hash<int>{}(p.first) ^ std::hash<int>{}(p.second);
    }
};

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

void setValues(matrix *x,int value)
{
    int row = std::get<0>(x->dimension);
    int col = std::get<1>(x->dimension);
    x->values.resize(row);
    for (int i = 0; i < row; ++i) 
    {
        x->values[i].resize(col);
    }
    for(int i = 0; i < row; i++)
    {
        for(int j = 0; j < col; j++)
        {
            x->values[i][j] = value;
        }
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
    dp(1,list_matrixes.size(), dimenions, s_table, &seen);
    //std::cout << "MAX is " << seen[{1,list_matrixes.size()}] << std::endl;

}

int main()
{
    /*
        Generate Matrices
    */
    matrix *A1 = new matrix;
    matrix *A2 = new matrix;
    matrix *A3 = new matrix;
    matrix *A4 = new matrix;
    //matrix *A5 = new matrix;
    
    /*
    //For odd number 
    A1->dimension = std::make_tuple(4,10);
    A2->dimension = std::make_tuple(10,3);
    A3->dimension = std::make_tuple(3,12);
    A4->dimension = std::make_tuple(12,20);
    A5->dimension = std::make_tuple(20,7);
    */

    //For even number 
    A1->dimension = std::make_tuple(3,2);
    A2->dimension = std::make_tuple(2,4);
    A3->dimension = std::make_tuple(4,2);
    A4->dimension = std::make_tuple(2,5);
    setValues(A1, 1);
    setValues(A2, 2);
    setValues(A3, 3);
    setValues(A4, 4);
    //setValues(A5, 5);
    
   

    std::unordered_map<char, matrix*> dict;
    dict['1'] = A1;
    dict['2'] = A2;
    dict['3'] = A3;
    dict['4'] = A4;
    //dict['5'] = A5;

    std::vector<matrix> list_matrixes;
    list_matrixes.push_back(*A1);
    list_matrixes.push_back(*A2);
    list_matrixes.push_back(*A3);
    list_matrixes.push_back(*A4);
    //list_matrixes.push_back(*A5);


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

    //Print S-Table for debugging
    /*
    std::cout << "S TABLE: " << std::endl;
    for(int i = 0; i < s_table.size(); i++)
    {
        for(int j = 0; j < s_table[0].size(); j++)
        {
            std::cout << s_table[i][j] << "\t";
        }
        std::cout << std::endl;
    }
    */
    Sequence seq(s_table, dict);

    Node* root = new Node();
    root = seq.init_sequence(1, list_matrixes.size());
     
    root = seq.init_sequence(1, list_matrixes.size());
    std::cout << "printing " << std::endl;
    std::cout << "(" << " ";
    seq.print_sequence(root);
    std::cout << ")" << " \n";
    
    std::cout << "COMPUTING " << std::endl;
    matrix* res = seq.compute(root);

    std::cout << "RES IS " << std::endl;
    seq.printMatrix(res);
    return 0;
}