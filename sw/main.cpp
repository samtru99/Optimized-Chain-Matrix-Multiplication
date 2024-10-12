#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <tuple>
#include <vector>
#include <unordered_map>
//#include <cuda_runtime.h>
//#include <device_launch_parameters.h>
#include <string.h>
#include "sequence.h"

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


int main()
{
    
    //Generate Matrices
    
    matrix *A1 = new matrix;
    matrix *A2 = new matrix;
    matrix *A3 = new matrix;
    matrix *A4 = new matrix;
    //matrix *A5 = new matrix;
    
    /*
    //For odd number 
    */
    // A1->dimension = std::make_tuple(4,10);
    // A2->dimension = std::make_tuple(10,3);
    // A3->dimension = std::make_tuple(3,12);
    // A4->dimension = std::make_tuple(12,20);
    // A5->dimension = std::make_tuple(20,7);
    

    //For even number 
    A1->dimension = std::make_tuple(3,2);
    A2->dimension = std::make_tuple(2,4);
    A3->dimension = std::make_tuple(4,2);
    A4->dimension = std::make_tuple(2,5);
    setValues(A1, 1);
    setValues(A2, 2);
    setValues(A3, 3);
    setValues(A4, 4);
   // setValues(A5, 5);
    
   

    std::unordered_map<char, matrix*> dict;
    dict['1'] = A1;
    dict['2'] = A2;
    dict['3'] = A3;
    dict['4'] = A4;
   // dict['5'] = A5;

    std::vector<matrix> list_matrixes;
    list_matrixes.push_back(*A1);
    list_matrixes.push_back(*A2);
    list_matrixes.push_back(*A3);
    list_matrixes.push_back(*A4);
   // list_matrixes.push_back(*A5);


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

    Sequence seq(s_table, dict);



    /*
        Perform DP
    */
    seq.init_dp(list_matrixes);

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
    //Sequence seq(s_table, dict);

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