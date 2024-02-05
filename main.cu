#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <tuple>
#include <vector>

struct matrix
{
    std::tuple<int, int> dimension;
};


int main()
{
    std::cout << "hello world " << std::endl;
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
    std::vector<std::vector<int>> m_table;
    std::vector<std::vector<int>> s_table;

    int rows = 4;
    int columns = 4;
    for(int i = 0; i < rows; i++)
    {
        std::vector<int> row(columns, 0);
        m_table.push_back(row);
        s_table.push_back(row);
    }
    /*
        Initialize m_table to set self X self to be 0
    */
    for(int i = 0; i < rows; i++)
    {
        m_table[i][i] = 0;
    }

    /*
        Extract D_0 -> D_(N-1) values
    */
    std::vector<matrix> list_matrixes;
    list_matrixes.push_back(A1);
    list_matrixes.push_back(A2);
    list_matrixes.push_back(A3);
    list_matrixes.push_back(A4);
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
    for(int i = 0; i < dimenions.size(); i++)
    {
        std::cout << dimenions[i] << " \n " << std::endl;
    }
    return 0;
}